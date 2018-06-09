-----------------------------------------------
-- MainFrame.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local GameTooltip = GameTooltip
local ipairs = ipairs
local IsShiftKeyDown = IsShiftKeyDown
local C_PetJournal = C_PetJournal
local type = type
local PetJournal = PetJournal
local GetItemQualityColor = GetItemQualityColor
local TogglePetJournal = TogglePetJournal

local addonName, addon = ...
local L = addon.L

BINDING_HEADER_CRICKET_TITLE = L["title"]
BINDING_NAME_CRICKET_ACTION = L["control action"]

-----------------------------------------------
-- Header button
-----------------------------------------------

local header = CreateFrame("Button", "CricketHeader", UIParent)
addon.header = header
header:SetSize(26, 26)
header:SetPoint("BOTTOMRIGHT", UIParent, "CENTER", -50, 100)
header:SetMovable(true)
header:SetUserPlaced(true)
header:SetClampedToScreen(true)
header:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
header:RegisterForDrag("LeftButton")
header:SetScript("OnDragStart", header.StartMoving)
header:SetScript("OnDragStop", header.StopMovingOrSizing)

header:SetScript("OnClick", function(self)
	GameTooltip:Hide()
	addon.frame:Toggle()
end)

header:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine(L["title"])
	GameTooltip:AddLine(L["toggle frame"], 1, 1, 1, 1)
	GameTooltip:Show()
end)

header:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

header.bkgnd = header:CreateTexture(nil, "BORDER")
header.bkgnd:SetAllPoints(header)
header.bkgnd:SetTexture("Interface\\PetBattles\\PetJournal")
header.bkgnd:SetTexCoord(0.06835938, 0.10937500, 0.02246094, 0.04296875)

header.icon = header:CreateTexture(nil, "ARTWORK")
header.icon:SetPoint("TOPLEFT", 4, -4)
header.icon:SetPoint("BOTTOMRIGHT", -4, 4)
header.icon:SetTexture("InterFace\\Icons\\Tracking_WildPet")

-----------------------------------------------
-- Main frame
-----------------------------------------------

local frame = UICreateInterfaceOptionPage("CricketFrame", L["title"], nil, nil, UIParent)
addon.frame = frame
frame:SetDialogStyle("DIALOG", 1)
frame:SetSize(310, 532)
frame:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -2)
frame:SetClampedToScreen(true)
frame:SetBackdrop({ bgFile = "Interface\\FrameGeneral\\UI-Background-Marble", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 } })
frame:SetUserPlaced(true)
frame:SetDontSavePosition(false)

frame:SetScript("OnShow", function(self)
	header:LockHighlight()
end)

------------------------------------------------------
-- I want my frame to be Esc-closable, but I don't want it to be annoyingly
-- closed by Blizzard default UI framework every time a pet battle starts,
-- so here's the solution: check the time duration between frame's "OnHide"
-- script and the "PLAYER_CONTROL_LOST" event, if it's shorter than 1 second
-- we re-open it. Am I a genius or what?
------------------------------------------------------

local hideTime
frame:SetScript("OnHide", function(self)
	header:UnlockHighlight()
	hideTime = GetTime()
end)

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_CONTROL_LOST")

frame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == addonName then
		if type(CricketDB) ~= "table" then
			CricketDB = {}
		end

		addon.db = CricketDB
		addon:BroadcastEvent("INITIALIZE", addon.db)

		local i
		for i = 1, addon.tabFrame:NumTabs() do
			addon:RegisterForDrag(addon.tabFrame:GetTabButton(i))
		end

		addon.tabFrame:SelectTab(1)

	elseif event == "PLAYER_CONTROL_LOST" and not InCombatLockdown() then
		if hideTime and GetTime() - hideTime < 1 and not self:IsShown() then
			self:Show()
		end
	end
end)

function Target_OnDragStart(self)
	frame:StartMoving()
end

function Target_OnDragStop(self)
	frame:StopMovingOrSizing()
end

function addon:RegisterForDrag(target)
	target:EnableMouse(true)
	target:RegisterForDrag("LeftButton")
	target:SetScript("OnDragStart", Target_OnDragStart)
	target:SetScript("OnDragStop", Target_OnDragStop)
end

addon:RegisterForDrag(frame.topClose)

-----------------------------------------------
-- Pet_Journal toggle button
-----------------------------------------------

