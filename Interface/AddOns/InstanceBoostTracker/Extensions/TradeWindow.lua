local TradeWindow = CreateFrame("frame")
local payment = {}

local targetCancelled = false
local targetAccepted = false
local playerAccepted = false
local TRADE_CLOSED_EVENT_TRIGGERED = false
local TRADE_REQUEST_CANCEL_EVENT_TRIGGERED = false

-- Fired when the status of the player and target accept buttons has changed. 
-- Target agree status only shown when he has done it first. 
-- By this, player and target agree status is only shown together (arg1 == 1 and arg2 == 1), when player agreed after target.
function TradeWindow.TRADE_ACCEPT_UPDATE(player, target)
    DebugHelper:Print("TradeWindow.TRADE_ACCEPT_UPDATE("..player..", "..target..")")

    if (targetAccepted == false and target == 1 or player == 1) then -- success
        local amount = tonumber(GetTargetTradeMoney())
        -- We only want to add the person to the list once we have verified that we have received money.
        if (amount > 0) then 
            local name = UnitName("npc")
            payment.Name = name
            payment.Amount = amount
            targetAccepted = true
        end
    end

    if (player == 1) then
        playerAccepted = true
    end
end

-- Fired when the Trade window appears after a trade request has been accepted or auto-accepted
function TradeWindow.TRADE_SHOW()
    DebugHelper:Print("TradeWindow.TRADE_SHOW()")

    -- initialize variables
    payment = {}
    targetAccepted = false
    targetCancelled = false
    playerAccepted = false
    TRADE_REQUEST_CANCEL_EVENT_TRIGGERED = false
    TRADE_CLOSED_EVENT_TRIGGERED = false
end

-- Fired when the trade window is closed by the trade being accepted, or the player or target closes the window.
function TradeWindow.TRADE_CLOSED()
    DebugHelper:Print("TradeWindow.TRADE_CLOSED()")

    if (TRADE_CLOSED_EVENT_TRIGGERED == false and targetCancelled == false and targetAccepted) then
        TRADE_CLOSED_EVENT_TRIGGERED = true

        if (TRADE_REQUEST_CANCEL_EVENT_TRIGGERED == false and playerAccepted == false) then
            DebugHelper:Print("-> Player cancelled the trade.")
            -- It has been cancelled by the player
        else
            Payment:Add(payment.Name, payment.Amount)
            GUI:Update()
        end
    end
end

-- Fired when a trade attempt is cancelled. Fired after TRADE_CLOSE when aborted by player, before TRADE_CLOSE when done by target.
function TradeWindow.TRADE_REQUEST_CANCEL()
    DebugHelper:Print("TradeWindow.TRADE_REQUEST_CANCEL()")

    TRADE_REQUEST_CANCEL_EVENT_TRIGGERED = true
    targetCancelled = true

    local name = UnitName("npc")
    if (name ~= nil) then
        print(name.." cancelled the trade.")
    end
end

-- Register all events we wish to hook
TradeWindow:RegisterEvent("TRADE_REQUEST_CANCEL")
TradeWindow:RegisterEvent("TRADE_ACCEPT_UPDATE")
TradeWindow:RegisterEvent("TRADE_CLOSED")
TradeWindow:RegisterEvent("TRADE_SHOW")
TradeWindow:SetScript("OnEvent", function(self, event, ...) self[event](...) end)