local AceGUI = LibStub("AceGUI-3.0")
local mainFrame = nil
local lockoutsCB, paymentsCB = nil, nil

GUISettings = {}

local function RefreshGUI()
    if mainFrame then
        mainFrame:Hide()
        mainFrame = nil
    end
    GUISettings:Show()
end

local function AddFeaturesTab(mainFrame)
    local featureTab = UIHelper:CreateTab(mainFrame, "Features")

    lockoutsCB = UIHelper:CreateCheckBoxButton(featureTab, "Lockouts", LockoutTracker:IsEnabled(), function(value) 
        LockoutTracker:EnableDisable(value) 
        RefreshGUI()
    end)

    paymentsCB = UIHelper:CreateCheckBoxButton(featureTab, "Payments", Payment:IsEnabled(), function(value) 
        Payment:EnableDisable(value)           
        RefreshGUI()
    end)

    UIHelper:CreateCheckBoxButton(featureTab, "SpeedyAutoLoot", Settings:GetKey("SPEEDY_AUTO_LOOT"), function(value) 
        Settings:SetKeyValue("SPEEDY_AUTO_LOOT", value)
        IT:ReloadUIPopup("A reload is required for this setting to take affect.")
    end)

    UIHelper:CreateSettingsKeyCB(featureTab, "Report Ele Earth", "REPORT_ELEMENTAL_EARTH")
    UIHelper:CreateSettingsKeyCB(featureTab, "BETA: Auto follow", "AUTO_FOLLOW")
end

-- Adds additional options for the lockout tracker system
local function AddLockoutTrackerSettings(mainFrame)
    if lockoutsCB:GetValue() then
        local tab = UIHelper:CreateTab(mainFrame, "Lockout settings")
        UIHelper:CreateSettingsKeyCB(tab, "Record statistics", "FEATURE_LockoutStatistics")
        UIHelper:CreateSettingsKeyCB(tab, "Report instance resets", "LOCKOUT_REPORTRESET")
        UIHelper:CreateSettingsKeyCB(tab, "Create statistics link", "STATISTICS_REPORT")
        UIHelper:CreateSettingsKeyCB(tab, "Reset upon joining group", "LOCKOUT_RESETONGROUPCHANGE")
        UIHelper:CreateSettingsKeyCB(tab, "Display locked warning on logoff", "LOCKOUT_LOGOFFWARNING", 250)
    end
end

-- Adds additional options for the payment system
local function AddPaymentSettings(mainFrame)
    if paymentsCB:GetValue() then
        local tab = UIHelper:CreateTab(mainFrame, "Payment settings")
        UIHelper:CreateSettingsKeyCB(tab, "Add payments to menu", "PAYMENT_REPORTMAIN")
        UIHelper:CreateSettingsKeyCB(tab, "Report payments to chat", "PAYMENT_REPORTCHAT")
    end
end

function GUISettings:IsShown()
    DebugHelper:Print("GUISettings:IsShown()")
    if (mainFrame ~= nil) then
        return mainFrame:IsShown()
    else
        return false
    end
end

local function CreateGUI()
    DebugHelper:Print("GUISettings:CreateGUI()")

    mainFrame = AceGUI:Create("Frame", UIParent)
    _G["IBPT_Settings"] = mainFrame
    tinsert(UISpecialFrames, "IBPT_Settings")	-- allow ESC close
    mainFrame:SetWidth(600)
    mainFrame:SetTitle("Settings")
    mainFrame:EnableResize(false)

    AddFeaturesTab(mainFrame)
    AddLockoutTrackerSettings(mainFrame)
    AddPaymentSettings(mainFrame)

    mainFrame:Show()
end

function GUISettings:Show()
    DebugHelper:Print("GUISettings:Show()")
    if (not GUISettings:IsShown()) then
        CreateGUI()
    else
        mainFrame:Hide()
        mainFrame = nil
    end
end