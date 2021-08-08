IT_NitIntegration = {}
local LibDeflate = LibStub:GetLibrary("LibDeflate");
local LibSerialize = LibStub:GetLibrary("LibSerialize");
local NIT_ADDON_MESSAGE_PREFIX = "NIT"

function IT_NitIntegration:PLAYER_LOGIN()
    local successfulRequest = C_ChatInfo.RegisterAddonMessagePrefix(NIT_ADDON_MESSAGE_PREFIX)
    if not successfulRequest then
		IT:PrintMsg(LuaHelper:ColorizeStr("WARNING: Something went wrong during initialization of the communication handler.", "ORANGE"))
	end
end

function IT_NitIntegration:DeserializeMessage(msg)
    local decoded = LibDeflate:DecodeForWoWAddonChannel(msg)
    local decompressed = LibDeflate:DecompressDeflate(decoded)
    local deserializeResult, deserialized = LibSerialize:Deserialize(decompressed)
    
    --print ("NIT: "..deserialized)

    return deserialized
end

-- Subscribe to NIT events
function IT_NitIntegration:OnMessageReceived(prefix, msg, channel, sender)
    local senderWithoutRealm = strsplit("-", sender)
    if prefix == NIT_ADDON_MESSAGE_PREFIX and senderWithoutRealm ~= IT_CONST_UNIT_NAME_PLAYER then
        local deserialized = IT_NitIntegration:DeserializeMessage(msg)
        -- Message will look like: 
        -- "instanceReset 1.18 Auchindoun: Shadow Labyrinth"
        -- "version 1.18 check"
        local command = strsplit(" ", deserialized)
        if (command == "instanceReset" or command == "instanceResetNoMsg" or command == "instanceResetOther") then
            IT_NitIntegration:OnInstanceReset(sender)
        end
    end
end

-- Instance reset
function IT_NitIntegration:OnInstanceReset(user)
    print ("A reset has been invoked by NIT (sent by "..user..").")
    LockoutTracker:ResetLockouts()
end

-- Statistics broadcast
function IT_NitIntegration:OnStatsReceived(...)

end