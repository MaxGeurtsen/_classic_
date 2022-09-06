----------------------------------------------------------
-- Reputation Guide (RepHelper) | A World of Warcraft addon to help you manage your reputation and Factions. --
-------------------------------------------------------
---------------------------
-- _00_ Variables Set up --
---------------------------
REP_ToExalted = {}
REP_ToExalted[0] = 84000;
REP_ToExalted[1] = 48000;	-- working on Hated -> Hostile, base offset 21k+12k+6k+3k+3k+3k
REP_ToExalted[2] = 45000;	-- working on Hostile -> Unfriendly, base offset 21k+12k+6k+3k+3k
REP_ToExalted[3] = 42000;	-- working on Unfriendly -> Neutral, base offset 21k+12k+6k+3k
REP_ToExalted[4] = 39000;	-- working on Neutral -> Friendly, base offset 21k+12k+6k
REP_ToExalted[5] = 33000;	-- working on Friendly -> Honored, base offset 21k+12k
REP_ToExalted[6] = 21000;	-- working on Honored -> Revered, base offset 21k
REP_ToExalted[7] = 0;	-- working on Revered -> Exalted, so no base offset
REP_ToExalted[8] = 0;	-- already at Exalted -> no offset
-- Expansions
REP_Expansions = {}
REP_Expansions[0] = "Classic";
REP_Expansions[1] = "The Burning Crusade";
REP_Expansions[2] = "Wrath of the Lich King";
REP_Expansions[3] = "Cataclysm";
REP_Expansions[4] = "Mists of Pandaria";
REP_Expansions[5] = "Warlords of Draenor";
REP_Expansions[6] = "Legion";
REP_Expansions[7] = "Battle for Azeroth";
REP_Expansions[8] = "Shadowlands";
REP_Expansions[9] = "Dragonflight";
-- REP_Expansions[10] = "";

-- Addon constants
REP_NAME = "ReputationGuide"
REP_VNMBR = 6020012	-- Number code for this version
local addonName, vars = ...
local L = vars.L
REP = vars

-- Colours
REP_Help_COLOUR = "|cFFFFFF7F"
REP_NEW_REP_COLOUR = "|cFF7F7FFF"
REP_NEW_STANDING_COLOUR = "|cFF6060C0"
REP_BAG_COLOUR = "|cFFC0FFC0"
REP_BAG_BANK_COLOUR = "|cFFFFFF7F"
REP_QUEST_COLOUR = "|cFFC0FFC0"
REP_HIGHLIGHT_COLOUR = "|cFF00FF00"
REP_QUEST_ACTIVE_COLOUR = "|cFFFF7F7F"
REP_LOWLIGHT_COLOUR = "|cFFFF3F3F"
REP_SUPPRESS_COLOUR = "|cFF7F7F7F"
-- Faction bar colors
FACTION_BAR_COLORS = {
  [0] = {r = 0.8, g = 0.3, b = 0.22},
  [1] = {r = 0.8, g = 0.3, b = 0.22},
  [2] = {r = 0.8, g = 0.3, b = 0.22},
  [3] = {r = 0.75, g = 0.27, b = 0},
  [4] = {r = 0.9, g = 0.7, b = 0},
  [5] = {r = 0, g = 0.6, b = 0.1},
  [6] = {r = 0, g = 0.6, b = 0.1},
  [7] = {r = 0, g = 0.6, b = 0.1},
  [8] = {r = 0, g = 0.6, b = 0.1},
};
--Profestions ggg
REP_LIMIT_TYPE_Herb = 1
REP_LIMIT_TYPE_Skin = 2
REP_LIMIT_TYPE_Mine = 3
REP_LIMIT_TYPE_Gather = 4
REP_LIMIT_TYPE_Engi = 5
REP_LIMIT_TYPE_Alch = 6
REP_LIMIT_TYPE_Blac = 7
REP_LIMIT_TYPE_Tail = 8
REP_LIMIT_TYPE_Leat = 9
REP_LIMIT_TYPE_Ench = 10
REP_LIMIT_TYPE_Jewel = 11
REP_LIMIT_TYPE_Incr = 12
REP_LIMIT_TYPE_Aid = 13
REP_LIMIT_TYPE_Arch = 14
REP_LIMIT_TYPE_Cook = 15
REP_LIMIT_TYPE_Fish = 16

--------------------------
-- _01_ Addon Variables --
--------------------------
-- Stored data (Data saved between sessions)
-- REP_Data = {}

-- Initialization
REP_Main = nil
REP_InitComplete = nil
REP_VarsLoaded = nil
REP_InitStages = 0
REP_InitCount = 0
REP_difficultyID = 0
REP_UpdateRequest = nil
REP_UPDATE_INTERVAL = 5
REP_OnLoadingScreen = false

-- Faction information
REP_FactionMapping = {}
REP_FactionGain = {}

-- Tracking data
REP_Entries = {}

-- Skill Tracking ggg
REP_Herb = false
REP_Skin = false
REP_Mine = false
REP_Jewel = false
REP_Cook = false
REP_Arch = false
REP_Fish = false
REP_Aid = false
REP_Black = false
REP_Tailor = false
REP_Leath = false
REP_Enchan = false
REP_Engin = false
REP_Incrip = false
REP_Alche = false

--- Race/Side/Difficulty
REP_IsHuman = false
REP_IsDeathKnight = false
REP_IsAlliance = false
REP_IsHorde = false
REP_IsHeroic = false

-- Guild Tracking
REP_GuildName = nil

-- Garrison Trading post level 3
REP_HasTradingPost = false

--- Current Expansion
REP_IsClassic = false
REP_IsTBC = false
REP_IsWotlk = false
REP_IsCata = false
REP_IsMoP = false
REP_IsWoD = false
REP_IsLegion = false
REP_IsBfA = false
REP_IsShadowLands = false

--- After Expansion
REP_AfterClassic = false
REP_AfterTBC = false
REP_AfterWotlk = false
REP_AfterCata = false
REP_AfterMoP = false
REP_AfterWoD = false
REP_AfterLegion = false
REP_AfterBfA = false
REP_AfterShadowLands = false

------------------------
-- _02_ Addon Startup --
------------------------
function REP_OnLoad(self)
  -- Events monitored by Event Handler
  REP_Main = self
  self:RegisterEvent("ADDON_LOADED")
  self:RegisterEvent("VARIABLES_LOADED")
  self:RegisterEvent("PLAYER_ENTERING_WORLD")
  self:RegisterEvent("PLAYER_LOGIN")
  self:RegisterEvent("LOADING_SCREEN_ENABLED")
  self:RegisterEvent("LOADING_SCREEN_DISABLED")

  -- Slash commands for CLI
  SLASH_REP1 = "/REP"
  SLASH_REP2 = "/reputations"
  SlashCmdList.REP = REP_SlashHandler

  -- create data structures
  local defaultData = {
    ProfileKeys = {},
    ShowInstances = true,
    ShowQuests = true,
    SwitchFactionBar = false,
    SilentSwitch = false,
    WriteChatMessage = true,
    ChatFrame = 0,
    ExtendDetails = true,
    ShowMobs = true,
    OriginalCollapsed = {},
    ShowMissing = true,
    Version = REP_VNMBR,
    ShowItems = true,
    ShowPreviewRep = true,
    ShowGeneral = true,
    SortByStanding = false,
    Version = REP_VNMBR,
  }

  -- Assign the default settings
  if not REP_Data then REP_Data = {} end
  if not REP_Data.Global then REP_Data.Global = defaultData; end

  for option, default in pairs(defaultData) do
    if REP_Data.Global[option] == nil then REP_Data.Global[option] = default end
  end

  REP_Orig_GetFactionInfo = GetFactionInfo;  -- api function
  -- GetFactionInfo = REP_GetFactionInfo;  -- api function

  REP_Orig_ReputationFrame_Update = ReputationFrame_Update -- rfl function
  ReputationFrame_Update = REP_ReputationFrame_Update -- rfl function

  REP_Orig_ReputationBar_OnClick = ReputationBar_OnClick -- rfl function
  ReputationBar_OnClick = REP_ReputationBar_OnClick -- rfl function

  REP_Orig_ExpandFactionHeader = ExpandFactionHeader
  ExpandFactionHeader = REP_ExpandFactionHeader

  REP_Orig_CollapseFactionHeader = CollapseFactionHeader
  CollapseFactionHeader = REP_CollapseFactionHeader

  --REP_Orig_ChatFrame_OnEvent = ChatFrame_OnEvent
  --ChatFrame_OnEvent = REP_ChatFrame_OnEvent

  REP_Orig_StandingText = ReputationFrameStandingLabel:GetText()
end

------------------------
-- _03_ Event Handler --
------------------------
function REP_OnEvent(self, event, ...)
  if (event == "LOADING_SCREEN_ENABLED") then
    REP_OnLoadingScreen = true
  end

  if (event == "LOADING_SCREEN_DISABLED") then
    REP_OnLoadingScreen = false
    REP:DumpReputationChangesToChat() -- Just to make sure we don't miss printing out any rep gain that occured during the loading screen
  end

  local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13 = ...

  local expansionIndex = GetExpansionLevel();
  if not REP_Data.Global.ExpansionIndex then REP_Data.Global.ExpansionIndex = expansionIndex end
  if (REP_Data.Global.ExpansionIndex ~= expansionIndex) then REP_Data.Global.ExpansionIndex = expansionIndex end

  if (event == "ADDON_LOADED") and (arg1 == REP_NAME) then
    REP_Main:UnregisterEvent("ADDON_LOADED")
    REP_InitStages = REP_InitStages + 1
    REP:Init()
  elseif (event == "VARIABLES_LOADED") then
    REP_OnShowOptionFrame()
    REP_VarsLoaded = true
    REP_InitStages = REP_InitStages + 2
    REP:Init()
  elseif (event == "PLAYER_LOGIN") then
    REP_Main:UnregisterEvent("PLAYER_LOGIN")
    --REP_DoInitialCollapse()
    REP_InitStages = REP_InitStages + 4
    REP:Init()
  elseif (event == "PLAYER_ENTERING_WORLD") then
    REP_InitStages = REP_InitStages + 8
    REP:Init()
    REP_Main:UnregisterEvent("PLAYER_ENTERING_WORLD")
    REP_Main:RegisterEvent("UPDATE_FACTION")
    -- to keep item list up to date
    REP_Main:RegisterEvent("BAG_UPDATE")
    REP_Main:RegisterEvent("BANKFRAME_OPENED")
    REP_Main:RegisterEvent("BANKFRAME_CLOSED")
    -- to keep dungeon Difficulty up to date
    if(expansionIndex > 1) then
      REP_Main:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
    end
    -- to keep list of known skills up to date
    REP_Main:RegisterEvent("CHAT_MSG_SKILL")
    REP_Main:RegisterEvent("SKILL_LINES_CHANGED")
    REP_Main:RegisterEvent("UPDATE_TRADESKILL_RECAST")
    REP_Main:RegisterEvent("QUEST_COMPLETE")
    REP_Main:RegisterEvent("QUEST_WATCH_UPDATE")

    if(expansionIndex > 5) then
      REP_Main:RegisterEvent("GARRISON_UPDATE")
    end

    -- new chat hook system
    ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE", REP_ChatFilter)
    ChatFrame_AddMessageEventFilter("COMBAT_TEXT_UPDATE", REP_ChatFilter)

    REP:MakeUIChanges(expansionIndex);
  elseif (event == "UPDATE_FACTION" or event == "QUEST_COMPLETE" or event == "QUEST_WATCH_UPDATE") then
    if (ReputationFrame:IsVisible()) then
      ReputationFrame_Update();
    end
    if (REP_ReputationDetailFrame:IsVisible()) then
      REP:BuildUpdateList();
      REP_UpdateList_Update();
    end
    REP:DumpReputationChangesToChat();
  elseif (event == "BAG_UPDATE") then
    if (REP_ReputationDetailFrame:IsVisible()) then
      -- Update rep frame (implicitely updates detail frame which In turn implicitely reparses bag contents)
      ReputationFrame_Update()
    end
  elseif (event == "BANKFRAME_OPENED") then
    REP_BankOpen = true
  elseif (event == "BANKFRAME_CLOSED") then
    -- this is fired twice when closing the bank window, bank contents only available at the first Event
    if (REP_BankOpen) then
      -- this is the first call
      REP_BankOpen = nil
      if (REP_ReputationDetailFrame:IsVisible()) then
        -- Update rep frame (implicitely updates detail frame which In turn implicitely reparses bag contents)
        ReputationFrame_Update();
      end
    end
  elseif (event == "PLAYER_DIFFICULTY_CHANGED") then
    -- REP:Print("PLAYER_DIFFICULTY_CHANGED", nil)
  elseif (event == "CHAT_MSG_SKILL") or (event == "SKILL_LINES_CHANGED") or (event == "UPDATE_TRADESKILL_RECAST") then
    REP:ExtractSkills()
    if (ReputationFrame:IsVisible()) then
      ReputationFrame_Update(); -- rfl Event
    end
    if (REP_ReputationDetailFrame:IsVisible()) then
      REP:BuildUpdateList()
      REP_UpdateList_Update()
    end
  elseif (event == "GARRISON_UPDATE") then
    -- Get garrison buildings to check for trading post
    local garrisonBuildings = C_Garrison.GetBuildings(Enum.GarrisonType.Type_6_0)
    for i, building in pairs(garrisonBuildings) do
      if building["buildingID"] == 145 then
        REP_HasTradingPost = true
      end
    end

    REP_InitStages = REP_InitStages + 5
    REP:Init()
    REP_Main:UnregisterEvent("GARRISON_UPDATE")
  end
end

-------------------------------
function REP_OnUpdate(self)
  if not REP_UpdateRequest then return end
  if REP_InitComplete and REP_InitCount > 5 then return end
  if (GetTime() < REP_UpdateRequest) then return end

  if (REP_InitCount <= 5) then
    -- Guild level seems to only return a proper value a little later
    --REP:Print("update number "..tostring(REP_InitCount))
    REP_InitCount = REP_InitCount + 1
    REP_UpdateRequest = GetTime() + REP_UPDATE_INTERVAL

    if (REP_InitCount > 5) then
      REP_UpdateRequest = nil
      --REP:Print("Stopping updates")
    end
  end
end

function REP:DumpTable(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. REP:DumpTable(v) .. ','
    end

    return s .. '} '
  else
    return tostring(o)
  end
end

-------------------------------
-- _04_ Addon Initialization --
-------------------------------
function REP:InitVariable(var, value)
  local result = 0
  if var == nil then return result end

  if (not REP_Data.Global[var]) and (not REP_Data.Global[var.."_inited"]) then
    -- this option is not Set, and has never been Set by default, do so and let the user know
    REP_Data.Global[var] = value
    REP_Data.Global[var.."_inited"] = true
    result = 1
  elseif (not REP_Data.Global[var.."_inited"]) then
    -- the option is enabled, but not marked as inited, do so silently
    REP_Data.Global[var.."_inited"] = true
  end

  return result
end

-------------------------------
function REP:Init()
  if REP_InitComplete then return end
  local expansionIndex = REP_Data.Global.ExpansionIndex


  -- TODO: Check actual expansionIndex
  if (expansionIndex > 6) then
    if (REP_InitStages ~= 20) then return end
  else
    if (REP_InitStages ~= 15) then return end
  end

  local version = GetAddOnMetadata("ReputationGuide", "Version");
  if (version == nil) then
    version = "unknown";
  end

  -- create data structures
  if not REP_Data.Global.OriginalCollapsed then REP_Data.Global.OriginalCollapsed = {} end
  if REP_Data.Global.ChatFrame == nil then REP_Data.Global.ChatFrame = 0 end

  local changed = 0
  changed = changed + REP:InitVariable("ShowMobs", true)
  changed = changed + REP:InitVariable("ShowQuests", true)
  changed = changed + REP:InitVariable("ShowInstances", true)
  changed = changed + REP:InitVariable("ShowItems", true)
  changed = changed + REP:InitVariable("ShowGeneral", true)
  changed = changed + REP:InitVariable("ShowMissing", true)
  changed = changed + REP:InitVariable("ExtendDetails", true)
  changed = changed + REP:InitVariable("WriteChatMessage", true)
  changed = changed + REP:InitVariable("ShowPreviewRep", true)
  changed = changed + REP:InitVariable("SwitchFactionBar", true)
  changed = changed + REP:InitVariable("SilentSwitch", true)

  if expansionIndex > 6 then
    changed = changed + REP:InitVariable("NoGuildGain", true)
    changed = changed + REP:InitVariable("NoGuildSwitch", true)
    changed = changed + REP:InitVariable("ShowParagonBar", true)
  end

  if (changed > 0) then
    StaticPopupDialogs["REP_CONFIG_CHANGED"] = {
      text = REP_TXT.configQuestion,
      button1 = REP_TXT.showConfig,
      button2 = REP_TXT.later,
      OnAccept = function()
        REP:ToggleConfigWindow();
      end,
      --OnCancel = function()
      --	REP:Print(GLDG_Data.colours.help..GLDG_NAME..":|cFFFF0000 "..GLDG_TXT.reload)
      --end,
      timeout = 0,
      whileDead = 1,
      hideOnEscape = 1,
      -- sound = SOUNDKIT.IG_QUEST_LOG_ABANDON_QUEST,
    };

    StaticPopup_Show("REP_CONFIG_CHANGED");
  end

  -- keep version In configuration file
  REP_Data.Global.Version = REP_VNMBR

  -- Set up UI
  REP_OptionsFrameTitle:SetText(REP_NAME.." "..REP_TXT.options)
  REP_EnableMissingBoxText:SetText(REP_TXT.showMissing)
  REP_ExtendDetailsBoxText:SetText(REP_TXT.extendDetails)
  REP_GainToChatBoxText:SetText(REP_TXT.gainToChat)
  REP_ShowPreviewRepBoxText:SetText(REP_TXT.showPreviewRep)
  REP_SwitchFactionBarBoxText:SetText(REP_TXT.switchFactionBar)
  REP_SilentSwitchBoxText:SetText(REP_TXT.silentSwitch)
  REP_OrderByStandingCheckBoxText:SetText(REP_TXT.orderByStanding)

  if (expansionIndex > 6) then
    REP_NoGuildGainBox:Show();
    REP_NoGuildSwitchBox:Show();
    REP_EnableParagonBarBox:Show();
    REP_NoGuildGainBoxText:SetText(REP_TXT.noGuildGain)
    REP_NoGuildSwitchBoxText:SetText(REP_TXT.noGuildSwitch)
    REP_EnableParagonBarBoxText:SetText(REP_TXT.EnableParagonBar)

    REP_ShowPreviewRepBox:SetPoint("TOPLEFT", REP_GainToChatBox, "BOTTOMLEFT", 0, -20);

    REP:ExtractSkills()
  else
    REP_NoGuildGainBox:Hide();
    REP_NoGuildSwitchBox:Hide();
    REP_EnableParagonBarBox:Hide();

    REP_ShowPreviewRepBox:SetPoint("TOPLEFT", REP_GainToChatBox, "BOTTOMLEFT", 0, -5);
  end

  ---	REP_OnShowOptionFrame()

  local _, race = UnitRace("player")
  local faction, locFaction = UnitFactionGroup("player")
  local class, enClass = UnitClass("player")
  REP_Expansion = REP_Expansions[expansionIndex]
  REP_Player = UnitName("player")
  REP_Gender = UnitSex("player")
  REP_Realm = GetRealmName()
  REP_Class = class
  REP_ProfileKey = format("%s-%s", REP_Player, REP_Realm)

  if REP_Data.Global.ProfileKeys[REP_ProfileKey] == nil then REP_Data.Global.ProfileKeys[REP_ProfileKey] = true end
  if REP_Data[REP_ProfileKey] == nil then REP_Data[REP_ProfileKey] = {} end

  REP_Data[REP_ProfileKey].profile = {
    name	= REP_Player,
    realm	= REP_Realm,
    gender	= REP_Gender,
    level	= REP_Level,
    class	= REP_Class,
    faction	= locFaction,
    race = race
  }

  if REP_Data[REP_ProfileKey].quests == nil then REP_Data[REP_ProfileKey].quests = {} end

  if (IsInGuild()) then
    if (REP_GuildName == nil or REP_GuildName == "") then REP_GuildName = GetGuildInfo("player") end
  end

  if (race and faction and locFaction and REP_Player and REP_Realm) then
    if (REP_Expansion) then
      if(REP_Expansion == "Classic") then
        REP_IsClassic = true
      elseif(REP_Expansion == "The Burning Crusade") then
        REP_IsTBC = true
      elseif(REP_Expansion == "Wrath of the Lich King") then
        REP_IsWotlk = true
      elseif(REP_Expansion == "Cataclysm") then
        REP_IsCata = true
      elseif(REP_Expansion == "Mists of Pandaria") then
        REP_IsMoP = true
      elseif(REP_Expansion == "Warlords of Draenor") then
        REP_IsWoD = true
      elseif(REP_Expansion == "Legion") then
        REP_IsLegion = true
      elseif(REP_Expansion == "Battle for Azeroth") then
        REP_IsBfA = true
      elseif(REP_Expansion == "Shadowlands") then
        REP_IsShadowLands = true
      elseif(REP_Expansion == "Dragonflight") then
        REP_IsDragonflight = true
      else
        REP_IsClassic = true
      end
    else
      REP_IsClassic = true
    end

    if (not REP_IsClassic) then
      REP_AfterClassic = true
      if (not REP_IsTBC) then
        REP_AfterTBC = true
        if (not REP_IsWotlk) then
          REP_AfterWotlk = true
          if (not REP_IsCata) then
            REP_AfterCata = true
            if (not REP_IsMoP) then
              REP_AfterMoP = true
              if (not REP_IsWoD) then
                REP_AfterWoD = true
                if (not REP_IsLegion) then
                  REP_AfterLegion = true
                  if (not REP_IsBfA) then
                    REP_AfterBfA = true
                    if (not REP_IsShadowLands) then
                      REP_AfterShadowLands = true
                      if (not REP_IsDragonflight) then
                        REP_AfterDragonflight = true
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    if (race == "Human") then
      REP_IsHuman = true
    end

    if enClass and enClass == "DEATHKNIGHT" then
      REP_IsDeathKnight = true
    end

    if (faction == FACTION_ALLIANCE) or (locFaction == FACTION_ALLIANCE) then
      REP_IsAlliance = true
    end

    if (faction == FACTION_HORDE) or (locFaction == FACTION_HORDE) then
      REP_IsHorde = true
    end

    REP:InitFactor(REP_IsHuman)

    -- Initialize Faction information
    local locale = GetLocale()
    REP:InitFactionMap(locale, REP_GuildName)
    -- Changed by Bagdad for easy reputation content moderation
    REP_FactionGain = {}
    REP_InitEnFactionGains(REP_GuildName)
    REP:DumpReputationChangesToChat(true)

    REP_InitComplete = true
    if (REP_InitCount <= 5) then
      REP_UpdateRequest = GetTime() + REP_UPDATE_INTERVAL
      --REP:Print("Init complete, setting up updates ("..tostring(REP_InitCount).." already done)")
      --else
      --REP:Print("Init complete, not starting updates")
    end
  end
end

----------------------------------------
-- UI Changes based on expansionIndex --
----------------------------------------
function REP:MakeUIChanges(expansionIndex)
  if (not expansionIndex) then expansionIndex = REP_Data.Global.ExpansionIndex; end

  if expansionIndex > 6 then
    REP_OrderByStandingCheckBox:SetPoint("TOPLEFT", ReputationFrame, "TOPLEFT", 55, -20);
    REP_OptionsButton:SetPoint("TOPRIGHT", ReputationFrame, "TOPRIGHT", -2, -22);
    REP_OptionsFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 0, 0);
    REP_ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 0, 0);
  end
