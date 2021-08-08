IT.AntiAfk = {}

local function PLAYER_FLAGS_CHANGED(...)
    if Settings:GetKey("AUTO_FOLLOW") and UnitIsAFK("player") then
        -- C_Timer.After(5, function() 
        --     SendChatMessage("Anti-AFK", "WHISPER", nil, "InstanceTracker1") 
        -- end)
    end
end
IT.AntiAfk.PLAYER_FLAGS_CHANGED = PLAYER_FLAGS_CHANGED