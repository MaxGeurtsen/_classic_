-- This 'class' will be used to track all payments which have been made by writing the values to a key value paired object.

--[[ 

    SavedHistoricalPaymentsV2 = [
        (string, uniqueKey) ["PlayerName"] = {
            (int) Sum - total amount the player has paid. 
            Transactions = [
                (int, uniqueKey) [TransactionId] = {
                    (datetime) PaymentDateTime - When the player paid
                    (int) Amount - Amount the player has paid with this transaction
                }
            ]
        }
    ]

--]]

Payment = {}

local function AddTransaction(player, amount)
    if SavedHistoricalPaymentsV2[player] == nil then
        SavedHistoricalPaymentsV2[player] = { 
            Sum = 0,
            Transactions = {}
        }
    end

    SavedHistoricalPaymentsV2[player].Sum = (SavedHistoricalPaymentsV2[player].Sum or 0) + amount
    tinsert(SavedHistoricalPaymentsV2[player].Transactions, {
        PaymentDateTime = DateTimeHelper:NowSplitObj(),
        Amount = amount
    })
end

-- Create or Add a payment if we already have one, then reports it back to the user.
function Payment:Add(player, amount)
    if Payment:IsEnabled() then
        DebugHelper:Print("Payment:Add("..player..", "..amount..")")

        if (SavedPayments[player] == nil) then
            DebugHelper:Print("-> No player found with the name "..player..", creating player.")
            SavedPayments[player] = amount
        else
            DebugHelper:Print("-> Adding "..amount.." to player "..player.." payments.")
            SavedPayments[player] = SavedPayments[player] + amount
        end

        AddTransaction(player, amount)

        if Settings:GetKey("PAYMENT_REPORTCHAT") then
            IT:PrintMsg("Received "..GetCoinTextureString(amount).." from "..player)
        end
    end
end

function Payment:GetTotalSum()
    local totalSum = 0

    for key, payment in pairs(SavedHistoricalPaymentsV2) do
        totalSum = totalSum + payment.Sum
    end
    
    return totalSum
end

function Payment:Delete(player)
    SavedPayments[player] = nil
    SavedHistoricalPaymentsV2[player] = nil
    Comment:Delete(player)
end

function Payment:Reset()
    DebugHelper:Print("Payment:Reset()")
    SavedPayments = {}
end

function Payment:HistoryReset()
    DebugHelper:Print("Payment:HistoryReset()")
    SavedHistoricalPaymentsV2 = {}
    Payment:Reset()
end

function Payment:GetPayments()
    DebugHelper:Print("Payment:GetPayments()")
    return SavedPayments
end

function Payment:GetHistoryPayments()
    DebugHelper:Print("Payment:GetHistoryPayments()")
    return SavedHistoricalPaymentsV2
end

function Payment:IsEnabled()
    return Settings:GetKey("FEATURE_Payment")
end

function Payment:EnableDisable(value)
    Settings:SetKeyValue("FEATURE_Payment", value)
end

-- On login we need to migrate all the objects we know from SavedHistoricalPayments to the new SavedHistoricalPaymentsV2
function Payment:PLAYER_LOGIN()
    if SavedHistoricalPayments then
        IT:PrintMsg ("Migrating payment object to new model.")
        for key, totalSum in pairs(SavedHistoricalPayments) do
            AddTransaction(key, totalSum)
        end
    end

    SavedHistoricalPayments = nil
end

if SavedPayments == nil then SavedPayments = {} end
--if SavedHistoricalPayments == nil then SavedHistoricalPayments = {} end
if SavedHistoricalPaymentsV2 == nil then SavedHistoricalPaymentsV2 = {} end
