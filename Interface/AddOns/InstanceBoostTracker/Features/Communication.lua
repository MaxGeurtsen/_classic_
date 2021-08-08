Communication = {}

local EVENTS = CreateFrame("frame")
local ADDON_MESSAGE_PREFIX = 'INSTANCE_TRACKER'
local ADDON_MESSAGE_RESET = 'INSTANCE RESET'
local ADDON_MESSAGE_RESET_CONFIRMED = 'INSTANCE_RESET_CONFIRMED'
local ADDON_MESSAGE_STATISTICS = 'STATISTICS'

local function AddBroadcastMessage(prefix, msg)
    DebugHelper:Print("Communication:AddBroadcastMessage()")

    local fullMsg = prefix
    if msg then
        fullMsg = fullMsg.."\t"..msg
    end
    DebugHelper:Print("-> "..fullMsg)

    Communication:Broadcast(fullMsg)
end

function Communication:Broadcast(msg)
    DebugHelper:Print("Communication:Broadcast()")

    local chatType = nil
    if IsInGroup() then
        chatType = "PARTY"
    elseif IsInRaid() then
		chatType = "RAID"
    end
    
    if chatType then
        DebugHelper:Print("-> Broadcasting message: "..msg)
        C_ChatInfo.SendAddonMessage(ADDON_MESSAGE_PREFIX, msg, chatType)
    end
end

function Communication:BroadcastReset()
    DebugHelper:Print("Communication:BroadcastReset()")
    AddBroadcastMessage(ADDON_MESSAGE_RESET)
end

function Communication:BroadcastResetConfirmation()
    DebugHelper:Print("Communication:BroadcastResetConfirmation()")
    AddBroadcastMessage(ADDON_MESSAGE_RESET_CONFIRMED, IT_CONST_UNIT_NAME_PLAYER)
end

function Communication:BroadcastStatistics(instanceName, playerName, gold, experience, kills, reputation)
    DebugHelper:Print("Communication:BroadcastStatistics()")
    local msg = instanceName.."\t"..playerName.."\t"..gold.."\t"..experience.."\t"..kills.."\t"..reputation
    AddBroadcastMessage(ADDON_MESSAGE_STATISTICS, msg)
end

function Communication:PLAYER_LOGIN()
    local successfulRequest = C_ChatInfo.RegisterAddonMessagePrefix(ADDON_MESSAGE_PREFIX)
    if not successfulRequest then
		IT:PrintMsg(LuaHelper:ColorizeStr("WARNING: Something went wrong during initialization of the communication handler.", "ORANGE"))
	end
end

function Communication:CHAT_MSG_ADDON(prefix, msg, channel, sender)
    -- Don't listen to our own messages
    local senderWithoutRealm = strsplit("-", sender)
    if prefix == ADDON_MESSAGE_PREFIX and senderWithoutRealm ~= IT_CONST_UNIT_NAME_PLAYER then
        DebugHelper:Print("Communication.CHAT_MSG_ADDON")
        DebugHelper:Print("-> Received message: "..msg)

        if msg == ADDON_MESSAGE_RESET then
            IT:PrintMsg("A reset has been invoked by "..senderWithoutRealm)
            LockoutTracker:ResetLockouts()
            Communication:BroadcastResetConfirmation()
        elseif string.find(msg, ADDON_MESSAGE_RESET_CONFIRMED) then
            local _, playerName  = strsplit("\t", msg)
            IT:PrintMsg("A reset has been confirmed by "..playerName)
        elseif string.find(msg, ADDON_MESSAGE_STATISTICS) then
            _, instanceName, playerName, gold, experience, kills, reputation  = strsplit("\t", msg)
            StatisticsTracker:ImportStatistics(instanceName, playerName, gold, experience, kills, reputation)
        end
    end
end