end

function REP:ToggleDarkmoonFaireBuff()
  REP_FactionGain = {}
  REP_InitEnFactionGains(REP_GuildName)
  REP_ReputationFrame_Update()
end

------------------------
-- _05_ Slash Handler --
------------------------
function REP_SlashHandler(msg)
  if not msg then
    return
  else
    local msgLower = string.lower(msg)
    local words = REP:GetWords(msg)
    local wordsLower = REP:GetWords(msgLower)
    local size = REP:TableSize(wordsLower)
    local FD_SH = REP_Data

    if (size > 0) then
      if (wordsLower[0] == "enable") then
        if (size > 1) then
          if (wordsLower[1] == "mobs") then
            FD_SH.ShowMobs = true
          elseif (wordsLower[1] == "quests") then
            FD_SH.ShowQuests = true
          elseif (wordsLower[1] == "dungeons" or wordsLower[1] == "instances") then
            FD_SH.ShowInstances = true
          elseif (wordsLower[1] == "items") then
            FD_SH.ShowItems = true
          elseif (wordsLower[1] == "general") then
            FD_SH.ShowGeneral = true
          elseif (wordsLower[1] == "missing") then
            FD_SH.ShowMissing = true
          elseif (wordsLower[1] == "details") then
            FD_SH.ExtendDetails = true
          elseif (wordsLower[1] == "chat") then
            FD_SH.WriteChatMessage = true
            FD_SH.NoGuildGain = false
          elseif (wordsLower[1] == "preview") then
            FD_SH.ShowPreviewRep = true
          elseif (wordsLower[1] == "bar") then
            FD_SH.SwitchFactionBar = true
            FD_SH.NoGuildSwitch = false
            FD_SH.SilentSwitch = false
          elseif (wordsLower[1] == "paragon") then
            FD_SH.ShowParagonBar = true
          elseif (wordsLower[1] == "all") then
            FD_SH.ShowMobs = true
            FD_SH.ShowQuests = true
            FD_SH.ShowInstances = true
            FD_SH.ShowItems = true
            FD_SH.ShowGeneral = true
            FD_SH.ShowMissing = true
            FD_SH.ExtendDetails = true
            FD_SH.WriteChatMessage = true
            FD_SH.NoGuildGain = false
            FD_SH.ShowPreviewRep = true
            FD_SH.SwitchFactionBar = true
            FD_SH.NoGuildSwitch = false
            FD_SH.SilentSwitch = false
          else
            REP:PrintSlash(REP_TXT.command,msgLower)
          end

          if (ReputationFrame:IsVisible()) then
            ReputationFrame_Update();
          end

          if (REP_ReputationDetailFrame:IsVisible()) then
            REP:BuildUpdateList();
            REP_UpdateList_Update();
          end
        else
          REP:PrintSlash(REP_TXT.command,msgLower);
        end
      elseif (wordsLower[0] == "disable") then
        if (size > 1) then
          if (wordsLower[1] == "mobs") then
            FD_SH.ShowMobs = false
          elseif (wordsLower[1] == "quests") then
            FD_SH.ShowQuests = false
          elseif (wordsLower[1] == "dungeons" or wordsLower[1] == "instances") then
            FD_SH.ShowInstances = false
          elseif (wordsLower[1] == "items") then
            FD_SH.ShowItems = false
          elseif (wordsLower[1] == "general") then
            FD_SH.ShowGeneral = false
          elseif (wordsLower[1] == "missing") then
            FD_SH.ShowMissing = false
          elseif (wordsLower[1] == "details") then
            FD_SH.ExtendDetails = false
          elseif (wordsLower[1] == "chat") then
            FD_SH.WriteChatMessage = false
            FD_SH.NoGuildGain = false
          elseif (wordsLower[1] == "preview") then
            FD_SH.ShowPreviewRep = false
          elseif (wordsLower[1] == "bar") then
            FD_SH.SwitchFactionBar = false
            FD_SH.NoGuildSwitch = false
            FD_SH.SilentSwitch = false
          elseif (wordsLower[1] == "paragon") then
            FD_SH.ShowParagonBar = false
          elseif (wordsLower[1] == "all") then
            FD_SH.ShowMobs = false
            FD_SH.ShowQuests = false
            FD_SH.ShowInstances = false
            FD_SH.ShowItems = false
            FD_SH.ShowGeneral = false
            FD_SH.ShowMissing = false
            FD_SH.ExtendDetails = false
            FD_SH.WriteChatMessage = false
            FD_SH.NoGuildGain = false
            FD_SH.ShowPreviewRep = false
            FD_SH.SwitchFactionBar = false
            FD_SH.NoGuildSwitch = false
            FD_SH.SilentSwitch = false
          else
            REP:PrintSlash(REP_TXT.command,msgLower)
          end

          if (ReputationFrame:IsVisible()) then
            ReputationFrame_Update(); -- rfl Event
          end

          if (REP_ReputationDetailFrame:IsVisible()) then
            REP:BuildUpdateList()
            REP_UpdateList_Update()
          end
        else
          REP:PrintSlash(REP_TXT.command, msgLower)
        end
      elseif (wordsLower[0] == "toggle") then
        if (size>1) then
          if (wordsLower[1] == "mobs") then
            FD_SH.ShowMobs = not FD_SH.ShowMobs
          elseif (wordsLower[1] == "quests") then
            FD_SH.ShowQuests = not FD_SH.ShowQuests
          elseif (wordsLower[1] == "dungeons" or wordsLower[1] == "instances") then
            FD_SH.ShowInstances = not FD_SH.ShowInstances
          elseif (wordsLower[1] == "items") then
            FD_SH.ShowItems = not FD_SH.ShowItems
          elseif (wordsLower[1] == "general") then
            FD_SH.ShowGeneral = not FD_SH.ShowGeneral
          elseif (wordsLower[1] == "missing") then
            FD_SH.ShowMissing = not FD_SH.ShowMissing
          elseif (wordsLower[1] == "details") then
            FD_SH.ExtendDetails = not FD_SH.ExtendDetails
          elseif (wordsLower[1] == "chat") then
            FD_SH.WriteChatMessage = not FD_SH.WriteChatMessage
            FD_SH.NoGuildGain = false
          elseif (wordsLower[1] == "preview") then
            FD_SH.ShowPreviewRep = not FD_SH.ShowPreviewRep
          elseif (wordsLower[1] == "preview") then
            FD_SH.SwitchFactionBar = not FD_SH.SwitchFactionBar
            FD_SH.NoGuildSwitch = false
            FD_SH.SilentSwitch = false
          elseif (wordsLower[1] == "paragon") then
            FD_SH.ShowParagonBar = not FD_SH.ShowParagonBar;
          elseif (wordsLower[1] == "all") then
            FD_SH.ShowMobs = not FD_SH.ShowMobs
            FD_SH.ShowQuests = not FD_SH.ShowQuests
            FD_SH.ShowInstances = not FD_SH.ShowInstances
            FD_SH.ShowItems = not FD_SH.ShowItems
            FD_SH.ShowGeneral = not FD_SH.ShowGeneral
            FD_SH.ShowMissing = not FD_SH.ShowMissing
            FD_SH.ExtendDetails = not FD_SH.ExtendDetails
            FD_SH.WriteChatMessage = not FD_SH.WriteChatMessage
            FD_SH.NoGuildGain = false
            FD_SH.ShowPreviewRep = not FD_SH.ShowPreviewRep
            FD_SH.SwitchFactionBar = not FD_SH.SwitchFactionBar
            FD_SH.NoGuildSwitch = false
            FD_SH.SilentSwitch = false
          else
            REP:PrintSlash(REP_TXT.command,msgLower);
          end

          if (ReputationFrame:IsVisible()) then
            ReputationFrame_Update();
          end

          if (REP_ReputationDetailFrame:IsVisible()) then
            REP:BuildUpdateList()
            REP_UpdateList_Update()
          end
        else
          REP:PrintSlash(REP_TXT.command,msgLower)
        end
      elseif (wordsLower[0] == "list") then
        if (size > 1) then
          if (wordsLower[1] == "1" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL1"])) then
            REP:ListByStanding(1)
          elseif (wordsLower[1] == "2" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL2"])) then
            REP:ListByStanding(2)
          elseif (wordsLower[1] == "3" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL3"])) then
            REP:ListByStanding(3)
          elseif (wordsLower[1] == "4" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL4"])) then
            REP:ListByStanding(4)
          elseif (wordsLower[1] == "5" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL5"])) then
            REP:ListByStanding(5)
          elseif (wordsLower[1] == "6" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL6"])) then
            REP:ListByStanding(6)
          elseif (wordsLower[1] == "7" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL7"])) then
            REP:ListByStanding(7)
          elseif (wordsLower[1] == "8" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL8"])) then
            REP:ListByStanding(8)
          else
            REP:PrintSlash(REP_TXT.command, msgLower)
          end
        else
          REP:ListByStanding()
        end
      elseif (wordsLower[0] == "loc") then
        if (size > 1) then
          if (wordsLower[1] == "1" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL1"])) then
            REP:ListByStanding(1)
          elseif (wordsLower[1] == "2" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL2"])) then
            REP:ListByStanding(2)
          elseif (wordsLower[1] == "3" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL3"])) then
            REP:ListByStanding(3)
          elseif (wordsLower[1] == "4" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL4"])) then
            REP:ListByStanding(4)
          elseif (wordsLower[1] == "5" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL5"])) then
            REP:ListByStanding(5)
          elseif (wordsLower[1] == "6" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL6"])) then
            REP:ListByStanding(6)
          elseif (wordsLower[1] == "7" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL7"])) then
            REP:ListByStanding(7)
          elseif (wordsLower[1] == "8" or wordsLower[1] == string.lower(_G["FACTION_STANDING_LABEL8"])) then
            REP:ListByStanding(8)
          else
            REP:PrintSlash(REP_TXT.command,msgLower)
          end
        else
          REP_ShowGerman()
        end
      elseif (wordsLower[0] == "test") then
        REP_Test()
      elseif (wordsLower[0] == "status") then
        REP:Status()
      elseif (wordsLower[0] == "help") then
        REP:Help()
      elseif (wordsLower[0] == "about") then
        REP:About()
      elseif (wordsLower[0] == "watch") then
        if (wordsLower[2]) then
          local repToWatch = table.concat(wordsLower, " ")
          REP:WatchFaction(repToWatch)
        else
          REP:WatchFaction(wordsLower[1])
        end
      else
        REP:PrintSlash(REP_TXT.command, msgLower)
      end
    else
      -- do nothing
    end
  end
end

-----------------------------------
-- _06_ General Helper Functions --
-----------------------------------
function REP:WatchFaction(faction)
  if not faction then return end

  local numFactions = GetNumFactions();
  for i = 1, numFactions, 1 do
    local index = i;
    local name, _, _, _, _, _, _, _, _, _, _, _, _, factionID, _, _ = GetFactionInfo(index);

    if (name or factionID or index) then
      if (string.lower(name) == tostring(faction)) then
        return SetWatchedFactionIndex(index)
      elseif (tostring(faction) == tostring(factionID)) then
        return SetWatchedFactionIndex(index)
      elseif faction == index then
        return SetWatchedFactionIndex(index)
      end
    else
      return REP:Print("Could not find a faction with either factionID: "..tostring(faction)..", index #"..tostring(faction).." or name: "..tostring(faction));
    end
  end
end

------------------------------------------------------------
function REP:Print(msg, forceDefault) --zzz
  if not (msg) then return end

  if ((REP_Data==nil) or forceDefault) then
    DEFAULT_CHAT_FRAME:AddMessage(msg)
  else
    for i = 1, NUM_CHAT_WINDOWS do
      local chatTab = _G["ChatFrame"..i.."Tab"]
      if chatTab:IsShown() then
        local chatFrame = _G["ChatFrame"..i]
        local messageTypes = chatFrame.messageTypeList
        for j = 1, #messageTypes do
          if messageTypes[j] == "COMBAT_FACTION_CHANGE" then
            _G["ChatFrame"..i]:AddMessage(msg)
          end
        end
      end
    end
  end
end
------------------------------------------------------------
function REP:Printtest(msg,msg1,msg2)
  REP:Print(""..tostring(msg).." "..tostring(msg1).."  "..tostring(msg2), nil)
end
------------------------------------------------------------
function REP:PrintSlash(msg,msg1)
  REP:Print(REP_Help_COLOUR..REP_NAME..":|r "..msg.." ["..REP_Help_COLOUR..msg1.."|r]", true)
  REP:Help()
end
------------------------------------------------------------
function REP:Debug(msg)
  if not (msg) then return end
  REP:Print(msg)
end
------------------------------------------------------------
function REP:TableSize(info)
  local result = 0
  if info then
    for item in pairs(info) do result = result + 1 end
  end
  return result
end

------------------------------------------------------------
function REP:GetWords(str)
  local ret = {};
  local pos=0;
  local index=0
  while(true) do
    local word;
    _,pos,word=string.find(str, "^ *([^%s]+) *", pos+1);
    if(not word) then
      return ret;
    end
    ret[index]=word
    index = index+1
  end
end

------------------------------------------------------------
function REP:Concat(list, start, stop)
  local ret = "";

  if (start == nil) then start = 0 end
  if (stop == nil) then stop = REP:TableSize(list) end

  for i = start,stop do
    if list[i] then
      if (ret ~= "") then ret = ret.." " end
        ret = ret..list[i]
      end
    end
  return ret
end

------------------------------------------------------------
function REP:BoolToEnabled(b)
  local result = REP_TXT.disabled
  if b then result = REP_TXT.enabled end
  return result
end

------------------------------------------------------------
function REP:RGBToColour_perc(a, r, g, b)
  return string.format("|c%02X%02X%02X%02X", a*255, r*255, g*255, b*255)
end

function REP:has_value (tab, val)
  for index, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
end

------------------------
-- _07_ information
------------------------
function REP:Help()
  REP:Print(" ", true)
  REP:Print(REP_Help_COLOUR..REP_NAME..":|r "..REP_TXT.help, true)
  REP:Print(REP_Help_COLOUR..REP_TXT.usage..":|r /REP help "..REP_Help_COLOUR..REP_TXT.helphelp, true)
  REP:Print(REP_Help_COLOUR..REP_TXT.usage..":|r /REP about "..REP_Help_COLOUR..REP_TXT.helpabout, true)
  REP:Print(REP_Help_COLOUR..REP_TXT.usage..":|r /REP status "..REP_Help_COLOUR..REP_TXT.helpstatus, true)
  REP:Print(REP_Help_COLOUR..REP_TXT.usage..":|r /REP watch <factionID> set faction as watched", true) -- TODO: Add as localised text
  REP:Print(REP_Help_COLOUR..REP_TXT.usage..":|r /REP enable { mobs | quests | instances | items | all }", true)
  REP:Print(REP_Help_COLOUR..REP_TXT.usage..":|r /REP disable { mobs | quests | instances | items | all }", true)
  REP:Print(REP_Help_COLOUR..REP_TXT.usage..":|r /REP toggle { mobs | quests | instances | items | all }", true)
  REP:Print(REP_Help_COLOUR..REP_TXT.usage..":|r /REP enable { missing | details | chat | paragon }", true)
  REP:Print(REP_Help_COLOUR..REP_TXT.usage..":|r /REP disable { missing | details | chat | paragon}", true)
  REP:Print(REP_Help_COLOUR..REP_TXT.usage..":|r /REP toggle { missing | details | chat | paragon}" , true)
end
------------------------------------------------------------
function REP:About()
  local ver = GetAddOnMetadata("ReputationGuide", "Version");
  local date = GetAddOnMetadata("ReputationGuide", "X-Date");
  local author = GetAddOnMetadata("ReputationGuide", "Author");
  local web = GetAddOnMetadata("ReputationGuide", "X-Website");

  if (author ~= nil) then
    REP:Print(REP_NAME.." "..REP_TXT.by..": "..REP_Help_COLOUR..author.."|r"..", updated and maintained by: "..REP_Help_COLOUR.."Tvlfrosty-Firemaw".."|r", true);
  end
  if (ver ~= nil) then
    REP:Print(" "..REP_TXT.version..": "..REP_Help_COLOUR..ver.."|r", true);
  end

  if (date ~= nil) then
    REP:Print(" "..REP_TXT.date..": "..REP_Help_COLOUR..date.."|r", true);
  end
  if (web ~= nil) then
    REP:Print(" "..REP_TXT.web..": "..REP_Help_COLOUR..web.."|r", true);
  end
end
------------------------------------------------------------
function REP:Status()
  REP:Print(" ", true)
  REP:Print(REP_Help_COLOUR..REP_NAME..":|r "..REP_TXT.status, true)
  REP:Print("   "..REP_TXT.statMobs..": "..REP_Help_COLOUR..REP:BoolToEnabled(REP_Data.Global.ShowMobs).."|r", true)
  REP:Print("   "..REP_TXT.statQuests..": "..REP_Help_COLOUR..REP:BoolToEnabled(REP_Data.Global.ShowQuests).."|r", true)
  REP:Print("   "..REP_TXT.statInstances..": "..REP_Help_COLOUR..REP:BoolToEnabled(REP_Data.Global.ShowInstances).."|r", true)
  REP:Print("   "..REP_TXT.statItems..": "..REP_Help_COLOUR..REP:BoolToEnabled(REP_Data.Global.ShowItems).."|r", true)
  REP:Print("   "..REP_TXT.statGeneral..": "..REP_Help_COLOUR..REP:BoolToEnabled(REP_Data.Global.ShowGeneral).."|r", true)
  REP:Print("   "..REP_TXT.statMissing..": "..REP_Help_COLOUR..REP:BoolToEnabled(REP_Data.Global.ShowMissing).."|r", true)
  REP:Print("   "..REP_TXT.statDetails..": "..REP_Help_COLOUR..REP:BoolToEnabled(REP_Data.Global.ExtendDetails).."|r", true)
  REP:Print("   "..REP_TXT.statChat..": "..REP_Help_COLOUR..REP:BoolToEnabled(REP_Data.Global.WriteChatMessage).."|r", true)

  REP:Print("   "..REP_TXT.statNoGuildChat..": "..REP_Help_COLOUR..REP:BoolToEnabled(REP_Data.Global.NoGuildGain).."|r", true)
  REP:Print("   "..REP_TXT.statPreview..": "..REP_Help_COLOUR..REP:BoolToEnabled(REP_Data.Global.ShowPreviewRep).."|r", true)
  REP:Print("   "..REP_TXT.statSwitch..": "..REP_Help_COLOUR..REP:BoolToEnabled(REP_Data.Global.SwitchFactionBar).."|r", true)
  REP:Print("   "..REP_TXT.statNoGuildSwitch..": "..REP_Help_COLOUR..REP:BoolToEnabled(REP_Data.Global.NoGuildSwitch).."|r", true)
  REP:Print("   "..REP_TXT.statSilentSwitch..": "..REP_Help_COLOUR..REP:BoolToEnabled(REP_Data.Global.SilentSwitch).."|r", true)
  REP:Print("   "..REP_TXT.EnableParagonBar..": "..REP_Help_COLOUR..REP:BoolToEnabled(REP_Data.Global.ShowParagonBar).."|r", true)
end

-----------------------------------
-- _08_ Faction map --
-----------------------------------
function REP:InitMapName(fimap)
  local map

  if (type(fimap) == "number") then
    if fimap == 1 then
      map = REP_TXT.srfd
    elseif fimap== 2 then
      map = REP_TXT.tbd
    elseif fimap== 3 then
      map = REP_TXT.mnd
    elseif fimap== 5 then
      map = REP_TXT.nci
    elseif fimap == 6 then
      map = REP_TXT.hci
    elseif not fimap then
      map = " "
    else
      local mapObj;
      local mapName;
      if C_Map then
        mapObj = C_Map.GetMapInfo(fimap);

        if mapObj then
          mapName = mapObj.name
        else
          mapName = fimap
        end
      elseif GetMapInfo then
        mapObj = GetMapInfo(fimap);

        if mapObj then
          mapName = mapObj.name
        else
          mapName = fimap
        end
      else
        mapName = fimap
      end

      map = mapName
    end
  end

  if not map then
    map = fimap
  end

  return map
end

function REP:InitMobName(fimob)
  local mob

  if fimob == 1 then
    mob = REP_TXT.tmob
  elseif fimob== 2 then
    mob = REP_TXT.oboss
  elseif fimob== 3 then
    mob = REP_TXT.aboss
  elseif fimob == 4 then
    mob = REP_TXT.pboss
  elseif fimob == 5 then
    mob = REP_TXT.fclear
  elseif fimob == 11 then
    mob = (REP_TXT.AU.." "..REP_TXT.BB)
  elseif fimob== 12 then
    mob = (REP_TXT.AU.." "..REP_TXT.SSP)
  elseif fimob== 13 then
    mob = (REP_TXT.AU.." "..REP_TXT.Wa)
  elseif fimob == 14 then
    mob = REP_TXT.VCm
  elseif fimob == 15 then
    mob = (REP_TXT.AN.." "..REP_TXT.BB)
  elseif fimob== 16 then
    mob = (REP_TXT.AN.." "..REP_TXT.SSP)
  elseif fimob== 17 then
    mob = (REP_TXT.AN.." "..REP_TXT.Wa)
  else
    --[[--
      local mobName = GetmobNameByID(fimob);
      mob = mobName
    --]]--
  end

  if not mob then
    mob = fimob
  end

  return mob
end

function REP:InitItemName(fiitem,amt)
  if fiitem==1 then
    item_name = REP_TXT.cdq
  elseif fiitem==2 then
    item_name = REP_TXT.fdq
  elseif fiitem==3 then
    item_name = REP_TXT.ndq
  elseif fiitem == 4 then
    item_name = REP_TXT.cbadge
  elseif fiitem == 5 then
    item_name = REP_TXT.deleted
  else
    item_name = GetItemInfo(fiitem)
  end

  if not item_name then
    item_name = fiitem

    -- item = C_CurrencyInfo.GetCurrencyInfo(fiitem)

    -- if item then
      -- item_name = item.name
    -- end
  end

  if not item_name then
    item_name = fiitem
  end

  return item_name
end

function REP:Quest_Names(questIndex)
  local expansionIndex = REP_Data.Global.ExpansionIndex
  local quest = nil

  if (expansionIndex < 2) then
    if (type(questIndex) == "number") then
      if (REP_QuestDB[questIndex]) then
        local localization = GetLocale()
        if localization == "esMX" then localization = "esES" end
        if localization == "zhTW" then localization = "zhCN" end

        quest = REP_QuestDB[questIndex][localization]
      else
        quest = "Quest name not available. QuestID: "..questIndex
      end
    else
      quest = questIndex
    end
  else
    if (type(questIndex) == "number") then
      REP_HiddenQuestTooltip:SetOwner(WorldFrame, ANCHOR_NONE)
      REP_HiddenQuestTooltip:SetHyperlink(format("quest:%d", questIndex))

      quest = REP_HiddenQuestTooltipTextLeft1:GetText()
      REP_HiddenQuestTooltip:Hide()
    else
      quest = questIndex
    end
  end


  if questIndex == 1 then
    quest = REP_TXT.cdq
  elseif questIndex == 2 then
    quest = REP_TXT.coq
  elseif questIndex == 3 then
    quest = REP_TXT.fdq
  elseif questIndex == 4 then
    quest = REP_TXT.foq
  elseif questIndex == 5 then
    quest = REP_TXT.ndq
  elseif questIndex == 6 then
    quest = REP_TXT.deleted
  elseif questIndex == 7 then
    quest = REP_TXT.Championing
  elseif questIndex == 8 then
    quest = REP_TXT.bpqfg
  elseif questIndex == 9 then
    quest = REP_TXT.djdq
  elseif questIndex == 99 then
    quest = REP_TXT.tbd
  else
    if not quest then
      quest = questIndex
    end
  end

  return quest
end

function REP:GetTabardFaction()
  for i = 1, 40 do
    local _, _, _, _, _, _, _, _, _, _, id = UnitBuff("player", i)
    if not id then
      break
    end

    local data = championFactions[id]
    if data then
      local faction, level = data[2], data[1]
      if DEBUG then self:Debug("GetChampionedFaction:", tostring(faction), tostring(level)) end
      return faction, level
    end
  end

  if DEBUG then self:Debug("GetChampionedFaction:", "none") end
end

function REP:InitFactor(REP_IsHuman, faction)
  --- Thanks Gwalkmaur for the heads up

  local draenorFactions = {"Council of Exarchs",
  "Frostwolf Orcs",
  "Wrynn's Vanguard",
  "Vol'jin's Spear",
  "Sha'tari Defense",
  "Laughing Skull Orcs",
  "Hand of the Prophet",
  "Vol'jin's Headhunters",
  "Arakkoa Outcasts",
  "Order of the Awakened",
  "The Saberstalkers",
  "Steamwheedle Preservation Society"}

  local factor = 1.0

  -- Race check
  if REP_IsHuman then factor = factor + 0.1 end
  -- WoD Faction trading post bonus
  if REP:has_value(draenorFactions, faction) and REP_HasTradingPost then
    factor = factor + 0.2;
  end

  -- Darkmoon Faire reputation buff setting
  if REP_Data.Global.ShowDarkmoonFaire then
    factor = factor + 0.1
  end

  -- bonus repgain check
  local numFactions = GetNumFactions();
  local factionOffset = 0;
  local factionIndex;
  local factor_h = 0

  for i=1,numFactions do
    local factionIndex = factionOffset + i;
    if (factionIndex <= numFactions) then
      local name, hasBonusRepGain;
      local name, _, _, _, _, _, _, _, _, _, _, _, _, _, hasBonusRepGain, _ = GetFactionInfo(factionIndex);
      if (faction == name) then
          --- f_if	REP:Printtest(faction,name,"test")
        if (hasBonusRepGain) then
          --- f_if	REP:Printtest(faction,name,"Gain")
          factor=factor + 1;
        end
      end
    end
  end
  return factor
end

function REP:InitFaction(guildName, faction)
  if faction == "guildName" or faction == REP_GuildName then
    REP_faction = faction
  else
    REP_faction = GetFactionInfoByID(faction)
  end

  return REP_faction
end

function REP:InitFactionMap(locale, guildName)
  REP_FactionMapping = {}
  REP_InitEnFactions();

  if (guildName) then
    REP_AddMapping(guildName, guildName)
  end
end

function REP_AddMapping(english, localised)
  if (not REP_FactionMapping) then
    REP_FactionMapping = {}
  end

  if (REP:InitFaction(REP_GuildName,localised)) then
    REP_FactionMapping[string.lower(REP_faction)] = string.lower(english)
  end
end

------------------------------------
-- _09_ Faction Lists --
------------------------------------
function REP:Content(faction, from, to, name, rep)
  if not faction then return 0 end
  if not from then return 0 end
  if not to then return 0 end
  if not name then return 0 end
  if not rep then return 0 end
  if (type(rep) ~= "number") then return 0 end
  if ((from<1) or (from>8)) then return 0 end
  if ((to<1) or (to>8)) then return 0 end
  if (from > to) then return 0 end
  return 1
end

function REP_AddSpell(faction, from, to, name, rep, zone, limit)
  --[[--	if not faction then return end
    if not from then return end
    if not to then return end
    if not name then return end
    if not rep then return end
    if (type(rep) ~= "number") then return end
    if ((from<1) or (from>8)) then return end
    if ((to<1) or (to>8)) then return end
    if (from > to) then return end
  --]]--

  if REP:Content(faction, from, to, name, rep) ~=1 then return end
  --[[-- REP_Initspellname(name)
  -- REP:InitMapName(zone)

  rep = rep * REP:InitFactor(REP_IsHuman,REP_faction)
  faction = string.lower(REP:InitFaction(REP_GuildName,faction))

  for standing = from, to do
    local faction_info = REP_FactionGain[faction]
    if not faction_info then
      faction_info = {}
      REP_FactionGain[faction] = faction_info
    end

    local standing_info = faction_info[standing]
    if not standing_info then
      standing_info = {}
      faction_info[standing] = standing_info
    end

    local add_info = standing_info.spells
    if add_info then
      add_info.count = add_info.count + 1
    else
      add_info = {}
      add_info.data = {}
      add_info.count = 0
      standing_info.spells = add_info
    end

    local count = add_info.count;
    add_info.data[count] = {};
    local add_count=add_info.data[count];
    add_count.name = mark_spell;
    add_count.rep = rep;
    add_count.zone = zone;
    add_count.maxStanding = to;

    if ((standing == to) and limit) then
      add_count.limit = limit
    end

    REP:Debug("Added spell ["..name.."] for faction ["..faction.."] and standing [".._G["FACTION_STANDING_LABEL"..standing].."]")
  end	--]]--
end

function REP_AddMob(faction, from, to, name, rep, zone, limit)
  --[[--
    if not faction then return end
    if not from then return end
    if not to then return end
    if not name then return end
    if not rep then return end
    if (type(rep) ~= "number") then return end
    if ((from<1) or (from>8)) then return end
    if ((to<1) or (to>8)) then return end
    if (from > to) then return end
  --]]--

  if REP:Content(faction, from, to, name, rep) ~=1 then return end
  faction = string.lower(REP:InitFaction(REP_GuildName, faction));
  rep = rep * REP:InitFactor(REP_IsHuman,REP_faction);

  for standing = from,to do
    local faction_info = REP_FactionGain[faction];
    if not faction_info then
      faction_info = {}
      REP_FactionGain[faction] = faction_info
    end

    local standing_info = faction_info[standing]
    if not standing_info then
      standing_info = {}
      faction_info[standing] = standing_info
    end

    local add_info = standing_info.mobs
    if add_info then
      add_info.count = add_info.count + 1
    else
      add_info = {}
      add_info.data = {}
      add_info.count = 0
      standing_info.mobs = add_info
    end

    local count = add_info.count;
    add_info.data[count] = {};
    local add_count=add_info.data[count];
    add_count.name = name;
    add_count.rep = rep;
    add_count.maxStanding = to;
    add_count.zone = zone;
    if ((standing == to) and limit) then
      add_count.limit = limit
    end

    -- REP:Debug("Added mob ["..name.."] for faction ["..faction.."] and standing [".._G["FACTION_STANDING_LABEL"..standing].."]")
  end
end

function REP_AddQuest(faction, from, to, name, rep, itemList, limitType, repeatable)
  --[[--	if not faction then return end
    if not from then return end
    if not to then return end
    if not name then return end
    if not rep then return end
    if (type(rep) ~= "number") then return end
    if ((from<1) or (from>8)) then return end
    if ((to<1) or (to>8)) then return end
    if (from > to) then return end
  --]]--

  local expansionIndex = REP_Data.Global.ExpansionIndex;

  if not key then key = REP_ProfileKey end
  if REP:Content(faction, from, to, name, rep) ~= 1 then return end

  faction = string.lower(REP:InitFaction(REP_GuildName, faction))
  rep = rep * REP:InitFactor(REP_IsHuman, REP_faction)

  for standing = from, to do
    local faction_info = REP_FactionGain[faction]
    if not faction_info then
      faction_info = {}
      REP_FactionGain[faction] = faction_info
    end

    local standing_info = faction_info[standing]
    if not standing_info then
      standing_info = {}
      faction_info[standing] = standing_info
    end

    local add_info = standing_info.quests
    if add_info then
      add_info.count = add_info.count + 1
    else
      add_info = {}
      add_info.data = {}
      add_info.count = 0
      standing_info.quests = add_info
    end

    local count = add_info.count
    add_info.data[count] = {}
    local add_count = add_info.data[count]
    add_count.name = name
    add_count.rep = rep
    add_count.maxStanding = to

    if (repeatable == nil) then
			add_count.repeatable = true
		else
			add_count.repeatable = repeatable
		end

    if (itemList) then
      if (itemList == "nil") then
        add_count.profession = limitType
      else
        add_count.items = {}

        for item in pairs(itemList) do
          add_count.items[item] = itemList[item]
        end
      end
    end

    if limitType then
      add_count.profession = limitType
    end

    if ((standing == to) and limit) then
      add_count.limit = limit
    end

    -- REP:Debug("Added quest ["..name.."] for faction ["..faction.."] and standing [".._G["FACTION_STANDING_LABEL"..standing].."]")
  end
end

function REP_AddInstance(faction, from, to, name, rep, heroic)
  --[[--
    if not faction then return end
    if not from then return end
    if not to then return end
    if not name then return end
    if not rep then return end
    if (type(rep) ~= "number") then return end
    if ((from<1) or (from>8)) then return end
    if ((to<1) or (to>8)) then return end
    if (from > to) then return end
  --]]--

  if REP:Content(faction, from, to, name, rep) ~=1 then return end

  faction = string.lower(REP:InitFaction(REP_GuildName,faction))
  rep = rep * REP:InitFactor(REP_IsHuman,REP_faction)

  for standing = from,to do
    local faction_info = REP_FactionGain[faction]
    if not faction_info then
      faction_info = {}
      REP_FactionGain[faction] = faction_info
    end

    local standing_info = faction_info[standing]
    if not standing_info then
      standing_info = {}
      faction_info[standing] = standing_info
    end

    local add_info = standing_info.instance
    if add_info then
      add_info.count = add_info.count + 1
    else
      add_info = {}
      add_info.data = {}
      add_info.count = 0
      standing_info.instance = add_info
    end

    local count = add_info.count
    add_info.data[count] = {}
    local add_count=add_info.data[count]
    add_count.name = name
    add_count.rep = rep
    add_count.maxStanding = to
    if ((standing == to) and limit) then
      add_count.limit = limit
    end

    add_count.level = (heroic and REP_TXT.heroic or REP_TXT.normal)
    -- REP:Debug("Added instance ["..name.."] for faction ["..faction.."] and standing [".._G["FACTION_STANDING_LABEL"..standing].."]")
  end
end

function REP_AddItems(faction, from, to, rep, itemList, alternativeItemList)
  --[[--
    if not faction then return end
    if not from then return end
    if not to then return end
    if not rep then return end
    if not itemList then return end
    if (type(rep) ~= "number") then return end
    if ((from<1) or (from>8)) then return end
    if ((to<1) or (to>8)) then return end
    if (from > to) then return end
  --]]--

  if REP:Content(faction, from, to, itemList, rep) ~=1 then return end

  faction = string.lower(REP:InitFaction(REP_GuildName,faction))
  rep = rep * REP:InitFactor(REP_IsHuman,REP_faction)
  local itemString = ""

  for standing = from,to do
    local faction_info = REP_FactionGain[faction]
    if not faction_info then
      faction_info = {}
      REP_FactionGain[faction] = faction_info
    end

    local standing_info = faction_info[standing]
    if not standing_info then
      standing_info = {}
      faction_info[standing] = standing_info
    end

    local add_info = standing_info.items
    if add_info then
      add_info.count = add_info.count + 1
    else
      add_info = {}
      add_info.data = {}
      add_info.count = 0
      standing_info.items = add_info
    end

    local count=add_info.count
    add_info.data[count] = {}
    local add_count=add_info.data[count]
    add_count.rep = rep
    add_count.maxStanding = to
    if ((standing == to) and limit) then
      add_count.limit = limit
    end

    if (itemList) then
      add_count.items = {}
      for item in pairs(itemList) do
        add_count.items[item] = itemList[item]
      end
    end

    if (alternativeItemList) then
      add_count.alternativeItems = {}
      for item in pairs(alternativeItemList) do
        add_count.alternativeItems[item] = alternativeItemList[item]
      end
    end

    -- REP:Debug("AddItem: Added items ["..itemString.."] for faction ["..faction.."] and standing [".._G["FACTION_STANDING_LABEL"..standing].."]")
  end
end

function REP_AddGeneral(faction, from, to, name, rep, head, tip, tipList, flag)
  --[[--
    if not faction then return end
    if not from then return end
    if not to then return end
    if not name then return end
    if not rep then return end
    if (type(rep) ~= "number") then return end
    if ((from<1) or (from>8)) then return end
    if ((to<1) or (to>8)) then return end
    if (from > to) then return end
  --]]--

  if REP:Content(faction, from, to, name, rep) ~= 1 then return end

  faction = string.lower(REP:InitFaction(REP_GuildName,faction))
  rep = rep * REP:InitFactor(REP_IsHuman,REP_faction)
  local tipString = ""

  for standing = from, to do
    local faction_info = REP_FactionGain[faction]
    if not faction_info then
      faction_info = {}
      REP_FactionGain[faction] = faction_info
    end

    local standing_info = faction_info[standing]
    if not standing_info then
      standing_info = {}
      faction_info[standing] = standing_info
    end

    local add_info = standing_info.general
    if add_info then
      add_info.count = add_info.count + 1
    else
      add_info = {}
      add_info.data = {}
      add_info.count = 0
      standing_info.general = add_info
    end

    local count = add_info.count
    add_info.data[count] = {}
    local add_count=add_info.data[count]
    add_count.name = name
    add_count.rep = rep
    add_count.maxStanding = to
    if ((standing == to) and limit) then
      add_count.limit = limit
    end

    if name == "1" then
      name = REP_TXT.tfr
      head = REP_TXT.tfr
      tip = REP_TXT.nswts
    end

    add_count.flag = flag
    add_count.head = head
    add_count.tip = tip
    if (tipList) then
      add_count.tipList = {}
      for tip in pairs(tipList) do
        if tipString ~= "" then tipString = tipString..", " end
        tipString = tipString..tipList[tip]..": "..tip
        add_count.tipList[tip] = tipList[tip]
      end
    end

    -- REP:Debug("AddGeneral: Added general rep gain ["..name.."] for faction ["..faction.."] and standing [".._G["FACTION_STANDING_LABEL"..standing].."] with tooltip ["..tipString.."]")
  end
end

-----------------------------------
-- _10_ New Hook Functions --
-----------------------------------
function REP_GetFactionInfo(factionIndex)
  -- get original information
  local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain = REP_Orig_GetFactionInfo(factionIndex)

  -- Normalize Values to within standing
  local normMax = barMax-barMin
  local normCurrent = barValue-barMin

  -- add missing reputation
  if (REP_Data.Global.ShowMissing and isHeader and not hasRep and ((normMax-normCurrent)>0)) then
    name = name.." ("..normMax-normCurrent..")"
  end

  -- return Values
  return name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain;
end

-----------------------------------
-- REP_RepFrame_Up Start --
-----------------------------------
function REP_ReputationFrame_Update()
  local expansionIndex = REP_Data.Global.ExpansionIndex;

  if (REP_OnLoadingScreen == false) then
    if expansionIndex > 2 then
      ReputationFrame.paragonFramesPool:ReleaseAll();
    end

    local numFactions
    if REP_Data.Global.SortByStanding then
      REP:StandingSort()
      numFactions = REP_OBS_numFactions
    else
      numFactions = GetNumFactions();
    end

    -- Update scroll frame
    if (not FauxScrollFrame_Update(ReputationListScrollFrame, numFactions, NUM_FACTIONS_DISPLAYED, REPUTATIONFRAME_FACTIONHEIGHT)) then
      ReputationListScrollFrameScrollBar:SetValue(0);
    end

    if (REP_Data.Global.ShowMissing) then
      ReputationFrameStandingLabel:SetText(REP_Orig_StandingText.." "..REP_TXT.missing)
    else
      ReputationFrameStandingLabel:SetText(REP_Orig_StandingText)
    end

    local i;
    local gender = UnitSex("player");
    local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame);
    local numberOfFactionsToDisplay

    if expansionIndex > 2 then
      numberOfFactionsToDisplay = NUM_FACTIONS_DISPLAYED
    else
      numberOfFactionsToDisplay = numFactions
    end

    for i = 1, NUM_FACTIONS_DISPLAYED, 1 do
      local factionBar;
      local factionStanding;
      local factionIndex = factionOffset + i;
      local factionRow = _G["ReputationBar"..i];
      local factionHeader = _G["ReputationHeader"..i];
      local factionCheck = _G["ReputationBar"..i.."Check"];
      local factionTitle = _G["ReputationBar"..i.."FactionName"];
      local factionButton = _G["ReputationBar"..i.."ExpandOrCollapseButton"];
      local factionBackground = _G["ReputationBar"..i.."Background"];
      local factionBarPreview = _G["REP_StatusBar"..i];
      local factionAtWarIndicator = _G["ReputationBar"..i.."AtWarCheck"]
      local factionRightBarTexture = _G["ReputationBar"..i.."ReputationBarRight"]

      if (expansionIndex > 1) then
        factionBar = _G["ReputationBar"..i.."ReputationBar"];
        factionStanding = _G["ReputationBar"..i.."ReputationBarFactionStanding"];
      else
        factionBar = _G["ReputationBar"..i];
        factionStanding = _G["ReputationBar"..i.."FactionStanding"];
      end

      if (factionIndex <= numFactions) then
        if REP_Data.Global.SortByStanding then
          if (expansionIndex > 1) then
            REP:SortByStandingWithoutFactionHeader(i, expansionIndex, factionIndex, factionRow, factionBar, factionBarPreview, factionTitle, factionButton, factionStanding, factionAtWarIndicator, factionBackground)
          else
            REP:SortByStandingWithFactionHeader(i, expansionIndex, factionIndex, factionBar, factionHeader, factionCheck, factionTitle, factionStanding, factionAtWarIndicator, factionRightBarTexture)
          end
        else
          if (expansionIndex > 1) then
            REP:OriginalRepOrderWithoutFactionHeader(i, expansionIndex, factionIndex, factionRow, factionBar, factionBarPreview, factionTitle, factionButton, factionStanding, factionAtWarIndicator, factionBackground)
          else
            REP:OriginalRepOrderWithFactionHeader(i, expansionIndex, factionIndex, factionBar, factionHeader, factionCheck, factionTitle, factionStanding, factionAtWarIndicator, factionRightBarTexture)
          end
        end
      else
        factionRow:Hide();

        if (expansionIndex < 2) then
          factionHeader:Hide();
        end
      end
    end

    if (GetSelectedFaction() == 0) then
      ReputationDetailFrame:Hide();
      REP_ReputationDetailFrame:Hide();
    end
  end
end

function REP_ExpandFactionHeader(index)
  -- replaces ExpandFactionHeader
  if not REP_Entries then return end
  if REP_Data.Global.SortByStanding then
    if not REP_Entries[index] then return end
    REP_Collapsed[REP_Entries[index].i] = nil
    REP_ReputationFrame_Update()
  else
    REP_Orig_ExpandFactionHeader(index)
    --[[
      local name = REP_Orig_GetFactionInfo(index);
      REP_Data.Global.OriginalCollapsed[name] = nil
      REP_ShowCollapsedList()
    ]]--
  end
end

function REP_ReputationFrame_SetRowType(factionRow, isChild, isHeader, hasRep, expansionIndex)
  -- rowType is a binary table of type isHeader, isChild
  local factionRowName = factionRow:GetName()
  local factionBar = _G[factionRowName.."ReputationBar"];
  local factionTitle = _G[factionRowName.."FactionName"];
  local factionStanding = _G[factionRowName.."ReputationBarFactionStanding"];
  local factionBackground = _G[factionRowName.."Background"];
  local factionLeftTexture = _G[factionRowName.."ReputationBarLeftTexture"];
  local factionRightTexture = _G[factionRowName.."ReputationBarRightTexture"];
  local factionButton;

  if((not expansionIndex) or (expansionIndex < 2)) then
    factionButton = _G[factionRowName.."ReputationHeader"];
  else
    factionButton = _G[factionRowName.."ExpandOrCollapseButton"];
  end

  if (factionLeftTexture) then factionLeftTexture:SetWidth(62); end
  if (factionRightTexture) then factionRightTexture:SetWidth(42); end
  if (factionBar) then factionBar:SetPoint("RIGHT", factionRow, "RIGHT", 0, 0); end

  if (isHeader) then
    -- show indent on child rows (isChild)
    if (false) then
      factionRow:SetPoint("LEFT", ReputationFrame, "LEFT", 35, 0);
    else
      factionRow:SetPoint("LEFT", ReputationFrame, "LEFT", 23, 0);
    end

    if (factionButton) then
      factionButton:SetPoint("LEFT", factionRow, "LEFT", 3, 0);
      factionButton:Show();
    end

    factionTitle:SetWidth(145);
    factionTitle:SetPoint("LEFT",factionButton,"RIGHT",10, 0);
    factionTitle:SetFontObject(GameFontNormalLeft);


    if (factionBackground) then factionBackground:Hide(); end

    if (factionLeftTexture) then
      factionLeftTexture:SetHeight(15);
      factionLeftTexture:SetWidth(60);
      factionLeftTexture:SetTexCoord(0.765625, 1.0, 0.046875, 0.28125);
    end

    if (factionRightTexture) then
      factionRightTexture:SetHeight(15);
      factionRightTexture:SetWidth(39);
      factionRightTexture:SetTexCoord(0.0, 0.15234375, 0.390625, 0.625);
    end

    if (factionBar) then factionBar:SetWidth(99); end
  else
    -- show indent on child rows (no way of saying when it's a child row of an other child row)
    if(false) then
      factionRow:SetPoint("LEFT", ReputationFrame, "LEFT", 41, 0);
    else
      factionRow:SetPoint("LEFT", ReputationFrame, "LEFT", 29, 0);
    end

    factionTitle:SetWidth(160);
    factionButton:Hide();
    factionTitle:SetPoint("LEFT", factionRow, "LEFT", 10, 0);
    factionTitle:SetFontObject(GameFontHighlightSmall);
    factionBackground:Show();
    factionLeftTexture:SetHeight(21);
    factionRightTexture:SetHeight(21);
    factionLeftTexture:SetTexCoord(0.7578125, 1.0, 0.0, 0.328125);
    factionRightTexture:SetTexCoord(0.0, 0.1640625, 0.34375, 0.671875);
    factionBar:SetWidth(101)
  end

  if ((hasRep) or (not isHeader)) then
    factionStanding:Show();
    factionBar:Show();
    factionBar:GetParent().hasRep = true;
  else
    if (factionStanding) then factionStanding:Hide(); end
    if (factionBar) then
      factionBar:Hide();
      factionBar:GetParent().hasRep = false;
    end
  end
end

function REP_CollapseFactionHeader(index)
  -- replaces CollapseFactionHeader
  if not REP_Entries then return end

  if REP_Data.Global.SortByStanding then
    if not REP_Entries[index] then return end

    REP_Collapsed[REP_Entries[index].i] = true
    REP_ReputationFrame_Update()
  else
    REP_Orig_CollapseFactionHeader(index)

    --[[
    local name = REP_Orig_GetFactionInfo(index);
    REP_Data.Global.OriginalCollapsed[name] = true
    --REP:Print("Collapsing original index "..tostring(index).." which is ["..tostring(name).."]")
    REP_ShowCollapsedList()
    ]]--
  end
end

function REP_ReputationBar_OnClick(self)
  -- redo from the main Reputation file
  if ((ReputationDetailFrame:IsVisible() or REP_ReputationDetailFrame:IsVisible()) and (GetSelectedFaction() == self.index)) then
    ReputationDetailFrame:Hide();
    REP_ReputationDetailFrame:Hide();
  else
    if (self.hasRep) then
      REP_ReputationDetailFrame:Show();
      SetSelectedFaction(self.index);
      ReputationDetailFrame:Hide();
      REP_OptionsFrame:Hide();

      if (REP_Data.Global.ExtendDetails) then
        REP:BuildUpdateList()
        REP_UpdateList_Update()
      end

      ReputationFrame_Update();
    end
  end
end

REP_UPDATE_LIST_HEIGHT = 13

function REP_UpdateList_Update()
  -- usually called In conjuction with REP:BuildUpdateList
  if (not REP_ReputationDetailFrame:IsVisible()) then return end

  local expansionIndex = REP_Data.Global.ExpansionIndex;

  REP_UpdateListScrollFrame:Show();
  REP_ShowQuestButton:SetChecked(REP_Data.Global.ShowQuests);
  REP_ShowItemsButton:SetChecked(REP_Data.Global.ShowItems);
  REP_ShowMobsButton:SetChecked(REP_Data.Global.ShowMobs);
  REP_ShowInstancesButton:SetChecked(REP_Data.Global.ShowInstances);
  REP_ShowGeneralButton:SetChecked(REP_Data.Global.ShowGeneral);

  REP_ShowQuestButtonText:SetText(REP_TXT.showQuests);
  REP_ShowItemsButtonText:SetText(REP_TXT.showItems);
  REP_ShowMobsButtonText:SetText(REP_TXT.showMobs);
  REP_ShowInstancesButtonText:SetText(REP_TXT.showInstances);
  REP_ShowGeneralButtonText:SetText(REP_TXT.showGeneral);

  REP_ShowAllButton:SetText(REP_TXT.showAll);
  REP_ShowNoneButton:SetText(REP_TXT.showNone);
  REP_ExpandButton:SetText(REP_TXT.expand);
  REP_CollapseButton:SetText(REP_TXT.collapse);

  REP_SupressNoneFactionButton:SetText(REP_TXT.supressNoneFaction);
  REP_SupressNoneGlobalButton:SetText(REP_TXT.supressNoneGlobal);
  REP_ReputationDetailSuppressHint:SetText(REP_TXT.suppressHint);
  REP_ClearSessionGainButton:SetText(REP_TXT.clearSessionGain);

  if (expansionIndex > 4) then
    -- Mists of Pandaria
    REP_ShowDarkmoonFaireButton:Show();
    REP_ShowDarkmoonFaireButton:SetChecked(REP_Data.Global.ShowDarkmoonFaire);
    REP_ShowDarkmoonFaireButtonText:SetText(REP_TXT.darkmoonFaireBuff);
  else
    REP_ShowDarkmoonFaireButton:Hide();
  end

  local numEntries, highestVisible = REP:GetUpdateListSize()

  -- Update scroll frame
  if (not FauxScrollFrame_Update(REP_UpdateListScrollFrame, numEntries, REP_UPDATE_LIST_HEIGHT, 16)) then
    REP_UpdateListScrollFrameScrollBar:SetValue(0);
  end

  local entryIndex
  local entryFrameName, entryFrame, entryTexture
  local entryLabel, entryName, entryRep, entryTimes
  local entryItemTimes, entryItemName, entryItemTotal
  local postfix

  local entryOffset = FauxScrollFrame_GetOffset(REP_UpdateListScrollFrame);

  local haveInfo = false;
  entryIndex = 1
  local i = 0
  local max = REP:TableSize(REP_UpdateList)

  while(i < entryOffset and entryIndex < max) do
    if REP_UpdateList[entryIndex].isShown then
      i = i + 1
    end

    entryIndex = entryIndex + 1
  end

  for i=1, REP_UPDATE_LIST_HEIGHT, 1 do
    while ((entryIndex <= highestVisible) and not REP_UpdateList[entryIndex].isShown) do
      entryIndex = entryIndex + 1
    end

    if (entryIndex <= highestVisible) then
      haveInfo = true

      entryFrameName = "REP_UpdateEntry"..i
      entryFrame = _G[entryFrameName]
      entryTexture = _G[entryFrameName.."Texture"]
      entryLabel = _G[entryFrameName.."Label"]
      entryName = _G[entryFrameName.."Name"]
      entryRep = _G[entryFrameName.."Rep"]
      entryTimes = _G[entryFrameName.."Times"]
      entryItemTimes = _G[entryFrameName.."ItemTimes"]
      entryItemName = _G[entryFrameName.."ItemName"]
      entryItemTotal = _G[entryFrameName.."TotalTimes"]
      local F_UL_ei = REP_UpdateList[entryIndex]

      if (entryFrame) then
        entryFrame:Show()
        entryFrame.id = F_UL_ei.index
        entryFrame.tooltipHead = F_UL_ei.tooltipHead
        entryFrame.tooltipTip = F_UL_ei.tooltipTip
        entryFrame.tooltipDetails = F_UL_ei.tooltipDetails
      end

      local color = ""
      if (F_UL_ei.highlight) then
        color = REP_HIGHLIGHT_COLOUR
      elseif (F_UL_ei.suppress) then
        color = REP_SUPPRESS_COLOUR
      elseif (F_UL_ei.lowlight) then
        color = REP_LOWLIGHT_COLOUR
      end

      if (F_UL_ei.type ~= "") then
        -- normal entry
        if (F_UL_ei.suppress) then
          postfix = ""
        else
          postfix = "-Green"
        end

        if (F_UL_ei.hasList) then
          if (F_UL_ei.listShown) then
            entryTexture:SetTexture("Interface\\Addons\\"..REP_NAME.."\\Textures\\UI-MinusButton-Up"..postfix..".tga")
          else
            entryTexture:SetTexture("Interface\\Addons\\"..REP_NAME.."\\Textures\\UI-PlusButton-Up"..postfix..".tga")
          end
        else
          entryTexture:SetTexture("Interface\\Addons\\"..REP_NAME.."\\Textures\\UI-EmptyButton-Up"..postfix..".tga")
        end

        if (F_UL_ei.canSuppress) then
          entryTexture:Show()
        else
          entryTexture:Hide()
        end

        entryLabel:Show()
        entryName:Show()
        entryRep:Show()
        entryTimes:Show()
        entryLabel:SetText(color..F_UL_ei.type)
        entryName:SetText(color..F_UL_ei.name)
        entryRep:SetText(color..F_UL_ei.rep)
        entryTimes:SetText(color..F_UL_ei.times)
        entryItemTimes:Hide()
        entryItemName:Hide()
        entryItemTotal:Hide()
      else
        -- item entry
        entryTexture:Hide()
        entryLabel:Hide()
        entryName:Hide()
        entryRep:Hide()
        entryTimes:Hide()
        entryItemTimes:Show()
        entryItemName:Show()
        entryItemTimes:SetText(color..F_UL_ei.times)
        entryItemName:SetText(color..F_UL_ei.name)
      end

      entryIndex = entryIndex + 1
    else
      _G["REP_UpdateEntry"..i]:Hide()
    end

    if haveInfo then
      REP_NoInformationText:Hide()
    else
      REP_NoInformationText:SetText(REP_TXT.noInfo)
      REP_NoInformationText:Show()
    end
  end
end

function REP_MouseButtonUp(self, button)
  -- unkown call
  if (button and button == "LeftButton") then
    REP_UpdateEntryClick(self)
  elseif (button and button == "RightButton") then
    REP:UpdateEntrySuppress(self)
  end
end

function REP_UpdateEntryClick(self)
  -- sub function of REP_MouseButtonUp
  if (REP_UpdateList[self.id] and REP_UpdateList[self.id].hasList) then
    if (REP_UpdateList[self.id].listShown) then
      REP:ShowUpdateEntry(self.id, false)
    else
      REP:ShowUpdateEntry(self.id, true)
    end
  end
end

function REP:UpdateEntrySuppress(self)
  -- sub function of REP_UpdateEntryClick
  if (REP_UpdateList[self.id]) then
    if (REP_UpdateList[self.id].type ~= "") then
      if (REP_UpdateList[self.id].faction and REP_UpdateList[self.id].originalName) then
        if (not REP_Suppressed) then
          REP_Suppressed = {}
        end

        if (not REP_Suppressed[REP_UpdateList[self.id].faction]) then
          REP_Suppressed[REP_UpdateList[self.id].faction] = {}
        end

        if (REP_Suppressed[REP_UpdateList[self.id].faction][REP_UpdateList[self.id].originalName]) then
          REP_Suppressed[REP_UpdateList[self.id].faction][REP_UpdateList[self.id].originalName] = nil
        else
          REP_Suppressed[REP_UpdateList[self.id].faction][REP_UpdateList[self.id].originalName] = true
        end

        REP:BuildUpdateList()
      end
    end
  end
end

function REP:SupressNone(allFactions)
  -- unkown call
  if (allFactions == true) then
    REP_Suppressed = {}
    REP:BuildUpdateList()
  else
    local factionIndex = GetSelectedFaction()
    local faction = GetFactionInfo(factionIndex)

    if (faction) then
      faction = string.lower(faction)

      if (REP_FactionMapping[faction]) then
        faction = REP_FactionMapping[faction]
      end

      if (not REP_Suppressed) then
        REP_Suppressed = {}
      end

      REP_Suppressed[faction] = {}
    end

    REP:BuildUpdateList()
  end
end

-----------------------------------
-- _11_ Prepare update entries   --
-----------------------------------
function REP:Update_Tooltip(x, l1,r1)
  x = x + 1
  local ToolTip_ID = {l = l1, r = r1}
  return ToolTip_ID, x
end

function REP:BuildUpdateList()
  REP_UpdateList = {}
  REP_CurrentRepInBag = 0
  REP_CurrentRepInBagBank = 0
  REP_CurrentRepInQuest = 0
  local index = 1

  local expansionIndex = REP_Data.Global.ExpansionIndex;

  if (not REP_ReputationDetailFrame:IsVisible()) then return end

  local factionIndex = GetSelectedFaction()
  --local faction, description, standingId, barMin, barMax, barValue = GetFactionInfo(factionIndex)
  local faction, description, standingId, barMin, barMax, barValue, _, _, _, _, _, _, _, factionID, _, _ = GetFactionInfo(factionIndex)

  if (faction) then
    origFaction = faction
    oFaction = string.lower(faction)
    faction = string.lower(faction)

    if (REP_FactionMapping[faction]) then
      faction = REP_FactionMapping[faction]
    end

    if(factionID and C_Reputation.IsFactionParagon(factionID)) then
      local currentValue, threshold, rewardQuestID, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID);
      barMin, barMax, barValue = 0, threshold, mod(currentValue, threshold);
    end

    -- local friendID, _, _, _, _, _, _, _, _ = GetFriendshipReputation(factionID);

    if friendID ~= nil and barMax == 43000 then
      barMax = 42000
    end

    -- Normalize Values
    local normMax = barMax - barMin
    local normCurrent = barValue - barMin
    local repToNext = barMax - barValue

    if (REP_FactionGain[oFaction]) then
      local fg_sid = REP_FactionGain[oFaction][standingId]

      if (fg_sid) then
        -- instances
        if (fg_sid.instance and REP_Data.Global.ShowInstances) then
          local fg_sid_x=fg_sid.instance
          for i = 0, fg_sid.instance.count do
            local fg_sid_x_d = fg_sid_x.data[i]
            if (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
              local toDo = string.format("%.2f", repToNext / fg_sid_x_d.rep)
              if (fg_sid_x_d.limit) then
                toDo = string.format("%.2f", (fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
              end

              REP_UpdateList[index] = {}
              local FUL_I = REP_UpdateList[index]
              local bul_name = REP:InitMapName(fg_sid_x_d.name)
              FUL_I.type = REP_TXT.instanceShort
              FUL_I.times = math.ceil(toDo).."x"
              FUL_I.rep = string.format("%d", fg_sid_x_d.rep)
              FUL_I.hasList = false
              FUL_I.listShown = nil
              FUL_I.index = index
              FUL_I.belongsTo = nil
              FUL_I.isShown = true
              FUL_I.name = bul_name.." ("..fg_sid_x_d.level..")"
              FUL_I.tooltipHead = REP_TXT.instanceHead
              FUL_I.tooltipTip = REP_TXT.instanceTip
              FUL_I.tooltipDetails = {}
              local FUL_I_TD = FUL_I.tooltipDetails
              local x = 0
              FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.instance2, bul_name)
              FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.mode, fg_sid_x_d.level)
              FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.reputation, FUL_I.rep)
              FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.timesToRun, FUL_I.times)
              FUL_I_TD[x], x = REP:Update_Tooltip(x, " ", " ")
              FUL_I_TD[x] = REP:Update_Tooltip(x, REP_TXT.maxStanding, _G["FACTION_STANDING_LABEL"..fg_sid_x_d.maxStanding])
              FUL_I_TD.count = x
              FUL_I.tooltipDetails = FUL_I_TD
              REP_UpdateList[index] = FUL_I
              index = index + 1
            end
          end
        end

        -- mobs
        if (fg_sid.mobs and REP_Data.Global.ShowMobs) then
          local fg_sid_x=fg_sid.mobs
          for i = 0, fg_sid_x.count do
            local fg_sid_x_d = fg_sid_x.data[i]
            if (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
              local toDo = ceil(repToNext / fg_sid_x_d.rep)
              if (fg_sid_x_d.limit) then
                toDo = ceil((fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
              end

              REP_UpdateList[index] = {}
              local FUL_I = REP_UpdateList[index]
              FUL_I.type = REP_TXT.mobShort
              FUL_I.times = math.ceil(toDo).."x"
              FUL_I.rep = string.format("%d", fg_sid_x_d.rep)
              FUL_I.hasList = false
              FUL_I.listShown = nil
              FUL_I.index = index
              FUL_I.belongsTo = nil
              FUL_I.isShown = true
              FUL_I.tooltipHead = REP_TXT.mobHead
              FUL_I.tooltipTip = REP_TXT.mobTip
              local bul_name = REP:InitMobName(fg_sid_x_d.name)

              if (fg_sid_x_d.zone) then
                local bul_zone = REP:InitMapName(fg_sid_x_d.zone)
                FUL_I.name = bul_name.." ("..bul_zone..")"
                FUL_I.tooltipDetails = {}
                local FUL_I_TD = FUL_I.tooltipDetails
                local x = 0
                FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.mob2, bul_name)
                FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.location, bul_zone)
                FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.reputation, FUL_I.rep)
                FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.toDo, FUL_I.times)
                FUL_I_TD[x], x = REP:Update_Tooltip(x, " ", " ")
                FUL_I_TD[x] = REP:Update_Tooltip(x, REP_TXT.maxStanding, _G["FACTION_STANDING_LABEL"..fg_sid_x_d.maxStanding])
                FUL_I_TD.count = x
              else
                FUL_I.name = bul_name
                FUL_I_TD = {}
                local x = 0
                FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.mob2, bul_name)
                FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.reputation, FUL_I.rep)
                FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.toDo, FUL_I.times)
                FUL_I_TD[x], x = REP:Update_Tooltip(x, " ", " ")
                FUL_I_TD[x] = REP:Update_Tooltip(x, REP_TXT.maxStanding, _G["FACTION_STANDING_LABEL"..fg_sid_x_d.maxStanding])
                FUL_I_TD.count = x
                FUL_I.tooltipDetails = FUL_I_TD
              end

              REP_UpdateList[index] = FUL_I
              index = index + 1
            end
          end
        end

        -- quests (may have items)
        local sum = 0
        local count = 0
        if (fg_sid.quests and REP_Data.Global.ShowQuests) then
          local fg_sid_x = fg_sid.quests
          for i = 0, fg_sid_x.count do
            local fg_sid_x_d=fg_sid_x.data[i]
            local showQuest = true

            if (fg_sid_x_d.profession) then
              local fg_sid_x_d_p=fg_sid_x_d.profession
              if ((fg_sid_x_d_p == REP_LIMIT_TYPE_Herb) and not REP_Herb) then
                -- if list of known professions does not contain Herbology
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Skin) and not REP_Skin) then
                -- if list of known professions does not contain Herbology
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Mine) and not REP_Mine) then
                -- if list of known professions does not contain Herbology
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Gather) and not (REP_Herb or REP_Skin or REP_Mine)) then
                -- no gathering profession
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Jewel) and not REP_Jewel) then
                -- if list of known professions does not contain jewelcrafting
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Cook) and not REP_Cook) then
                -- if list of known professions does not contain jewelcrafting
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Arch) and not REP_Arch) then
                -- if list of known professions does not contain jewelcrafting
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Fish) and not REP_Fish) then
                -- if list of known professions does not contain jewelcrafting
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Aid) and not REP_Aid) then
                -- if list of known professions does not contain jewelcrafting
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Blac) and not REP_Black) then
                -- if list of known professions does not contain BLACKsmith
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Tail) and not REP_Tailor) then
                -- if list of known professions does not contain tailor
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Leat) and not REP_Leath) then
                -- if list of known professions does not contain leather
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Ench) and not REP_Enchan) then
                -- if list of known professions does not contain enchanter
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Engi) and not REP_Engin) then
                -- if list of known professions does not contain BLACKsmith
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Incr) and not REP_Incrip) then
                -- if list of known professions does not contain leather
                showQuest = false
              elseif ((fg_sid_x_d_p == REP_LIMIT_TYPE_Alch) and not REP_Alche) then
                -- if list of known professions does not contain enchanter
                showQuest = false
              else
                -- unexpected limit -> ignore this and still show quest ggg
              end
            end

            if (showQuest) then
              if (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
                local toDo = ceil(repToNext / fg_sid_x_d.rep)
                if (fg_sid_x_d.limit) then
                  toDo = ceil((fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
                end

                REP_UpdateList[index] = {}
                local FUL_I = REP_UpdateList[index]
                FUL_I.type = REP_TXT.questShort
                FUL_I.rep = string.format("%d", fg_sid_x_d.rep)
                FUL_I.index = index
                FUL_I.belongsTo = nil
                FUL_I.isShown = true
                local bul_name = REP:Quest_Names(fg_sid_x_d.name)
                FUL_I.name = bul_name
                FUL_I.originalName = FUL_I.name
                FUL_I.tooltipHead = REP_TXT.questHead

                if (fg_sid_x_d.repeatable) then
  								FUL_I.times = math.ceil(toDo).."x"
  								FUL_I.tooltipTip = REP_TXT.questTip
  							else
  								FUL_I.times = math.ceil(1).."x"
  								FUL_I.tooltipTip = REP_TXT.questTipNonRepeatable
  							end

                FUL_I.faction = faction
                FUL_I.canSuppress = true
                FUL_I.suppress = nil
                if (REP_Suppressed and REP_Suppressed[oFaction] and REP_Suppressed[oFaction][FUL_I.originalName]) then
                  FUL_I.suppress = true
                end

                FUL_I.tooltipDetails = {}
                local FUL_I_TD = FUL_I.tooltipDetails
                local x = 0
                FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.quest2, FUL_I.name)
                FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.reputation, FUL_I.rep)
                FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.toDo, FUL_I.times)

                if (not FUL_I.suppress) then
                  if (fg_sid_x_d.repeatable) then
  									sum = sum + fg_sid_x_d.rep
  									count = count + 1
  								end
                end

                if (fg_sid_x_d.items) then
                  FUL_I.hasList = true
                  FUL_I.listShown = false
                  FUL_I_TD[x], x = REP:Update_Tooltip(x, " ", " ")
                  FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.itemsRequired, " ")
                  -- quest In log?
                  FUL_I.lowlight = nil

                  -- check if this quest is known
                  local entries, quests;

                  if (expansionIndex > 6) then
                    entries, quests = C_QuestLog.GetNumQuestLogEntries()
                  else
                    entries, quests = GetNumQuestLogEntries()
                  end

                  for z = 1, entries do
                    local title, level, tag, group, header, collapsed, complete, daily;

                    if (expansionIndex > 6) then
                      title, level, tag, group, header, collapsed, complete, daily = C_QuestLog.GetTitleForLogIndex(z)
                    else
                      title, level, tag, group, header, collapsed, complete, daily = GetQuestLogTitle(z)
                    end

                    if (title and not header) then
                      if string.find(string.lower(bul_name), string.lower(title)) then
                        -- this quest matches
                        FUL_I.lowlight = true
                        FUL_I.name = FUL_I.name..REP_QUEST_ACTIVE_COLOUR.." ("..REP_TXT.active..")|r"
                      end
                    end
                  end

                  -- add items
                  local itemIndex = index+1
                  local currentQuestTimesBag = -1
                  local currentQuestTimesBagBank = -1

                  for item in pairs(fg_sid_x_d.items) do
                    REP_UpdateList[itemIndex] = {}
                    local FUL_II = REP_UpdateList[itemIndex]
                    FUL_II.type = ""
                    FUL_II.times = math.ceil((fg_sid_x_d.items[item] * toDo)).."x"
                    FUL_II.rep = nil
                    FUL_II.index = itemIndex
                    FUL_II.belongsTo = index
                    FUL_II.hasList = nil
                    FUL_II.listShown = nil
                    FUL_II.isShown = FUL_I.listShown
                    FUL_II.name = REP:InitItemName(item).." ("..fg_sid_x_d.items[item].."x)"
                    FUL_I_TD[x], x = REP:Update_Tooltip(x, fg_sid_x_d.items[item].."x", REP:InitItemName(item))
                    FUL_II, currentQuestTimesBag, currentQuestTimesBagBank = REP:Quest_Items(fg_sid_x_d.items[item], currentQuestTimesBag, currentQuestTimesBagBank, FUL_II, item)
                    REP_UpdateList[itemIndex] = FUL_II
                    itemIndex = itemIndex + 1
                  end

                  if (currentQuestTimesBag > 0) then
                    FUL_I.highlight = true
                    FUL_I.lowlight = nil
                    FUL_I.name = FUL_I.name..REP_BAG_COLOUR.." ["..currentQuestTimesBag.."x]|r"
                    FUL_I.currentTimesBag = currentQuestTimesBag
                    FUL_I.currentRepBag = currentQuestTimesBag * FUL_I.rep
                    REP_CurrentRepInBag = REP_CurrentRepInBag + FUL_I.currentRepBag
                    --FUL_I.name = FUL_I.originalName
                    FUL_I_TD[x], x = REP:Update_Tooltip(x, " ", " ")
                    FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.inBag, " ")
                    FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.turnIns, string.format("%d", FUL_I.currentTimesBag))
                    FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.reputation, string.format("%d", FUL_I.currentRepBag))
                  else
                    FUL_I.currentTimesBag = nil
                    FUL_I.currentRepBag = nil
                  end

                  if (currentQuestTimesBagBank > 0) then
                    FUL_I.name = FUL_I.name..REP_BAG_BANK_COLOUR.." ["..currentQuestTimesBagBank.."x]|r"
                    FUL_I.currentTimesBagBank = currentQuestTimesBagBank
                    FUL_I.currentRepBagBank = currentQuestTimesBagBank * FUL_I.rep
                    FUL_I.highlight = true
                    FUL_I.name = FUL_I.originalName
                    FUL_I.lowlight = nil
                    REP_CurrentRepInBagBank = REP_CurrentRepInBagBank + FUL_I.currentRepBagBank
                    FUL_I_TD[x], x = REP:Update_Tooltip(x, " ", " ")
                    FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.inBagBank, " ")
                    FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.turnIns, string.format("%d", FUL_I.currentTimesBagBank))
                    FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.reputation, string.format("%d", FUL_I.currentRepBagBank))
                  else
                    FUL_I.currentTimesBagBank = nil
                    FUL_I.currentRepBagBank = nil
                  end

                  if ((currentQuestTimesBag == 0) and (currentQuestTimesBagBank)) then
                    FUL_I.highlight = nil
                  end

                  index = itemIndex
                else
                  -- no items to add
                  FUL_I.hasList = false
                  FUL_I.listShown = nil
                  FUL_I.highlight = nil	-- will be Changed below if needed
                  FUL_I.lowlight = nil

                  -- check if this quest is known and/or completed
                  local entries, quests;

                  if (expansionIndex > 6) then
                    entries, quests = C_QuestLog.GetNumQuestLogEntries()
                  else
                    entries, quests = GetNumQuestLogEntries()
                  end

                  for z = 1, entries do
                    local title, level, tag, group, header, collapsed, complete, daily;

                    if (expansionIndex > 6) then
                      title, level, tag, group, header, collapsed, complete, daily = C_QuestLog.GetTitleForLogIndex(z)
                    else
                      title, level, tag, group, header, collapsed, complete, daily = GetQuestLogTitle(z)
                    end

                    if (title) then
                      if string.find(string.lower(bul_name), string.lower(title)) then
                        -- this quest matches
                        if (complete) then
                          FUL_I.highlight = true
                          FUL_I.name = FUL_I.name..REP_QUEST_COLOUR.." ("..REP_TXT.complete..")|r"
                          FUL_I.currentTimesQuest = 1
                          FUL_I.currentRepQuest = FUL_I.rep
                          REP_CurrentRepInQuest = REP_CurrentRepInQuest + fg_sid_x_d.rep
                          FUL_I_TD[x], x = REP:Update_Tooltip(x, " ", " ")
                          FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.questCompleted, " ")
                          FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.reputation, string.format("%d", FUL_I.currentRepQuest))
                        else
                          FUL_I.lowlight = true
                          FUL_I.name = FUL_I.name..REP_QUEST_ACTIVE_COLOUR.." ("..REP_TXT.active..")|r"
                        end
                      end
                    end
                  end

                  index = index + 1
                end

                FUL_I_TD[x], x = REP:Update_Tooltip(x, " ", " ")
                FUL_I_TD[x] = REP:Update_Tooltip(x, REP_TXT.maxStanding, _G["FACTION_STANDING_LABEL"..fg_sid_x_d.maxStanding])
                FUL_I_TD.count = x
              end
            end
          end

          if ((sum > 0) and (count > 1)) then
            -- add virtual quest to show summary of all quests:
            local toDo = ceil(repToNext / sum)
            REP_UpdateList[index] = {}
            local FUL_I = REP_UpdateList[index]
            FUL_I.type = REP_TXT.questShort
            FUL_I.times = math.ceil(toDo).."x"
            FUL_I.rep = string.format("%d", sum)
            FUL_I.index = index
            FUL_I.belongsTo = nil
            FUL_I.isShown = true
            FUL_I.name = string.format(REP_TXT.allOfTheAbove, count)
            FUL_I.tooltipHead = string.format(REP_TXT.questSummaryHead, count)
            FUL_I.tooltipTip = REP_TXT.questSummaryTip
            FUL_I_TD = {}
            local x = 0
            FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.reputation, FUL_I.rep)
            FUL_I_TD[x], x  = REP:Update_Tooltip(x, REP_TXT.timesToDo, FUL_I.times)
            FUL_I_TD.count = x-1
            FUL_I.tooltipDetails = FUL_I_TD
            REP_UpdateList[index] = FUL_I
            index = index + 1
          end
        end

        -- items
        if (fg_sid.items and REP_Data.Global.ShowItems) then
          local fg_sid_x=fg_sid.items
          for i = 0, fg_sid_x.count do
            local fg_sid_x_d=fg_sid_x.data[i]
            if (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
              local toDo = ceil(repToNext / fg_sid_x_d.rep)
              if (fg_sid_x_d.limit) then
                toDo = ceil((fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
              end

              if (fg_sid_x_d.items) then
                REP_UpdateList[index] = {}
                local FUL_I = REP_UpdateList[index]
                FUL_I.type = REP_TXT.itemsShort
                FUL_I.times = math.ceil(toDo).."x"
                FUL_I.rep = string.format("%d", fg_sid_x_d.rep)
                FUL_I.index = index
                FUL_I.belongsTo = nil
                FUL_I.isShown = true
                FUL_I.name = REP_TXT.itemsName
                FUL_I.hasList = true
                FUL_I.listShown = false
                FUL_I.tooltipHead = REP_TXT.itemsHead
                FUL_I.tooltipTip = REP_TXT.itemsTip
                FUL_I.tooltipDetails = {}
                local FUL_I_TD = FUL_I.tooltipDetails

                local x = 0
                FUL_I_TD[x], x = REP:Update_Tooltip(x, FUL_I.name, " ")
                FUL_I_TD[x], x = REP:Update_Tooltip(x, " ", " ")
                FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.itemsRequired, " ")

                -- add items
                local itemIndex = index + 1
                local currentQuestTimesBag = -1
                local currentQuestTimesBagBank = -1

                for item in pairs(fg_sid_x_d.items) do
                  REP_UpdateList[itemIndex] = {}
                  local FUL_II = REP_UpdateList[itemIndex]
                  FUL_II.type = ""
                  FUL_II.times = math.ceil((fg_sid_x_d.items[item] * toDo)).."x"
                  FUL_II.rep = nil
                  FUL_II.index = itemIndex
                  FUL_II.belongsTo = index
                  FUL_II.hasList = nil
                  FUL_II.listShown = nil
                  FUL_II.isShown = FUL_I.listShown
                  local tempItemName = REP:InitItemName(item)
                  FUL_II.name = tempItemName.." ("..fg_sid_x_d.items[item].."x)"
                  FUL_I.name = tempItemName
                  FUL_I_TD[x], x = REP:Update_Tooltip(x, fg_sid_x_d.items[item].."x", REP:InitItemName(item))
                  FUL_II, currentQuestTimesBag, currentQuestTimesBagBank = REP:Quest_Items(fg_sid_x_d.items[item], currentQuestTimesBag, currentQuestTimesBagBank, FUL_II, item)

                  if fg_sid_x_d.alternativeItems ~= nil then
                    for altItem in pairs(fg_sid_x_d.alternativeItems) do
                      temp_FUL_II, temp_currentQuestTimesBag, temp_currentQuestTimesBagBank = REP:Quest_Items(fg_sid_x_d.alternativeItems[altItem], -1, -1, FUL_II, altItem)

                      if temp_currentQuestTimesBagBank > 0 then
                        if currentQuestTimesBagBank < 0 then
                          currentQuestTimesBagBank = temp_currentQuestTimesBagBank
                        else
                          currentQuestTimesBagBank = currentQuestTimesBagBank + temp_currentQuestTimesBagBank
                        end
                      end

                      if temp_currentQuestTimesBag > 0 then
                        currentQuestTimesBag = currentQuestTimesBag + temp_currentQuestTimesBag
                      end
                    end
                  end

                  REP_UpdateList[itemIndex] = FUL_II
                  itemIndex = itemIndex + 1
                end

                if (currentQuestTimesBag > 0) then
                  FUL_I.highlight = true
                  FUL_I.lowlight = nil
                  FUL_I.name = FUL_I.name..REP_BAG_COLOUR.." ["..currentQuestTimesBag.."x]|r"
                  FUL_I.currentTimesBag = currentQuestTimesBag
                  FUL_I.currentRepBag = currentQuestTimesBag * FUL_I.rep
                  REP_CurrentRepInBag = REP_CurrentRepInBag + FUL_I.currentRepBag
                  FUL_I_TD[x], x = REP:Update_Tooltip(x, " ", " ")
                  FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.inBag, " ")
                  FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.turnIns, string.format("%d", FUL_I.currentTimesBag))
                  FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.reputation, string.format("%d", FUL_I.currentRepBag))
                end

                if (currentQuestTimesBagBank > 0) then
                  FUL_I.highlight = true
                  FUL_I.lowlight = nil
                  FUL_I.name = FUL_I.name..REP_BAG_BANK_COLOUR.." ["..currentQuestTimesBagBank.."]|r"
                  FUL_I.currentTimesBagBank = currentQuestTimesBagBank
                  FUL_I.currentRepBagBank = currentQuestTimesBagBank * FUL_I.rep
                  REP_CurrentRepInBagBank = REP_CurrentRepInBagBank + FUL_I.currentRepBagBank
                  FUL_I_TD[x] = {}

                  if (not REP_UpdateList[index].hasList) then return end	-- not a list Header entry

                  FUL_I_TD[x], x = REP:Update_Tooltip(x, " ", " ")
                  FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.inBagBank, " ")
                  FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.turnIns, string.format("%d", FUL_I.currentTimesBagBank))
                  FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.reputation, string.format("%d", FUL_I.currentRepBagBank))
                end

                if ((currentQuestTimesBag == 0) and (currentQuestTimesBagBank > 0 == false)) then
                  FUL_I.highlight = nil
                end

                FUL_I_TD[x], x = REP:Update_Tooltip(x, " ", " ")
                FUL_I_TD[x] = REP:Update_Tooltip(x, REP_TXT.maxStanding, _G["FACTION_STANDING_LABEL"..fg_sid_x_d.maxStanding])
                FUL_I_TD.count = x
                FUL_I.tooltipDetails = FUL_I_TD
                REP_UpdateList[index] = FUL_I
                index = itemIndex
              end
            end
          end
        end

        -- General
        if (fg_sid.general and REP_Data.Global.ShowGeneral) then
          local fg_sid_x = fg_sid.general
          for i = 0, fg_sid_x.count do
            local fg_sid_x_d = fg_sid_x.data[i]
            if (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
              local toDo = string.format("%.2f", repToNext / fg_sid_x_d.rep)
              if (fg_sid_x_d.limit) then
                toDo = string.format("%.2f", (fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
              end

              -- calculate Number of times to do differently for Guild cap
              REP_UpdateList[index] = {}
              local FUL_I = REP_UpdateList[index]
              FUL_I.type = REP_TXT.generalShort
              FUL_I.times = math.ceil(toDo).."x"
              FUL_I.rep = string.format("%d", fg_sid_x_d.rep)
              FUL_I.index = index
              FUL_I.belongsTo = nil
              FUL_I.isShown = true
              FUL_I.hasList = false
              FUL_I.listShown = nil
              local bul_name = fg_sid_x_d.name
              FUL_I.name = bul_name

              if (fg_sid_x_d.head and fg_sid_x_d.head ~= "") then
                FUL_I.tooltipHead = fg_sid_x_d.head
              else
                FUL_I.tooltipHead = REP_TXT.generalHead
              end

              if (fg_sid_x_d.tip and fg_sid_x_d.tip ~= "") then
                FUL_I.tooltipTip = fg_sid_x_d.tip
              else
                FUL_I.tooltipTip = REP_TXT.generalTip
              end

              FUL_I.tooltipDetails = {}
              local FUL_I_TD = FUL_I.tooltipDetails
              local x = 0
              FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.general2, bul_name)
              FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.reputation, FUL_I.rep)
              FUL_I_TD[x], x = REP:Update_Tooltip(x, REP_TXT.timesToRun, FUL_I.times)
              FUL_I_TD[x], x = REP:Update_Tooltip(x, " ", " ")
              if (fg_sid_x_d.tipList) then
                for tip in pairs(fg_sid_x_d.tipList) do
                  FUL_I_TD[x], x = REP:Update_Tooltip(x, tip, fg_sid_x_d.tipList[tip])
                end

                FUL_I_TD[x], x = REP:Update_Tooltip(x, " ", " ")
              end

              FUL_I_TD[x] = REP:Update_Tooltip(x, REP_TXT.maxStanding, _G["FACTION_STANDING_LABEL"..fg_sid_x_d.maxStanding])
              FUL_I_TD.count = x
              local FUL_I_TD = FUL_I.tooltipDetails
              REP_UpdateList[index] = FUL_I
              index = index + 1
            end
          end
        end
      end
    end
  end

  REP_UpdateList_Update();
end

function REP:Quest_Items(itemsNeed, currentQuestTimesBag, currentQuestTimesBagBank, QuestItem, item)
  local expansionIndex = REP_Data.Global.ExpansionIndex;

  if not QuestItem.times then
    QuestItem = {}
    QuestItem.name = "James"
  end

  if (GetItemCount(item, true) == 0) then -- and C_CurrencyInfo.GetCurrencyInfo(item) == nil
    -- not enough of this item for quest -> set to 0
    currentQuestTimesBag = 0
  else
    local itemBag = 0
    local itemTotal = 0

    if (GetItemCount(item, true) == 0) then -- If GetItemCount is 0 then this is a currency and not a item
      _, itemBag = GetCurrencyInfo(item) -- C_CurrencyInfo.GetCurrencyInfo(item).quantity
      itemTotal = itemBag
    else
      itemBag = GetItemCount(item)
      itemTotal = GetItemCount(item, true)
    end

    local itemBank = itemTotal - itemBag
    if ((itemBag >= itemsNeed) and (itemsNeed > 0)) then
      QuestItem.currentTimesBag = floor(itemBag / itemsNeed)
      QuestItem.name = QuestItem.name..REP_BAG_COLOUR.." ["..itemBag.."x]|r"

      if (currentQuestTimesBag == -1) then
        -- first items for this quest --> take value
        currentQuestTimesBag = QuestItem.currentTimesBag
      else
        -- some items already Set
        if (QuestItem.currentTimesBag < currentQuestTimesBag) then
          -- fewer of this item than of others, reduce quest count
          currentQuestTimesBag = QuestItem.currentTimesBag
        end
      end
    else
      -- not enough of this item for quest -> set to 0
      currentQuestTimesBag = 0
      QuestItem.name = QuestItem.name.." ["..itemBag.."x]"
    end

    if itemBank > 0 then
      if ((itemTotal >= itemsNeed) and (itemsNeed > 0)) then
        QuestItem.name = QuestItem.name..REP_BAG_BANK_COLOUR.." ["..itemTotal.."x]|r"
        QuestItem.currentTimesBagBank = floor(itemBank / itemsNeed)

        if (currentQuestTimesBagBank == -1) then
          -- first items for this quest --> take value
          currentQuestTimesBagBank = QuestItem.currentTimesBagBank
        else
          -- some items already Set
          if (QuestItem.currentTimesBagBank < currentQuestTimesBagBank) then
            -- fewer of this item than of others, reduce quest count
            currentQuestTimesBagBank = QuestItem.currentTimesBagBank
          end
        end
      else
        -- not enough of this item for quest -> set to 0
        currentQuestTimesBagBank = 0
        QuestItem.name = QuestItem.name.." ["..itemBank.."x]"
      end
    else
    -- none of this carried In bank
    end
  end

  return QuestItem, currentQuestTimesBag, currentQuestTimesBagBank
end

function REP:GetUpdateListSize()
  -- sub function of	REP_UpdateList_Update()
  local count = 0
  local highest = 0
  for i in pairs(REP_UpdateList) do
    if (REP_UpdateList[i].isShown) then
      count = count + 1
      if (i > highest) then
        highest = i
      end
    end
  end

  return count, highest
end

function REP:ShowUpdateEntry(index, show)
  if (not REP_UpdateList[index]) then return end		-- invalid index
  if (not REP_UpdateList[index].hasList) then return end	-- not a list Header entry
  if (type(show)~="boolean") then return end		-- wrong data type

  REP_UpdateList[index].listShown = show
  for i in pairs(REP_UpdateList) do
    if (REP_UpdateList[i].belongsTo == index) then
      REP_UpdateList[i].isShown = show
    end
  end

  REP_UpdateList_Update()
end

function REP_ShowUpdateEntries(show)
  if (type(show)~="boolean") then return end		-- wrong data type

  for i in pairs(REP_UpdateList) do
    if (REP_UpdateList[i].belongsTo == nil) then
      -- always show parent entries, show or Hide their children
      REP_UpdateList[i].isShown = true
      REP_UpdateList[i].listShown = show
    else
      -- show or Hide child entries
      REP_UpdateList[i].isShown = show
    end
  end

  REP_UpdateList_Update()
end

function REP_ShowLineToolTip(self)
  if not self then return end

  if (self.tooltipHead) then
    GameTooltip_SetDefaultAnchor(GameTooltip, self)
    GameTooltip:SetText(self.tooltipHead, 1, 1, 0.5, 1)
    if (self.tooltipTip) then
      GameTooltip:AddLine(self.tooltipTip, 1, 1, 1, 1)
    end

    if (self.tooltipDetails and type(self.tooltipDetails) == "table") then
      GameTooltip:AddLine(" ", 1, 1, 1, 1)
      for i = 0, self.tooltipDetails.count do
        if (self.tooltipDetails[i].l and self.tooltipDetails[i].r) then
          if (self.tooltipDetails[i].r == " " or self.tooltipDetails[i].r=="") then
            GameTooltip:AddDoubleLine(self.tooltipDetails[i].l, self.tooltipDetails[i].r, 1, 1, 0, 1, 1, 1)
          else
            GameTooltip:AddDoubleLine(self.tooltipDetails[i].l, self.tooltipDetails[i].r, 1, 1, 0.5, 1, 1, 1)
          end
        end
      end
    end

    GameTooltip:Show()
  end
end

function REP_ShowHelpToolTip(self, element)
  if not element then return end

  local name = ""
  -- cut off leading frame name
  --if (string.find(element, GLDG_GUI)) then
  --	name = string.sub(element, string.len(GLDG_GUI)+1)
  --elseif (string.find(element, GLDG_COLOUR)) then
  --	name = string.sub(element, string.len(GLDG_COLOUR)+1)
  --elseif (string.find(element, GLDG_LIST)) then
  name = element
  --end

  -- cut off trailing Number In case of line and collect
  --local s,e = string.find(name, "Line");
  --if (s and e) then
  --	name = string.sub(name, 0, e)
  --end
  --s,e = string.find(name, "Collect");
  --if (s and e) then
  --	name = string.sub(name, 0, e)
  --end

  -- cut off colour button/texture
  --if (string.find(name, "Colour") == 1) then
  --	-- ["ColourGuildNewButton"] = true,
  --	s,e = string.find(name, "Button");
  --	if (s and e) then
  --		name = string.sub(name, 0, s-1)
  --	end
  --	-- ["ColourGuildNewColour"] = true,
  --	s,e = string.find(name, "Colour", 2);	-- start at 2 to skip the initial Colour
  --	if (s and e) then
  --		name = string.sub(name, 0, s-1)
  --	end
  --end

  local tip = ""
  local head = ""
  if (REP_TXT.elements and
    REP_TXT.elements.name and
    REP_TXT.elements.tip and
    REP_TXT.elements.name[name] and
    REP_TXT.elements.tip[name]) then
    tip = REP_TXT.elements.tip[name]
    head = REP_TXT.elements.name[name]

    if (REP_Data.Global.needsTip and REP_Data.Global.needsTip[name]) then
      REP_Data.Global.needsTip[name] = nil
    end
  else
    if (not REP_Data.Global.needsTip) then
      REP_Data.Global.needsTip = {}
    end

    REP_Data.Global.needsTip[name] = true
  end

  --GameTooltip_SetDefaultAnchor(GameTooltip, self)
  GameTooltip:SetOwner(self, "ANCHOR_RIGHT");

  if (head ~= "") then
    GameTooltip:SetText(head, 1, 1, 0.5, 1.0, 1)
    GameTooltip:AddLine(tip, 1, 1, 1, 1.0, 1)
    -- GameTooltip:AddLine(name, 1, 0, 0, 1.0, 1)
    -- else
    -- GameTooltip:SetText(element, 1, 1, 0.5, 1.0, 1)
    -- GameTooltip:AddLine(name, 1, 1, 1, 1.0, 1)
  end

  GameTooltip:Show()
end

function tableSort(a, b)
  return a.rep > b.rep
end

-----------------------------------
-- _12_ reputation Changes to chat
-----------------------------------
function REP:DumpReputationChangesToChat(initOnly)
  if not REP_StoredRep then REP_StoredRep = {} end

  if (REP_OnLoadingScreen == false) then
    local numFactions = GetNumFactions();
    local expansionIndex = REP_Data.Global.ExpansionIndex;
    local factionIndex, watchIndex, watchedIndex, watchName
    local name, standingID, barMin, barMax, barValue, isHeader, hasRep
    local RepRemains
    local factionID

    watchIndex = 0
    watchedIndex = 0
    watchName = nil

    for factionIndex=1, numFactions, 1 do
      name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep, isWatched, _, factionID = GetFactionInfo(factionIndex)

      if(factionID and C_Reputation.IsFactionParagon(factionID)) then
        local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID);
        barMin, barMax, barValue = 0, threshold, mod(currentValue, threshold);
      end

      if expansionIndex > 2 then
        local friendID, _, _, _, _, _, friendTextLevel, _, nextFriendThreshold = GetFriendshipReputation(factionID)
      end

      if (not isHeader or hasRep) then
        if (isWatched) then
          watchedIndex = factionIndex
        end

        if REP_StoredRep[name] and not initOnly then
          if (REP_Data.Global.WriteChatMessage) then
            if (not REP_Data.Global.NoGuildGain or name ~= REP_GuildName) then
              local sign=""
              if ((barValue-REP_StoredRep[name].origRep)>0) then
                sign = "+"
              end

              if (barValue > REP_StoredRep[name].rep) then
                -- increased rep
                if (friendID ~= nil and nextFriendThreshold ~= nil) then
                  -- If the faction is a friend faction and not at max rank get the next standing text
                  REP:Print(REP_NEW_REP_COLOUR..string.format(FACTION_STANDING_INCREASED..REP_TXT.statsNextStanding, name, barValue-REP_StoredRep[name].rep, sign, barValue-REP_StoredRep[name].origRep, REP_GetFriendFactionStandingLabel(factionID, nextFriendThreshold),barMax-barValue))
                elseif (friendID == nil and standingID < 8) then
                  -- If not a friend faction and below max rank use the format (Total: %s%d, Left to %s: %d) if not use the normal format (Total: %s%d, Left: %d)
                  REP:Print(REP_NEW_REP_COLOUR..string.format(FACTION_STANDING_INCREASED..REP_TXT.statsNextStanding, name, barValue-REP_StoredRep[name].rep, sign, barValue-REP_StoredRep[name].origRep, _G["FACTION_STANDING_LABEL"..standingID + 1],barMax-barValue))
                else
                  REP:Print(REP_NEW_REP_COLOUR..string.format(FACTION_STANDING_INCREASED..REP_TXT.stats, name, barValue-REP_StoredRep[name].rep, sign, barValue-REP_StoredRep[name].origRep, barMax-barValue))
                end
              elseif (barValue < REP_StoredRep[name].rep) then
                -- decreased rep
                if (standingID > 1 and friendID == nil) then
                  -- Only use the new format (Total: %s%d, Left to %s: %d) if we are above the lowest rank, otherwise use the normal format (Total: %s%d, Left: %d)
                  REP:Print(REP_NEW_REP_COLOUR..string.format(FACTION_STANDING_DECREASED..REP_TXT.statsNextStanding, name, REP_StoredRep[name].rep-barValue, sign, barValue-REP_StoredRep[name].origRep, _G["FACTION_STANDING_LABEL"..standingID - 1], barMax-barValue))
                else
                  REP:Print(REP_NEW_REP_COLOUR..string.format(FACTION_STANDING_DECREASED..REP_TXT.stats, name, REP_StoredRep[name].rep-barValue, sign, barValue-REP_StoredRep[name].origRep, barMax-barValue))
                end
              end

              if (REP_StoredRep[name].standingID ~= standingID) then
                if friendID == nil then
                  REP:Print(REP_NEW_STANDING_COLOUR..string.format(FACTION_STANDING_CHANGED, _G["FACTION_STANDING_LABEL"..standingID], name))
                else
                  REP:Print(REP_NEW_STANDING_COLOUR..string.format(FACTION_STANDING_CHANGED, friendTextLevel, name))
                end
              end
            end
          end

          if (REP_Data.Global.SwitchFactionBar) then
            if (not REP_Data.Global.NoGuildSwitch or name ~= REP_GuildName) then
              if (barValue > REP_StoredRep[name].rep) then
                watchIndex = factionIndex
                watchName = name
              end
            end
          end
        else
          REP_StoredRep[name] = {}
          REP_StoredRep[name].origRep = barValue
        end

        REP_StoredRep[name].standingID = standingID
        REP_StoredRep[name].rep = barValue
      end
    end

    if(expansionIndex < 2) then
      if (REP_Data.Global.SwitchFactionBar and REP:TableSize(factionsChanged) > 1) then
        table.sort(factionsChanged, tableSort)
        watchIndex = factionsChanged[1].watchIndex
        watchName = factionsChanged[1].watchName
      end
    end

    if (watchIndex > 0) then
      if (watchIndex ~= watchedIndex) then
        if (not REP_Data.Global.SilentSwitch) then
          REP:Print(REP_Help_COLOUR..REP_NAME..":|r "..REP_TXT.switchBar.." ["..tostring(watchName).."|r]")
        end
      end

      -- choose Faction to show
      SetWatchedFactionIndex(watchIndex)
    end
  end
