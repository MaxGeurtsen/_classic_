Test = {}

local function CreatePayments()
	for i=10,1,-1 do 
		Payment:Add(LuaHelper:RandomString(12), LuaHelper:RandomNumber(5))
	end
end

local function CreateLockouts()
	for i=2,1,-1 do 
		local cl = { 
			identifier = LuaHelper:RandomNumber(5),
			instanceName = LuaHelper:RandomString(12),
			instanceType = "party",
			playerName = LuaHelper:RandomString(12),
		}
		CharacterLockout:Add(cl)

		local rHour = LuaHelper:RandomNumberBetween(1, 11)
		local rMin = LuaHelper:RandomNumberBetween(1, 50)
		local al = {
			instanceName = LuaHelper:RandomString(12),
			playerName = IT_CONST_UNIT_NAME_PLAYER,
			startDateTime = {
				year = date("20%y"),
				month = date("%m"),
				day = date("%d"),
				hour = rHour,
				minute = rMin,
				second = date("%S")
			},
			endDateTime = {
				year = date("20%y"),
				month = date("%m"),
				day = date("%d"),
				hour = rHour + 1,
				minute = rMin + 5,
				second = date("%S")
			}
		}
		AccountLockout:Add(cl.identifier, al)

		Statistics:ImportStatistics(cl.identifier, cl.playerName, LuaHelper:RandomNumber(10), LuaHelper:RandomNumber(5), LuaHelper:RandomNumber(3))
		for i=4,1,-1 do 
			Statistics:ImportStatistics(cl.identifier, LuaHelper:RandomString(12), LuaHelper:RandomNumber(10), LuaHelper:RandomNumber(5), LuaHelper:RandomNumber(3))
		end

		StatisticsTracker:CreateStatisticsLink(cl.identifier)
	end
end

function Test:All()
	CreatePayments()
	CreateLockouts()
end