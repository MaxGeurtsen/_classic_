--[[

    This is the source code that belongs to the addon of SpeedyAutoLoot, if you want a standalone version then you should download that addon!
    ## Interface: 11305
    ## Title: |cffEEE4AESpeedy AutoLoot|r
    ## Notes: |cff58C6FALoot at ludicrous speed!|r|n|n|cffFFC700Slash command: /sal, /speedyautoloot|r
    ## Author: Yuyuli
    ## Version: 2.0.31
    ## SavedVariables: SpeedyAutoLootDB

]]

SpeedyAutoLoot = CreateFrame("Frame")
local addonName = ...
local SAL_Settings = {}

local SetCVar = SetCVar or C_CVar.SetCVar
local GetCVarBool = GetCVarBool or C_CVar.GetCVarBool
local BACKPACK_CONTAINER, LOOT_SLOT_ITEM, NUM_BAG_SLOTS = BACKPACK_CONTAINER, LOOT_SLOT_ITEM, NUM_BAG_SLOTS
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local GetCursorPosition = GetCursorPosition
local GetItemCount = GetItemCount
local GetItemInfo = GetItemInfo
local GetLootSlotInfo = GetLootSlotInfo
local GetLootSlotLink = GetLootSlotLink
local GetLootSlotType = GetLootSlotType
local GetNumLootItems = GetNumLootItems
local IsFishingLoot = IsFishingLoot
local IsModifiedClick = IsModifiedClick
local LootSlot = LootSlot
local PlaySound = PlaySound
local band = bit.band
local select = select
local tContains = tContains

function SpeedyAutoLoot:ProcessLoot(item, q)
	local total, free, bagFamily = 0
	local itemFamily = GetItemFamily(item)
	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		free, bagFamily = GetContainerNumFreeSlots(i)
		if (not bagFamily or bagFamily == 0) or (itemFamily and band(itemFamily, bagFamily) > 0) then
			total = total + free
		end
	end
	if total > 0 then
		return true
	end

	local have = (GetItemCount(item) or 0)
	if have > 0 then
		local itemStackCount = (select(8,GetItemInfo(item)) or 0)
		if itemStackCount > 1 then
			while have > itemStackCount do
				have = have - itemStackCount
			end
			local remain = itemStackCount - have
			if remain >= q then
				return true
			end
		end
	end
	return false
end

function SpeedyAutoLoot:ShowLootFrame(show)
	if self.ElvUI then
		if show then
			ElvLootFrame:SetParent(ElvLootFrameHolder)
			ElvLootFrame:SetFrameStrata("HIGH")
			self:LootUnderMouse(ElvLootFrame, ElvLootFrameHolder, 20)
			self.isHidden = false
		else
			ElvLootFrame:SetParent(self)
			self.isHidden = true
		end
	elseif LootFrame:IsEventRegistered("LOOT_SLOT_CLEARED") then
		LootFrame.page = 1;
		if show then
			LootFrame_Show(LootFrame)
			self.isHidden = false
		else
			self.isHidden = true
		end
	end
end

function SpeedyAutoLoot:LootItems(numItems)
	local lootThreshold = (self.isClassic and select(2,GetLootMethod()) == 0) and GetLootThreshold() or 10
	for i = numItems, 1, -1 do
		local itemLink = GetLootSlotLink(i)
		local slotType = GetLootSlotType(i)
		local quantity, _, quality, locked, isQuestItem = select(3, GetLootSlotInfo(i))
		if locked or (quality and quality >= lootThreshold) then
			self.isItemLocked = true
		else
			if slotType ~= LOOT_SLOT_ITEM or (not self.isClassic and isQuestItem) or self:ProcessLoot(itemLink, quantity) then
				numItems = numItems - 1
				LootSlot(i)
			end
		end
	end
	if numItems > 0 then
		self:ShowLootFrame(true)
		self:PlayInventoryFullSound()
	end

	if IsFishingLoot() and not SAL_Settings.global.fishingSoundDisabled then
		PlaySound(SOUNDKIT.FISHING_REEL_IN, self.audioChannel)
	end
end

function SpeedyAutoLoot:OnEvent(e, ...)
	if Settings:GetKey("SPEEDY_AUTO_LOOT") then

		if e == "ADDON_LOADED" and ... == addonName then
			SpeedyAutoLootDB = SpeedyAutoLootDB or {}
			SAL_Settings = SpeedyAutoLootDB
			SAL_Settings.global = SAL_Settings.global or {}
		elseif e == "PLAYER_LOGIN" then
			if SAL_Settings.global.alwaysEnableAutoLoot then
				SetCVar("autoLootDefault",1)
			end

			C_Timer.After(1, function()
				self.ElvUI = (ElvUI and ElvUI[1].private.general.loot)
				self:ShowLootFrame(false)
			end)
		elseif (e == "LOOT_READY" or e == "LOOT_OPENED") and not self.isLooting then
			local aL = ...

			local numItems = GetNumLootItems()
			if numItems == 0 then
				return
			end

			self.isLooting = true
			if aL or (aL == nil and GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE")) then
				self:LootItems(numItems)
			else
				self:ShowLootFrame(true)
			end
		elseif e == "LOOT_CLOSED" then
			self.isLooting = false
			self.isHidden = false
			self.isItemLocked = false
			self:ShowLootFrame(false)
		elseif (e == "UI_ERROR_MESSAGE" and tContains(({ERR_INV_FULL,ERR_ITEM_MAX_COUNT}), select(2,...))) or e == "LOOT_BIND_CONFIRM" then
			if self.isLooting and self.isHidden then
				self:ShowLootFrame(true)
				if e == "UI_ERROR_MESSAGE" then
					self:PlayInventoryFullSound()
				end
			end
		end
	end
end

function SpeedyAutoLoot:PlayInventoryFullSound()
	if SAL_Settings.global.enableSound and not self.isItemLocked then
		PlaySound(SAL_Settings.global.InventoryFullSound, self.audioChannel)
	end
end

function SpeedyAutoLoot:LootUnderMouse(self, parent, yoffset)
	if GetCVarBool("lootUnderMouse") then
		local x, y = GetCursorPosition()
		x = x / self:GetEffectiveScale()
		y = y / self:GetEffectiveScale()

		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x - 40, y + (yoffset or 20))
		self:GetCenter()
		self:Raise()
	else
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", parent, "TOPLEFT")
	end
end

function SpeedyAutoLoot:OnLoad()
	self:SetToplevel(true)
	self:Hide()
	self:SetScript("OnEvent", function(_,...)
		self:OnEvent(...)
	end)

	for _,e in next, ({	"ADDON_LOADED", "PLAYER_LOGIN", "LOOT_READY", "LOOT_OPENED", "LOOT_CLOSED", "UI_ERROR_MESSAGE" }) do
		self:RegisterEvent(e)
	end

	self.audioChannel = "master"
	self.isClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)

	if self.isClassic then
        self:RegisterEvent("LOOT_BIND_CONFIRM")
        self:RegisterEvent("OPEN_MASTER_LOOT_LIST")
	end

	if Settings:GetKey("SPEEDY_AUTO_LOOT") then
		LootFrame:UnregisterEvent('LOOT_OPENED')
	end
end

SpeedyAutoLoot:OnLoad()