end

function REP:ClearSessionGain()
  local factionIndex = GetSelectedFaction()
  local name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep, isWatched = GetFactionInfo(factionIndex)

  if (name) then
    REP_StoredRep[name] = {}
    REP_StoredRep[name].origRep = barValue
    REP_StoredRep[name].standingID = standingID
    REP_StoredRep[name].rep = barValue
  end

  REP_ReputationFrame_Update()
end

-----------------------------------
-- _13_ chat filtering
-----------------------------------
function REP_ChatFilter(chatFrame, event, ...) -- chatFrame = self
  --[[
    CHAT_MSG_COMBAT_FACTION_CHANGE
    Fires when player's faction changes. ie: "Your reputation with Timbermaw Hold has very slightly increased." -- NEW 1.9
    arg1
    The message to display

    COMBAT_TEXT_UPDATE
    arg1
    Combat message type.
    Known values include "HONOR_GAINED", and "FACTION".
    arg2
    for faction gain, this is the faction name.
    arg3
    for faction gain, the amount of reputation gained.
  ]]--

  local msg, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13 = ...;

  local skip = false
  if (REP_Data.Global.WriteChatMessage and event) then

    if (event == "CHAT_MSG_COMBAT_FACTION_CHANGE") then
      skip = true
    end

    if ((event == "COMBAT_TEXT_UPDATE") and (msg=="FACTION")) then
      skip = true
    end
  end

  return skip, msg, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13
