local AceGUI = LibStub("AceGUI-3.0")
local mainFrame = nil
local scroll = nil
local tableContent = nil
local selectedLine = nil
GUIPayments = {}
local previousColumnSortIdx = 0

local function SortTable(t, columnIdx)
    DebugHelper:Print("GUIPayments:SortTable()")
    columnIdx = columnIdx or 1

    if (columnName ~= nil) then
        DebugHelper:Print("-> Sorting on "..columnName.."("..columnIdx..")")
    end

    local sortDesc = function(a, b)
        return a[columnIdx] > b[columnIdx]
    end
    
    local sortAsc = function(a, b)
        return a[columnIdx] < b[columnIdx]
	end
    
    if (previousColumnSortIdx ~= columnIdx) then
        table.sort(t, sortDesc)
        previousColumnSortIdx = columnIdx
    else
        table.sort(t, sortAsc)
        previousColumnSortIdx = 0 -- reset the flag
    end
end

local function BuildTableContent()
    DebugHelper:Print("GUIPayments:BuildTableContent()")

    tableContent = {}

    for playerName, payments in pairs(Payment:GetHistoryPayments()) do
        DebugHelper:Print("-> Inserting "..playerName..", "..payments.Sum)
        -- we need to query the comments because if the user sorts on it it needs to have a value.
        table.insert(tableContent, {playerName, payments.Sum, Comment:Get(playerName)})
    end
end

local function UpdateTableContent()
    DebugHelper:Print("GUIPayments:UpdateTableContent()")

    local knownPayments = Payment:GetHistoryPayments()
    local rowCount = table.getn(tableContent)
    for index = 1, rowCount do
        local contentRow = tableContent[index]
        if contentRow then
            local playerName = contentRow[1]

            if not knownPayments[playerName] then
                DebugHelper:Print("-> Removing "..playerName)
                table.remove(tableContent, index)
            end
        else
            table.remove(tableContent, index)
        end
    end
end

-- https://wowwiki.fandom.com/wiki/UI_Object_UIDropDownMenu
-- creating test data structure
local MenuOptions = {
    ["Comment"] = {},
    ["Delete"] = {},
}

local function DropDownOnClick(self, arg1, arg2, checked)
    if self.value.Key == "Comment" then
        GUIPaymentComment:New(selectedLine.Player)
    elseif self.value.Key == "Delete" then
        Payment:Delete(selectedLine.Player)
        UpdateTableContent()
        GUIPayments:ForceUpdate()
        GUI:Update()
    end
end

-- menu create function
local function DropDownInitialize(self, level)
    level = level or 1;
    if (level == 1) then
        for key, subarray in pairs(MenuOptions) do
            local info = UIDropDownMenu_CreateInfo();
            info.notCheckable = true
            info.text = key;
            info.func = DropDownOnClick
            info.value = { 
                ["Key"] = key;
            };
            UIDropDownMenu_AddButton(info, level);
        end 
    end 
end 

local function Update()
    DebugHelper:Print("GUIPayments:Update()")

    local buttons = HybridScrollFrame_GetButtons(scroll)
    local maxRecords = table.getn(buttons)
    local rowCount = table.getn(tableContent)
    local scrollOffset = HybridScrollFrame_GetOffset(scroll)

    for index = 1, maxRecords do
        local curRowIndex = index + scrollOffset
        if curRowIndex > rowCount then
            local b = buttons[index]
            if b then
                b.Name:SetText(nil)
                b.Gold:SetText(nil)
                b.Comment:SetText(nil)
            end
            break
        end

        local player, gold, comment = unpack(tableContent[curRowIndex])
        local button = buttons[index]
        button.Name:SetText(player)
        button.Gold:SetText(GetCoinTextureString(gold))
        -- We query the comment again in case the Update gets called without a table refresh.
        -- Might not be the best performance wise... but ye..
        button.Comment:SetText(Comment:Get(player))

        -- https://wowwiki.fandom.com/wiki/UIHANDLER_OnClick
        button:RegisterForClicks("AnyUp")
        button:SetScript("OnClick", function (self, button)
            local dropDown = CreateFrame("Frame", "DropDownValues", UIParent, "UIDropDownMenuTemplate", BackdropTemplateMixin and "BackdropTemplate")
            dropDown:Hide()

            selectedLine = { Player = player }
            DebugHelper:Print("-> Clicked on "..player)

            -- Check if we don't exceed our bounds before applying button functionality
            if curRowIndex <= table.getn(tableContent) then
                if button == "RightButton" then
                    UIDropDownMenu_Initialize(dropDown, DropDownInitialize, "MENU")
                    ToggleDropDownMenu(1, nil, dropDown, "cursor")
                end
            end
        end)
        button:Show()
    end
    
    local buttonHeight = scroll.buttonHeight;
	local totalHeight = rowCount * buttonHeight;
	local shownHeight = maxRecords * buttonHeight;

	HybridScrollFrame_Update(scroll, totalHeight, shownHeight);
