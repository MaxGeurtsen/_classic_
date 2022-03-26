
OmniCCDB = {
	["profileKeys"] = {
		["Partijleider - Gehennas"] = "Default",
		["Partijlijder - Gehennas"] = "Default",
		["Cursedbreath - Firemaw"] = "Default",
		["Mírjam - Razorgore"] = "Default",
		["Partijcurses - Gehennas"] = "Default",
		["Mírjam - Firemaw"] = "Default",
		["Awwaa - Gehennas"] = "Default",
		["Helpsiebren - Razorgore"] = "Default",
		["Partijlijder - Razorgore"] = "Default",
		["Mirjam - Firemaw"] = "Default",
		["Partijleider - Razorgore"] = "Default",
		["Rinque - Gehennas"] = "Default",
		["Eefjé - Razorgore"] = "Default",
		["Firebreather - Firemaw"] = "Default",
		["Kealthas - Razorgore"] = "Default",
	},
	["global"] = {
		["dbVersion"] = 6,
		["addonVersion"] = "9.2.0",
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
						["seconds"] = {
						},
						["minutes"] = {
						},
						["soon"] = {
						},
					},
				},
				["Plater Nameplates Theme"] = {
					["textStyles"] = {
						["seconds"] = {
						},
						["soon"] = {
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
			["yOff"] = 0,
			["anchor"] = "CENTER",
			["minDuration"] = 2,
			["xOff"] = 0,
			["tenthsDuration"] = 0,
			["fontOutline"] = "OUTLINE",
			["minSize"] = 0.5,
			["mmSSDuration"] = 0,
			["minEffectDuration"] = 30,
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
		},
	},
	["groups"] = {
	},
}