end

-----------------------------------
-- _13_ show option window
-----------------------------------
function REP:ToggleConfigWindow()
  if ReputationFrame:IsVisible() then
    if REP_OptionsFrame:IsVisible() then
      -- both windows shown -> hide them both
      REP_OptionsFrame:Hide()
      HideUIPanel(CharacterFrame)
    else
      -- options window not shown -> show, hide any detail window
      REP_OptionsFrame:Show()
      REP_ReputationDetailFrame:Hide();
      ReputationDetailFrame:Hide();
    end

  else
    -- window not shown -> show both
    ToggleCharacter("ReputationFrame")
    REP_ReputationDetailFrame:Hide();
    ReputationDetailFrame:Hide();
    REP_OptionsFrame:Show()
  end
end

function REP:ToggleDetailWindow()
  if ReputationFrame:IsVisible() then
    if (REP_Data.Global.ExtendDetails) then
      if REP_ReputationDetailFrame:IsVisible() then
        -- both windows shown -> hide them both
        REP_ReputationDetailFrame:Hide()
        HideUIPanel(CharacterFrame)
      else
        -- detail window not shown -> show it, hide any others
        REP_ReputationDetailFrame:Show()
        ReputationDetailFrame:Hide();
        REP_OptionsFrame:Hide();
        ReputationFrame_Update();
      end
    else
      if ReputationDetailFrame:IsVisible() then
        -- both windows shown -> hide them both
        ReputationDetailFrame:Hide()
        HideUIPanel(CharacterFrame)
      else
        -- detail window not shown -> show it, hide any others
        REP_ReputationDetailFrame:Hide()
        ReputationDetailFrame:Show();
        REP_OptionsFrame:Hide();
        ReputationFrame_Update();
      end
    end
  else
    -- window not shown -> show both
    ToggleCharacter("ReputationFrame")
    if (REP_Data.Global.ExtendDetails) then
      REP_ReputationDetailFrame:Show();
    else
      ReputationDetailFrame:Show();
    end

    REP_OptionsFrame:Hide()
    ReputationFrame_Update();
  end
