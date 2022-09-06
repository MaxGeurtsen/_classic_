local AceGUI = LibStub("AceGUI-3.0")
local mainFrame = nil
local scroll = nil
local tableContent = nil
GUILockouts = {}

local previousColumnSortIdx = 0
local function SortTable(t, columnIdx)
    DebugHelper:Print("GUILockouts:SortTable()")
    local columnIdx = columnIdx or 5

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
    DebugHelper:Print("GUILockouts:BuildTableContent()")

    tableContent = {}

    for id, lockout in pairs(LockoutTracker:UpdateAndGetAllLockouts()) do
        local playerName = ""
        if lockout.playerName ~= nil then
            playerName = lockout.playerName
        end

        local startDateTime = lockout.startDateTime
        local startDateTimeStr = "UNKNOWN"
        if startDateTime ~= nil then
            startDateTimeStr = startDateTime.year.."/"..startDateTime.month.."/"..startDateTime.day.." - "..startDateTime.hour..":"..startDateTime.minute..":"..startDateTime.second
        end

        local endDateTime = lockout.endDateTime
        local endDateTimeStr = "UNKNOWN"
        if endDateTime ~= nil then
            endDateTimeStr = endDateTime.year.."/"..endDateTime.month.."/"..endDateTime.day.." - "..endDateTime.hour..":"..endDateTime.minute..":"..endDateTime.second
        end

        local timeTaken = ">0"
        if startDateTime and endDateTime then
            local duration = DateTimeHelper:FromTable(endDateTime) - DateTimeHelper:FromTable(startDateTime)

            if duration:gethours() >= 1 then
                timeTaken = ">60"
            else
                local minutes = tostring(duration:getminutes())
                if string.len(minutes) < 2 then
                    minutes = "0"..minutes
                end

                local seconds = tostring(duration:getseconds())
                if string.len(seconds) < 2 then
                    seconds = "0"..seconds
                end

                timeTaken = minutes..":"..seconds
            end
        end

        local strColor = "|cffffffff"
        if (DateTimeHelper:FromTable(endDateTime) < DateTimeHelper:Now():addhours(-1)) then
            strColor = "|cffa0a0a0"
        end

        local object = { id, playerName, lockout.instanceName or "", startDateTimeStr, endDateTimeStr, timeTaken, strColor }
        table.insert(tableContent, object)
    end
end

-- https://wowwiki.fandom.com/wiki/UI_Object_UIDropDownMenu
-- creating test data structure
local MenuOptions = {
    ["Statistics"] = {},
    ["Delete"] = {},
}

local function DropDownOnClick(self, arg1, arg2, checked)
    if self.value.Key == "Statistics" then
        GUILockoutStatistics:Create(selectedLine.InstanceId)
    elseif self.value.Key == "Delete" then
        AccountLockout:Delete(selectedLine.InstanceId, function() 
            if mainFrame then
                mainFrame:Hide()
                mainFrame = nil
            end
            GUILockouts:Show()
        end)
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
    DebugHelper:Print("GUILockouts:Update()")

    local buttons = HybridScrollFrame_GetButtons(scroll)
    local maxRecords = table.getn(buttons)
    local rowCount = table.getn(tableContent)
    local scrollOffset = HybridScrollFrame_GetOffset(scroll)

    for index = 1, rowCount do
        local curRowIndex = index + scrollOffset
        if curRowIndex > rowCount then
            local b = buttons[index]
            if b then
                b.Id:SetText(nil)
                b.Character:SetText(nil)
                b.InstanceName:SetText(nil)
                b.StartDateTime:SetText(nil)
                b.EndDateTime:SetText(nil)
                b.TimeTaken:SetText(nil)
            end
            break
        end

        local id, character, instance, startDateTime, endDateTime, timeTaken, strColor = unpack(tableContent[curRowIndex])
        local button = buttons[index]
        if button then
            button.Id:SetText(strColor..tostring(id))
            button.Character:SetText(strColor..tostring(character))
            button.InstanceName:SetText(strColor..tostring(instance))
            button.StartDateTime:SetText(strColor..tostring(startDateTime))
            button.EndDateTime:SetText(strColor..tostring(endDateTime))
            button.TimeTaken:SetText(strColor..tostring(timeTaken))

            -- https://wowwiki.fandom.com/wiki/UIHANDLER_OnClick
            button:RegisterForClicks("AnyUp")
            button:SetScript("OnClick", function (self, button)
                local dropDown = CreateFrame("Frame", "DropDownValues", UIParent, "UIDropDownMenuTemplate", BackdropTemplateMixin and "BackdropTemplate")
                dropDown:Hide()

                selectedLine = { InstanceId = id }
                DebugHelper:Print("-> Clicked on lockout ID "..id)

                -- Check if we don't exceed our bounds before applying button functionality
                if curRowIndex <= table.getn(tableContent) then
                    if button == "RightButton" then
                        UIDropDownMenu_Initialize(dropDown, DropDownInitialize, "MENU")
                        ToggleDropDownMenu(1, nil, dropDown, "cursor")
                    elseif button == "LeftButton" then
                        GUILockoutStatistics:Create(id)
                    end
                end
            end)
            button:Show()
        end
    end
    
    local buttonHeight = scroll.buttonHeight;
	local totalHeight = rowCount * buttonHeight;
	local shownHeight = maxRecords * buttonHeight;

	HybridScrollFrame_Update(scroll, totalHeight, shownHeight);
