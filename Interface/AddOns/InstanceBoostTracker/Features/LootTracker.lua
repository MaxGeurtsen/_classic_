LootTracker = {}

function LootTracker.CHAT_MSG_LOOT(...)

    if Settings:GetKey("REPORT_ELEMENTAL_EARTH") then
        if IsInInstance() then
            -- <Target> receives loot: <item>
            -- You receive loot: <item>
            local chatMsg, chatLineId = ...
            if string.find(chatMsg, "receives") then
                local receiver, _, _, item = strsplit(" ", chatMsg, 4)

                -- We don't want to register "You" as a potential target, hence we update it to the player name
                if receiver and item then
                    local itemName, itemLink, itemRarity = GetItemInfo(item)

                    if itemName and string.find(itemName, "Elemental Earth") then
                        --IT:PrintMsg("Detected elemental earth drop for player "..receiver)
                        SendChatMessage("Detected elemental earth drop for "..receiver, "PARTY");
                    end
                end
            end
        end
    end
end
