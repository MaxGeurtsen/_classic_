
ExtendedCharacterStats = {
	["general"] = {
		["addColorsToStatTexts"] = true,
		["statFontSize"] = 10,
		["statColorSelection"] = "full",
		["profileVersion"] = 10,
		["showQualityColors"] = true,
		["window"] = {
			["height"] = 422,
			["yOffset"] = 30,
			["xOffset"] = -30,
			["width"] = 180,
		},
		["headerFontSize"] = 11,
		["statsWindowClosedOnOpen"] = false,
	},
	["profile"] = {
		["ranged"] = {
			["attackPower"] = {
				["display"] = true,
				["text"] = "ATTACK_POWER",
				["refName"] = "RangeAttackpower",
			},
			["attackSpeed"] = {
				["display"] = true,
				["text"] = "ATTACK_SPEED",
				["refName"] = "RangedAttackSpeed",
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
				["text"] = "HIT",
				["display"] = true,
				["rating"] = {
					["display"] = true,
					["isTbcOnly"] = true,
					["refName"] = "RangedHitRating",
					["text"] = "RATING",
				},
				["refName"] = "RangedHitHeader",
				["bonus"] = {
					["display"] = true,
					["text"] = "BONUS",
					["refName"] = "RangedHitBonus",
				},
			},
			["display"] = false,
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
			["resilience"] = {
				["display"] = true,
				["text"] = "RESILIENCE_VALUE",
				["refName"] = "ResilienceValue",
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
				["text"] = "HIT",
				["display"] = true,
				["rating"] = {
					["display"] = true,
					["isTbcOnly"] = true,
					["refName"] = "SpellHitRating",
					["text"] = "RATING",
				},
				["refName"] = "SpellHitHeader",
				["bonus"] = {
					["display"] = true,
					["text"] = "BONUS",
					["refName"] = "SpellHitBonus",
				},
			},
			["penetration"] = {
				["display"] = true,
				["text"] = "SPELL_PENETRATION",
				["refName"] = "SpellPenetration",
			},
			["display"] = false,
			["text"] = "SPELL",
			["crit"] = {
				["display"] = true,
				["text"] = "CRIT_CHANCE",
				["refName"] = "SpellCritChance",
			},
			["refName"] = "SpellHeader",
		},
		["spellBonus"] = {
			["physicalCrit"] = {
				["display"] = false,
				["text"] = "PHYSICAL_CRIT",
				["refName"] = "PhysicalCritChance",
			},
			["arcaneCrit"] = {
				["display"] = false,
				["text"] = "ARCANCE_CRIT",
				["refName"] = "ArcaneCritChance",
			},
			["natureDmg"] = {
				["display"] = false,
				["text"] = "NATURE_DMG",
				["refName"] = "NatureDmg",
			},
			["holyDmg"] = {
				["display"] = true,
				["text"] = "HOLY_DMG",
				["refName"] = "HolyDmg",
			},
			["frostCrit"] = {
				["display"] = false,
				["text"] = "FROST_CRIT",
				["refName"] = "FrostCritChance",
			},
			["fireDmg"] = {
				["display"] = false,
				["text"] = "FIRE_DMG",
				["refName"] = "FireDmg",
			},
			["bonusHealing"] = {
				["display"] = false,
				["text"] = "HEALING_POWER",
				["refName"] = "BonusHealing",
			},
			["fireCrit"] = {
				["display"] = false,
				["text"] = "FIRE_CRIT",
				["refName"] = "FireCritChance",
			},
			["shadowDmg"] = {
				["display"] = false,
				["text"] = "SHADOW_DMG",
				["refName"] = "ShadowDmg",
			},
			["frostDmg"] = {
				["display"] = false,
				["text"] = "FROST_DMG",
				["refName"] = "FrostDmg",
			},
			["text"] = "SPELL_POWER",
			["holyCrit"] = {
				["display"] = false,
				["text"] = "HOLY_CRIT",
				["refName"] = "HolyCritChance",
			},
			["physicalDmg"] = {
				["display"] = false,
				["text"] = "PHYSICAL_DMG",
				["refName"] = "PhysicalDmg",
			},
			["shadowCrit"] = {
				["display"] = false,
				["text"] = "SHADOW_CRIT",
				["refName"] = "ShadowCritChance",
			},
			["display"] = true,
			["arcaneDmg"] = {
				["display"] = false,
				["text"] = "ARCANCE_DMG",
				["refName"] = "ArcaneDmg",
			},
			["refName"] = "SpellBonusHeader",
			["natureCrit"] = {
				["display"] = false,
				["text"] = "NATURE_CRIT",
				["refName"] = "NatureCritChance",
			},
		},
		["regen"] = {
			["mp5Buffs"] = {
				["display"] = false,
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
			["display"] = false,
			["text"] = "MANA",
			["refName"] = "ManaHeader",
			["mp5Items"] = {
				["display"] = true,
				["text"] = "MP5_ITEMS",
				["refName"] = "MP5Items",
			},
		},
		["melee"] = {
			["attackPower"] = {
				["display"] = true,
				["text"] = "ATTACK_POWER",
				["refName"] = "MeleeAttackPower",
			},
			["expertise"] = {
				["display"] = true,
				["text"] = "EXPERTISE",
				["refName"] = "Expertise",
			},
			["attackSpeed"] = {
				["offHand"] = {
					["display"] = false,
					["text"] = "ATTACK_SPEED_OFF_HAND",
					["refName"] = "MeleeAttackSpeedOffHand",
				},
				["mainHand"] = {
					["display"] = true,
					["text"] = "ATTACK_SPEED_MAIN_HAND",
					["refName"] = "MeleeAttackSpeedMainHand",
				},
				["display"] = true,
				["text"] = "ATTACK_SPEED_HEADER",
				["refName"] = "MeleeAttackSpeedHeader",
				["isSubGroup"] = true,
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
				["text"] = "HIT",
				["display"] = true,
				["rating"] = {
					["display"] = false,
					["isTbcOnly"] = true,
					["refName"] = "MeleeHitRating",
					["text"] = "RATING",
				},
				["refName"] = "MeleeHitHeader",
				["bonus"] = {
					["display"] = false,
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
	},
}
