-----------------------------------------------
-- ActionFrame.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local InCombatLockdown = InCombatLockdown
local ClearOverrideBindings = ClearOverrideBindings
local GetBindingKey = GetBindingKey
local SetOverrideBindingClick = SetOverrideBindingClick
local format = format
local type = type
local UnitName = UnitName
local strfind = strfind
local GetCurrentMapAreaID = GetCurrentMapAreaID
local C_PetBattles = C_PetBattles
local LE_BATTLE_PET_ALLY = LE_BATTLE_PET_ALLY
local LE_BATTLE_PET_ENEMY = LE_BATTLE_PET_ENEMY

local _, addon = ...
local L = addon.L

local lib = _G.LibActionPixel

local frame = lib:CreatePixelFrame("CricketPixelFrame", UIParent, "TOP")
addon.pixelFrame = frame
frame:HidePixel()
frame:Hide()

local actionButton = lib:CreateActionButton(frame, frame:GetName().."ActionButton", "CRICKET_ACTION")
addon.actionButton = actionButton

actionButton:SetScript("PostClick", function(self)
	frame:HidePixel()
end)

local wasAcivated
function addon:IsActivated()
	return wasAcivated
end

local function Activate()
	if wasAcivated then
		return
	end

	wasAcivated = 1
	addon:Reset()
	frame:SetAlpha(1)
	addon:AddSpecialLog("STARTUP", L["log manager activate"])
	addon:AddSpecialLog("SYSTEM", L["log all states"])
end

local function Deactivate()
	if not wasAcivated then
		return
	end

	wasAcivated = nil
	frame:SetAlpha(0)
	addon:StopThread()
	addon:AddSpecialLog("STARTUP", L["log manager deactivate"])
end

function frame:OnTick()
	if addon:GetNpcDistance() < 100 then
		Activate()
	else
		Deactivate()
	end
end

frame:SetScript("OnShow", frame.OnTick)
frame:SetScript("OnHide", Deactivate)

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("ZONE_CHANGED")

frame:SetScript("OnEvent", function(self, event)
	if GetCurrentMapAreaID() == 807 then
		self:Show()
	else
		self:Hide()
	end
end)

function addon:ClearPixel()
	frame:HidePixel()
end

function addon:NotifySpecialClick(color)
	frame:ShowPixel(color)
end

function addon:NotifyClick(snippet, arg1, ...)
	if snippet == 1 or snippet == 2 or snippet == 3 then
		actionButton:SetAction("C_PetBattles.UseAbility(%d)", snippet)
	else
		actionButton:SetAction(snippet, arg1, ...)
	end
	frame:ShowPixel("BLUE")
end

function addon:UsePetAbility(index)
	local name, link, icon = addon:GetBattlePetAbilityInfo(C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY), index)
	addon:AddLog(L["log battle using ability"], icon, link)
	addon:NotifyClick(index)
end

function addon:Forfeit()
	addon:AddLog(L["log battle forfeit"])
	addon:NotifyClick("C_PetBattles.ForfeitGame()")
end

function addon:ChangePet(index)
	local _, link, icon = addon:GetPetInfo(index)
	addon:AddLog(L["log battle change pet"], icon, link)
	addon:NotifyClick("C_PetBattles.ChangePet(%d)", index)
end

function addon:IsNpcTargeted()
	return UnitName("target") == L["boss name"]
end

function addon:TargetNpc()
	if self:IsNpcTargeted() then
		return 1
	end

	addon:AddLog(L["log interact targeting npc"])
	addon:NotifyClick("/targetexact "..L["boss name"])
end

function addon:InteractNpc()
	addon:AddLog(L["log interact interacting"])
	addon:NotifySpecialClick("YELLOW") -- interact
end

-- To avoid multiple interacting in a short duration which raises the risk of being detected by Blizzard
hooksecurefunc("InteractUnit", function(unit)
	if unit == "target" and addon:IsNpcTargeted() then
		frame:HidePixel()
	end
end)