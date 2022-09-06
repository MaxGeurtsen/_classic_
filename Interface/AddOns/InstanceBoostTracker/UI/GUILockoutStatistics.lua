local AceGUI = LibStub("AceGUI-3.0")
local mainFrame = nil
local scroll = nil
local tableContent = nil
local columns = {}
GUILockoutStatistics = {}

local previousColumnSortIdx = 0
local function SortTable(t, columnName)
    DebugHelper:Print("GUILockoutStatistics:SortTable()")
    local columnIdx = columns[columnName] or 1

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

local function BuildTableContent(instanceStatistics)
    DebugHelper:Print("GUILockoutStatistics:BuildTableContent()")

    tableContent = {}

    for playerName, statistics in pairs(instanceStatistics) do
        local object = { playerName, statistics.Experience, statistics.Gold, statistics.Reputation, statistics.Kills }
        table.insert(tableContent, object)
    end
end

local function Update()
    DebugHelper:Print("GUILockoutStatistics:Update()")

    local buttons = HybridScrollFrame_GetButtons(scroll)
    local maxRecords = table.getn(buttons)
    local rowCount = table.getn(tableContent)
    local scrollOffset = HybridScrollFrame_GetOffset(scroll)

    for index = 1, rowCount do
        local curRowIndex = index + scrollOffset
        -- we shouldn't exceed the maxrecords amount otherwise we'll post or retrieve info outside of our bounds
        if (index > maxRecords or curRowIndex > rowCount) then
            break
        end
        
        local playerName, experience, gold, reputation, kills = unpack(tableContent[curRowIndex])
        local button = buttons[index]
        button.PlayerName:SetText(playerName)
        button.Experience:SetText(experience)
        button.Gold:SetText(GetCoinTextureString(gold))
        button.Reputation:SetText(reputation)
        button.Kills:SetText(kills)
        button:Show()
    end
    
    local buttonHeight = scroll.buttonHeight;
	local totalHeight = rowCount * buttonHeight;
	local shownHeight = maxRecords * buttonHeight;

	HybridScrollFrame_Update(scroll, totalHeight, shownHeight);
end

function GUILockoutStatistics:ForceUpdate()
    Update()
end

local function AddScroll(tableContentGroup)
    DebugHelper:Print("GUILockoutStatistics:AddScroll()")
    scroll = CreateFrame("ScrollFrame", nil, tableContentGroup.frame, "LockoutStatistics")
	HybridScrollFrame_CreateButtons(scroll, "LockoutStatisticsItemTemplate");
	HybridScrollFrame_SetDoNotHideScrollBar(scroll, true)
    scroll.update = function() 
        Update() 
    end
end

local amountOfColumns = 0
local function CreateColumn(header, columnName, width)
    DebugHelper:Print("GUILockoutStatistics:CreateColumn()")
    width = width or 150

    amountOfColumns = amountOfColumns + 1
    columns[columnName] = amountOfColumns

    local btn = AceGUI:Create("InteractiveLabel")
    btn:SetCallback("OnClick", function() 
        DebugHelper:Print("Sorting on "..columnName)
        SortTable(tableContent, columnName)
        Update()
    end)
	btn:SetWidth(width)
	btn:SetText(LuaHelper:ColorizeStr(columnName, "CYAN"))
	header:AddChild(btn)
end

local function CreateHeader()
    DebugHelper:Print("GUILockoutStatistics:CreateHeader()")
    local header = AceGUI:Create("SimpleGroup")
	header:SetFullWidth(true)
	header:SetLayout("Flow")
	mainFrame:AddChild(header)

    amountOfColumns = 0
    CreateColumn(header, "Player name", 100)
    CreateColumn(header, "Experience", 100)
    CreateColumn(header, "Gold", 120)
    CreateColumn(header, "Reputation", 100)
    CreateColumn(header, "Kills", 50)

    return header
end

local function CreateTable()
    DebugHelper:Print("GUILockoutStatistics:CreateTable()")
    local tableHeader = CreateHeader()

    tableContentGroup = AceGUI:Create("SimpleGroup")
	tableContentGroup:SetFullWidth(true)
	tableContentGroup:SetHeight(200)
	tableContentGroup:SetLayout("Fill")
	mainFrame:AddChild(tableContentGroup)
	tableContentGroup:ClearAllPoints()
	tableContentGroup.frame:SetPoint("TOP", tableHeader.frame, "BOTTOM", 0, -5)
    tableContentGroup.frame:SetPoint("BOTTOM", 0, 20)
    AddScroll(tableContentGroup)
end

function GUILockoutStatistics:IsShown()
    DebugHelper:Print("GUILockoutStatistics:IsShown()")
    if (mainFrame ~= nil) then
        return mainFrame:IsShown()
    else
        return false
    end
end

local function CreateGUI(instanceId)
    DebugHelper:Print("GUILockoutStatistics:CreateGUI()")

    mainFrame = AceGUI:Create("Frame", UIParent)
    mainFrame:Hide()
    _G["IBPT_Statistics"] = mainFrame
    tinsert(UISpecialFrames, "IBPT_Statistics")	-- allow ESC close
    mainFrame:SetWidth(550)
    mainFrame:SetHeight(300)
    mainFrame:SetTitle("Statistics - "..instanceId)
    mainFrame:EnableResize(false)

    CreateTable()
end

function GUILockoutStatistics:Create(instanceId)
    DebugHelper:Print("GUILockoutStatistics:Show()")

    local instanceStatistics = Statistics:GetAllStatisticsFor(instanceId)
    if instanceStatistics then
        if (not GUILockoutStatistics:IsShown()) then
            BuildTableContent(instanceStatistics)
            previousColumnSortIdx = 0
            SortTable(tableContent)
            CreateGUI(instanceId)
            mainFrame:Show()
            Update()
        else
            mainFrame:Hide()
            mainFrame = nil
        end
    end
end