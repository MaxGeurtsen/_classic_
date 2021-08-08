local AceGUI = LibStub("AceGUI-3.0")

GUIPaymentComment = {}
GUIPaymentComment["HasFrameActive"] = false
local window = nil

function GUIPaymentComment:New(player)
    if GUIPaymentComment["HasFrameActive"] then
        window:Hide()
    end

    GUIPaymentComment["HasFrameActive"] = true;
    DebugHelper:Print("GUIPaymentComment:CreateGUI()")

    window = AceGUI:Create("Window", UIParent)
    window:Hide()
    _G["IBPT_GUIPaymentComment"] = window
    tinsert(UISpecialFrames, "IBPT_GUIPaymentComment")	-- allow ESC close
    window:SetWidth(400)
    window:SetHeight(110)
    window:SetTitle("Add comment for "..player)
    window:EnableResize(false)
    
    local editbox = AceGUI:Create("EditBox")
    editbox:SetLabel("Add comment")
    editbox:SetFullWidth(true)
    editbox:SetText(Comment:Get(player))
    window:AddChild(editbox)

    local saveBtn = AceGUI:Create("Button")
    saveBtn:SetText("Save")
    saveBtn:SetRelativeWidth(0.20)
    saveBtn:SetCallback("OnClick", function() 
        Comment:Set(player, editbox.lasttext)
        GUIPayments:ForceUpdate()
        window:Hide()
        GUIPaymentComment["HasFrameActive"] = false;
    end)
    window:AddChild(saveBtn)
    window:Show()
end