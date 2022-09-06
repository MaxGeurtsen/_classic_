local IsEnteringFirstInstanceAfterLogin = true
local CURRENT_LOCKOUT = nil
local AUTO_RESET_INSTANCE = false
local SUBSCRIBED_CALLBACKS = nil
local PLAYER_IN_GROUP = false
local PLAYER_ENTERED_WORLD = false
LockoutTracker = {}

function LockoutTracker:GetCurrentLockout()
    return CURRENT_LOCKOUT
end

function LockoutTracker:ResetLockouts(force)
    DebugHelper:Print("LockoutTracker:ResetLockouts()")
    force = force or false

    if CURRENT_LOCKOUT and not force then
        IT:PrintMsg("Auto reset of instance will activate after you've left the instance.")
        -- We're adding this function because if a player is too fast with resetting,
        --   and a party member is still inside then we need to reset it after we have left, otherwise we go out of sync with the others
        AUTO_RESET_INSTANCE = true
    else
        CharacterLockout:ClearUnitAndPartyMembers()

        if UnitIsGroupLeader("player") then
            if Settings:GetKey("LOCKOUT_REPORTRESET") then
                local chatType = "party"
                if UnitInRaid("player") then
                    chatType = "raid"
                end
                SendChatMessage("Instance(s) have been reset.", chatType)
            end

            Communication:BroadcastReset()
        end

        CURRENT_LOCKOUT = nil
    end
end

local function OnInstanceReset()
    DebugHelper:Print("LockoutTracker:OnInstanceReset()")
    LockoutTracker:ResetLockouts()
end

local function UpdateLockout()
    DebugHelper:Print("LockoutTracker.UpdateLockout")

    if CURRENT_LOCKOUT then
        AccountLockout:Update(CURRENT_LOCKOUT.identifier)
        StatisticsTracker:StartTracking(CURRENT_LOCKOUT.identifier, nil, CURRENT_LOCKOUT.instanceName)
    end
end

function LockoutTracker:GenerateTimeTaken()
    local timeTaken = ""

    if CURRENT_LOCKOUT then
        local curLockout = AccountLockout:Get(CURRENT_LOCKOUT.identifier)

        if curLockout then
            local startDateTime = curLockout.startDateTime
            local endDateTime = curLockout.endDateTime

            if startDateTime and endDateTime then
                local duration = DateTimeHelper:FromTable(endDateTime) - DateTimeHelper:FromTable(startDateTime)

                if duration:gethours() >= 1 then
                    timeTaken = ">60"
                else
                    local minutes = tostring(duration:getminutes())
                    if string.len(minutes) < 2 then
                        minutes = "0"..minutes
                    end

                    local seconds = tostring(duration:getseconds())
                    if string.len(seconds) < 2 then
                        seconds = "0"..seconds
                    end

                    timeTaken = minutes..":"..seconds
                end
            end
        end
    end

    return timeTaken
end

