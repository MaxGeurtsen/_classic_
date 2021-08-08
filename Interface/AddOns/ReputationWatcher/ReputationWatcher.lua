local isRussian = GetLocale() == "ruRU";


function ReputationWatcher_OnLoad(self)
    self:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
end


function ReputationWatcher_OnEvent(self, event, ...)
    if event == "CHAT_MSG_COMBAT_FACTION_CHANGE" then
        local message = ...

        -- checking for normal reputation gain
        local faction, amount = ReputationWaterch_TryGetFaction(message, FACTION_STANDING_INCREASED)

        if not faction then
            -- checking for reputation gain with recruit a friend bonus
            faction, amount = ReputationWaterch_TryGetFaction(message, FACTION_STANDING_INCREASED_BONUS)
        end

        -- setting faction for reputation gain
        -- We don't set faction for reputation losses because if this happens there's usually a second faction with a gain, so we pick the latter.
        if faction and amount and tonumber(amount) > 0 then
            ReputationWatcher_SetWatchedFaction(faction)
        end
    end
end


function ReputationWatcher_GetFactionIndex(faction)
    for i = 1, GetNumFactions() do
        local infoFaction = GetFactionInfo(i)

        -- compare faction name against faction name from list, and in case of Russion also against its grammar case as in FACTION_STANDING_INCREASED
        if infoFaction == faction or isRussian and format("|3-7(%s)", infoFaction) == faction then
            if IsFactionInactive(i) then
                break
            end
            return i
        end
    end
end


function ReputationWatcher_SetWatchedFaction(faction)
    local index = ReputationWatcher_GetFactionIndex(faction)
    if index and index > 0 then
        SetWatchedFactionIndex(index)
    end
end


function ReputationWaterch_TryGetFaction(message, factionString)
    -- escape all "magic characters" (except %) in case of modifications to the global string by another addon
    local pattern = string.gsub(factionString, "[%^%$%(%)%.%[%]%*%+%-%?]", "%%%0")

    -- replace digit format placeholder by search pattern for amount
    pattern = string.gsub(pattern, "%%d", "(%%d+)")

    -- replace string format placeholder by search pattern for faction name
    if isRussian then
        -- additionally remove Russion grammer case prefix "|3-7" since it is not contained in message
        pattern = string.gsub(pattern, "|3%-7%(%%s%)", "(.+)")
    else
        pattern = string.gsub(pattern, "%%s", "(.+)")
    end

    return strmatch(message, pattern)
end
