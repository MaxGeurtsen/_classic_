CharacterLockout = {}

local function RemovePartyMemberLockouts()
    for i = 1, GetNumGroupMembers() do
        unitName = GetRaidRosterInfo(i)
        
        if unitName then
            SavedCharacterLockouts[unitName] = {}
        end
    end
end

function CharacterLockout:ClearPartyLockoutsForPlayerOnLogoff()
    local playerLockouts = {}

    -- The reason why we do it this way and not with a tremove is because we don't use an integer as an identifier.
    for playerLockoutNameKey, playerLockout in pairs(SavedCharacterLockouts) do
        for instanceNameKey, lockoutDetails in pairs(playerLockout) do
            -- We want to keep lockouts which don't belong to ourself
            -- Raid lockouts don't reset upon logoff, hence we keep them.
            if playerLockoutNameKey ~= IT_CONST_UNIT_NAME_PLAYER or lockoutDetails.instanceType == "raid" then
                DebugHelper:Print("-> Keeping "..playerLockoutNameKey)
                playerLockouts[playerLockoutNameKey] = playerLockout
            end
        end
    end

    SavedCharacterLockouts = playerLockouts
end

function CharacterLockout:ClearUnitAndPartyMembers()
    SavedCharacterLockouts[IT_CONST_UNIT_NAME_PLAYER] = {}
    RemovePartyMemberLockouts()
end

function CharacterLockout:Get(instanceName)
    if SavedCharacterLockouts[IT_CONST_UNIT_NAME_PLAYER] then
        return SavedCharacterLockouts[IT_CONST_UNIT_NAME_PLAYER][instanceName]
    else
        return nil
    end
end

function CharacterLockout:GetAllLockouts()
    return SavedCharacterLockouts
end

function CharacterLockout:Create()
    local instanceName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = IT:GetInstanceInfo()

    newCharacterLockout = { 
        identifier = LuaHelper:RandomNumber(7),
        instanceName = instanceName,
        playerName = IT_CONST_UNIT_NAME_PLAYER,
        instanceType = instanceType
    }

    CharacterLockout:Add(newCharacterLockout)
    AccountLockout:Create(newCharacterLockout)    

    return newCharacterLockout
end

function CharacterLockout:Add(characterLockout)
    DebugHelper:Print("CharacterLockout.Add()")

    if not SavedCharacterLockouts[IT_CONST_UNIT_NAME_PLAYER] then
        DebugHelper:Print("-> Creating character object")
        SavedCharacterLockouts[IT_CONST_UNIT_NAME_PLAYER] = {}
    end

    if not SavedCharacterLockouts[IT_CONST_UNIT_NAME_PLAYER][characterLockout.instanceName] then
        DebugHelper:Print("-> Creating instance object")
        SavedCharacterLockouts[IT_CONST_UNIT_NAME_PLAYER][characterLockout.instanceName] = {}
    end

    DebugHelper:Print("-> Adding instance lockout to character "..IT_CONST_UNIT_NAME_PLAYER)
    SavedCharacterLockouts[IT_CONST_UNIT_NAME_PLAYER][characterLockout.instanceName] = characterLockout
end

function CharacterLockout:Delete(identifier)
    DebugHelper:Print("CharacterLockout:Delete()")
    SavedCharacterLockouts[identifier] = nil
end

function CharacterLockout:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    DebugHelper:Print("CharacterLockout.PLAYER_ENTERING_WORLD")

    -- Restore the object to it's previous state, this is hacky, but if we cannot hook the ReloadUI func.
    -- If we hook that func and someone overrules it then we lose our hook.
    if isReloadingUi then
        DebugHelper:Print("-> UI has been reloaded")
        if SavedAntiReloadUISettings and SavedAntiReloadUISettings["SavedCharacterLockouts"] then
            DebugHelper:Print("-> Restoring SavedCharacterLockouts object.")
            SavedCharacterLockouts = SavedAntiReloadUISettings["SavedCharacterLockouts"]
        end
    end 

    SavedAntiReloadUISettings["SavedCharacterLockouts"] = nil
end

function CharacterLockout:PLAYER_LOGOUT()
    DebugHelper:Print("CharacterLockout.PLAYER_LOGOUT")

    -- We need to clone the table, if we don't then the object will be stored as a PTR
    -- And since we clear the object the PTR object will be empty.
    SavedAntiReloadUISettings["SavedCharacterLockouts"] = SavedCharacterLockouts

    CharacterLockout:ClearPartyLockoutsForPlayerOnLogoff()
end

if SavedCharacterLockouts == nil then SavedCharacterLockouts = {} end
