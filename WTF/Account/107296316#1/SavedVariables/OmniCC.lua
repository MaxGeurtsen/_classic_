
OmniCCDB = {
	["global"] = {
		["dbVersion"] = 6,
		["addonVersion"] = "9.2.1",
	},
	["profileKeys"] = {
		["Partijlijder - Gehennas"] = "Default",
		["Firebreather - Firemaw"] = "Default",
		["Partijcurses - Gehennas"] = "Default",
		["Awwaa - Gehennas"] = "Default",
		["Partijlijder - Razorgore"] = "Default",
		["Kealthas - Razorgore"] = "Default",
		["Firebreather - Gehennas"] = "Default",
		["Partijdood - Gehennas"] = "Default",
		["Mírjam - Razorgore"] = "Default",
		["Partijleider - Razorgore"] = "Default",
		["Helpsiebren - Razorgore"] = "Default",
		["Mirjam - Firemaw"] = "Default",
		["Mírjam - Firemaw"] = "Default",
		["Eefjé - Razorgore"] = "Default",
		["Rinque - Gehennas"] = "Default",
		["Cursedbreath - Firemaw"] = "Default",
		["Partijleider - Gehennas"] = "Default",
		["Partijaxert - Gehennas"] = "Default",
	},
	["profiles"] = {
		["Default"] = {
			["rules"] = {
				{
					["patterns"] = {
						"PlaterMainAuraIcon", -- [1]
						"PlaterSecondaryAuraIcon", -- [2]
						"ExtraIconRowIcon", -- [3]
					},
					["id"] = "Plater Nameplates Rule",
					["priority"] = 1,
					["theme"] = "Plater Nameplates Theme",
				}, -- [1]
			},
			["themes"] = {
				["Default"] = {
					["textStyles"] = {
						["minutes"] = {
						},
						["seconds"] = {
						},
						["soon"] = {
						},
					},
				},
				["Plater Nameplates Theme"] = {
					["textStyles"] = {
						["soon"] = {
						},
						["seconds"] = {
						},
						["minutes"] = {
						},
					},
				},
			},
		},
	},
}
OmniCC4Config = {
	["groupSettings"] = {
		["base"] = {
			["fontSize"] = 18,
			["styles"] = {
				["seconds"] = {
					["scale"] = 1,
				},
				["minutes"] = {
					["scale"] = 1,
				},
				["soon"] = {
					["scale"] = 1.5,
				},
				["hours"] = {
					["scale"] = 0.75,
				},
				["charging"] = {
					["scale"] = 0.75,
				},
				["controlled"] = {
					["scale"] = 1.5,
				},
			},
			["mmSSDuration"] = 0,
			["minDuration"] = 2,
			["xOff"] = 0,
			["tenthsDuration"] = 0,
			["fontOutline"] = "OUTLINE",
			["minSize"] = 0.5,
			["minEffectDuration"] = 30,
			["anchor"] = "CENTER",
			["yOff"] = 0,
		},
	},
	["groups"] = {
	},
	["version"] = "8.2.5",
}
