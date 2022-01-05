IT = {}

local OriginalSetHyperlink = ItemRefTooltip.SetHyperlink
function ItemRefTooltip:SetHyperlink(link, ...)
	if link and string.match(link, "InstanceTrackerLink") then
		return;
	end
	return OriginalSetHyperlink(self, link, ...);
end

function IT:PrintMsg(msg)
    local colorCodeStr = "|cff00CB72"
    local prefix = colorCodeStr.."InstanceTracker: |r"
    
    print(prefix..msg)
end

function IT:ReloadUIPopup(msg)
	IT:PrintMsg(msg)
	StaticPopupDialogs["RELOAD_UI"] = {
		text = "Do you want to reload your UI?", button1 = "Yes", button2 = "No",
		OnAccept = function()
			ReloadUI()
		end,
	}
	StaticPopup_Show("RELOAD_UI");
end

function IT:GetInstanceInfo()
	local instanceName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()

	local dungeonDifficultyId = GetDungeonDifficultyID()
	--print ("Player has entered dungeon " .. instanceName .. " with difficulty " .. tostring(dungeonDifficultyId))

	-- Apparently in TBC the heroics are difficulty ID 174 you can verify this by running:
	-- /run for i = 1, 200 do local name = GetDifficultyInfo(i) if name then print(i, name) end end
	if (instanceType == "party" and (dungeonDifficultyId == 2 or dungeonDifficultyId == 174)) then -- heroic
        instanceName = "[H] " .. instanceName
    end

	return instanceName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID
end

if SavedAntiReloadUISettings == nil then SavedAntiReloadUISettings = {} end

IT_CONST_UNIT_NAME_PLAYER = UnitName("player")