end

-----------------------------------
-- _14_ Testing
-----------------------------------
function REP_Test()
  if (REP_GuildFactionBar:GetParent()) then
    REP:Print("REP_GuildFactionBar parent: "..tostring(REP_GuildFactionBar:GetParent():GetName()))
  else
    REP:Print("REP_GuildFactionBar has no parent")
  end

  if (REP_GuildFactionBarCapHeader:GetParent()) then
    REP:Print("REP_GuildFactionBarCapHeader parent: "..tostring(REP_GuildFactionBarCapHeader:GetParent():GetName()))
  else
    REP:Print("REP_GuildFactionBarCapHeader has no parent")
  end

  if (REP_GuildFactionBarCapText:GetParent()) then
    REP:Print("REP_GuildFactionBarCapText parent: "..tostring(REP_GuildFactionBarCapText:GetParent():GetName()))
  else
    REP:Print("REP_GuildFactionBarCapText has no parent")
  end

  if (REP_GuildFactionBarCapMarker:GetParent()) then
    REP:Print("REP_GuildFactionBarCapMarker parent: "..tostring(REP_GuildFactionBarCapMarker:GetParent():GetName()))
  else
    REP:Print("REP_GuildFactionBarCapMarker has no parent")
  end

  if (REP_GuildFactionBarBaseMarker:GetParent()) then
    REP:Print("REP_GuildFactionBarBaseMarker parent: "..tostring(REP_GuildFactionBarBaseMarker:GetParent():GetName()))
  else
    REP:Print("REP_GuildFactionBarBaseMarker has no parent")
  end
