StatisticsTracker = {}
local INSTANCE_ID = nil
local NEW_BROADCAST_MESSAGE = false

function StatisticsTracker:Broadcast()
    local inInstance = IsInInstance()
    if NEW_BROADCAST_MESSAGE and inInstance and INSTANCE_ID then
        local instanceName = IT:GetInstanceInfo()
        local playerName = IT_CONST_UNIT_NAME_PLAYER
        local stats = Statistics:GetStatisticsFor(INSTANCE_ID, playerName)

        if instanceName and playerName and stats then
            local gold = stats.Gold or 0
            local experience = stats.Experience or 0
            local kills = stats.Kills or 0
            local reputation = stats.Reputation or 0
            
            Communication:BroadcastStatistics(instanceName, playerName, gold, experience, kills, reputation)
        end

        NEW_BROADCAST_MESSAGE = false
    end

    StatisticsTracker:BroadcastLoop()
end

function StatisticsTracker:BroadcastLoop()
    C_Timer.After(10, function() StatisticsTracker:Broadcast() end)
end
StatisticsTracker:BroadcastLoop()

function StatisticsTracker:StartTracking(identifier, playerName)
    DebugHelper:Print("StatisticsTracker:StartTracking()")

    if Settings:GetKey("FEATURE_LockoutStatistics") then
        INSTANCE_ID = identifier
        Statistics:CreateStatisticsFor(INSTANCE_ID, playerName)
    end
end

function StatisticsTracker:StopTracking()
    if INSTANCE_ID then
        StatisticsTracker:CreateDelayedStatisticsLink(INSTANCE_ID)
        INSTANCE_ID = nil
    end
end

function StatisticsTracker:ImportStatistics(instanceName, playerName, gold, experience, kills, reputation)
    DebugHelper:Print("StatisticsTracker:ImportStatistics()")

    if Settings:GetKey("FEATURE_LockoutStatistics") then
        local instanceLockout = CharacterLockout:Get(instanceName)
        if instanceLockout then
            DebugHelper:Print("-> Found id "..instanceLockout.identifier.." for the name "..instanceName)
            Statistics:ImportStatistics(instanceLockout.identifier, playerName, experience, gold, kills, reputation)
        end
    end
end

function StatisticsTracker:CreateStatisticsLink(identifier)
    if Settings:GetKey("STATISTICS_REPORT") and identifier then
        local link = "|cffff6633|HInstanceTrackerLink:lockoutstatistics:"..identifier.."|hClick here to view the statistics for "..identifier.."|h|r"
        --ChatFrame1:AddMessage(link);
        IT:PrintMsg(link)
    end
end

function StatisticsTracker:CreateDelayedStatisticsLink(identifier, delay)
    delay = delay or 3 -- in seconds

    C_Timer.After(delay, function() 
        StatisticsTracker:CreateStatisticsLink(identifier)
    end)
end

function StatisticsTracker:CHAT_MSG_MONEY(...)
    DebugHelper:Print("StatisticsTracker:CHAT_MSG_MONEY()")

	if INSTANCE_ID then
        local text = ...;
        local copperGained = string.match(text, "(%d+) Copper") or 0;
		local silverGained = string.match(text, "(%d+) Silver") or 0;
		local goldGained = string.match(text, "(%d+) Gold") or 0;
        local total = copperGained + (silverGained * 100) + (goldGained * 10000);

        DebugHelper:Print("-> Money gained")
        Statistics:UpdateGold(INSTANCE_ID, IT_CONST_UNIT_NAME_PLAYER, total)

        NEW_BROADCAST_MESSAGE = true
	end
end

function StatisticsTracker:CHAT_MSG_COMBAT_XP_GAIN(...)
    DebugHelper:Print("StatisticsTracker:CHAT_MSG_COMBAT_XP_GAIN()")

    -- We get a kill whenever we get xp..., this only works when we're below 60
    if INSTANCE_ID and UnitLevel("player") ~= 70 then
        DebugHelper:Print("-> Adding xp gained")

        local text = ...;
        local xpGained = string.match(text, "%d+");

        DebugHelper:Print("-> XP gained")
        Statistics:UpdateExp(INSTANCE_ID, IT_CONST_UNIT_NAME_PLAYER, xpGained)
        Statistics:UpdateKills(INSTANCE_ID, IT_CONST_UNIT_NAME_PLAYER, 1)

        NEW_BROADCAST_MESSAGE = true
    end
end

function StatisticsTracker:CHAT_MSG_COMBAT_FACTION_CHANGE(...)
    DebugHelper:Print("StatisticsTracker:CHAT_MSG_COMBAT_FACTION_CHANGE()")

    if INSTANCE_ID then 
        DebugHelper:Print("-> Adding rep gained")

        local text = ...;
        local repGained = string.match(text, "%d+");

        DebugHelper:Print("-> REP gained")
        Statistics:UpdateRep(INSTANCE_ID, IT_CONST_UNIT_NAME_PLAYER, repGained)

        NEW_BROADCAST_MESSAGE = true
    end
end

function StatisticsTracker:COMBAT_LOG_EVENT_UNFILTERED(...)
    DebugHelper:Print("StatisticsTracker:COMBAT_LOG_EVENT_UNFILTERED")

    -- Only use this function if we're 60, otherwise we'll add a kill count per time we get xp.
    if INSTANCE_ID and UnitLevel("player") == 70 then
        local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, 
                destName, destFlags, destRaidFlags, _, spellName = CombatLogGetCurrentEventInfo();

        if subEvent == "UNIT_DIED" and string.match(destGUID, "Creature") then
            DebugHelper:Print("-> Mob killed")
            Statistics:UpdateKills(INSTANCE_ID, IT_CONST_UNIT_NAME_PLAYER, 1)

            NEW_BROADCAST_MESSAGE = true
        end
    end
end

hooksecurefunc("ChatFrame_OnHyperlinkShow", function(...)
    local chatFrame, link, text, button = ...
    
    if string.find(link, "InstanceTrackerLink:lockoutstatistics") then
        DebugHelper:Print("-> Parsing link: "..link)

        local instanceId = link:gsub("InstanceTrackerLink:lockoutstatistics:", "")

        if instanceId then
            DebugHelper:Print("-> Possible instance ID: "..instanceId)
            GUILockoutStatistics:Create(tonumber(instanceId));
        end
    end
end)