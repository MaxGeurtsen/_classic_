local frame = CreateFrame("Frame", "AutoFollow", UIParent)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("UNIT_POWER_UPDATE")
frame:RegisterEvent("AUTOFOLLOW_BEGIN")
frame:RegisterEvent("AUTOFOLLOW_END")
frame:EnableMouse(true)

local target = nil
local isFollowing = false

function frame:OnEvent(event, arg1, arg2, ...)
    args = ...

    if (Settings:GetKey("AUTO_FOLLOW")) then
        if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" or event == "UNIT_POWER_UPDATE" then
            if event == "PLAYER_ENTERING_WORLD" then
                isFollowing = false
            end
            
            if target ~= nil and not isFollowing then 
                FollowUnit(target) 
            end
        end

        if event == "AUTOFOLLOW_BEGIN" then
            isFollowing = true
            target = arg1

            StaticPopupDialogs["RESET"] = {
                text = "", button1 = "Stop auto follow",
                OnAccept = function () 
                    target = nil 
                    FollowUnit("player") 
                end,
            }
            StaticPopup_Show("RESET");
        end

        if event == "AUTOFOLLOW_END" then
            isFollowing = false
        end
    end
end

frame:SetScript("OnEvent", frame.OnEvent)