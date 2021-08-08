DebugHelper = {}
local IsDebuggingEnabled = false

function DebugHelper:Print(msg)
    if IsDebuggingEnabled then
		print(LuaHelper:ColorizeStr("[D] "..msg, "CYAN"))
    end
end

function DebugHelper:Dump(...)
	if IsDebuggingEnabled then
		if type(...) == "table" then
			UIParentLoadAddOn('Blizzard_DebugTools');
			--DevTools_Dump(...);
			DisplayTableInspectorWindow(...);
		else
			DebugHelper:Print(...)
		end
	end	
end

function DebugHelper:Enable()
    IsDebuggingEnabled = true
    DebugHelper:Print("Debugging enabled.")
end