end

-------------------------------------------
-- _15_ Getting reputation ready to hand In
-------------------------------------------
function REP:GetReadyReputation(factionIndex)
  local result = 0
  return result end	--[[-- curently disabled
  if not factionIndex then return result end

  if (not ReputationFrame:IsVisible()) then return result end

  local maxFactionIndex = GetNumFactions()
  if (factionIndex > maxFactionIndex) then return result end

  local faction, description, standingId, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = REP_Orig_GetFactionInfo(factionIndex)
  if (isHeader) then return result end

  if (faction) then
    origFaction = faction
    faction = string.lower(faction)
    if (REP_FactionMapping[faction]) then
      faction = REP_FactionMapping[faction]
    end

    -- Normalize Values
    local normMax = barMax - barMin
    local normCurrent = barValue - barMin
    local repToNext = barMax - barValue

    local REP_FG_f=REP_FactionGain[faction]
    if (REP_FG_f) then
      local REP_FG_fs=REP_FG_f[standingId]
      if (REP_FG_fs) then
        -- quests (may have items)
        local REP_FG_fs_h=REP_FG_fs.quests
        if (REP_FG_fs_h) then
          for i = 0, REP_FG_fs_h.count do
            local REP_FG_fs_h_d=REP_FG_fs_h.data[i]
            if (not REP_FG_fs_h_d.limit or (normCurrent < REP_FG_fs_h_d.limit)) then
              local toDo = ceil(repToNext / REP_FG_fs_h_d.rep)
              if (REP_FG_fs_h_d.limit) then
                toDo = ceil((REP_FG_fs_h_d.limit - normCurrent) / REP_FG_fs_h_d.rep)
              end

              if (REP_FG_fs_h_d.items) then
                local currentQuestTimesBag = -1
                local currentQuestTimesBagBank = -1
                for item in pairs(REP_FG_fs_h_d.items) do
                  _, currentQuestTimesBag, currentQuestTimesBagBank = REP:Quest_Items(REP_FG_fs_h_d.items[item], currentQuestTimesBag, currentQuestTimesBagBank, "nil", item)
                end

                if (currentQuestTimesBag > toDo) then
                  currentQuestTimesBag = toDo
                end

                if (currentQuestTimesBagBank > toDo) then
                  currentQuestTimesBagBank = toDo
                end

                if (currentQuestTimesBagBank > 0) then
                  result = result + currentQuestTimesBagBank * REP_FG_fs_h_d.rep
                elseif (currentQuestTimesBag > 0) then
                  result = result + currentQuestTimesBag * REP_FG_fs_h_d.rep
                else
                -- nothing to add
                end
              else
                -- no items, check if this quest is completed
                local entries, quests = GetNumQuestLogEntries()
                for z=1,entries do
                  local title,level,tag,group,header,collapsed,complete,daily = GetQuestLogTitle(z)
                  if (title and not header and complete) then
                    if string.find(string.lower(REP:Quest_Names(REP_FG_fs_h_d.name)), string.lower(title)) then
                      -- this quest matches
                      result = result + REP_FG_fs_h_d.rep
                    end
                  end
                end
              end
            end
          end
        end

        -- items
        local REP_FG_fs_h=REP_FG_fs.items
        if (REP_FG_fs_h and REP_Data.Global.ShowItems) then
          for i = 0, REP_FG_fs_h.count do
            local REP_FG_fs_h_d=REP_FG_fs_h.data[i]
            if (not REP_FG_fs_h_d.limit or (normCurrent < REP_FG_fs_h_d.limit)) then
              local toDo = ceil(repToNext / REP_FG_fs_h_d.rep)
              if (REP_FG_fs_h_d.limit) then
                toDo = ceil((REP_FG_fs_h_d.limit - normCurrent) / REP_FG_fs_h_d.rep)
              end

              if (REP_FG_fs_h_d.items) then
                local currentQuestTimesBag = -1
                local currentQuestTimesBagBank = -1
                for item in pairs(REP_FG_fs_h_d.items) do
                  _, currentQuestTimesBag, currentQuestTimesBagBank = REP:Quest_Items(REP_FG_fs_h_d.items[item], currentQuestTimesBag, currentQuestTimesBagBank, "nil", item)
                end

                if (currentQuestTimesBag > toDo) then
                  currentQuestTimesBag = toDo
                end

                if (currentQuestTimesBagBank > toDo) then
                  currentQuestTimesBagBank = toDo
                end

                if (currentQuestTimesBagBank > 0) then
                  result = result + currentQuestTimesBagBank * REP_FG_fs_h_d.rep
                elseif (currentQuestTimesBag > 0) then
                  result = result + currentQuestTimesBag * REP_FG_fs_h_d.rep
                end
              end
            end
          end
        end
      end
    end
  end

  return result;
end	--]]--

----------------------------------
-- _16_ FSS // RDF_IS // RDF
-----------------------------------
function REP:StandingSort()
  local standings = {}
  local numFactions = GetNumFactions();
  local expansionIndex = REP_Data.Global.ExpansionIndex;

  for i = 1, numFactions do
    local name, description, standingID, _, barMax, barValue, _, _, isHeader, _, hasRep, isWatched, isChild, factionID, hasBonusRepGain = GetFactionInfo(i);

    if (expansionIndex > 2) then
      if(factionID and C_Reputation.IsFactionParagon(factionID) and REP_Data.Global.ShowParagonBar) then
        local currentValue, threshold, _, _ = C_Reputation.GetFactionParagonInfo(factionID);
        barMax, barValue, standingID = threshold, mod(currentValue, threshold), 9;
      end
    end

    if (not isHeader or hasRep) then
      if not standings[standingID] then
        standings[standingID] = {}
      end

      local size = REP:TableSize(standings[standingID])
      local entry = {}
      local inserted = false
      entry.missing = barMax-barValue
      entry.i = i

      if (size) then
        for j = 1, size do
          if (not inserted) then
            if (standings[standingID][j].missing > entry.missing) then
              table.insert(standings[standingID], j, entry);
              inserted = true
            end
          end
        end

        if (not inserted) then
          table.insert(standings[standingID], entry)
        end
      else
        table.insert(standings[standingID], entry)
      end
    end
  end

  -- find Number of elements to display
  local numFactions = 0
  REP_Entries = {}

  if (not REP_Collapsed) then
    REP_Collapsed = {}
  end

  for i = 9, 1, -1 do
    --for i In pairs(standings) do
    if REP:TableSize(standings[i]) then
      if (standings[i]) then
        numFactions = numFactions + 1 -- count standing as header
        REP_Entries[numFactions] = {}
        REP_Entries[numFactions].header = true
        REP_Entries[numFactions].i = i	-- this is the standingID
        REP_Entries[numFactions].size = REP:TableSize(standings[i]) -- this is the number of factions with this standing

        if (not REP_Collapsed[i]) then
          for j in pairs(standings[i]) do
            numFactions = numFactions + 1 -- count each faction in the current standing
            REP_Entries[numFactions] = {}
            REP_Entries[numFactions].header = false
            REP_Entries[numFactions].i = standings[i][j].i -- this is the index into the faction table
            REP_Entries[numFactions].size = 0
          end
        end
      end
    end
  end

  REP_OBS_numFactions = numFactions
end

function REP_ReputationDetailFrame_IsShown(faction, flag, flag2, i)
  local name, description, _, _, _, _, atWarWith, canToggleAtWar, _, _, _, isWatched, _, _, _, _ = GetFactionInfo(faction);

  ReputationDetailFactionName:SetText(name);
  ReputationDetailFactionDescription:SetText(description);

  if (atWarWith) then
    ReputationDetailAtWarCheckBox:SetChecked(true);
  else
    ReputationDetailAtWarCheckBox:SetChecked(false);
  end

  if flag then
    ReputationDetailAtWarCheckBox:Enable();
    ReputationDetailAtWarCheckBoxText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
  else
    ReputationDetailAtWarCheckBox:Disable();
    ReputationDetailAtWarCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
  end

  if flag2 == 2 then
    if (not isHeader) then
      ReputationDetailInactiveCheckBox:Enable();
      ReputationDetailInactiveCheckBoxText:SetTextColor(ReputationDetailInactiveCheckBoxText:GetFontObject():GetTextColor());
    else
      ReputationDetailInactiveCheckBox:Disable();
      ReputationDetailInactiveCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
    end

    _G["ReputationBar"..i.."ReputationBarHighlight1"]:Show();
    _G["ReputationBar"..i.."ReputationBarHighlight2"]:Show();
  end

  if (IsFactionInactive(faction)) then
    ReputationDetailInactiveCheckBox:SetChecked(true);
  else
    ReputationDetailInactiveCheckBox:SetChecked(false);
  end

  if (isWatched) then
    ReputationDetailMainScreenCheckBox:SetChecked(true);
  else
    ReputationDetailMainScreenCheckBox:SetChecked(false);
  end
end

