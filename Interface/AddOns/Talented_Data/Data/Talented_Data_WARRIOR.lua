if not Talented_Data then return end

Talented_Data.WARRIOR = {
	{
		numtalents = 23,
		talents = {
			{
				info = {
					name = "Improved Heroic Strike",
					ranks = 3,
					column = 1,
					icon = 132282,
					row = 1,
					tips = "Reduces the cost of your Heroic Strike ability by %d rage point%s.",
					tipValues = {{1, ''}, {2, 's'}, {3, 's'}},
				},
			}, -- [1]
			{
				info = {
					name = "Deflection",
					ranks = 5,
					column = 2,
					icon = 132269,
					row = 1,
					tips = "Increases your Parry chance by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
				},
			}, -- [2]
			{
				info = {
					name = "Improved Rend",
					ranks = 3,
					column = 3,
					icon = 132155,
					row = 1,
					tips = "Increases the bleed damage done by your Rend ability by %d%%.",
					tipValues = {{25}, {50}, {75}},
				},
			}, -- [3]
			{
				info = {
					name = "Improved Charge",
					ranks = 2,
					column = 1,
					icon = 132337,
					row = 2,
					tips = "Increases the amount of rage generated by your Charge ability by %d.",
					tipValues = {{3}, {6}},
				},
			}, -- [4]
			{
				info = {
					name = "Iron Will",
					ranks = 5,
					column = 2,
					icon = 135995,
					row = 2,
					tips = "Increases your chance to resist Stun and Charm effects by an additional %d%%.",
					tipValues = {{3}, {6}, {9}, {12}, {15}},
				},
			}, -- [5]
			{
				info = {
					name = "Improved Thunder Clap",
					ranks = 3,
					column = 3,
					icon = 132326,
					row = 2,
					tips = "Reduces the cost of your Thunder Clap ability by %d rage point%s and increases the damage by %d%% and the slowing effect by an additional %d%%.",
					tipValues = {{1, '', 40, 4}, {2, 's', 70, 7}, {4, 's', 100, 10}},
				},
			}, -- [6]
			{
				info = {
					name = "Improved Overpower",
					ranks = 2,
					column = 1,
					icon = 135275,
					row = 3,
					tips = "Increases the critical strike chance of your Overpower ability by %d%%.",
					tipValues = {{25}, {50}},
				},
			}, -- [7]
			{
				info = {
					ranks = 1,
					name = "Anger Management",
					icon = 135881,
					column = 2,
					exceptional = 1,
					row = 3,
					tips = "Generates 1 rage per 3 seconds while in combat.",
				},
			}, -- [8]
			{
				info = {
					name = "Deep Wounds",
					ranks = 3,
					column = 3,
					icon = 132090,
					row = 3,
					tips = "Your critical strikes cause the opponent to bleed, dealing %d%% of your melee weapon's average damage over 12 sec.",
					tipValues = {{20}, {40}, {60}},
				},
			}, -- [9]
			{
				info = {
					name = "Two-Handed Weapon Specialization",
					ranks = 5,
					column = 2,
					icon = 132400,
					row = 4,
					tips = "Increases the damage you deal with two-handed melee weapons by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
				},
			}, -- [10]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 3,
							source = 9,
						}, -- [1]
					},
					name = "Impale",
					ranks = 2,
					column = 3,
					icon = 132312,
					row = 4,
					tips = "Increases the critical strike damage bonus of your abilities in Battle, Defensive, and Berserker stance by %d%%.",
					tipValues = {{10}, {20}},
				},
			}, -- [11]
			{
				info = {
					name = "Poleaxe Specialization",
					ranks = 5,
					column = 1,
					icon = 132397,
					row = 5,
					tips = "Increases your chance to get a critical strike with Axes and Polearms by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
				},
			}, -- [12]
			{
				info = {
					ranks = 1,
					name = "Death Wish",
					icon = 136146,
					column = 2,
					exceptional = 1,
					row = 5,
					tips = "When activated, increases your physical damage by 20% and makes you immune to Fear effects, but increases all damage taken by 5%.  Lasts 30 sec.",
				},
			}, -- [13]
			{
				info = {
					name = "Mace Specialization",
					ranks = 5,
					column = 3,
					icon = 133476,
					row = 5,
					tips = "Gives your melee attacks a chance to stun your target for 3 sec and generate 7 rage when using a Mace.",
				},
			}, -- [14]
			{
				info = {
					name = "Sword Specialization",
					ranks = 5,
					column = 4,
					icon = 135328,
					row = 5,
					tips = "Gives you a %d%% chance to get an extra attack on the same target after hitting your target with your Sword.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
				},
			}, -- [15]
			{
				info = {
					name = "Improved Intercept",
					ranks = 2,
					column = 1,
					icon = 132307,
					row = 6,
					tips = "Reduces the cooldown of your Intercept ability by %d sec.",
					tipValues = {{5}, {10}},
				},
			}, -- [16]
			{
				info = {
					name = "Improved Hamstring",
					ranks = 3,
					column = 3,
					icon = 132316,
					row = 6,
					tips = "Gives your Hamstring ability a %d%% chance to immobilize the target for 5 sec.",
					tipValues = {{5}, {10}, {15}},
				},
			}, -- [17]
			{
				info = {
					name = "Improved Disciplines",
					ranks = 3,
					column = 4,
					icon = 132346,
					row = 6,
					tips = "Reduces the cooldown of your Retaliation, Recklessness and Shield Wall abilities by %d min and increases their duration by %d sec.",
					tipValues = {{4, 2}, {7, 4}, {10, 6}},
				},
			}, -- [18]
			{
				info = {
					name = "Blood Frenzy",
					ranks = 2,
					column = 1,
					icon = 132334,
					row = 7,
					tips = "Your Rend and Deep Wounds abilities also increase all physical damage caused to that target by %d%%.",
					tipValues = {{2}, {4}},
				},
			}, -- [19]
			{
				info = {
					ranks = 1,
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Mortal Strike",
					icon = 132355,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "A vicious strike that deals weapon damage plus 85 and wounds the target, reducing the effectiveness of any healing by 50% for 10 sec.",
				},
			}, -- [20]
			{
				info = {
					name = "Second Wind",
					ranks = 2,
					column = 3,
					icon = 132175,
					row = 7,
					tips = "Whenever you are struck by a Stun or Immobilize effect you will generate %d rage and %d%% of your total health over 10 sec.",
					tipValues = {{10, 5}, {20, 10}},
				},
			}, -- [21]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 20,
						}, -- [1]
					},
					name = "Improved Mortal Strike",
					ranks = 5,
					column = 2,
					icon = 132355,
					row = 8,
					tips = "Reduces the cooldown of your Mortal Strike ability by %.1f sec and increases the damage it causes by %d%%.",
					tipValues = {{0.2, 1}, {0.4, 2}, {0.6, 3}, {0.8, 4}, {1.0, 5}},
				},
			}, -- [22]
			{
				info = {
					ranks = 1,
					name = "Endless Rage",
					icon = 132344,
					column = 2,
					exceptional = 1,
					row = 9,
					tips = "You generate 25% more rage from damage dealt.",
				},
			}, -- [23]
		},
		info = {
			name = "Arms",
			background = "WarriorArms",
		},
	}, -- [1]
	{
		numtalents = 21,
		talents = {
			{
				info = {
					name = "Booming Voice",
					ranks = 5,
					column = 2,
					icon = 136075,
					row = 1,
					tips = "Increases the area of effect and duration of your Battle Shout, Demoralizing Shout and Commanding Shout by %d%%.",
					tipValues = {{10}, {20}, {30}, {40}, {50}},
				},
			}, -- [1]
			{
				info = {
					name = "Cruelty",
					ranks = 5,
					column = 3,
					icon = 132292,
					row = 1,
					tips = "Increases your chance to get a critical strike with melee weapons by %d%%.",
					tipValues = {{1}, {2}, {3}, {4}, {5}},
				},
			}, -- [2]
			{
				info = {
					name = "Improved Demoralizing Shout",
					ranks = 5,
					column = 2,
					icon = 132366,
					row = 2,
					tips = "Increases the melee attack power reduction of your Demoralizing Shout by %d%%.",
					tipValues = {{8}, {16}, {24}, {32}, {40}},
				},
			}, -- [3]
			{
				info = {
					name = "Unbridled Wrath",
					ranks = 5,
					column = 3,
					icon = 136097,
					row = 2,
					tips = "Gives you a chance to generate an additional rage point when you deal melee damage with a weapon.",
				},
			}, -- [4]
			{
				info = {
					name = "Improved Cleave",
					ranks = 3,
					column = 1,
					icon = 132338,
					row = 3,
					tips = "Increases the bonus damage done by your Cleave ability by %d%%.",
					tipValues = {{40}, {80}, {120}},
				},
			}, -- [5]
			{
				info = {
					ranks = 1,
					name = "Piercing Howl",
					icon = 136147,
					column = 2,
					exceptional = 1,
					row = 3,
					tips = "Causes all enemies within 10 yards to be Dazed, reducing movement speed by 50% for 6 sec.",
				},
			}, -- [6]
			{
				info = {
					name = "Blood Craze",
					ranks = 3,
					column = 3,
					icon = 136218,
					row = 3,
					tips = "Regenerates %d%% of your total Health over 6 sec after being the victim of a critical strike.",
					tipValues = {{1}, {2}, {3}},
				},
			}, -- [7]
			{
				info = {
					name = "Commanding Presence",
					ranks = 5,
					column = 4,
					icon = 136035,
					row = 3,
					tips = "Increases the melee attack power bonus of your Battle Shout and the health bonus of your Commanding Shout by %d%%.",
					tipValues = {{5}, {10}, {15}, {20}, {25}},
				},
			}, -- [8]
			{
				info = {
					name = "Dual Wield Specialization",
					ranks = 5,
					column = 1,
					icon = 132147,
					row = 4,
					tips = "Increases the damage done by your offhand weapon by %d%%.",
					tipValues = {{5}, {10}, {15}, {20}, {25}},
				},
			}, -- [9]
			{
				info = {
					name = "Improved Execute",
					ranks = 2,
					column = 2,
					icon = 135358,
					row = 4,
					tips = "Reduces the rage cost of your Execute ability by %d.",
					tipValues = {{2}, {5}},
				},
			}, -- [10]
			{
				info = {
					name = "Enrage",
					ranks = 5,
					column = 3,
					icon = 136224,
					row = 4,
					tips = "Gives you a %d%% melee damage bonus for 12 sec up to a maximum of 12 swings after being the victim of a critical strike.",
					tipValues = {{5}, {10}, {15}, {20}, {25}},
				},
			}, -- [11]
			{
				info = {
					name = "Improved Slam",
					ranks = 2,
					column = 1,
					icon = 132340,
					row = 5,
					tips = "Decreases the casting time of your Slam ability by %.1f sec.",
					tipValues = {{0.5}, {1.0}},
				},
			}, -- [12]
			{
				info = {
					ranks = 1,
					name = "Sweeping Strikes",
					icon = 132306,
					column = 2,
					exceptional = 1,
					row = 5,
					tips = "Your next 10 melee attacks strike an additional nearby opponent.",
				},
			}, -- [13]
			{
				info = {
					name = "Weapon Mastery",
					ranks = 2,
					column = 4,
					icon = 132367,
					row = 5,
					tips = "Reduces the chance for your attacks to be dodged by %d%% and reduces the duration of all Disarm effects used against you by %d%%.  This does not stack with other Disarm duration reducing effects.",
					tipValues = {{1, 25}, {2, 50}},
				},
			}, -- [14]
			{
				info = {
					name = "Improved Berserker Rage",
					ranks = 2,
					column = 1,
					icon = 136009,
					row = 6,
					tips = "The Berserker Rage ability will generate %d rage when used.",
					tipValues = {{5}, {10}},
				},
			}, -- [15]
			{
				info = {
					prereqs = {
						{
							column = 3,
							row = 4,
							source = 11,
						}, -- [1]
					},
					name = "Flurry",
					ranks = 5,
					column = 3,
					icon = 132152,
					row = 6,
					tips = "Increases your attack speed by %d%% for your next 3 swings after dealing a melee critical strike.",
					tipValues = {{5}, {10}, {15}, {20}, {25}},
				},
			}, -- [16]
			{
				info = {
					name = "Precision",
					ranks = 3,
					column = 1,
					icon = 132222,
					row = 7,
					tips = "Increases your chance to hit with melee weapons by %d%%.",
					tipValues = {{1}, {2}, {3}},
				},
			}, -- [17]
			{
				info = {
					ranks = 1,
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 13,
						}, -- [1]
					},
					name = "Bloodthirst",
					icon = 136012,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Instantly attack the target causing 275 damage.  In addition, the next 5 successful melee attacks will restore 10 health.  This effect lasts 8 sec.  Damage is based on your attack power.",
				},
			}, -- [18]
			{
				info = {
					name = "Improved Whirlwind",
					ranks = 2,
					column = 3,
					icon = 132369,
					row = 7,
					tips = "Reduces the cooldown of your Whirlwind ability by %d sec.",
					tipValues = {{1}, {2}},
				},
			}, -- [19]
			{
				info = {
					name = "Improved Berserker Stance",
					ranks = 5,
					column = 3,
					icon = 132275,
					row = 8,
					tips = "Increases attack power by %d%% and reduces threat caused by %d%% while in Berserker Stance.",
					tipValues = {{2, 2}, {4, 4}, {6, 6}, {8, 8}, {10, 10}},
				},
			}, -- [20]
			{
				info = {
					ranks = 1,
					prereqs = {
						{
							column = 2,
							row = 7,
							source = 18,
						}, -- [1]
					},
					name = "Rampage",
					icon = 132352,
					column = 2,
					exceptional = 1,
					row = 9,
					tips = "Warrior goes on a rampage, increasing attack power by 30 and causing most successful melee attacks to increase attack power by an additional 30.  This effect will stack up to 5 times.  Lasts 30 sec.  This ability can only be used after scoring a critical hit.",
				},
			}, -- [21]
		},
		info = {
			name = "Fury",
			background = "WarriorFury",
		},
	}, -- [2]
	{
		numtalents = 22,
		talents = {
			{
				info = {
					name = "Improved Bloodrage",
					ranks = 2,
					column = 1,
					icon = 132277,
					row = 1,
					tips = "Increases the instant rage generated by your Bloodrage ability by %d.",
					tipValues = {{3}, {6}},
				},
			}, -- [1]
			{
				info = {
					name = "Tactical Mastery",
					ranks = 3,
					column = 2,
					icon = 136031,
					row = 1,
					tips = "You retain up to an additional %d of your rage points when you change stances.  Also greatly increases the threat generated by your Bloodthirst and Mortal Strike abilities when you are in Defensive Stance.",
					tipValues = {{5}, {10}, {15}},
				},
			}, -- [2]
			{
				info = {
					name = "Anticipation",
					ranks = 5,
					column = 3,
					icon = 136056,
					row = 1,
					tips = "Increases your Defense skill by %d.",
					tipValues = {{4}, {8}, {12}, {16}, {20}},
				},
			}, -- [3]
			{
				info = {
					name = "Shield Specialization",
					ranks = 5,
					column = 2,
					icon = 134952,
					row = 2,
					tips = "Increases your chance to block attacks with a shield by %d%% and has a %d%% chance to generate 1 rage when a block occurs.",
					tipValues = {{1, 20}, {2, 40}, {3, 60}, {4, 80}, {5, 100}},
				},
			}, -- [4]
			{
				info = {
					name = "Toughness",
					ranks = 5,
					column = 3,
					icon = 135892,
					row = 2,
					tips = "Increases your armor value from items by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
				},
			}, -- [5]
			{
				info = {
					ranks = 1,
					name = "Last Stand",
					icon = 135871,
					column = 1,
					exceptional = 1,
					row = 3,
					tips = "When activated, this ability temporarily grants you 30% of your maximum health for 20 sec.  After the effect expires, the health is lost.",
				},
			}, -- [6]
			{
				info = {
					prereqs = {
						{
							column = 2,
							row = 2,
							source = 4,
						}, -- [1]
					},
					name = "Improved Shield Block",
					ranks = 1,
					column = 2,
					icon = 132110,
					row = 3,
					tips = "Allows your Shield Block ability to block an additional attack and increases the duration by 1 second.",
				},
			}, -- [7]
			{
				info = {
					name = "Improved Revenge",
					ranks = 3,
					column = 3,
					icon = 132353,
					row = 3,
					tips = "Gives your Revenge ability a %d%% chance to stun the target for 3 sec.",
					tipValues = {{15}, {30}, {45}},
				},
			}, -- [8]
			{
				info = {
					name = "Defiance",
					ranks = 3,
					column = 4,
					icon = 132347,
					row = 3,
					tips = "Increases the threat generated by your attacks by %d%% while in Defensive Stance and increases your expertise by %d.",
					tipValues = {{5, 2}, {10, 4}, {15, 6}},
				},
			}, -- [9]
			{
				info = {
					name = "Improved Sunder Armor",
					ranks = 3,
					column = 1,
					icon = 132363,
					row = 4,
					tips = "Reduces the cost of your Sunder Armor and Devastate abilities by %d rage point.",
					tipValues = {{1}, {2}, {3}},
				},
			}, -- [10]
			{
				info = {
					name = "Improved Disarm",
					ranks = 3,
					column = 2,
					icon = 132343,
					row = 4,
					tips = "Increases the duration of your Disarm ability by %d secs.",
					tipValues = {{1}, {2}, {3}},
				},
			}, -- [11]
			{
				info = {
					name = "Improved Taunt",
					ranks = 2,
					column = 3,
					icon = 136080,
					row = 4,
					tips = "Reduces the cooldown of your Taunt ability by %d sec.",
					tipValues = {{1}, {2}},
				},
			}, -- [12]
			{
				info = {
					name = "Improved Shield Wall",
					ranks = 2,
					column = 1,
					icon = 132362,
					row = 5,
					tips = "Increases the effect duration of your Shield Wall ability by %d secs.",
					tipValues = {{3}, {5}},
				},
			}, -- [13]
			{
				info = {
					ranks = 1,
					name = "Concussion Blow",
					icon = 132325,
					column = 2,
					exceptional = 1,
					row = 5,
					tips = "Stuns the opponent for 5 sec.",
				},
			}, -- [14]
			{
				info = {
					name = "Improved Shield Bash",
					ranks = 2,
					column = 3,
					icon = 132357,
					row = 5,
					tips = "Gives your Shield Bash ability a %d%% chance to silence the target for 3 sec.",
					tipValues = {{50}, {100}},
				},
			}, -- [15]
			{
				info = {
					name = "Shield Mastery",
					ranks = 3,
					column = 1,
					icon = 132360,
					row = 6,
					tips = "Increases the amount of damage absorbed by your shield by %d%%.",
					tipValues = {{10}, {20}, {30}},
				},
			}, -- [16]
			{
				info = {
					name = "One-Handed Weapon Specialization",
					ranks = 5,
					column = 3,
					icon = 135321,
					row = 6,
					tips = "Increases physical damage you deal when a one-handed melee weapon is equipped by %d%%.",
					tipValues = {{2}, {4}, {6}, {8}, {10}},
				},
			}, -- [17]
			{
				info = {
					name = "Improved Defensive Stance",
					ranks = 3,
					column = 1,
					icon = 132341,
					row = 7,
					tips = "Reduces all spell damage taken while in Defensive Stance by %d%%.",
					tipValues = {{2}, {4}, {6}},
				},
			}, -- [18]
			{
				info = {
					ranks = 1,
					prereqs = {
						{
							column = 2,
							row = 5,
							source = 14,
						}, -- [1]
					},
					name = "Shield Slam",
					icon = 134951,
					column = 2,
					exceptional = 1,
					row = 7,
					tips = "Slam the target with your shield, causing 225 to 235 damage, modified by your shield block value, and dispels 1 magic effect on the target.  Also causes a high amount of threat.",
				},
			}, -- [19]
			{
				info = {
					name = "Focused Rage",
					ranks = 3,
					column = 3,
					icon = 132345,
					row = 7,
					tips = "Reduces the rage cost of your offensive abilities by %d.",
					tipValues = {{1}, {2}, {3}},
				},
			}, -- [20]
			{
				info = {
					name = "Vitality",
					ranks = 5,
					column = 2,
					icon = 133123,
					row = 8,
					tips = "Increases your total Stamina by %d%% and your total Strength by %d%%.",
					tipValues = {{1, 2}, {2, 4}, {3, 6}, {4, 8}, {5, 10}},
				},
			}, -- [21]
			{
				info = {
					ranks = 1,
					name = "Devastate",
					icon = 135291,
					column = 2,
					exceptional = 1,
					row = 9,
					tips = "Sunder the target's armor causing the Sunder Armor effect.  In addition, causes 50% of weapon damage plus 15 for each application of Sunder Armor on the target.  The Sunder Armor effect can stack up to 5 times.",
				},
			}, -- [22]
		},
		info = {
			name = "Protection",
			background = "WarriorProtection",
		},
	}, -- [3]
}