end

function GUIPayments:ForceUpdate()
    Update()
end

function GUIPayments:Reset()
    DebugHelper:Print("GUIPayments:Reset()")

    StaticPopupDialogs["RESET"] = {
        text = "Do you want to perform a FULL reset?", button1 = "Yes", button2 = "No",
        OnAccept = function()
            Payment:HistoryReset()
            Comment:Reset()
            GUI:Update()
            mainFrame:Hide()
        end,
    }
    StaticPopup_Show("RESET");
end

local function CreateTableHeader()
    DebugHelper:Print("GUIPayments:CreateTableHeader()")

    local header = TableHelper:CreateHeader(mainFrame)

    TableHelper:CreateColumns(header, { 
        { "Name", 120 }, 
        { "Amount", 120},
        { "Comment", 250 }
    }, function(columnIdx) 
        SortTable(tableContent, columnIdx)
        Update()
    end)

    return header
end

local function CreateTable()
    DebugHelper:Print("GUIPayments:CreateTable()")

    local tableHeader = CreateTableHeader()
    tableContentGroup = AceGUI:Create("SimpleGroup")
	tableContentGroup:SetFullWidth(true)
	tableContentGroup:SetHeight(405)
	tableContentGroup:SetLayout("Fill")
	mainFrame:AddChild(tableContentGroup)
	tableContentGroup:ClearAllPoints()
	tableContentGroup.frame:SetPoint("TOP", tableHeader.frame, "BOTTOM", 0, -5)
    tableContentGroup.frame:SetPoint("BOTTOM", 0, 20)
    scroll = TableHelper:AddScroll(tableContentGroup, "HybridScrollFrameHistory", "HybridScrollFrameHistoryItemTemplate", function() 
        GUIPayments:ForceUpdate() 
    end)
end

function GUIPayments:IsShown()
    DebugHelper:Print("GUIPayments:IsShown()")
    if (mainFrame ~= nil) then
        return mainFrame:IsShown()
    else
        return false
    end
end

local function CreateGUI()
    DebugHelper:Print("GUIPayments:CreateGUI()")

    mainFrame = AceGUI:Create("Frame", UIParent)
    mainFrame:Hide()
    _G["IBPT_History"] = mainFrame
    tinsert(UISpecialFrames, "IBPT_History")	-- allow ESC close
    mainFrame:SetWidth(600)
    mainFrame:SetTitle("History")
    mainFrame:EnableResize(false)

    local totalSum = AceGUI:Create("Label")
    totalSum:SetFullWidth(true)
    local text = "Total gold acquired: " .. GetCoinTextureString(Payment:GetTotalSum())
    totalSum:SetText(text)
    mainFrame:AddChild(totalSum)

    CreateTable()

    local resetBtn = AceGUI:Create("Button")
    resetBtn:SetText("Full Reset")
    resetBtn:SetRelativeWidth(0.20)
    resetBtn:SetCallback("OnClick", function() GUIPayments:Reset() end)
    mainFrame:AddChild(resetBtn)
end

function GUIPayments:Show()
    DebugHelper:Print("GUIPayments:Show()")
    if (not GUIPayments:IsShown()) then
        BuildTableContent()
        previousColumnSortIdx = 0
        SortTable(tableContent)
        CreateGUI()
        mainFrame:Show()
        Update()
    else
        mainFrame:Hide()
        mainFrame = nil
    end
end