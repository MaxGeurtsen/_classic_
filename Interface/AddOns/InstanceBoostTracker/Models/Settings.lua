Settings = {}
if SavedSettings == nil then SavedSettings = {} end

function Settings:GetKey(key)
    if SavedSettings[key] == nil then
        InitializeVariables()
    end
    return SavedSettings[key]
end

function Settings:SetKeyValue(key, value)
    SavedSettings[key] = value
end

function InitializeVariables()
    if SavedSettings["FEATURE_Payment"] == nil then SavedSettings["FEATURE_Payment"] = true end
    if SavedSettings["FEATURE_LockoutTracker"] == nil then SavedSettings["FEATURE_LockoutTracker"] = true end
    if SavedSettings["FEATURE_LockoutStatistics"] == nil then SavedSettings["FEATURE_LockoutStatistics"] = true end

    if SavedSettings["LOCKOUT_REPORTRESET"] == nil then SavedSettings["LOCKOUT_REPORTRESET"] = false end
    if SavedSettings["LOCKOUT_LOGOFFWARNING"] == nil then SavedSettings["LOCKOUT_LOGOFFWARNING"] = true end
    if SavedSettings["LOCKOUT_RESETONGROUPCHANGE"] == nil then SavedSettings["LOCKOUT_RESETONGROUPCHANGE"] = true end

    if SavedSettings["STATISTICS_REPORT"] == nil then SavedSettings["STATISTICS_REPORT"] = true end

    if SavedSettings["PAYMENT_REPORTMAIN"] == nil then SavedSettings["PAYMENT_REPORTMAIN"] = true end
    if SavedSettings["PAYMENT_REPORTCHAT"] == nil then SavedSettings["PAYMENT_REPORTCHAT"] = true end

    if SavedSettings["SPEEDY_AUTO_LOOT"] == nil then SavedSettings["SPEEDY_AUTO_LOOT"] = false end
    if SavedSettings["REPORT_ELEMENTAL_EARTH"] == nil then SavedSettings["REPORT_ELEMENTAL_EARTH"] = false end
    if SavedSettings["AUTO_FOLLOW"] == nil then SavedSettings["AUTO_FOLLOW"] = false end
end