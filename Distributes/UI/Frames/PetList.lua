-----------------------------------------------
-- PetList.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local GameTooltip = GameTooltip
local ipairs = ipairs
local UNKNOWN = UNKNOWN
local PetJournal_ShowPetCardByID = PetJournal_ShowPetCardByID
local C_PetJournal = C_PetJournal
local ChatEdit_InsertLink = ChatEdit_InsertLink
local IsAltKeyDown = IsAltKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local PetJournal = PetJournal
local TogglePetJournal = TogglePetJournal

local _, addon = ...
local L = addon.L

addon:AddCategory(L["pets"], "pets")

local frame = UICreateVirtualScrollList(addon.frame:GetName().."List", addon.tabFrame, 8, 1)
addon.listFrame = frame
addon:RegisterForDrag(frame)
frame:SetPoint("TOPLEFT", 8, -8)
frame:SetPoint("BOTTOMRIGHT", -8, 8)

function frame:OnButtonCreated(button)
	button:SetHeight(50)

	button.bkgnd = button:CreateTexture(nil, "BACKGROUND")
	button.bkgnd:SetPoint("TOPLEFT")
	button.bkgnd:SetPoint("BOTTOMRIGHT", -2, 0)
	button.bkgnd:SetTexture("Interface\\PetBattles\\PetJournal")
	button.bkgnd:SetTexCoord(0.49804688, 0.90625, 0.12792969, 0.17285156)

	button.typeIcon = button:CreateTexture(nil, "BORDER")
	button.typeIcon:SetSize(90 * 50 / 44, 50)
	button.typeIcon:SetPoint("RIGHT", -2, 0)
	button.typeIcon:SetTexCoord(0.0078125, 0.7109375, 0.74609375, 0.91796875)

	button.loadOutIcon = button:CreateTexture(nil, "ARTWORK")
	button.loadOutIcon:Hide()
	button.loadOutIcon:SetSize(20, 20)
	button.loadOutIcon:SetPoint("RIGHT", -6, 0)
	button.loadOutIcon:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")

	button.name = button:CreateFontString(nil, "ARTWORK", "GameFontNormalLeft")
	button.name:SetPoint("LEFT", 44, 0)
	button.name:SetPoint("RIGHT", -6, 0)

	local child = CreateFrame("Frame", nil, button)
	child:SetSize(36, 36)
	child:SetPoint("TOPLEFT", 4, -2)

	button.icon = child:CreateTexture(nil, "BACKGROUND")
	button.icon:SetAllPoints(child)

	button.dead = child:CreateTexture(nil, "BORDER")
	button.dead:SetAllPoints(button.icon)
	button.dead:SetTexture("Interface\\PetBattles\\DeadPetIcon")

	button.levelBg = child:CreateTexture(nil, "ARTWORK")
	button.levelBg:SetSize(17, 17)
	button.levelBg:SetPoint("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 4, -4)
	button.levelBg:SetTexture("Interface\\PetBattles\\PetJournal")
	button.levelBg:SetTexCoord(0.06835938, 0.10937500, 0.02246094, 0.04296875)

	button.level = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	button.level:SetPoint("CENTER", button.levelBg, "CENTER", 1, -1)
	button.level:SetFont(STANDARD_TEXT_FONT, 11)

	local healthBar = CreateFrame("StatusBar", button:GetName().."HealthBar", button)
	button.healthBar = healthBar
	healthBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	healthBar:SetStatusBarColor(0, 1, 0)
	healthBar:SetSize(36, 7)
	healthBar:SetPoint("TOP", child, "BOTTOM", 0, -3)
	healthBar:SetMinMaxValues(0, 1)
	healthBar:SetValue(1)

	local hbLeft = healthBar:CreateTexture(healthBar:GetName().."Left", "OVERLAY")
	hbLeft:SetSize(11, 7)
	hbLeft:SetPoint("RIGHT", healthBar, "LEFT", 9, 0)
	hbLeft:SetTexture("Interface\\PetBattles\\PetJournal")
	hbLeft:SetTexCoord(0.04492188, 0.06640625, 0.00097656, 0.00781250)

	local hbRight = healthBar:CreateTexture(healthBar:GetName().."Right", "OVERLAY")
	hbRight:SetSize(11, 7)
	hbRight:SetPoint("LEFT", healthBar, "RIGHT", -9, 0)
	hbRight:SetTexture("Interface\\PetBattles\\PetJournal")
	hbRight:SetTexCoord(0.07031250, 0.09179688, 0.00097656, 0.00781250)

	local hbMiddle = healthBar:CreateTexture(healthBar:GetName().."Middle", "OVERLAY")
	hbMiddle:SetPoint("TOPLEFT", hbLeft, "TOPRIGHT")
	hbMiddle:SetPoint("BOTTOMRIGHT", hbRight, "BOTTOMLEFT")
	hbMiddle:SetTexture("Interface\\PetBattles\\PetJournal")
	hbMiddle:SetTexCoord(0.01953125, 0.04101563, 0.00097656, 0.00781250)

	addon:RegisterForDrag(button)
end

function frame:OnButtonUpdate(button, petId)
	local name, link, icon, speciesId, petType, level, rarity, health, r, g, b, sourceText, description, tradable, maxHealth, attack, speed = addon:GetPetInfo(petId)
	if name then
		button.icon:SetTexture(icon)
		button.typeIcon:SetTexture(GetPetTypeTexture(petType))
		button.typeIcon:Show()
		button.name:SetText(name)
		button.name:SetTextColor(r, g, b)
		button.level:SetFormattedText("%d", level)
		if health > 0 then
			button.dead:Hide()
		else
			button.dead:Show()
		end

		if addon:IsPetInLoadOut(petId) then
			button.loadOutIcon:Show()
		else
			button.loadOutIcon:Hide()
		end

		button.healthBar:SetMinMaxValues(0, maxHealth)
		button.healthBar:SetValue(health)
		button.healthBar:Show()
	else
		button.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
		button.typeIcon:Hide()
		button.name:SetText(UNKNOWN)
		button.name:SetTextColor(1, 0.1, 0.1)
		button.level:SetText()
		button.dead:Hide()
		button.loadOutIcon:Hide()
		button.healthBar:Hide()
	end
end

function frame:OnSelectionChanged(selection, petId)
	if selection then
		PetJournal_ShowPetCardByID(petId)
	end
end

function frame:OnButtonTooltip(button, petId)
	local name, link, icon, speciesId, petType, level, rarity, health, r, g, b, sourceText, description, tradable = addon:GetPetInfo(petId)
	if not name then
		return
	end

	GameTooltip:AddLine(name, r, g, b)

	if sourceText and sourceText ~= "" then
		GameTooltip:AddLine(sourceText, 1, 1, 1, 1)
	end

	if not tradable then
		GameTooltip:AddLine(BATTLE_PET_NOT_TRADABLE, 1, 0.1, 0.1, 1)
	end

	if description and description ~= "" then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(description, nil, nil, nil, 1)
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L["add to team"], 0.5, 0.75, 1, 1)
end

