
OmniCCDB = {
	["profileKeys"] = {
		["Partijleider - Gehennas"] = "Default",
		["Partijlijder - Gehennas"] = "Default",
		["Mírjam - Razorgore"] = "Default",
		["Cursedbreath - Firemaw"] = "Default",
		["Firebreather - Firemaw"] = "Default",
		["Awwaa - Gehennas"] = "Default",
		["Helpsiebren - Razorgore"] = "Default",
		["Partijleider - Razorgore"] = "Default",
		["Mirjam - Firemaw"] = "Default",
		["Partijlijder - Razorgore"] = "Default",
		["Eefjé - Razorgore"] = "Default",
		["Mírjam - Firemaw"] = "Default",
		["Rinque - Gehennas"] = "Default",
		["Kealthas - Razorgore"] = "Default",
	},
	["global"] = {
		["dbVersion"] = 6,
		["addonVersion"] = "9.1.6",
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
	["groupSettings"] = {
		["base"] = {
			["fontSize"] = 18,
			["minDuration"] = 2,
			["minSize"] = 0.5,
			["yOff"] = 0,
			["xOff"] = 0,
			["tenthsDuration"] = 0,
			["fontOutline"] = "OUTLINE",
			["anchor"] = "CENTER",
			["minEffectDuration"] = 30,
			["mmSSDuration"] = 0,
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
	["version"] = "8.2.5",
}
