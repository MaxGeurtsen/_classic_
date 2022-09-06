--[[
    - The first purpose of this class is solely to dictate the order the events get processed by our children
    - The second purpose is performance improvements, before we would have multiple event handlers, this way we provide a uniform way of handling the events
]]
local events = CreateFrame("frame")

function events.PLAYER_LOGIN()
    Payment:PLAYER_LOGIN()
    LockoutTracker:PLAYER_LOGIN()
    GUI:PLAYER_LOGIN()
    Communication:PLAYER_LOGIN()
    IT_NitIntegration:PLAYER_LOGIN()
end

function events.PLAYER_LOGOUT()
    CharacterLockout:PLAYER_LOGOUT()
    LockoutTracker:PLAYER_LOGOUT()
    GUI:PLAYER_LOGOUT()
end

function events.PLAYER_CAMPING()
    LockoutTracker:PLAYER_CAMPING()
end

function events.PLAYER_QUITING()
    LockoutTracker:PLAYER_QUITING()
end

function events.PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    CharacterLockout:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    LockoutTracker:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
end

function events.CHAT_MSG_MONEY(...)
    StatisticsTracker:CHAT_MSG_MONEY(...)
end

function events.CHAT_MSG_COMBAT_XP_GAIN(...)
    StatisticsTracker:CHAT_MSG_COMBAT_XP_GAIN(...)
end

function events.CHAT_MSG_COMBAT_FACTION_CHANGE(...)
    StatisticsTracker:CHAT_MSG_COMBAT_FACTION_CHANGE(...)
end

function events.COMBAT_LOG_EVENT_UNFILTERED(...)
    StatisticsTracker:COMBAT_LOG_EVENT_UNFILTERED(...)
end

function events.CHAT_MSG_LOOT(...)
    LootTracker.CHAT_MSG_LOOT(...)
end

function events.GROUP_ROSTER_UPDATE(...)
    LockoutTracker.GROUP_ROSTER_UPDATE(...)
end

function events.RAID_ROSTER_UPDATE(...)
    LockoutTracker.RAID_ROSTER_UPDATE(...)
end

function events.CHAT_MSG_ADDON(...)
    Communication:CHAT_MSG_ADDON(...)
    IT_NitIntegration:OnMessageReceived(...)
end

function events.PLAYER_FLAGS_CHANGED(...)
end

events:RegisterEvent("PLAYER_LOGIN")
events:RegisterEvent("PLAYER_LOGOUT")
events:RegisterEvent("PLAYER_CAMPING")
events:RegisterEvent("PLAYER_QUITING")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("CHAT_MSG_MONEY")
events:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
events:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
events:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
events:RegisterEvent("CHAT_MSG_LOOT")
events:RegisterEvent("GROUP_ROSTER_UPDATE")
events:RegisterEvent("RAID_ROSTER_UPDATE")
events:RegisterEvent("CHAT_MSG_ADDON")
events:RegisterEvent("PLAYER_FLAGS_CHANGED")
events:SetScript("OnEvent", function(self, event, ...) self[event](...) end)