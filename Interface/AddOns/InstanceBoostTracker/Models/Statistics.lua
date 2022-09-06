Statistics = {}

function Statistics:CreateStatisticsFor(instanceId, playerName, instanceName)
    DebugHelper:Print("Statistics:CreateStatisticsFor()")

    playerName = playerName or IT_CONST_UNIT_NAME_PLAYER

    if SavedStatistics[instanceId] == nil then
        SavedStatistics[instanceId] = {}
    end

    local stats = SavedStatistics[instanceId]
    if stats[playerName] == nil then
        stats[playerName] = {
            Experience = 0,
            Gold = 0,
            Kills = 0,
            Reputation = 0,
            Name = instanceName
        }
    end
end

function Statistics:ImportStatistics(instanceId, playerName, experience, gold, kills, reputation, instanceName)
    DebugHelper:Print("Statistics:ImportStatistics()")
    
    -- If we don't check for the playername being nil then we will override our own statistics.
    -- We're doing this for a fail save check, in case we get a nil object
    if playerName then
        Statistics:CreateStatisticsFor(instanceId, playerName)
        SavedStatistics[instanceId][playerName] = {
            Experience = tonumber(experience),
            Gold = tonumber(gold),
            Kills = tonumber(kills),
            Reputation = tonumber(reputation),
            Name = instanceName
        }
    end
end

function Statistics:GetAllStatisticsFor(instanceId)
    return SavedStatistics[instanceId]
end

function Statistics:GetStatisticsFor(instanceId, playerName)
    return SavedStatistics[instanceId][playerName]
end

function Statistics:UpdateExp(instanceId, playerName, value)
    SavedStatistics[instanceId][playerName].Experience = SavedStatistics[instanceId][playerName].Experience + value
end

function Statistics:UpdateRep(instanceId, playerName, value)
    SavedStatistics[instanceId][playerName].Reputation = SavedStatistics[instanceId][playerName].Reputation + value
end

function Statistics:UpdateGold(instanceId, playerName, value)
    SavedStatistics[instanceId][playerName].Gold = SavedStatistics[instanceId][playerName].Gold + value
end

function Statistics:UpdateKills(instanceId, playerName, value)
    SavedStatistics[instanceId][playerName].Kills = SavedStatistics[instanceId][playerName].Kills + value
end

function Statistics:Delete(identifier)
    DebugHelper:Print("Statistics:Delete()")
    SavedStatistics[identifier] = nil
end

if SavedStatistics == nil then SavedStatistics = {} end