function REP:Rep_Detail_Frame(faction,colorID,barValue,barMax,origBarValue,standingID,toExalted,factionStandingtext, toBFF, isParagon, isFriend, isCappedFriendship)
  local name, description, _, _, _, _, atWarWith, canToggleAtWar, _, _, _, isWatched, _, factionID, _, _ = GetFactionInfo(faction);

  local friendInfo
  local friendID, friendRep, friendMaxRep, friendName, friendText, friendTextLevel, nextFriendThreshold

  if isFriend then
    friendID, friendRep, friendMaxRep, friendName, friendText, _, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
  end

  local gender = UnitSex("player");
  REP:BuildUpdateList()
  REP_ReputationDetailFactionName:SetText(name);
  REP_ReputationDetailFactionDescription:SetText(description);

  if isParagon then
    REP_ReputationDetailStandingName:SetText("Paragon")
  elseif isFriend then
    REP_ReputationDetailStandingName:SetText(friendTextLevel)
  else
    REP_ReputationDetailStandingName:SetText(factionStandingtext)
  end

  local color = FACTION_BAR_COLORS[colorID]
  REP_ReputationDetailStandingName:SetTextColor(color.r, color.g, color.b)

  REP_ReputationDetailStandingCurrent:SetText(REP_TXT.currentRep)
  REP_ReputationDetailStandingNeeded:SetText(REP_TXT.neededRep)
  REP_ReputationDetailStandingMissing:SetText(REP_TXT.missingRep)
  REP_ReputationDetailStandingBag:SetText(REP_TXT.repInBag)
  REP_ReputationDetailStandingBagBank:SetText(REP_TXT.repInBagBank)
  REP_ReputationDetailStandingQuests:SetText(REP_TXT.repInQuest)
  REP_ReputationDetailStandingGained:SetText(REP_TXT.factionGained)

  REP_ReputationDetailStandingCurrentValue:SetText(barValue)
  REP_ReputationDetailStandingNeededValue:SetText(barMax)
  REP_ReputationDetailStandingMissingValue:SetText(barMax-barValue)
  REP_ReputationDetailStandingBagValue:SetText(REP_CurrentRepInBag)
  REP_ReputationDetailStandingBagBankValue:SetText(REP_CurrentRepInBagBank)
  REP_ReputationDetailStandingQuestsValue:SetText(REP_CurrentRepInQuest)

  if (REP_StoredRep and REP_StoredRep[name] and REP_StoredRep[name].origRep) then
    REP_ReputationDetailStandingGainedValue:SetText(string.format("%d", origBarValue-REP_StoredRep[name].origRep))
  else
    REP_ReputationDetailStandingGainedValue:SetText("")
  end

  if isFriend then
    if isCappedFriendship ~= true then
      color = FACTION_BAR_COLORS[8]
      REP_ReputationDetailStandingNextValue:SetText("(--> "..REP_GetFriendFactionStandingLabel(factionID, nextFriendThreshold)..")")
      REP_ReputationDetailStandingNextValue:SetTextColor(color.r, color.g, color.b)
    else
      REP_ReputationDetailStandingNextValue:SetText("")
    end
  else
    if (standingID < 8) then
      color = FACTION_BAR_COLORS[standingID+1]
      --REP_ReputationDetailStandingNext:SetText(REP_TXT.nextLevel)
      REP_ReputationDetailStandingNextValue:SetText("(--> "..GetText("FACTION_STANDING_LABEL"..standingID+1, gender)..")")
      REP_ReputationDetailStandingNextValue:SetTextColor(color.r, color.g, color.b)
    else
      --REP_ReputationDetailStandingNext:SetText("")
      REP_ReputationDetailStandingNextValue:SetText("")
    end
  end

  if isFriend then
    if (isCappedFriendship ~= true) then
      -- Add to localization file sometime
      REP_ReputationDetailStandingToExaltedHeader:SetText("Reputation to max")
      REP_ReputationDetailStandingToExaltedValue:SetText(toBFF)
    else
      REP_ReputationDetailStandingToExaltedHeader:SetText("")
      REP_ReputationDetailStandingToExaltedValue:SetText("")
      end
  else
    if (standingID < 7) then
      -- Add to localization file sometime
      REP_ReputationDetailStandingToExaltedHeader:SetText(REP_TXT.toExalted)
      REP_ReputationDetailStandingToExaltedValue:SetText(toExalted)
    else
      REP_ReputationDetailStandingToExaltedHeader:SetText("")
      REP_ReputationDetailStandingToExaltedValue:SetText("")
    end
  end

  if (atWarWith) then
    REP_ReputationDetailAtWarCheckBox:SetChecked(true);
  else
    REP_ReputationDetailAtWarCheckBox:SetChecked(false);
  end

  if (canToggleAtWar) then
    REP_ReputationDetailAtWarCheckBox:Enable();
    REP_ReputationDetailAtWarCheckBoxText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
  else
    REP_ReputationDetailAtWarCheckBox:Disable();
    REP_ReputationDetailAtWarCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
  end

  if (IsFactionInactive(faction)) then
    REP_ReputationDetailInactiveCheckBox:SetChecked(true);
  else
    REP_ReputationDetailInactiveCheckBox:SetChecked(false);
  end

  if (isWatched) then
    REP_ReputationDetailMainScreenCheckBox:SetChecked(true);
  else
    REP_ReputationDetailMainScreenCheckBox:SetChecked(false);
  end
end

function REP_Friend_Detail(factionID, standingID, factionRow)
  local expansionIndex = REP_Data.Global.ExpansionIndex;
  if expansionIndex > 2 then
    local colorIndex, factionStandingtext, isCappedFriendship;
    local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID);

    if (friendID ~= nil) then
      if (nextFriendThreshold) then
        barMin, barMax, barValue = friendThreshold, nextFriendThreshold, friendRep;
      else	-- max rank, make it look like a full bar
        barMin, barMax, barValue = 0, 1, 1;
        isCappedFriendship = true;
      end
      colorIndex = 5;	-- always color friendships green
      factionStandingtext = friendTextLevel;
      factionRow.friendshipID = friendID;
      isFriend = true;

      return colorIndex, isCappedFriendship, factionStandingtext, isFriend
    else
      factionStandingtext = GetText("FACTION_STANDING_LABEL"..standingID, gender);
      factionRow.friendshipID = nil;
      colorIndex = standingID;
      isFriend = false;

      return colorIndex, isCappedFriendship, factionStandingtext, isFriend
    end
  else
    factionStandingtext = GetText("FACTION_STANDING_LABEL"..standingID, gender);
    factionRow.friendshipID = nil;
    colorIndex = standingID;
    isFriend = false;

    return colorIndex, isCappedFriendship, factionStandingtext, isFriend
  end
end

-----------------------------------
-- _16_ Listing by standing
-----------------------------------
function REP:ListByStanding(standing)
  local numFactions = GetNumFactions();
  local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, hasRep, isCollapsed, isWatched;
  local list = {}

  -- get factions by standing
  for i = 1, numFactions do
    name, description, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep = GetFactionInfo(i)
    if (not isHeader or hasRep) then
      if ((standing == nil) or (standing==standingID)) then
        if (not list[standingID]) then
          list[standingID] = {}
        end

        list[standingID][name]={}
        list[standingID][name].max = barMax-barMin
        list[standingID][name].value = barValue-barMin
      end
    end
  end

  -- output
  for i = 1, 8 do
    if (list[i]) then
      REP:Print(REP_Help_COLOUR..REP_NAME..":|r "..REP:RGBToColour_perc(1, FACTION_BAR_COLORS[i].r, FACTION_BAR_COLORS[i].g, FACTION_BAR_COLORS[i].b).."--- "..REP_TXT_STAND_LV[i].." ("..i..") ---|r")

      for p in pairs(list[i]) do
        --REP:Print("    "..p..": "..list[i][p].value.."/"..list[i][p].max.." ("..REP_TXT.missing2..": "..list[i][p].max-list[i][p].value..")")
        REP:Print("    "..p..": "..REP_TXT.missing2..": "..list[i][p].max-list[i][p].value)
      end

      if (not standing) then
        REP:Print(" ")
      end
    end
  end
end

------------------------
-- _17_ extracting Skill information
------------------------
function REP:ExtractSkills()
  REP_Herb = false
  REP_Skin = false
  REP_Mine = false
  REP_Alche = false
  REP_Black = false
  REP_Enchan = false
  REP_Engin = false
  REP_Jewel = false
  REP_Incrip = false
  REP_Leath = false
  REP_Tailor = false
  REP_Aid = false
  REP_Arch = false
  REP_Cook = false
  REP_Fish = false

  local expansionIndex = REP_Data.Global.ExpansionIndex;

  if (expansionIndex > 2) then
    local professions = {}
    local name, skillLine
    local prof1, prof2, archaeology, fishing, cooking, firstaid = GetProfessions();

    if (prof1) then
      name, _, _, _, _, _, skillLine = GetProfessionInfo(prof1);
      if name then professions[1] = name end
    end

    if (prof2) then
      name, _, _, _, _, _, skillLine = GetProfessionInfo(prof2);
      if name then professions[2] = name end
    end

    if (archaeology) then
      name, _, _, _, _, _, skillLine = GetProfessionInfo(archaeology);
      if name then professions[3] = name end
    end

    if (fishing) then
      name, _, _, _, _, _, skillLine = GetProfessionInfo(fishing);
      if name then professions[4] = name end
    end

    if (cooking) then
      name, _, _, _, _, _, skillLine = GetProfessionInfo(cooking);
      if name then professions[5] = name end
    end

    if (firstaid) then
      name, _, _, _, _, _, skillLine = GetProfessionInfo(firstaid);
      if name then professions[6] = name end
    end

    for skillIndex in pairs(professions) do
      skillName = professions[skillIndex] --- ggg zzz
      if (skillName == REP_TXT.skillHerb) then
        REP_Herb = true
      elseif (skillName == REP_TXT.skillSkin) then
        REP_Skin = true
      elseif (skillName == REP_TXT.skillMine) then
        REP_Mine = true
      elseif (skillName == REP_TXT.skillAlch) then
        REP_Alche = true
      elseif (skillName == REP_TXT.skillBlack) then
        REP_Black = true
      elseif (skillName == REP_TXT.skillEnch) then
        REP_Enchan = true
      elseif (skillName == REP_TXT.skillEngi) then
        REP_Engin = true
      elseif (skillName == REP_TXT.skillIncrip) then
        REP_Incrip = true
      elseif (skillName == REP_TXT.skillJewel) then
        REP_Jewel = true
      elseif (skillName == REP_TXT.skillLeath) then
        REP_Leath = true
      elseif (skillName == REP_TXT.skillTail) then
        REP_Tailor = true
      elseif (skillName == REP_TXT.skillAid) then
        REP_Aid = true
      elseif (skillName == REP_TXT.skillArch) then
        REP_Arch = true
      elseif (skillName == REP_TXT.skillCook) then
        REP_Cook = true
      elseif (skillName == REP_TXT.skillFish) then
        REP_Fish = true
      end
    end
  else
    for i = 1, GetNumSkillLines() do
      local skillName = GetSkillLineInfo(i)

      if (skillName == REP_TXT.skillAlch) then
        REP_Alche = true
      end

      if (skillName == REP_TXT.skillBlack) then
        REP_Black = true
      end

      if (skillName == REP_TXT.skillEnch) then
        REP_Enchan = true
      end

      if (skillName == REP_TXT.skillEngi) then
        REP_Engin = true
      end

      if (skillName == REP_TXT.skillHerb) then
        REP_Herb = true
      end

      if (skillName == REP_TXT.skillLeath) then
        REP_Leath = true
      end

      if (skillName == REP_TXT.skillMine) then
        REP_Mine = true
      end

      if (skillName == REP_TXT.skillSkin) then
        REP_Skin = true
      end

      if (skillName == REP_TXT.skillTail) then
        REP_Tailor = true
      end

      if (skillName == REP_TXT.skillCook) then
        REP_Cook = true
      end

      if (skillName == REP_TXT.skillAid) then
        REP_Aid = true
      end

      if (skillName == REP_TXT.skillFish) then
        REP_Fish = true
      end
    end
  end

  --REP:Printtest(prof1, prof2, archaeology)
  --REP:Printtest(fishing, cooking, firstaid)
  --REP:Printtest("skillHerb",REP_TXT.skillHerb,REP_Herb)
  --REP:Printtest("skillHerb",REP_TXT.skillMine,REP_Mine)
  --REP:Printtest("skillHerb",REP_TXT.skillSkin,REP_Skin)
  --REP:Printtest("skillHerb",REP_TXT.skillAlch,REP_Alche)
  --REP:Printtest("skillHerb",REP_TXT.skillBlack,REP_Black)
  --REP:Printtest("skillHerb",REP_TXT.skillEnch,REP_Enchan)
  --REP:Printtest("skillHerb",REP_TXT.skillEngi,REP_Engin)
  --REP:Printtest("skillHerb",REP_TXT.skillIncrip,REP_Incrip)
  --REP:Printtest("skillHerb",REP_TXT.skillJewel,REP_Jewel)
  --REP:Printtest("skillHerb",REP_TXT.skillLeath,REP_Leath)
  --REP:Printtest("skillHerb",REP_TXT.skillAid,REP_Aid)
  --REP:Printtest("skillHerb",REP_TXT.skillArch,REP_Arch)
  --REP:Printtest("skillHerb",REP_TXT.skillCook,REP_Cook)
  --REP:Printtest("skillHerb",REP_TXT.skillFish,REP_Fish)
end

--------------------------
-- _18_ classic options
--------------------------
function REP_OnShowOptionFrame()
  local expansionIndex = REP_Data.Global.ExpansionIndex;

  REP_EnableMissingBox:SetChecked(REP_Data.Global.ShowMissing)
  REP_ExtendDetailsBox:SetChecked(REP_Data.Global.ExtendDetails)
  REP_GainToChatBox:SetChecked(REP_Data.Global.WriteChatMessage)
  REP_ShowPreviewRepBox:SetChecked(REP_Data.Global.ShowPreviewRep)
  REP_SwitchFactionBarBox:SetChecked(REP_Data.Global.SwitchFactionBar)
  REP_SilentSwitchBox:SetChecked(REP_Data.Global.SilentSwitch)
  REP_OrderByStandingCheckBox:SetChecked(REP_Data.Global.SortByStanding)

  if (expansionIndex > 2) then
    REP_NoGuildGainBox:SetChecked(REP_Data.Global.NoGuildGain)
    REP_NoGuildSwitchBox:SetChecked(REP_Data.Global.NoGuildSwitch)
    REP_EnableParagonBarBox:SetChecked(REP_Data.Global.ShowParagonBar)
  end
end

--------------------------
-- _19_ interface options
--------------------------
function REP_OnLoadOptions(panel)
  local expansionIndex = REP_Data.Global.ExpansionIndex;

  if (not expansionIndex) then expansionIndex = GetExpansionLevel(); end

  panel.name = REP_NAME
  panel.okay = REP_OptionsOk
  panel.cancel = REP_OptionsCancel
  panel.default = REP_OptionsDefault

  InterfaceOptions_AddCategory(panel);

  REP_OptionEnableMissingCBText:SetText(REP_TXT.showMissing)
  REP_OptionExtendDetailsCBText:SetText(REP_TXT.extendDetails)
  REP_OptionGainToChatCBText:SetText(REP_TXT.gainToChat)
  REP_OptionShowPreviewRepCBText:SetText(REP_TXT.showPreviewRep)
  REP_OptionSwitchFactionBarCBText:SetText(REP_TXT.switchFactionBar)
  REP_OptionSilentSwitchCBText:SetText(REP_TXT.silentSwitch)

  if (expansionIndex > 2) then
    REP_OptionNoGuildSwitchCBText:SetText(REP_TXT.noGuildSwitch)
    REP_OptionNoGuildGainCBText:SetText(REP_TXT.noGuildGain)
    REP_OptionEnableParagonBarCBText:SetText(REP_TXT.EnableParagonBar)
  end
end

------------------------------------------------------------
function REP_OnShowOptions(self)
  if (REP_Data and REP_VarsLoaded) then
    local expansionIndex = REP_Data.Global.ExpansionIndex;

    REP_OptionsShown = true
    REP_OptionEnableMissingCB:SetChecked(REP_Data.Global.ShowMissing)
    REP_OptionExtendDetailsCB:SetChecked(REP_Data.Global.ExtendDetails)
    REP_OptionGainToChatCB:SetChecked(REP_Data.Global.WriteChatMessage)
    REP_OptionShowPreviewRepCB:SetChecked(REP_Data.Global.ShowPreviewRep)
    REP_OptionSwitchFactionBarCB:SetChecked(REP_Data.Global.SwitchFactionBar)
    REP_OptionSilentSwitchCB:SetChecked(REP_Data.Global.SilentSwitch)

    if (expansionIndex > 2) then
      REP_OptionNoGuildGainCB:SetChecked(REP_Data.Global.NoGuildGain)
      REP_OptionNoGuildSwitchCB:SetChecked(REP_Data.Global.NoGuildSwitch)
      REP_OptionEnableParagonBarCB:SetChecked(REP_Data.Global.ShowParagonBar)
    end
  end
end

------------------------------------------------------------
function REP_OptionsOk()
  if (REP_OptionsShown) then
    local expansionIndex = REP_Data.Global.ExpansionIndex;

    REP_Data.Global.ShowMissing = REP_OptionEnableMissingCB:GetChecked()
    REP_Data.Global.ExtendDetails = REP_OptionExtendDetailsCB:GetChecked()
    REP_Data.Global.WriteChatMessage = REP_OptionGainToChatCB:GetChecked()
    REP_Data.Global.ShowPreviewRep = REP_OptionShowPreviewRepCB:GetChecked()
    REP_Data.Global.SwitchFactionBar = REP_OptionSwitchFactionBarCB:GetChecked()
    REP_Data.Global.SilentSwitch = REP_OptionSilentSwitchCB:GetChecked()

    if (expansionIndex > 2) then
      REP_Data.Global.NoGuildGain = REP_OptionNoGuildGainCB:GetChecked()
      REP_Data.Global.NoGuildSwitch = REP_OptionNoGuildSwitchCB:GetChecked()
      REP_Data.Global.ShowParagonBar = REP_OptionEnableParagonBarCB:GetChecked()
    end

    ReputationFrame_Update()
  end

  REP_OptionsShown = nil
end

------------------------------------------------------------
function REP_OptionsCancel()
  -- nothing to do
  REP_OptionsShown = nil
end

------------------------------------------------------------
function REP_OptionsDefault()
  -- nothing to do
end

function REP_GetFriendFactionRemaining(factionID, factionStandingtext, barMax, barValue)
  local _, friendRep, friendMaxRep, _, _, _, _, _, _ = GetFriendshipReputation(factionID);
  local bodyguards = {1738, 1740, 1733, 1741, 1737, 1736, 1739}

  -- WoD bodyguards are capped at 20k reputation but GetFriendshipReputation still returns 42k reputation as maximum so we need to check for that and set max to 20k
  if tContains(bodyguards, factionID) then
    friendMaxRep = 20000
  end

  return friendMaxRep - friendRep;
end

function REP_GetFriendFactionStandingLabel(factionID, nextFriendThreshold)
  -- Add localization
  local REP_BFFLabels = {}
  REP_BFFLabels[0] = {}
  REP_BFFLabels[0][8400] = "Acquaintance"
  REP_BFFLabels[0][16800] = "Buddy"
  REP_BFFLabels[0][25200] = "Friend"
  REP_BFFLabels[0][33600] = "Good Friend"
  REP_BFFLabels[0][42000] = "Best Friend"

  -- Corbyn
  REP_BFFLabels[2100] = {}
  REP_BFFLabels[2100][8400] = "Curiosity"
  REP_BFFLabels[2100][16800] = "Non-Threat"
  REP_BFFLabels[2100][25200] = "Friend"
  REP_BFFLabels[2100][33600] = "Helpful Friend"
  REP_BFFLabels[2100][42000] = "Best Friend"

  -- Nat Pagle
  REP_BFFLabels[1358] = {}
  REP_BFFLabels[1358][8400] = "Pal"
  REP_BFFLabels[1358][16800] = "Buddy"
  REP_BFFLabels[1358][25200] = "Friend"
  REP_BFFLabels[1358][33600] = "Good Friend"
  REP_BFFLabels[1358][42000] = "Best Friend"

  if REP_BFFLabels[factionID] ~= nil then
    return REP_BFFLabels[factionID][nextFriendThreshold]
  else
    if REP_BFFLabels[0][nextFriendThreshold] ~= nil then
      return REP_BFFLabels[0][nextFriendThreshold]
    else
      return ""
    end
  end
end