local toggleButton = CreateFrame("Button", frame:GetName().."Toggle", frame, "UIMenuButtonStretchTemplate")
addon:RegisterForDrag(toggleButton)

toggleButton:SetSize(24, 20)
toggleButton:SetPoint("TOPLEFT", 8, -8)
toggleButton.leftArrow:Show()

toggleButton:SetScript("OnClick", function(self)
	GameTooltip:Hide()
	TogglePetJournal(2)
end)

toggleButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine(PET_JOURNAL)
	GameTooltip:AddLine(BINDING_NAME_TOGGLEPETJOURNAL, 1, 1, 1, 1)
	GameTooltip:Show()
end)

toggleButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

-----------------------------------------------
-- Tab frame
-----------------------------------------------

local tabFrame = UICreateTabFrame(frame:GetName().."TabFrame", frame)
addon.tabFrame = tabFrame
tabFrame:SetPoint("TOPLEFT", 12, -58)
tabFrame:SetPoint("TOPRIGHT", -12, -58)
tabFrame:SetHeight(418)

function tabFrame:OnTabSelected(index, key)
	addon:BroadcastEvent("TAB_SELECTION", key)
end

function addon:AddCategory(text, key, tooltip)
	tabFrame:AddTab(text, key, tooltip)
end

-----------------------------------------------
-- Author info
-----------------------------------------------

local abin = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
abin:SetText("Abin Studio - 2013")
abin:SetFont(STANDARD_TEXT_FONT, 10)
abin:SetTextColor(0.5, 0.5, 0.5)
abin:SetPoint("BOTTOMRIGHT", -16, 12)

-----------------------------------------------
-- Utilities
-----------------------------------------------

local function PressButton_OnClick(self)
	local func = self:GetParent()["On"..self.key]
	if func then
		func(self:GetParent(), IsShiftKeyDown())
	end
end

local function PressButton_OnEnter(self)
	local func = self:GetParent()["OnTooltip"..self.key]
	if not func then
		return
	end

	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self:GetText())
	func(self:GetParent(), GameTooltip)
	GameTooltip:Show()
end

local function PressButton_OnLeave(self)
	GameTooltip:Hide()
end

local function CreatePressButton(parent, text, key)
	local button = frame:CreatePressButton(text)
	button:SetParent(parent)
	button:Disable()
	button:SetSize(90, 22)
	addon:RegisterForDrag(button)
	button.key = key

	if key == "Down" then
		button:SetPoint("TOP", tabFrame, "BOTTOM", 0, -6)
	elseif key == "Up" then
		button:SetPoint("RIGHT", parent.downButton, "LEFT")
	elseif key == "Delete" then
		button:SetPoint("LEFT", parent.downButton, "RIGHT")
	end

	button:SetScript("OnClick", PressButton_OnClick)
	button:SetScript("OnEnter", PressButton_OnEnter)
	button:SetScript("OnLeave", PressButton_OnLeave)

	return button
end

function frame:CreateOperateButtons(parent, textUp, textDown, textDelete)
	parent.downButton = CreatePressButton(parent, textDown, "Down")
	parent.upButton = CreatePressButton(parent, textUp, "Up")
	parent.deleteButton = CreatePressButton(parent, textDelete, "Delete")
	return parent.upButton, parent.downButton, parent.deleteButton
end

------------------------------------------------------------
-- Round counting text
------------------------------------------------------------
local roundFrame = CreateFrame("Frame", "CricketRoundCountFrame", PetBattleFrame)
roundFrame:SetPoint("TOP", 0, -64)
roundFrame:SetSize(40, 40)

local roundText = roundFrame:CreateFontString(roundFrame:GetName().."Text", "BORDER", "ZoneTextFont")
roundText:SetPoint("TOP")
roundText:SetTextColor(0.8, 0.8, 0)

roundFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
roundFrame:RegisterEvent("PET_BATTLE_OPENING_START")
roundFrame:RegisterEvent("PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE")

roundFrame:SetScript("OnEvent", function(self, event, arg1)
	if event == "PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE" then
		roundText:SetFormattedText("%d", (arg1 or 0) + 1)
	else
		roundText:SetText("1")
	end
end)

------------------------------------------------------------
-- Slash command: /halfhill
------------------------------------------------------------

SLASH_CRICKET1 = "/cricketer"
SLASH_CRICKET2 = "/cric"

SlashCmdList["CRICKET"] = function()
	frame:Toggle()
end