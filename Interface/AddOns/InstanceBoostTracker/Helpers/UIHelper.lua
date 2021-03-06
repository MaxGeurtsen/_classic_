local AceGUI = LibStub("AceGUI-3.0")
UIHelper = {}

function UIHelper:CreateTab(parent, title, width)
    local tab = AceGUI:Create("TabGroup")
    if width then
        tab:SetWidth(width)
    else
        tab:SetFullWidth(true)
    end
    tab:SetLayout("Flow")
    tab:SetTitle(title)
    parent:AddChild(tab)

    return tab
end

function UIHelper:CreateCheckBoxButton(parent, label, value, onClickCallback, width)
    local checkbox = AceGUI:Create("CheckBox")

    checkbox:SetLabel(label)
    checkbox:SetValue(value)

    checkbox:SetCallback("OnValueChanged", function (_,_,value) 
        onClickCallback(value)
    end)

    if width then
        checkbox:SetWidth(width)
    end

    parent:AddChild(checkbox)

    return checkbox
end

function UIHelper:CreateSettingsKeyCB(parent, label, settingsKey, width, callback)
    UIHelper:CreateCheckBoxButton(parent, label, Settings:GetKey(settingsKey), function(value) 
        Settings:SetKeyValue(settingsKey, value)
        if callback ~= nil then
            callback(value)
        end
    end, width)
end