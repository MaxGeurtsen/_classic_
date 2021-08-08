
ExtendedCharacterStats = {
	["general"] = {
		["addColorsToStatTexts"] = true,
		["statsWindowClosedOnOpen"] = false,
		["statColorSelection"] = "full",
		["headerFontSize"] = 11,
		["showQualityColors"] = true,
		["window"] = {
			["height"] = 422,
			["width"] = 180,
			["xOffset"] = -30,
			["yOffset"] = 30,
		},
		["statFontSize"] = 10,
		["profileVersion"] = 6,
	},
	["profile"] = {
		["ranged"] = {
			["attackPower"] = {
				["display"] = true,
				["text"] = "ATTACK_POWER",
				["refName"] = "RangeAttackpower",
			},
			["hit"] = {
				["bossLevel"] = {
					["display"] = true,
					["text"] = "MISS_BOSS",
					["refName"] = "RangedHitBossLevel",
				},
				["sameLevel"] = {
					["display"] = true,
					["text"] = "MISS",
					["refName"] = "RangedHitSameLevel",
				},
				["isSubGroup"] = true,
				["display"] = true,
				["text"] = "HIT",
				["refName"] = "RangedHitHeader",
				["bonus"] = {
					["display"] = true,
					["text"] = "BONUS",
					["refName"] = "RangedHitBonus",
				},
			},
			["display"] = true,
			["text"] = "RANGED",
			["refName"] = "RangedHeader",
			["crit"] = {
				["display"] = true,
				["text"] = "CRIT_CHANCE",
				["refName"] = "RangedCritChance",
			},
		},
		["defense"] = {
			["defense"] = {
				["display"] = true,
				["text"] = "DEFENSE_VALUE",
				["refName"] = "DefenseValue",
			},
			["blockChance"] = {
				["display"] = true,
				["text"] = "BLOCK_CHANCE",
				["refName"] = "BlockChance",
			},
			["text"] = "DEFENSE",
			["parry"] = {
				["display"] = true,
				["text"] = "PARRY_CHANCE",
				["refName"] = "ParryChance",
			},
			["dodge"] = {
				["display"] = true,
				["text"] = "DODGE_CHANCE",
				["refName"] = "DodgeChance",
			},
			["display"] = true,
			["armor"] = {
				["display"] = true,
				["text"] = "ARMOR",
				["refName"] = "Armor",
			},
			["refName"] = "DefenseHeader",
			["blockValue"] = {
				["display"] = true,
				["text"] = "BLOCK_VALUE",
				["refName"] = "BlockValue",
			},
		},
		["general"] = {
			["display"] = true,
			["text"] = "GENERAL",
			["refName"] = "GeneralHeader",
			["movementSpeed"] = {
				["display"] = true,
				["text"] = "MOVEMENT_SPEED",
				["refName"] = "MovementSpeed",
			},
		},
		["melee"] = {
			["attackPower"] = {
				["display"] = true,
				["text"] = "ATTACK_POWER",
				["refName"] = "MeleeAttackpower",
			},
			["hit"] = {
				["bossLevel"] = {
					["display"] = true,
					["text"] = "MISS_BOSS",
					["refName"] = "MeleeHitBossLevel",
				},
				["sameLevel"] = {
					["display"] = true,
					["text"] = "MISS",
					["refName"] = "MeleeHitSameLevel",
				},
				["isSubGroup"] = true,
				["display"] = true,
				["text"] = "HIT",
				["refName"] = "MeleeHitHeader",
				["bonus"] = {
					["display"] = true,
					["text"] = "BONUS",
					["refName"] = "MeleeHitBonus",
				},
			},
			["display"] = true,
			["text"] = "MELEE",
			["refName"] = "MeleeHeader",
			["crit"] = {
				["display"] = true,
				["text"] = "CRIT_CHANCE",
				["refName"] = "MeleeCritChance",
			},
		},
		["regen"] = {
			["mp5Buffs"] = {
				["display"] = true,
				["text"] = "MP5_BUFFS",
				["refName"] = "MP5Buffs",
			},
			["mp5Spirit"] = {
				["display"] = true,
				["text"] = "MP5_SPIRIT",
				["refName"] = "MP5Spirit",
			},
			["mp5Casting"] = {
				["display"] = true,
				["text"] = "MP5_CASTING",
				["refName"] = "MP5Casting",
			},
			["display"] = true,
			["text"] = "MANA",
			["refName"] = "ManaHeader",
			["mp5Items"] = {
				["display"] = true,
				["text"] = "MP5_ITEMS",
				["refName"] = "MP5Items",
			},
		},
		["spellBonus"] = {
			["physicalCrit"] = {
				["display"] = true,
				["text"] = "PHYSICAL_CRIT",
				["refName"] = "PhysicalCritChance",
			},
			["arcaneCrit"] = {
				["display"] = true,
				["text"] = "ARCANCE_CRIT",
				["refName"] = "ArcaneCritChance",
			},
			["natureDmg"] = {
				["display"] = true,
				["text"] = "NATURE_DMG",
				["refName"] = "NatureDmg",
			},
			["holyDmg"] = {
				["display"] = true,
				["text"] = "HOLY_DMG",
				["refName"] = "HolyDmg",
			},
			["frostCrit"] = {
				["display"] = true,
				["text"] = "FROST_CRIT",
				["refName"] = "FrostCritChance",
			},
			["fireDmg"] = {
				["display"] = true,
				["text"] = "FIRE_DMG",
				["refName"] = "FireDmg",
			},
			["bonusHealing"] = {
				["display"] = true,
				["text"] = "HEALING_POWER",
				["refName"] = "BonusHealing",
			},
			["fireCrit"] = {
				["display"] = true,
				["text"] = "FIRE_CRIT",
				["refName"] = "FireCritChance",
			},
			["shadowDmg"] = {
				["display"] = true,
				["text"] = "SHADOW_DMG",
				["refName"] = "ShadowDmg",
			},
			["frostDmg"] = {
				["display"] = true,
				["text"] = "FROST_DMG",
				["refName"] = "FrostDmg",
			},
			["text"] = "SPELL_POWER",
			["holyCrit"] = {
				["display"] = true,
				["text"] = "HOLY_CRIT",
				["refName"] = "HolyCritChance",
			},
			["physicalDmg"] = {
				["display"] = true,
				["text"] = "PHYSICAL_DMG",
				["refName"] = "PhysicalDmg",
			},
			["shadowCrit"] = {
				["display"] = true,
				["text"] = "SHADOW_CRIT",
				["refName"] = "ShadowCritChance",
			},
			["display"] = true,
			["arcaneDmg"] = {
				["display"] = true,
				["text"] = "ARCANCE_DMG",
				["refName"] = "ArcaneDmg",
			},
			["refName"] = "SpellBonusHeader",
			["natureCrit"] = {
				["display"] = true,
				["text"] = "NATURE_CRIT",
				["refName"] = "NatureCritChance",
			},
		},
		["spell"] = {
			["hit"] = {
				["bossLevel"] = {
					["display"] = true,
					["text"] = "MISS_BOSS",
					["refName"] = "SpellHitBossLevel",
				},
				["sameLevel"] = {
					["display"] = true,
					["text"] = "MISS",
					["refName"] = "SpellHitSameLevel",
				},
				["isSubGroup"] = true,
				["display"] = true,
				["text"] = "HIT",
				["refName"] = "SpellHitHeader",
				["bonus"] = {
					["display"] = true,
					["text"] = "BONUS",
					["refName"] = "SpellHitBonus",
				},
			},
			["display"] = true,
			["text"] = "SPELL",
			["refName"] = "SpellHeader",
			["crit"] = {
				["display"] = true,
				["text"] = "CRIT_CHANCE",
				["refName"] = "SpellCritChance",
			},
		},
	},
}