--------------------------
-- _20_ rep Main window
--------------------------
function REP:SortByStandingWithoutFactionHeader(i, expansionIndex, factionIndex, factionRow, factionBar, factionBarPreview, factionTitle, factionButton, factionStanding, factionAtWarIndicator, factionBackground)
  local OBS_fi = REP_Entries[factionIndex]
  local OBS_fi_i = OBS_fi.i

  if (OBS_fi.header) then
    REP_ReputationFrame_SetRowType(factionRow, isChild, OBS_fi.header, hasRep, expansionIndex);

    -- display the standingID as Header
    if (OBS_fi_i == 9) then
      factionTitle:SetText("Paragon".." ("..tostring(OBS_fi.size)..")");
    elseif (OBS_fi_i == 8) then
      factionTitle:SetText(GetText("FACTION_STANDING_LABEL"..OBS_fi_i, gender).." ("..tostring(OBS_fi.size)..")");
    else
      factionTitle:SetText(GetText("FACTION_STANDING_LABEL"..OBS_fi_i, gender).." -> "..GetText("FACTION_STANDING_LABEL"..OBS_fi_i+1, gender).." ("..tostring(OBS_fi.size)..")");
    end

    if (REP_Collapsed[OBS_fi_i]) then
      factionButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
    else
      factionButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
    end

    factionRow.index = factionIndex
    factionRow.isCollapsed = REP_Collapsed[OBS_fi_i];
  else
    -- get the info for this Faction
    local isParagon
    local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain = GetFactionInfo(OBS_fi_i);
    local colorIndex, isCappedFriendship, factionStandingtext  = REP_Friend_Detail(factionID, standingID, factionRow);

    factionTitle:SetText(name);

    -- Normalize Values
    local origBarValue = barValue

    if (factionID and C_Reputation.IsFactionParagon(factionID)) then
      if IsAddOnLoaded("ParagonReputation") then
        -- REP:Print("Paragon repution addon loaded throgh Repution Guide")
      end

      isParagon = true
      local paragonFrame = ReputationFrame.paragonFramesPool:Acquire();
      paragonFrame.factionID = factionID;
      paragonFrame:SetPoint("RIGHT", factionRow, 11, 0);
      local currentValue, threshold, rewardQuestID, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID);
      origBarValue = mod(currentValue, threshold);
      C_Reputation.RequestFactionParagonPreloadRewardData(factionID);
      paragonFrame.Glow:SetShown(hasRewardPending);
      paragonFrame.Check:SetShown(hasRewardPending);
      paragonFrame:Show();
    end

    local isCapped;
    if (standingID == MAX_REPUTATION_REACTION) then
      isCapped = true;
    end

    -- If exalted show a full green bar
    if(standingID == 8 or isCappedFriendship) then
      barMin, barMax, barValue = 0, 1, 1;
    end

    -- Set reputation bar to paragon values if user option is activated and faction is at paragon rep
    if(factionID and C_Reputation.IsFactionParagon(factionID) and REP_Data.Global.ShowParagonBar) then
      local currentValue, threshold, rewardQuestID, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID);
      barMin, barMax, barValue = 0, threshold, mod(currentValue, threshold);
    end

    barMax = barMax - barMin;
    barValue = barValue - barMin;
    barMin = 0;

    if(factionID and C_Reputation.IsFactionParagon(factionID) and REP_Data.Global.ShowParagonBar and REP_Data.Global.ShowMissing ~= true) then
      factionRow.rolloverText = HIGHLIGHT_FONT_COLOR_CODE.." "..format(REPUTATION_PROGRESS_FORMAT, barValue, barMax)..FONT_COLOR_CODE_CLOSE;
    elseif(isCapped or isCappedFriendship) then
      factionRow.rolloverText = nil;
    elseif(REP_Data.Global.ShowMissing ~= true) then
      factionRow.rolloverText = HIGHLIGHT_FONT_COLOR_CODE.." "..format(tostring(REPUTATION_PROGRESS_FORMAT), barValue, barMax)..FONT_COLOR_CODE_CLOSE;
    else
      factionRow.rolloverText = nil;
    end

    local toExalted = 0
    if (standingID < 8) then
      toExalted = REP_ToExalted[standingID] + barMax - barValue;
    end

    local toBFF = 0
    if (isCappedFriendship ~= true and isFriend) then
      toBFF = REP_GetFriendFactionRemaining(factionID, factionStandingtext, barMax, barValue)
    end

    factionRow.index = OBS_fi_i;

    if (REP_Data.Global.ShowMissing) then
      if ((barMax - barValue) ~= 0 and factionID and C_Reputation.IsFactionParagon(factionID) and REP_Data.Global.ShowParagonBar) then
        factionRow.standingText = "Paragon".." ("..barMax - barValue..")";
      elseif ((barMax - barValue) ~= 0) then
        if(factionStandingtext) then
          factionRow.standingText = factionStandingtext.." ("..barMax - barValue..")";
        else
          factionRow.standingText = "("..barMax - barValue..")";
        end
      else
        factionRow.standingText = factionStandingtext;
      end
    else
      if(factionID and C_Reputation.IsFactionParagon(factionID) and REP_Data.Global.ShowParagonBar) then
        factionRow.standingText = "Paragon";
      else
        factionRow.standingText = factionStandingtext;
      end
    end

    factionStanding:SetText(factionRow.standingText);

    if (isCappedFriendship) then
      factionRow.tooltip = nil;
    else
      factionRow.tooltip = HIGHLIGHT_FONT_COLOR_CODE.." "..barValue.." / "..barMax..FONT_COLOR_CODE_CLOSE;
    end

    factionBar:SetMinMaxValues(0, barMax);
    factionBar:SetValue(barValue);
    local color = FACTION_BAR_COLORS[standingID];
    factionBar:SetStatusBarColor(color.r, color.g, color.b);

    if(expansionIndex > 2) then
      factionBar.BonusIcon:SetShown(hasBonusRepGain);
    end

    local previewValue = 0
    if (REP_Data.Global.ShowPreviewRep) then
      previewValue = REP:GetReadyReputation(OBS_fi_i)
    end

    if ((previewValue > 0) and not ((standingID==8) and (barMax-barValue == 1))) then
      factionBarPreview:Show()
      factionBarPreview:SetMinMaxValues(0, barMax)
      previewValue = previewValue + barValue

      if (previewValue > barMax) then previewValue = barMax end

      factionBarPreview:SetValue(previewValue)
      factionBarPreview:SetID(factionIndex)
      factionBarPreview:SetStatusBarColor(0.8, 0.8, 0.8, 0.5)
    else
      if factionBarPreview then
        factionBarPreview:Hide()
      end
    end

    REP_ReputationFrame_SetRowType(factionRow, isChild, OBS_fi.header, hasRep, expansionIndex);
    factionRow:Show();

    -- Update details if this is the selected Faction
    if (atWarWith) then
      _G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:Show();
      _G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:Show();
      if factionAtWarIndicator then
        factionAtWarIndicator:Show();
      end
    else
      _G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:Hide();
      _G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:Hide();
      if factionAtWarIndicator then
        factionAtWarIndicator:Hide();
      end
    end

    -- Update details if this is the selected Faction
    if (OBS_fi_i == GetSelectedFaction()) then
      if (ReputationDetailFrame:IsShown()) then
        if (canToggleAtWar) then local flag = 1 end
        REP_ReputationDetailFrame_IsShown(OBS_fi_I,flag,1)
      end

      if (REP_ReputationDetailFrame:IsVisible()) then
        REP:Rep_Detail_Frame(OBS_fi_i,standingID,barValue,barMax,origBarValue,standingID,toExalted,factionStandingtext, toBFF, isParagon, isFriend, isCappedFriendship)

        _G["ReputationBar"..i.."ReputationBarHighlight1"]:Show();
        _G["ReputationBar"..i.."ReputationBarHighlight2"]:Show();
      end
    else
      _G["ReputationBar"..i.."ReputationBarHighlight1"]:Hide();
      _G["ReputationBar"..i.."ReputationBarHighlight2"]:Hide();
    end
  end
end

----------------------------------------------
-- REP:OriginalRepOrderWithoutFactionHeader
----------------------------------------------
function REP:OriginalRepOrderWithoutFactionHeader(i, expansionIndex, factionIndex, factionRow, factionBar, factionBarPreview, factionTitle, factionButton, factionStanding, factionAtWarIndicator, factionBackground)
  -- get the info for this Faction
  local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(factionIndex); -- , factionID, hasBonusRepGain, canBeLFGBonus
  local isParagon

  factionTitle:SetText(name);

  if (isCollapsed) then
    factionButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
  else
    factionButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
  end

  factionRow.index = factionIndex;
  factionRow.isCollapsed = isCollapsed;

  local colorIndex, isCappedFriendship, factionStandingtext, isFriend = REP_Friend_Detail(factionID, standingID, factionRow);
  local origBarValue = barValue

  if expansionIndex > 2 then
    if (factionID and C_Reputation.IsFactionParagon(factionID)) then
      isParagon = true

      local currentValue, threshold, rewardQuestID, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID);
      local paragonFrame = ReputationFrame.paragonFramesPool:Acquire();

      paragonFrame.factionID = factionID;
      paragonFrame:SetPoint("RIGHT", factionRow, 11, 0);

      origBarValue = mod(currentValue, threshold);
      C_Reputation.RequestFactionParagonPreloadRewardData(factionID);
      paragonFrame.Glow:SetShown(hasRewardPending);
      paragonFrame.Check:SetShown(hasRewardPending);
      paragonFrame:Show();
    end
  end

  local isCapped;
  if (standingID == MAX_REPUTATION_REACTION) then
    isCapped = true;
  end

  -- If exalted show a full green bar
  if(standingID == 8 or isCappedFriendship) then
    barMin, barMax, barValue = 0, 1, 1;
  end

  -- Set reputation bar to paragon values if user option is activated and faction is at paragon rep
  if(factionID and C_Reputation.IsFactionParagon(factionID) and REP_Data.Global.ShowParagonBar) then
    local currentValue, threshold, rewardQuestID, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID);
    barMin, barMax, barValue = 0, threshold, mod(currentValue, threshold);
  end

  -- Normalize Values
  barMax = barMax - barMin;
  barValue = barValue - barMin;
  barMin = 0;

  if(factionID and C_Reputation.IsFactionParagon(factionID) and REP_Data.Global.ShowParagonBar and REP_Data.Global.ShowMissing ~= true) then
    factionRow.rolloverText = HIGHLIGHT_FONT_COLOR_CODE.." "..format(REPUTATION_PROGRESS_FORMAT, barValue, barMax)..FONT_COLOR_CODE_CLOSE;
  elseif(isCapped or isCappedFriendship) then
    factionRow.rolloverText = nil;
  elseif(REP_Data.Global.ShowMissing ~= true) then
    factionRow.rolloverText = HIGHLIGHT_FONT_COLOR_CODE.." "..format(tostring(REPUTATION_PROGRESS_FORMAT), barValue, barMax)..FONT_COLOR_CODE_CLOSE;
  else
    factionRow.rolloverText = nil;
  end

  local toExalted = 0
  if (standingID < 8) then
    toExalted = REP_ToExalted[standingID] + barMax - barValue;
  end

  local toBFF = 0
  if (isCappedFriendship ~= true and isFriend) then
    toBFF = REP_GetFriendFactionRemaining(factionID, factionStandingtext, barMax, barValue)
  end

  if (REP_Data.Global.ShowMissing) then
    if ((barMax - barValue) ~= 0 and factionID and C_Reputation.IsFactionParagon(factionID) and REP_Data.Global.ShowParagonBar) then
      factionRow.standingText = "Paragon".." ("..barMax - barValue..")";
    elseif ((barMax - barValue) ~= 0) then
      if factionStandingtext then
        factionRow.standingText = factionStandingtext.." ("..barMax - barValue..")";
      else
       factionRow.standingText = "("..barMax - barValue..")";
      end
    else
      factionRow.standingText = factionStandingtext;
    end
  else
    if(factionID and C_Reputation.IsFactionParagon(factionID) and REP_Data.Global.ShowParagonBar) then
      factionRow.standingText = "Paragon";
    else
      factionRow.standingText = factionStandingtext;
    end
  end

  factionStanding:SetText(factionRow.standingText);

  if (isCappedFriendship) then
    factionRow.tooltip = nil;
  else
    factionRow.tooltip = HIGHLIGHT_FONT_COLOR_CODE.." "..barValue.." / "..barMax..FONT_COLOR_CODE_CLOSE;
  end

  REP_ReputationFrame_SetRowType(factionRow, isChild, isHeader, hasRep, expansionIndex);
  factionRow:Show();

  if colorIndex ~= standingID then
    if ((colorIndex == nil or colorIndex == 0) and standingID) then
      colorIndex = standingID;
    else
      colorIndex = 0;
    end
  end

  factionBar:SetMinMaxValues(0, barMax);
  factionBar:SetValue(barValue);
  local color = FACTION_BAR_COLORS[colorIndex];
  factionBar:SetStatusBarColor(color.r, color.g, color.b);

  if(expansionIndex > 2) then
    factionBar.BonusIcon:SetShown(hasBonusRepGain);
  end

  local previewValue = 0
  if (REP_Data.Global.ShowPreviewRep) then
    previewValue = REP:GetReadyReputation(factionIndex)
  end

  if ((previewValue > 0) and not ((standingID == 8) and (barMax - barValue == 1))) then
    factionBarPreview:Show()
    factionBarPreview:SetMinMaxValues(0, barMax)
    previewValue = previewValue + barValue

    if (previewValue > barMax) then previewValue = barMax end

    factionBarPreview:SetValue(previewValue)
    factionBarPreview:SetID(factionIndex)
    factionBarPreview:SetStatusBarColor(0.8, 0.8, 0.8, 0.5)
  else
    -- factionBarPreview:Hide()
  end

  -- Update details if this is the selected Faction
  if (atWarWith) then
    _G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:Show();
    _G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:Show();
    if factionAtWarIndicator then
      factionAtWarIndicator:Show();
    end
  else
    _G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:Hide();
    _G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:Hide();
    if factionAtWarIndicator then
      factionAtWarIndicator:Hide();
    end
  end

  if (factionIndex == GetSelectedFaction()) then
    if (ReputationDetailFrame:IsShown()) then
      if (canToggleAtWar and (not isHeader)) then local flag = 1 end
      REP_ReputationDetailFrame_IsShown(factionIndex,flag,2)
    end

    if (REP_ReputationDetailFrame:IsVisible()) then
      REP:Rep_Detail_Frame(factionIndex, colorIndex, barValue, barMax, origBarValue, standingID, toExalted, factionStandingtext, toBFF, isParagon, isFriend, isCappedFriendship)
      _G["ReputationBar"..i.."ReputationBarHighlight1"]:Show();
      _G["ReputationBar"..i.."ReputationBarHighlight2"]:Show();
    end
  else
    _G["ReputationBar"..i.."ReputationBarHighlight1"]:Hide();
    _G["ReputationBar"..i.."ReputationBarHighlight2"]:Hide();
  end
end
----------------------------------------------
-- REP:SortByStandingWithFactionHeader
----------------------------------------------
function REP:SortByStandingWithFactionHeader(i, expansionIndex, factionIndex, factionBar, factionHeader, factionCheck, factionTitle, factionStanding, factionAtWarIndicator, factionRightBarTexture)
  local OBS_fi = REP_Entries[factionIndex]
  local OBS_fi_i = OBS_fi.i

  local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(OBS_fi_i);
  local origBarValue = barValue
  local toExalted

  if (OBS_fi.header) then
    if (OBS_fi_i == 8) then
      factionHeader.Text:SetText(GetText("FACTION_STANDING_LABEL"..OBS_fi_i, gender).." ("..tostring(OBS_fi.size)..")")
    else
      factionHeader.Text:SetText(GetText("FACTION_STANDING_LABEL"..OBS_fi_i, gender).." -> "..GetText("FACTION_STANDING_LABEL"..OBS_fi_i+1, gender).." ("..tostring(OBS_fi.size)..")")
    end

    if (REP_Collapsed[OBS_fi_i]) then
      factionHeader:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
    else
      factionHeader:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
    end

    factionHeader.index = factionIndex;
    factionHeader.isCollapsed = REP_Collapsed[OBS_fi_i];

    factionBar:Hide()
    factionHeader:Show()
    factionCheck:Hide()
  else
    factionStandingText = GetText("FACTION_STANDING_LABEL"..standingID, gender)
    factionStanding:SetText(factionStandingText)
    factionTitle:SetText(name)

    if (atWarWith) then
      if factionAtWarIndicator then
        factionAtWarIndicator:Show();
      end
    else
      if factionAtWarIndicator then
        factionAtWarIndicator:Hide();
      end
    end

    barMax = barMax - barMin
    barValue = barValue - barMin
    barMin = 0

    if (standingID < 8) then
      toExalted = REP_ToExalted[standingID] + barMax - barValue
    end

    factionBar.index = OBS_fi_i
    factionBar.standingText = factionStandingText
    factionBar.tooltip  = HIGHLIGHT_FONT_COLOR_CODE.." "..barValue.." / "..barMax..FONT_COLOR_CODE_CLOSE
    factionBar:SetMinMaxValues(0, barMax)
    factionBar:SetValue(barValue)
    color = FACTION_BAR_COLORS[standingID]
    factionBar:SetStatusBarColor(color.r, color.g, color.b)
    factionBar:SetID(factionIndex)
    factionBar:Show()
    factionHeader:Hide()

    if (REP_Data.Global.ShowMissing) then
      if (barMax - barValue ~= 0) then
        factionStanding:SetText(factionStandingText .. " ("..barMax - barValue..")")
        factionBar.standingText = factionStandingText .. " ("..barMax - barValue..")"
        factionBar.tooltip = nil
      end
    end

    if (hasRep) or (not isHeader) then
      factionBar.hasRep = true
    else
      factionBar.hasRep = false
    end

    if (isWatched) then
      factionCheck:Show()
      factionTitle:SetWidth(100)
      factionCheck:SetPoint("LEFT", factionTitle, "LEFT", factionTitle:GetStringWidth(), 0)
    else
      factionCheck:Hide()
      factionTitle:SetWidth(110)
    end

    if (OBS_fi_i == GetSelectedFaction()) then
      if (ReputationDetailFrame:IsShown()) then
        ReputationDetailfactionTitle:SetText(name);
        ReputationDetailFactionDescription:SetText(description);

        if (atWarWith) then
          ReputationDetailAtWarCheckBox:SetChecked(1);
        else
          ReputationDetailAtWarCheckBox:SetChecked(nil);
        end

        if (canToggleAtWar) then
          ReputationDetailAtWarCheckBox:Enable();
          ReputationDetailAtWarCheckBoxText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
          REP_ReputationDetailFrame_IsShown(OBS_fi_i, 1, 1)
        else
          ReputationDetailAtWarCheckBox:Disable();
          ReputationDetailAtWarCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
        end

        if (IsFactionInactive(factionIndex)) then
          ReputationDetailInactiveCheckBox:SetChecked(1);
        else
          ReputationDetailInactiveCheckBox:SetChecked(nil);
        end

        if (isWatched) then
          ReputationDetailMainScreenCheckBox:SetChecked(1);
        else
          ReputationDetailMainScreenCheckBox:SetChecked(nil);
        end
      end

      if (REP_ReputationDetailFrame:IsVisible()) then
        REP:Rep_Detail_Frame(OBS_fi_i,standingID,barValue,barMax,origBarValue,standingID,toExalted,factionStandingText)
      end

      _G["ReputationBar"..i.."Highlight1"]:Show();
      _G["ReputationBar"..i.."Highlight2"]:Show();
    else
      _G["ReputationBar"..i.."Highlight1"]:Hide();
      _G["ReputationBar"..i.."Highlight2"]:Hide();
    end
  end
end

----------------------------------------------
-- REP:OriginalRepOrderWithFactionHeader
----------------------------------------------
function REP:OriginalRepOrderWithFactionHeader(i, expansionIndex, factionIndex, factionBar, factionHeader, factionCheck, factionTitle, factionStanding, factionAtWarIndicator, factionRightBarTexture)
  -- get the info for this Faction
  local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(factionIndex);
  local origBarValue = barValue
  local toExalted

  if (isHeader) then
    factionHeader.Text:SetText(name)

    if (isCollapsed) then
      factionHeader:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
    else
      factionHeader:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
    end

    factionHeader.index = factionIndex;
    factionHeader.isCollapsed = isCollapsed;

    factionBar:Hide()
    factionHeader:Show()
    factionCheck:Hide()
  else
    factionStandingText = GetText("FACTION_STANDING_LABEL"..standingID, gender)
    factionStanding:SetText(factionStandingText)
    factionTitle:SetText(name)

    if (atWarWith) then
      if factionAtWarIndicator then
        factionAtWarIndicator:Show();
      end
    else
      if factionAtWarIndicator then
        factionAtWarIndicator:Hide();
      end
    end

    barMax = barMax - barMin
    barValue = barValue - barMin
    barMin = 0

    if (standingID < 8) then
      toExalted = REP_ToExalted[standingID] + barMax - barValue
    end

    factionBar.index = factionIndex
    factionBar.standingText = factionStandingText
    factionBar.tooltip  = HIGHLIGHT_FONT_COLOR_CODE.." "..barValue.." / "..barMax..FONT_COLOR_CODE_CLOSE
    factionBar:SetMinMaxValues(0, barMax)
    factionBar:SetValue(barValue)
    color = FACTION_BAR_COLORS[standingID]
    factionBar:SetStatusBarColor(color.r, color.g, color.b)
    factionBar:SetID(factionIndex)
    factionBar:Show()
    factionHeader:Hide()

    if (REP_Data.Global.ShowMissing) then
      if (barMax - barValue ~= 0) then
        factionStanding:SetText(factionStandingText .. " ("..barMax - barValue..")")
        factionBar.standingText = factionStandingText .. " ("..barMax - barValue..")"
        factionBar.tooltip = nil
      end
    end

    if (hasRep) or (not isHeader) then
      factionBar.hasRep = true
    else
      factionBar.hasRep = false
    end

    if (isWatched) then
      factionCheck:Show()
      factionTitle:SetWidth(100)
      factionCheck:SetPoint("LEFT", factionTitle, "LEFT", factionTitle:GetStringWidth(), 0)
    else
      factionCheck:Hide()
      factionTitle:SetWidth(110)
    end

    if (factionIndex == GetSelectedFaction()) then
      if (ReputationDetailFrame:IsShown()) then
        ReputationDetailFactionName:SetText(name);
        ReputationDetailFactionDescription:SetText(description);

        if (atWarWith) then
          ReputationDetailAtWarCheckBox:SetChecked(1);
        else
          ReputationDetailAtWarCheckBox:SetChecked(nil);
        end

        if (canToggleAtWar) then
          ReputationDetailAtWarCheckBox:Enable();
          ReputationDetailAtWarCheckBoxText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
          REP_ReputationDetailFrame_IsShown(factionIndex, 1, 2)
        else
          ReputationDetailAtWarCheckBox:Disable();
          ReputationDetailAtWarCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
        end

        if (IsFactionInactive(factionIndex)) then
          ReputationDetailInactiveCheckBox:SetChecked(1);
        else
          ReputationDetailInactiveCheckBox:SetChecked(nil);
        end

        if (isWatched) then
          ReputationDetailMainScreenCheckBox:SetChecked(1);
        else
          ReputationDetailMainScreenCheckBox:SetChecked(nil);
        end
      end

      if (REP_ReputationDetailFrame:IsVisible()) then
        REP:Rep_Detail_Frame(factionIndex,standingID,barValue,barMax,origBarValue,standingID,toExalted,factionStandingText)
      end

      _G["ReputationBar"..i.."Highlight1"]:Show();
      _G["ReputationBar"..i.."Highlight2"]:Show();
    else
      _G["ReputationBar"..i.."Highlight1"]:Hide();
      _G["ReputationBar"..i.."Highlight2"]:Hide();
    end
  end
end
