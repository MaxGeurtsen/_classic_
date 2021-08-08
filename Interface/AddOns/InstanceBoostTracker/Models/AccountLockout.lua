AccountLockout = {}



function CleanUp()
    DebugHelper:Print("AccountLockout:CleanUp()")

    -- Disabled as we are now tracking statistics of all instances

    -- local correctedList = {}
    -- local yesterday = DateTimeHelper:Now():adddays(-1)

    -- for key, lockout in pairs(SavedAccountLockouts) do
    --     local lockoutDateTime = lockout.endDateTime or DateTimeHelper:NowSplitObj()
    --     local lockoutDateTimeObj = DateTimeHelper:FromTable(lockoutDateTime)
    --     if lockoutDateTimeObj > yesterday then
    --     correctedList[key] = lockout
    --     end
    -- end

    -- SavedAccountLockouts = correctedList
end

function AccountLockout:Get(identifier)
    DebugHelper:Print("AccountLockout:Get()")
    return SavedAccountLockouts[identifier]
end

function AccountLockout:GetAllLockouts()
    DebugHelper:Print("AccountLockout:GetAllLockouts()")
    CleanUp()
    return SavedAccountLockouts
end

function AccountLockout:Update(identifier)
    DebugHelper:Print("AccountLockout:UpdateLockout()")

    local accLockout = SavedAccountLockouts[identifier]
    
    if accLockout then
        DebugHelper:Print("-> Updating endDateTime of lockout "..identifier)
        accLockout =
        {
            instanceName = accLockout.instanceName,
            playerName = accLockout.playerName,
            startDateTime = accLockout.startDateTime,
            endDateTime = DateTimeHelper:NowSplitObj()
        }
        
        SavedAccountLockouts[identifier] = accLockout
    end
end

function AccountLockout:Create(savedCharacterLockout)
    DebugHelper:Print("AccountLockout:Create()")

    if not SavedAccountLockouts[savedCharacterLockout.identifier] then
        DebugHelper:Print("-> Adding lockout to account lockouts "..savedCharacterLockout.identifier)
        accountLockout = {
            instanceName = savedCharacterLockout.instanceName,
            playerName = savedCharacterLockout.playerName,
            startDateTime = DateTimeHelper:NowSplitObj(),
        }
    
        AccountLockout:Add(savedCharacterLockout.identifier, accountLockout)
    else
        DebugHelper:Print("-> Lockout "..savedCharacterLockout.identifier.." is already present in account lockouts.")
    end
end

function AccountLockout:Add(identifier, accountLockout)
    DebugHelper:Print("AccountLockout:Add()")
    SavedAccountLockouts[identifier] = accountLockout
end

function AccountLockout:Delete(identifier, callback)
    DebugHelper:Print("AccountLockout:Delete()")

    StaticPopupDialogs["ACCOUNTLOCKOUT_DELETE"] = {
        text = "Are you sure you want to delete "..identifier, button1 = "Yes", button2 = "No",
        OnAccept = function()
            SavedAccountLockouts[identifier] = nil
            CharacterLockout:Delete(identifier)
            Statistics:Delete(identifier)

            callback()

            IT:PrintMsg("Deleted entry "..selectedLine.InstanceId)
        end,
    }
    StaticPopup_Show("ACCOUNTLOCKOUT_DELETE");
end

if SavedAccountLockouts == nil then SavedAccountLockouts = {} end
