
OmniCCDB = {
	["global"] = {
		["dbVersion"] = 6,
		["addonVersion"] = "9.2.0",
	},
	["profileKeys"] = {
		["Partijleider - Gehennas"] = "Default",
		["Partijlijder - Gehennas"] = "Default",
		["Partijcurses - Gehennas"] = "Default",
		["Mírjam - Razorgore"] = "Default",
		["Cursedbreath - Firemaw"] = "Default",
		["Firebreather - Firemaw"] = "Default",
		["Awwaa - Gehennas"] = "Default",
		["Helpsiebren - Razorgore"] = "Default",
		["Rinque - Gehennas"] = "Default",
		["Mirjam - Firemaw"] = "Default",
		["Partijleider - Razorgore"] = "Default",
		["Eefjé - Razorgore"] = "Default",
		["Partijlijder - Razorgore"] = "Default",
		["Mírjam - Firemaw"] = "Default",
		["Kealthas - Razorgore"] = "Default",
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
	["version"] = "8.2.5",
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
}