-- Validate if we already have an active save for this instance by name
--   If we don't have an active save then we create one and store the current instance id in our session and create a global instance lockout
--   If we do have an active session then this might be a raid, if this is a raid then we need to check if the user has logged out.
--      If the user logged out and re-entered the instance then that means he might have reset the run from a different char/account.
--   If not, then the user re-entered the old instance, and we should update the datetime of the account lockout.
--      This is more of a fail safe, as leaving an instance or logging off should report the correct time..
local function CreateSave()
    DebugHelper:Print("LockoutTracker:CreateSave()")

    if LockoutTracker:IsEnabled() then
        local instanceName, _, difficultyID, _, maxPlayers = IT:GetInstanceInfo()

        -- With the recent hotfix, (June 19, 2020 - https://us.forums.blizzard.com/en/wow/t/wow-classic-hotfixes-updated-june-22/361448), 
        --  40 man raids are no longer included in the lockout list.
        if maxPlayers == 40 then
            DebugHelper:Print("-> Player entered a 40 player raid, skipping..")
            return
        end
        
        curLockout = CharacterLockout:Get(instanceName)
        if not curLockout then
            curLockout = CharacterLockout:Create()
            CURRENT_LOCKOUT = curLockout
            LockoutTracker:ReportLockouts()
            DebugHelper:Print("-> Created new lockout with identifier "..curLockout.identifier)

        else
            -- When we enter the first instance of the day, but we already have a lockout we need to verify if this is a new one
            if IsEnteringFirstInstanceAfterLogin then
                StaticPopupDialogs["RESET_LOCKOUT"] = {
                    text = "Is this a new instance lockout?", button1 = "Yes", button2 = "No",
                    OnAccept = function () 
                        LockoutTracker:ResetLockouts(true) 
                        CreateSave()
                    end,
                    OnCancel = function ()
                        CURRENT_LOCKOUT = curLockout
                        UpdateLockout()
                    end
                }
                StaticPopup_Show("RESET_LOCKOUT");
            else
                DebugHelper:Print("-> Player has re-entered identifier "..curLockout.identifier)
                CURRENT_LOCKOUT = curLockout
                UpdateLockout()
            end
        end

    end
end

local function PlayerJoinedLeftGroup()
    if Settings:GetKey("LOCKOUT_RESETONGROUPCHANGE") and PLAYER_ENTERED_WORLD and not UnitIsDeadOrGhost("player") then
        if PLAYER_IN_GROUP and not (IsInGroup() or IsInRaid()) then -- Player left a group 
            PLAYER_IN_GROUP = false
            LockoutTracker:ResetLockouts(force)
        elseif not PLAYER_IN_GROUP and (IsInGroup() or IsInRaid()) then -- Player entered a group
            PLAYER_IN_GROUP = true
            if not UnitIsGroupLeader("player") then
                LockoutTracker:ResetLockouts(force)
            end
        end
    end
end

function LockoutTracker:IsEnabled()
    return Settings:GetKey("FEATURE_LockoutTracker")
end

function LockoutTracker:EnableDisable(value)
    Settings:SetKeyValue("FEATURE_LockoutTracker", value)
end

-- Cleans the current lockouts first and then reports to the user the current lockouts
function LockoutTracker:ReportLockouts()
    DebugHelper:Print("LockoutTracker:ReportLockouts()")

    local hourlyLockouts = LockoutTracker:CalculateHourlyLockouts();
    IT:PrintMsg("Hourly lockouts currently active: "..hourlyLockouts.."/5")

    if hourlyLockouts >= 4 then
        IT:PrintMsg(LuaHelper:ColorizeStr(LockoutTracker:CreateNextReadableLockoutTimer(), "ORANGE"))
    end

    --IT:PrintMsg("Daily lockouts currently active: "..LockoutTracker:CalculateDailyLockouts().."/30")
end

-- Calculate the total daily lockouts currently active
function LockoutTracker:CalculateDailyLockouts()
    DebugHelper:Print("LockoutTracker:CalculateDailyLockouts()")

    local nrOfLockouts = 0

    -- local dayAgo = DateTimeHelper:Now():adddays(-1)
    -- for key, lockout in pairs(AccountLockout:GetAllLockouts()) do
    --     -- Needs to be equal to player name since blizz now does a lockout count based on character instead of account.
    --     if lockout.playerName == IT_CONST_UNIT_NAME_PLAYER then
    --         if lockout.endDateTime == nil then
    --             DebugHelper:Print("-> WARNING: Cannot find an end time for lockout "..identifier)
    --         end

    --         local lockoutDateTime = lockout.endDateTime or lockout.startDateTime
    --         local lockoutDateTimeObj = DateTimeHelper:FromTable(lockoutDateTime)
    --         if lockoutDateTimeObj > dayAgo then
    --             nrOfLockouts = nrOfLockouts + 1
    --         end
    --     end
    -- end

    return nrOfLockouts
end

-- Calculates the lockouts within the hour
function LockoutTracker:CalculateHourlyLockouts()
    DebugHelper:Print("LockoutTracker:CalculateHourlyLockouts()")
    
    UpdateLockout()
    
    local nrOfInstances = 0
    
    local hourAgo = DateTimeHelper:Now():addhours(-1)
    for identifier, lockout in pairs(AccountLockout:GetAllLockouts()) do
        if lockout.endDateTime == nil then
            DebugHelper:Print("-> WARNING: Cannot find an end time for lockout "..identifier)
        end

        -- IN TBC This is now Account wide again instead of per character
        --if lockout.playerName == IT_CONST_UNIT_NAME_PLAYER then
            local lockoutDateTime = lockout.endDateTime or lockout.startDateTime
            local lockoutDateTimeObj = DateTimeHelper:FromTable(lockoutDateTime)
            if lockoutDateTimeObj > hourAgo then
                nrOfInstances = nrOfInstances + 1
            end
        --end
    end

    return nrOfInstances
end

function LockoutTracker:CalculateLastLockoutInCurrentHour()
    local lastLockoutInCurrentHour = nil

    local hourAgo = DateTimeHelper:Now():addhours(-1)
    for identifier, lockout in pairs(AccountLockout:GetAllLockouts()) do
        if lockout.endDateTime == nil then
            DebugHelper:Print("-> WARNING: Cannot find an end time for lockout "..identifier)
        end

        local lockoutDateTime = lockout.endDateTime or lockout.startDateTime
        local lockoutDateTimeObj = DateTimeHelper:FromTable(lockoutDateTime)
        -- Make sure we are within the hour lockout time
        if lockoutDateTimeObj > hourAgo then
            -- If we don't have a value then this will be our initial value
            -- Otherwise we check if our current lockoutDateTime is the furthest away
            if lastLockoutInCurrentHour == nil or lockoutDateTimeObj < lastLockoutInCurrentHour then
                lastLockoutInCurrentHour = lockoutDateTimeObj
            end
        end
    end

    return lastLockoutInCurrentHour
end

function LockoutTracker:CalculateLastLockoutInCurrentDay()
    local lastLockout = nil

    local dayAgo = DateTimeHelper:Now():adddays(-1)
    for identifier, lockout in pairs(AccountLockout:GetAllLockouts()) do
        if lockout.endDateTime == nil then
            DebugHelper:Print("-> WARNING: Cannot find an end time for lockout "..identifier)
        end

        local lockoutDateTime = lockout.endDateTime or lockout.startDateTime
        local lockoutDateTimeObj = DateTimeHelper:FromTable(lockoutDateTime)
        -- Make sure we are within the hour lockout time
        if lockoutDateTimeObj > dayAgo then
            -- If we don't have a value then this will be our initial value
            -- Otherwise we check if our current lockoutDateTime is the furthest away
            if lastLockout == nil or lockoutDateTimeObj < lastLockout then
                lastLockout = lockoutDateTimeObj
            end
        end
    end

    return lastLockout
end

function LockoutTracker:CreateNextReadableLockoutTimer()
    local timer = LockoutTracker:CalculateNextInstanceAvailable()
    local readableTimer = "More instances available in "

    if LockoutTracker:CalculateDailyLockouts() >= 30 then
        readableTimer = readableTimer..timer:gethours().." hour(s), " 
    end

    if timer:getminutes() > 0 then
        readableTimer = readableTimer..timer:getminutes().." minute(s)." 
    end

    return readableTimer
end

-- Calculates the next available lockout, by using the last known time of the first instance that created a lock within the hour
function LockoutTracker:CalculateNextInstanceAvailable()
    DebugHelper:Print("LockoutTracker:CalculateNextInstanceAvailable()")

    local lastLockout = nil

    if LockoutTracker:CalculateDailyLockouts() >= 30 then
        lastLockout = LockoutTracker:CalculateLastLockoutInCurrentDay()
    else
        lastLockout = LockoutTracker:CalculateLastLockoutInCurrentHour()
    end

    if lastLockout then
        -- We substract the minutes from our first lockout from an hour and a minute
        return 60 - (DateTimeHelper:Now() - lastLockout)
    else
        return 0
    end
end

function LockoutTracker:UpdateAndGetAllLockouts()
    UpdateLockout()
    return AccountLockout:GetAllLockouts()
end

function LockoutTracker:OnPulse(callback)
    SUBSCRIBED_CALLBACKS = callback
end

local function Pulse()
    UpdateLockout()
    SUBSCRIBED_CALLBACKS()
end

local ORIGINAL_CANCEL_LOGOUT = CancelLogout
local ORIGINAL_RESET_INSTANCES = ResetInstances
-- https://wow.gamepedia.com/AddOn_loading_process - best practice to initialize this in PLAYER_LOGIN
function LockoutTracker:PLAYER_LOGIN()
    DebugHelper:Print("LockoutTracker.PLAYER_LOGIN")
    hooksecurefunc("ResetInstances", function ()
        OnInstanceReset()
        ORIGINAL_RESET_INSTANCES()
    end)

    -- I couldn't find a better way to do this besides doing it like this :/
    hooksecurefunc("CancelLogout", function()
        LockoutTracker:PLAYER_CANCEL_LOGOUT()
        ORIGINAL_CANCEL_LOGOUT()
    end)
end

function LockoutTracker:RAID_ROSTER_UPDATE()
    PlayerJoinedLeftGroup()
end

function LockoutTracker:GROUP_ROSTER_UPDATE()
    PlayerJoinedLeftGroup()
end

function LockoutTracker:PLAYER_QUITING()
    DebugHelper:Print("LockoutTracker.PLAYER_QUITING")
    UpdateLockout()
end

function LockoutTracker:PLAYER_CAMPING()
    DebugHelper:Print("LockoutTracker.PLAYER_CAMPING")
    UpdateLockout()

    local hourlyLockouts = LockoutTracker:CalculateHourlyLockouts();
    if hourlyLockouts == 5 then
        IT:PrintMsg(LuaHelper:ColorizeStr("WARNING: "..LockoutTracker:CreateNextReadableLockoutTimer(), "ORANGE"))
    end

    StatisticsTracker:StopTracking()
end

function LockoutTracker:PLAYER_CANCEL_LOGOUT()
    DebugHelper:Print("LockoutTracker.PLAYER_CANCEL_LOGOUT")
    UpdateLockout()
end

function LockoutTracker:PLAYER_LOGOUT()
    DebugHelper:Print("LockoutTracker.PLAYER_LOGOUT")
    
    -- When the player is in an instance then we will need to update the endDateTime.
    -- if we don't, the endDateTime will not be updated because the "PLAYER_ENTERING_WORLD" will not trigger to update it.
    if CURRENT_LOCKOUT then
        UpdateLockout()

        -- Readd the removed party instance, because we're currently in an instance which is of type party
        if CURRENT_LOCKOUT.instanceType == "party" then
            CharacterLockout:Add(CURRENT_LOCKOUT)
        end
    end

    SavedAntiReloadUISettings["IsEnteringFirstInstanceAfterLogin"] = IsEnteringFirstInstanceAfterLogin
end

-- This can go two ways we either have entered an instance, or we havent.
-- If we have then we want to create a save.
-- Otherwise we want to mark the datetime of the instance we were in, this is the time we need to calculate the next available instance.
function LockoutTracker:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    DebugHelper:Print("LockoutTracker.PLAYER_ENTERING_WORLD()")

    -- If we were reloading and inside an instance then we need to make sure that we reset this flag to false.
    -- Else the user will get a popup asking if this is a new instance ID, which it is not.
    if isReloadingUi and SavedAntiReloadUISettings then
        IsEnteringFirstInstanceAfterLogin = SavedAntiReloadUISettings["IsEnteringFirstInstanceAfterLogin"]
    else
        SavedAntiReloadUISettings["IsEnteringFirstInstanceAfterLogin"] = IsEnteringFirstInstanceAfterLogin
    end

    if not isReloadingUI then
        local inInstance, instanceType = IsInInstance()

        -- Player has entered an instance
        if inInstance and (instanceType == "party" or instanceType == "raid") then
            DebugHelper:Print("-> Player entered a "..instanceType.." lockout.")
            CreateSave()
            IsEnteringFirstInstanceAfterLogin = false

            Timer:Start(Pulse)
        else -- Player has left an instance
            Timer:Stop()
            DebugHelper:Print("-> Player entered non dungeon related area.")
            -- We're using this code here opposed to the "INSTANCE_LOCK_STOP" event, because this event gets triggered when you die as well.
            -- Check if the player is, or was in an instance, so we can update the last dungeon we were in.
            if not inInstance and CURRENT_LOCKOUT then
                DebugHelper:Print("-> Found previous lockout "..CURRENT_LOCKOUT.identifier)
                UpdateLockout()
                
                CURRENT_LOCKOUT = nil
                StatisticsTracker:StopTracking()
            end

            if AUTO_RESET_INSTANCE then
                -- This will also trigger our OnInstanceReset hook
                ResetInstances()
                AUTO_RESET_INSTANCE = false
            end

            -- Doing one more pulse after we have left the dungeon
            Pulse()
        end
    end

    -- Moved check to a lower area, to trigger the check more often.
    if IsInGroup() or IsInRaid() then
        PLAYER_IN_GROUP = true
    end

    PLAYER_ENTERED_WORLD = true
end