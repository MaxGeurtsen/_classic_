local LUF = select(2, ...)
local L = {
["Changed profile to %s."] = "Changed profile to %s.",
["Cannot find any profiles named \"%s\"."] = "Cannot find any profiles named \"%s\".",
["pettarget"] = "Pet Target",
["pettargettarget"] = "Pet ToT",
["targettarget"] = "ToT",
["targettargettarget"] = "ToToT",
["focustarget"] = "Focus Target",
["focustargettarget"] = "Focus ToT",
["partytarget"] = "Party Target",
["partypet"] = "Party Pet",
["raidpet"] = "Raidpet",
["maintanktarget"] = "Maintanktarget",
["maintanktargettarget"] = "Maintank ToT",
["mainassisttarget"] = "Mainassisttarget",
["mainassisttargettarget"] = "Mainassist ToT",
["arenapet"] = "Arena Pet",
["arenatarget"] = "Arena Target",
["Hide Blizzard"] = "Hide Blizzard",
["Buffs"] = "Buffs",
["Debuffs"] = "Debuffs",
["Hides the default %s frame"] = "Hides the default %s frame",
["Units"] = "Units",
["Enable the %s frame(s)"] = "Enable the %s frame(s)",
["Reset Colors"] = "Reset Colors",
["Gradient Colors"] = "Gradient Colors",
["Reaction Colors"] = "Reaction Colors",
["Status Colors"] = "Status Colors",
["XP Colors"] = "XP Colors",
["Misc Colors"] = "Misc Colors",
["Aura Colors"] = "Aura Colors",
["Removable"] = "Removable",
["Tapped"] = "Tapped",
["Red"] = "Red",
["Green"] = "Green",
["Static"] = "Static",
["Yellow"] = "Yellow",
["Inc Own Heal"] = "Inc Own Heal",
["Inc Hots"] = "Inc Hots",
["Enemy civilian"] = "Enemy civilian",
["Aggro"] = "Aggro",
["Hint"] = "Hint",
["You will need to do a /console reloadui before a hidden frame becomes visible again."] = "You will need to do a /console reloadui before a hidden frame becomes visible again.",
["Health bar"] = "Health bar",
["Portrait"] = "Portrait",
["Show Status"] = "Show Status",
["Show unit status on the portrait with a cooldown animation."] = "Show unit status on the portrait with a cooldown animation.",
["Verbose Status"] = "Verbose Status",
["Show more unit statuses on the portrait."] = "Show more unit statuses on the portrait.",
["Power bar"] = "Power bar",
["Mana Prediction"] = "Mana Prediction",
["Lock"] = "Lock",
["Preview Auras"] = "Preview Auras",
["Show the maximum Auras in preview mode"] = "Show the maximum Auras in preview mode",
["Tooltip in Combat"] = "Tooltip in Combat",
["Show unitframe tooltips in combat"] = "Show unitframe tooltips in combat",
["Bar texture"] = "Bar texture",
["Global Settings"] = "Global Settings",
["Global Unit Settings"] = "Global Unit Settings",
["Auras"] = "Auras",
["Incoming heals"] = "Incoming heals",
["Empty bar"] = "Empty bar",
["Reckoning Stacks"] = "Reckoning Stacks",
["XP/Rep bar"] = "XP/Rep bar",
["Scale"] = "Scale",
["Set the scale of the frame."] = "Set the scale of the frame.",
["Height"] = "Height",
["Set the height of the frame."] = "Set the height of the frame.",
["Width"] = "Width",
["Set the width of the frame."] = "Set the width of the frame.",
["X Position"] = "X Position",
["Y Position"] = "Y Position",
["Set the position of the frame."] = "Set the position of the frame.",
["Anchor To"] = "Anchor To",
["Anchor to another frame."] = "Anchor to another frame.",
["Bars"] = "Bars",
["Stacking"] = "Stacking",
["Direction for stacking"] = "Direction for stacking",
["Horizontal"] = "Horizontal",
["Set the width of the bars."] = "Set the width of the bars.",
["Not a valid number."] = "Not a valid number.",
["Enable or disable the %s."] = "Enable or disable the %s.",
["Background alpha"] = "Background alpha",
["Set the background alpha."] = "Set the background alpha.",
["Color by type"] = "Color by type",
["Color by reaction"] = "Color by reaction",
["Set the height."] = "Set the height.",
["Order"] = "Order",
["Set the order priority."] = "Set the order priority.",
["Health percent"] = "Health percent",
["Never (Disabled)"] = "Never (Disabled)",
["Players only"] = "Players only",
["NPCs and Hostile players"] = "NPCs and Hostile players",
["NPCs only"] = "NPCs only",
["Power Type"] = "Power Type",
["Set the alpha."] = "Set the alpha.",
["Color by class."] = "Color by class.",
["Range"] = "Range",
["Distance"] = "Distance",
["Distance to measure"] = "Distance to measure",
["Inspect distance"] = "Inspect distance",
["Follow distance"] = "Follow distance",
["Spell based"] = "Spell based",
["Is Visible"] = "Is Visible",
["Tags"] = "Tags",
["Size"] = "Size",
["Set the size."] = "Set the size.",
["Limit"] = "Limit",
["The maximum amount to show"] = "The maximum amount to show",
["Set after which percentage of the bar to cut off."] = "Set after which percentage of the bar to cut off.",
["Top right"] = "Top right",
["Right"] = "Right",
["Bottom right"] = "Bottom right",
["Left Center"] = "Left Center",
["Center"] = "Center",
["Right Center"] = "Right Center",
["Top left"] = "Top left",
["Left"] = "Left",
["Bottom left"] = "Bottom left",
["Top"] = "Top",
["Bottom"] = "Bottom",
["Inside"] = "Inside",
["Inside Center"] = "Inside Center",
["Set the tags."] = "Set the tags.",
["Set the font size."] = "Set the font size.",
["Set the height when in bar mode."] = "Set the height when in bar mode.",
["full Before"] = "full Before",
["full After"] = "full After",
["Set the width of the portrait."] = "Set the width of the portrait.",
["Portrait type"] = "Portrait type",
["Alignment"] = "Alignment",
["Portrait alignment"] = "Portrait alignment",
["Bar"] = "Bar",
["Type"] = "Type",
["3D"] = "3D",
["2D"] = "2D",
["2D Class"] = "2D Class",
["Inc Heal Cap"] = "Inc Heal Cap",
["Let the prediction overgrow the bar."] = "Let the prediction overgrow the bar.",
["Filter %s"] = "Filter %s",
["Show only buffs that you or everyone of your class can apply"] = "Show only buffs that you or everyone of your class can apply",
["Show only debuffs that you can dispel or cast"] = "Show only debuffs that you can dispel or cast",
["Set the buffsize."] = "Set the buffsize.",
["Set the debuffsize."] = "Set the debuffsize.",
["Weaponbuffs"] = "Weaponbuffs",
["Bordercolor"] = "Bordercolor",
["Padding"] = "Padding",
["Distance between aura icons."] = "Distance between aura icons.",
["Timers"] = "Timers",
["Limit timers to..."] = "Limit timers to...",
["Position of the %s."] = "Position of the %s.",
["Show stealable"] = "Show stealable",
["Highlight stealable Buffs"] = "Highlight stealable Buffs",
["Bigger buffs"] = "Bigger buffs",
["Bigger buff size"] = "Bigger buff size",
["Bigger debuffs"] = "Bigger debuffs",
["Bigger debuff size"] = "Bigger debuff size",
["Horizontal Limit Side"] = "Horizontal Limit Side",
["Side on which to cut shorter than the frame"] = "Side on which to cut buffs shorter than the frame",
["Horizontal Limit"] = "Horizontal Limit",
["Limit to a percentage of the frame"] = "Limit to a percentage of the frame",
["Own"] = "Own",
["Position"] = "Position",
["Up"] = "Up",
["Down"] = "Down",
["Growth direction"] = "Growth direction",
["The direction in which new frames are added."] = "The direction in which new frames are added.",
["This is set through %s options."] = "This is set through %s options.",
["Hide in raid"] = "Hide in raid",
["Hide while in a raid group."] = "Hide while in a raid group.",
["Never"] = "Never",
["Raid > 5 man"] = "Raid > 5 man",
["Any Raid"] = "Any Raid",
["Sort by"] = "Sort by",
["Sort by name or index"] = "Sort by name or index",
["Index"] = "Index",
["Sort order"] = "Sort order",
["Sort ascending or descending"] = "Sort ascending or descending",
["Ascending"] = "Ascending",
["Descending"] = "Descending",
["Units per column"] = "Units per column",
["The amount of units until a new column is started"] = "The amount of units until a new column is started",
["Max columns"] = "Max columns",
["The maximum amount of columns"] = "The maximum amount of columns",
["Column spacing"] = "Column spacing",
["The space between each column"] = "The space between each column",
["Column Growth direction"] = "Column Growth direction",
["Where a new column is started"] = "Where a new column is started",
["Borders"] = "Borders",
["Highlight the frames borders when the unit is targeted"] = "Highlight the frames borders when the unit is targeted",
["Highlight the frames borders when the unit is moused over"] = "Highlight the frames borders when the unit is moused over",
["Highlight the frames borders when the unit has aggro"] = "Highlight the frames borders when the unit has aggro",
["Highlight the frames borders when the unit has a debuff you or someone can remove"] = "Highlight the frames borders when the unit has a debuff you or someone can remove",
["Highlight"] = "Highlight",
["Mouseover"] = "Mouseover",
["On target"] = "On target",
["On mouseover"] = "On mouseover",
["On aggro"] = "On aggro",
["Highlight the frame when the unit has aggro"] = "Highlight the frame when the unit has aggro",
["On debuff"] = "On debuff",
["Highlight the frame when the unit has a debuff you or someone can remove"] = "Highlight the frame when the unit has a debuff you or someone can remove",
["Your own"] = "Your own",
["Auto hide"] = "Auto hide",
["Hide when inactive"] = "Hide when inactive",
["Cast icon"] = "Cast icon",
["Set the behaviour of the cast icon"] = "Set the behaviour of the cast icon",
["Bars with lower order priority than this will be above."] = "Bars with lower order priority than this will be above.",
["Bars with higher order priority than this will be below."] = "Bars with higher order priority than this will be below.",
["Combat fader"] = "Combat fader",
["Combat alpha"] = "Combat alpha",
["Inactive alpha"] = "Inactive alpha",
["Speedy fade"] = "Speedy fade",
["Druid bar"] = "Druid bar",
["Reckoning stacks"] = "Reckoning stacks",
["Xp bar"] = "Xp bar",
["Combat text"] = "Combat text",
["Font"] = "Font",
["Set the font"] = "Set the font",
["Fontshadow"] = "Fontshadow",
["Display a shadow behind the text"] = "Display a shadow behind the text",
["Fontoutline"] = "Fontoutline",
["Display an outline around the text"] = "Display an outline around the text",
["Aura border"] = "Aura border",
["Light"] = "Light",
["Dark"] = "Dark",
["Black"] = "Black",
["Light thin"] = "Light thin",
["Dark thin"] = "Dark thin",
["Black thin"] = "Black thin",
["Heal prediction timeframe"] = "Heal prediction timeframe",
["Set how long into the future heals are predicted."] = "Set how long into the future heals are predicted.",
["Disable hots"] = "Disable hots",
["Disable hots in heal prediction"] = "Disable hots in heal prediction",
["Disable OmniCC"] = "Disable OmniCC",
["Prevent OmniCC from putting numbers on cooldown animations (Requires UI reload)"] = "Prevent OmniCC from putting numbers on cooldown animations (Requires UI reload)",
["Disable Blizzard cooldown count"] = "Disable Blizzard cooldown count",
["Prevent the default UI from putting numbers on cooldown animations"] = "Prevent the default UI from putting numbers on cooldown animations",
["Mouse interaction"] = "Mouse interaction",
["This enables xp tooltips but disables clicks or vice versa"] = "This enables xp tooltips but disables clicks or vice versa",
["Indicators"] = "Indicators",
["Set the X coordinate."] = "Set the X coordinate.",
["Set the Y coordinate."] = "Set the Y coordinate.",
["Side"] = "Side",
["Elite indicator alignment"] = "Elite indicator alignment",
["Point"] = "Point",
["Anchor point"] = "Anchor point",
["WARNING! This will set ALL bars to this texture."] = "WARNING! This will set ALL bars to this texture.",
["WARNING! This will set ALL texts to this font."] = "WARNING! This will set ALL texts to this font.",
["WARNING! This will set ALL colors back to default."] = "WARNING! This will set ALL colors back to default.",
["afktime"] = "Time this unit has been afk",
["afk"] = "("..AFK..")",
["nameafk"] = "Name or ("..AFK..")",
["rare"] = strupper(strmatch(GARRISON_MISSION_RARE,"%a*")),
["elite"] = ELITE,
["Ticker"] = "Ticker",
["Ticker Background"] = "Ticker Background",
["Since mana/energy regenerate in ticks, show a timer for it"] = "Since mana/energy regenerate in ticks, show a timer for it",
["Autohide ticker"] = "Autohide ticker",
["Hide the ticker when it's not needed"] = "Hide the ticker when it's not needed",
["Five second rule"] = "Five second rule",
["Show a timer for the five second rule"] = "Show a timer for the five second rule",
["Totem bar"] = "Totem bar",
["Enable this group"] = "Enable this group",
["Offset"] = "Offset",
["Set the space between units."] = "Set the space between units.",
["Show when"] = "Show when",
["Show even smaller groups than a raid in the raidframe"] = "Show even smaller groups than a raid in the raidframe",
["Squares"] = "Squares",
["What the indicator should display."] = "What the indicator should display.",
["Name (exact) or ID"] = "Name (exact) or ID",
["Name (partial) or ID"] = "Name (partial) or ID",
["Name (exact) or ID of the effect to track. Use ; as a logical AND and / as logical OR. Also supports [mana] to only check on mana classes. Example: Arcane Intellect[mana]/Arcane Brilliance[mana];Dampen Magic"] = "Name (exact) or ID of the effect to track. Use ; as a logical AND and / as logical OR. Also supports [mana] to only check on mana classes. Example: Arcane Intellect[mana]/Arcane Brilliance[mana];Dampen Magic",
["Name (partial) or ID of the effect to track. Use ; as a seperator for multiple auras"] = "Name (partial) or ID of the effect to track. Use ; as a seperator for multiple auras",
["Buff/Debuff"] = "Buff/Debuff",
["Own buff/debuff"] = "Own buff/debuff",
["Missing Buff"] = "Missing Buff",
["You can only use Spellnames for Spells your Character knows otherwise please use Spell IDs"] = "You can only use Spellnames for Spells your Character knows otherwise please use Spell IDs",
["Timer"] = "Timer",
["Texture"] = "Texture",
["Show the spell texture instead of its type color."] = "Show the spell texture instead of its type color.",
["Groupnumbers"] = "Groupnumbers",
["Show Groupnumbers next to the group"] = "Show Groupnumbers next to the group",
["Groupnumberfont"] = "Groupnumberfont",
["Set the size of the group number."] = "Set the size of the group number.",
["Group by"] = "Group by",
["Group by class or group"] = "Group by class or group",
["Tag Help"] = "Tag Help",
["Tags - Help"] = "Tags - Help",
["You can use tags to change the text information displayed on each frame. Just go to the tag section of the frame you want to change and put in some tags."] = "You can use tags to change the text information displayed on each frame. Just go to the tag section of the frame you want to change and put in some tags.",
["Auto Profiles"] = "Auto Profiles",
["Auto Profiles - Help"] = "Auto Profiles - Help",
["You can set up here which profiles should be automatically loaded on certain conditions."] = "You can set up here which profiles should be automatically loaded on certain conditions.",
["Switch by"] = "Switch by",
["Type of event to switch to"] = "Type of event to switch to",
["Screen Resolution"] = "Screen Resolution",
["Resolution to assign a profile to"] = "Resolution to assign a profile to",
["Size of Group"] = "Size of Group",
["Size of group to assign a profile to"] = "Size of group to assign a profile to",
["Raid40"] = "Raid40",
["Raid25"] = "Raid25",
["Raid20"] = "Raid20",
["Raid15"] = "Raid15",
["Raid10"] = "Raid10",
["Raid5"] = "Raid5",
["Solo"] = "Solo",
["Profile"] = "Profile",
["Name of the profile which to switch to"] = "Name of the profile which to switch to",
["Profiles"] = "Profiles",
["Show player"] = "Show player",
["Show player in the party frame."] = "Show player in the party frame.",
["Show solo"] = "Show solo",
["Show player in the party frame when solo."] = "Show player in the party frame when solo.",
["Vertical"] = "Vertical",
["Set the bar vertical."] = "Set the bar vertical.",
["Bar Group"] = "Bar Group",
["Left Group"] = "Left Group",
["Right Group"] = "Right Group",
["Center Group"] = "Center Group",
["Select the bar stack"] = "Select the bar stack",
["Invert"] = "Invert",
["Kind of inverts the color scheme."] = "Kind of inverts the color scheme.",
["numtargeting"] = "Number of people in your group targeting this unit",
["cnumtargeting"] = "Colored version of numtargeting",
["enumtargeting"] = "Guessed amount of enemies targeting this unit (PvP only)",
["br"] = "Adds a line break",
["name"] = "Returns plain name of the unit",
["shortname:x"] = "Returns the first x letters of the name (1-12)",
["abbrev:name"] = "Returns shortened names (Marshall Williams = M. Williams)",
["guild"] = "Guildname",
["guildrank"] = "Guildrank",
["level"] = "Current level, returns ?? for bosses and players too high",
["smartlevel"] = "Returns \"Boss\" for bosses and Level+10+ for players too high",
["class"] = "Class of the unit",
["smartclass"] = "Returns Class for players and Creaturetype for NPCs",
["raredesc"] = "\"rare\" if the creature is rare or rareelite",
["elitedesc"] = "\"elite\" if the creature is elite or rareelite",
["classification"] = "Shows elite, rare, boss, etc...",
["shortclassification"] = "\"E\", \"R\", \"RE\" for the respective classification",
["race"] = "Race if available",
["smartrace"] = "Shows race if player, creaturetype when npc",
["creature"] = "Creature type (Bat, Wolf , etc..)",
["sex"] = "One of the two genders", -- :D
["druidform"] = "Current druid form of friendly unit",
["civilian"] = "Returns '("..DISHONORABLE_KILLS..")' when civilian",
["pvp"] = "Displays '"..PVP.."' if flagged for it",
["rank"] = "PvP title",
["numrank"] = "Numeric PvP rank",
["faction"] = "Horde or Alliance",
["ignore"] = "Returns '"..IGNORED.."' if the player is on your ignore list",
["server"] = "Server name",
["status"] = "\"Dead\", \"Ghost\" or \"Offline\"",
["happiness"] = "Pet happiness as 'unhappy','content' or 'happy'",
["group"] = "Current subgroup of the raid",
["combat"] = "("..COMBAT..") when in combat",
["loyalty"] = "Loyalty level of your pet",
["buffcount"] = "Number of positive effects on a unit",
["range"] = "Range to this unit",
["namehealerhealth"] = "The same as \"healerhealth\" but displays name on full health",
["healerhealth"] = "Returns the same as \"smart:healmishp\" on friendly units and hp/maxhp on enemies",
["smart:healmishp"] = "Returns missing hp with healing factored in. Shows status when needed (\"Dead\", \"Offline\", \"Ghost\")",
["cpoints"] = "Combo Points",
["smarthealth"] = "The classic hp display (hp/maxhp and \"Dead\" if dead etc)",
["smarthealthp"] = "Like [smarthealth] but with a permanent percentage",
["ssmarthealth"] = "Like [smarthealth] but shortened when over 10K",
["ssmarthealthp"] = "Like [smarthealthp] but shortened when over 10K",
["healhp"] = "Current hp and heal in one number (green when heal is incoming)",
["hp"] = "Current hp",
["shp"] = "Current hp shortened when over 10K",
["sshp"] = "Like [ssmarthealth] but without maximum hp",
["maxhp"] = "Current maximum hp",
["smaxhp"] = "Current maximum hp shortened when over 10K",
["missinghp"] = "Current missing hp",
["healmishp"] = "Missing hp after incoming heal (green when heal is incoming)",
["perhp"] = "HP percent",
["perstatus"] = "Like [smarthealth] but only percentages for hp",
["pp"] = "Current mana/rage/energy etc",
["spp"] = "Current mana/rage/energy etc shortened when over 10K",
["maxpp"] = "Maximum mana/rage/energy etc",
["smaxpp"] = "Maximum mana/rage/energy etc shortened when over 10K",
["missingpp"] = "Missing mana/rage/energy",
["perpp"] = "Mana/rage/energy percent",
["druid:pp"] = "Returns current mana even in druid form",
["druid:maxpp"] = "Returns current maximum mana even in druid form",
["druid:missingpp"] = "Returns missing mana even in druid form",
["druid:perpp"] = "Returns mana percentage even in druid form",
["incheal"] = "Value of incoming heal",
["numheals"] = "Number of incoming heals",
["incownheal"] = "Your direct incoming heals",
["incpreheal"] = "Direct heal landing before yours",
["incafterheal"] = "Direct heal landing after yours, defaults to all direct heal when yours is zero",
["hotheal"] = "The amount that the active hots will heal in the timeframe you set up",
["effheal"] = "Effective direct healing",
["overheal"] = "Direct healing that goes over the current hp",
["combatcolor"] = "Red when in combat",
["pvpcolor"] = "White for unflagged units, green for flagged friendlies and red for flagged enemies",
["reactcolor"] = "Red for enemies, yellow for neutrals, and green for friendlies",
["levelcolor"] = "Colors based on your level vs the level of the unit. (grey,green,yellow and red)",
["threat"] = "Threat in scaled percent",
["aggrocolor"] = "Red if the unit is targeted by an enemy",
["classcolor"] = "Classcolor of the unit",
["healthcolor"] = "Color based on health (red = dead)",
["color:xxxxxx"] = "Custom color in hexadecimal (rrggbb)",
["nocolor"] = "Resets the color to white",
["castname"] = "Name of the unit's current cast",
["casttime"] = "Casttime of the unit's current cast",
["xp"] = "The unit's current xp level",
["xppet"] = "The pet's current xp level",
["percxp"] = "The unit's current xp percentage",
["percxppet"] = "The pet's current xp percentage",
["rep"] = "The players standing with the currently watched faction",
["Info tags"] = "Info tags",
["Health and power tags"] = "Health and power tags",
["Color tags"] = "Color tags",
["Targeting sound"] = "Targeting sound",
["Enable the sound when switching target"] = "Enable the sound when switching target",
["Right click to focus"] = "Right click to focus",
["Focus the unit upon right clicking"] = "Focus the unit upon right clicking",
}

LUF.L = L