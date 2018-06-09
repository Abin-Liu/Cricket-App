-----------------------------------------------
-- Healing.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local GetSpellCooldown = GetSpellCooldown
local GetTime = GetTime
local max = max
local GetItemCount = GetItemCount
local GetItemInfo = GetItemInfo

local _, addon = ...
local L = addon.L

local SPELL_ID = 125439
local SPELL_NAME, _, SPELL_ICON = GetSpellInfo(SPELL_ID)
local SPELL_LINK = GetSpellLink(SPELL_ID)

local BANDAGE_ID = 86143
local bandageName, bandageLink, bandageIcon

local function UpdateBandageInfo()
	if not bandageName then
		local _
		bandageName, bandageLink, _, _, _, _, _, _, _, bandageIcon = GetItemInfo(BANDAGE_ID)
	end
end

UpdateBandageInfo()
addon:RegisterEventCallback("INITIALIZE", UpdateBandageInfo)
addon:RegisterEventCallback("THREAD_START", UpdateBandageInfo)
addon:RegisterEventCallback("BATTLE_OVER", UpdateBandageInfo)

function addon:GetHealingSpellCooldown()
	local start, duration, enable = GetSpellCooldown(SPELL_ID)
	local cooldown = 0
	if start > 0 then
		cooldown = max(0, start + duration - GetTime())
	end
	return cooldown
end

function addon:HealPets()
	local cooldown = self:GetHealingSpellCooldown()
	if cooldown == 0 then
		addon:AddLog(L["log team cast heal"], SPELL_ICON, SPELL_LINK)
		addon:NotifyClick("/cast "..SPELL_NAME)
		return 1
	end

	addon:AddLog(L["log team heal cooldown"], SPELL_ICON, SPELL_LINK, cooldown)

	if cooldown > 20 and bandageName and GetItemCount(BANDAGE_ID) > 0 then
		addon:AddLog(L["log use bandage"], bandageIcon, bandageLink)
		addon:NotifyClick("/use "..bandageName)
		return 2
	end

	-- In other cases just sit and wait...
end