end

function GUILockouts:ForceUpdate()
    Update()
end

local function CreateTableHeader()
    DebugHelper:Print("GUILockouts:CreateTableHeader()")
    local header = TableHelper:CreateHeader(mainFrame)

    TableHelper:CreateColumns(header, { 
        { "Id", 70 }, 
        { "Character", 80 },
        { "Instance name", 240 },
        { "Start date time", 175 },
        { "End date time", 175 },
        { "TT", 50 }
    }, function(columnIdx) 
        SortTable(tableContent, columnIdx)
        Update()
    end)

    return header
end

local function CreateTable()
    DebugHelper:Print("GUILockouts:CreateTable()")

    local tableHeader = CreateTableHeader()
    tableContentGroup = AceGUI:Create("SimpleGroup")
	tableContentGroup:SetFullWidth(true)
	tableContentGroup:SetHeight(400)
	tableContentGroup:SetLayout("Fill")
    
	mainFrame:AddChild(tableContentGroup)
    
	tableContentGroup:ClearAllPoints()
	tableContentGroup.frame:SetPoint("TOP", tableHeader.frame, "BOTTOM", 0, -5)
    tableContentGroup.frame:SetPoint("BOTTOM", 0, 20)

    scroll = TableHelper:AddScroll(tableContentGroup, "InstanceLockoutHistory", "InstanceLockoutHistoryItemTemplate", function() 
        GUILockouts:ForceUpdate() 
    end)
end

function GUILockouts:IsShown()
    DebugHelper:Print("GUILockouts:IsShown()")
    if (mainFrame ~= nil) then
        return mainFrame:IsShown()
    else
        return false
    end
end

local function CreateGUI()
    DebugHelper:Print("GUILockouts:CreateGUI()")

    mainFrame = AceGUI:Create("Frame", UIParent)
    mainFrame:Hide()
    _G["IBPT_Lockouts"] = mainFrame
    tinsert(UISpecialFrames, "IBPT_Lockouts")	-- allow ESC close
    mainFrame:SetWidth(860)
    mainFrame:SetTitle("Lockouts")
    mainFrame:EnableResize(false)

    local lockoutLabel = AceGUI:Create("Label")
    lockoutLabel:SetFullWidth(true)

    local text = "Hourly: "..LockoutTracker:CalculateHourlyLockouts().."/5"
    if LockoutTracker:CalculateHourlyLockouts() >= 4 or LockoutTracker:CalculateDailyLockouts() >= 30 then
        text = text..", "..LockoutTracker:CreateNextReadableLockoutTimer()
    end

    lockoutLabel:SetText(text)
    mainFrame:AddChild(lockoutLabel)

    CreateTable()
end

function GUILockouts:Show()
    DebugHelper:Print("GUILockouts:Show()")
    if not GUILockouts:IsShown() then
        mainFrame = nil
        BuildTableContent()
        -- Resetting the previously sorted column so we can sort descending on the default column.
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