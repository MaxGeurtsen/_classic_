Timer = {}
local CALLBACK_FUNCTION = nil
local TIME = 0
local ISRUNNING = false

local function Pulse()
    if ISRUNNING then
        TIME = TIME + 1
        CALLBACK_FUNCTION()
        Timer:InternalLoop()
    end
end

function Timer:InternalLoop()
    C_Timer.After(1, function() Pulse() end)
end

function Timer:Start(callback)
    CALLBACK_FUNCTION = callback
    ISRUNNING = true
    Timer:InternalLoop()
end

function Timer:Stop()
    ISRUNNING = false
end