function frame:OnButtonClick(button, petId, flag)
	if flag ~= "LeftButton" then
		return
	end

	if IsShiftKeyDown() then
		local link = C_PetJournal.GetBattlePetLink(petId)
		if link then
			ChatEdit_InsertLink(link)
		end
	elseif IsAltKeyDown() then
		addon:SetLoadout(1, petId)
	end
end

function frame:OnButtonDoubleClick(button, petId)
	PetJournal_ShowPetCardByID(petId)
	if PetJournalParent:IsShown() then
		PetJournalParentTab2:Click()
	else
		TogglePetJournal(2)
	end
end

addon:RegisterEventCallback("PetListUpdate", function()
	frame:BindDataList(addon.petList)
end)

addon:RegisterEventCallback("TAB_SELECTION", function(key)
	if key == "pets" then
		frame:Show()
	else
		frame:Hide()
	end
end)

------------------------------------------------------------
-- Hook Pet_Journal list buttons
------------------------------------------------------------

local function FindPetInQueue(petId)
	return initDone and petId and (addon:IsPetInQueue("youngling", petId) or addon:IsPetInQueue("fighter1", petId) or addon:IsPetInQueue("fighter2", petId))
end

local function UpdatePetJournal()
	local i
	for i = 1, 100 do
		local button = _G["PetJournalListScrollFrameButton"..i]
		if not button then
			return
		end

		local petId = button.petID

		local result, _, _, _, _, rarity = pcall(C_PetJournal.GetPetStats, petId)
		local r, g, b = GetItemQualityColor((rarity or 2) - 1)
		button.name:SetTextColor(r, g, b)

		local queued = FindPetInQueue(button.petID)

		local flag = button.__CricketFlag
		if not flag then
			flag = button:CreateTexture(nil, "OVERLAY")
			button.__CricketFlag = flag
			flag:SetSize(24, 24)
			flag:SetPoint("RIGHT", -6, 0)
			flag:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
		end

		if queued then
			flag:Show()
		else
			flag:Hide()
		end
	end
end

addon:RegisterEventCallback("PetListUpdate", UpdatePetJournal)

hooksecurefunc("HybridScrollFrame_Update", function(scrollFrame)
	if scrollFrame == PetJournal.listScroll then
		UpdatePetJournal()
	end
end)