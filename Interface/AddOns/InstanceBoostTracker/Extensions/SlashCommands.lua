function addonCommand(command)
    if     command == nil               then GUI:Show()
    elseif command == ""                then GUI:Show()
    elseif command == "test"            then Test:All(); GUI:Show(); print("Test data has been generated");
    elseif command == "debug"           then DebugHelper:Enable()
    elseif command == "history"         then GUIPayments:Show()
    elseif command == "reportlockouts"  then LockoutTracker:ReportLockouts()
    elseif command == "rl"              then LockoutTracker:ReportLockouts()
    elseif command == "reset"           then GUI:Reset()
    elseif command == "resetposition"   then GUI:ResetPosition()
    elseif command == "fullreset"       then GUIPayments:Reset()
    end
end

SLASH_IT1, SLASH_IBT1, SLASH_IBPT1 = "/ibt", "/ibpt", "/it"
SlashCmdList.IT = addonCommand
SlashCmdList.IBT = addonCommand
SlashCmdList.IBPT = addonCommand