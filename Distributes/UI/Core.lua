-----------------------------------------------
-- Core.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local wipe = wipe
local type = type
local pairs = pairs
local format = format
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local ipairs = ipairs
local C_PetBattles = C_PetBattles
local LE_BATTLE_PET_ENEMY = LE_BATTLE_PET_ENEMY
local LE_BATTLE_PET_ALLY = LE_BATTLE_PET_ALLY
local C_PetJournal = C_PetJournal
local GetItemQualityColor = GetItemQualityColor
local PetJournal = PetJournal
local PetJournal_UpdatePetLoadOut = PetJournal_UpdatePetLoadOut
local ITEM_QUALITY_COLORS = ITEM_QUALITY_COLORS
local GetPlayerMapPosition = GetPlayerMapPosition
local sqrt = sqrt
local strtrim = strtrim

local addonName, addon = ...
_G["Cricket"] = addon

local L = addon.L

EmbedEventObject(addon)
addon.version = GetAddOnMetadata(addonName, "Version") or "1.0"
addon.db = {}

local BOSS_POS_X = 0.4053 -- Boss map position x
local BOSS_POS_Y = 0.4366 -- Boss map position y
local BOSS_SPECIES_ID = 1190 -- Boss species id

local FIGHTER_TYPES = {
	[1180] = { ability1 = 921, ability2 = 919, ability3 = 917, priority = 3 },
	[1211] = { ability1 = 921, ability2 = 364, ability3 = 919, priority = 2 },
	[1212] = { ability1 = 921, ability2 = 364, ability3 = 305, priority = 1 },
}

addon.petList = {}

function addon:Print(msg, arg1, ...)
	if not addon.silent and type(msg) == "string" then
		if arg1 then
			msg = format(msg, arg1, ...)
		end

		DEFAULT_CHAT_FRAME:AddMessage("|cffffff78"..L["title"]..":|r "..msg, 0.5, 0.75, 1)
	end
end

local function SortCompare(pet1, pet2)
	if pet1 and pet2 then
		local priority1 = FIGHTER_TYPES[C_PetJournal.GetPetInfoByPetID(pet1)].priority or 0
		local priority2 = FIGHTER_TYPES[C_PetJournal.GetPetInfoByPetID(pet2)].priority or 0
		return priority1 > priority2
	end
end

function addon:UpdatePetList()
	wipe(self.petList)

	local _, count = C_PetJournal.GetNumPets()
	local i
	for i = 1, count do
		local petId, speciesId, owned, _, level = C_PetJournal.GetPetInfoByIndex(i)
		if owned and level >= 25 and FIGHTER_TYPES[speciesId] then
			tinsert(self.petList, petId)
		end
	end

	sort(self.petList, SortCompare)
	self:BroadcastEvent("PetListUpdate")
end

function addon:PickFighter()
	local wounded
	local i
	for i = 1, #self.petList do
		local petId = self.petList[i]
		if C_PetJournal.GetPetStats(petId) >= 1000 then
			return petId
		else
			wounded = 1
		end
	end
	return nil, wounded
end

function addon:GetFighterAbilities(speciesId)
	if type(speciesId) == "string" then
		speciesId = C_PetJournal.GetPetInfoByPetID(speciesId)
	end

	local data = FIGHTER_TYPES[speciesId]
	if data then
		return data.ability1, data.ability2, data.ability3
	end
end

function addon:GetNpcDistance()
	local x, y = GetPlayerMapPosition("player")
	return sqrt((x - BOSS_POS_X) * (x - BOSS_POS_X) + (y - BOSS_POS_Y) * (y - BOSS_POS_Y)) * 10000
end

function addon:IsCricketBattle()
	return C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, 1) == BOSS_SPECIES_ID
end

function addon:GetBattlePetLink(petId)
	if type(petId) == "number" then
		petId = C_PetJournal.GetPetLoadOutInfo(petId)
	end

	if type(petId) == "string" then
		return C_PetJournal.GetBattlePetLink(petId)
	end
end

function addon:GetPetInfo(petId)
	if type(petId) == "number" then
		petId = C_PetJournal.GetPetLoadOutInfo(petId)
	end

	if type(petId) ~= "string" then
		return
	end

	local speciesId, customName, level, _, _, _, _, name, icon, petType, _, sourceText, description, _, canBattle, tradable = C_PetJournal.GetPetInfoByPetID(petId)
	if not canBattle then
		return
	end

	if customName and customName ~= "" then
		name = customName
	end

	local health, maxHealth, attack, speed, rarity = C_PetJournal.GetPetStats(petId)
	rarity = rarity - 1
	local link = C_PetJournal.GetBattlePetLink(petId)
	local r, g, b = GetItemQualityColor(rarity)

	return name, link, icon, speciesId, petType, level, rarity, health, r, g, b, sourceText, description, tradable, maxHealth, attack, speed
end

function addon:GetBattlePetAbilityInfo(petIndex, abilityIndex, enemy)
	local owner = enemy and LE_BATTLE_PET_ENEMY or LE_BATTLE_PET_ALLY
	local id, name, icon = C_PetBattles.GetAbilityInfo(owner, petIndex, abilityIndex)
	if id and name then
		return name, GetBattlePetAbilityHyperlink(id, C_PetBattles.GetMaxHealth(owner, petIndex), C_PetBattles.GetPower(owner, petIndex), C_PetBattles.GetSpeed(owner, petIndex)), icon
	end
end

function addon:SetLoadout(index, petId)
	if petId and C_PetJournal.GetPetLoadOutInfo(index) ~= petId then
		C_PetJournal.SetPetLoadOutInfo(index, petId)
		if PetJournal:IsVisible() then
			PetJournal_UpdatePetLoadOut()
		end
	end
end

function addon:ChooseAbilities(index, ability1, ability2, ability3)
	local _, a1, a2, a3 = C_PetJournal.GetPetLoadOutInfo(index)

	local changed

	if ability1 and ability1 ~= a1 then
		C_PetJournal.SetAbility(index, 1, ability1)
		changed = 1
	end

	if ability2 and ability2 ~= a2 then
		C_PetJournal.SetAbility(index, 2, ability2)
		changed = 1
	end

	if ability3 and ability3 ~= a3 then
		C_PetJournal.SetAbility(index, 3, ability3)
		changed = 1
	end

	if changed and PetJournal:IsVisible() then
		PetJournal_UpdatePetLoadOut()
	end
end

function addon:VerifyAbilities(index, ability1, ability2, ability3)
	local _, a1, a2, a3 = C_PetJournal.GetPetLoadOutInfo(index)

	if ability1 and ability1 ~= a1 then
		return
	end

	if ability2 and ability2 ~= a2 then
		return
	end

	if ability3 and ability3 ~= a3 then
		return
	end

	return 1
end

function addon:IsAbilityUsable(petIndex, abilityIndex, enemy)
	local owner = enemy and LE_BATTLE_PET_ENEMY or LE_BATTLE_PET_ALLY
	local usable, cooldown = C_PetBattles.GetAbilityState(owner, petIndex, abilityIndex)
	return usable, cooldown
end

function addon:IsPetInLoadOut(petId)
	if type(petId) == "string" then
		local i
		for i = 1, 3 do
			if C_PetJournal.GetPetLoadOutInfo(i) == petId then
				return i
			end
		end
	end
end

function addon:CanSwapPet()
	return C_PetBattles.CanActivePetSwapOut()
end

function addon:PetHasAura(index, auraId, enemy)
	if not auraId then
		return
	end

	local owner = enemy and LE_BATTLE_PET_ENEMY or LE_BATTLE_PET_ALLY
	local i
	for i = 1, C_PetBattles.GetNumAuras(owner, index) do
		local id, _, remain, helpful = C_PetBattles.GetAuraInfo(owner, index, i)
		if id == auraId then
			return remain, helpful
		end
	end
end

function addon:GetAmplifiedDamage(petIndex, baseDamage)
	local modifier = self:PetHasAura(1, 542, 1) and 2 or 1
	local beast = self:PetHasAura(petIndex, 237) and 1.25 or 1
	return (baseDamage or 1) * modifier * beast
end

function addon:Reset()
	if C_PetBattles.IsInBattle() then
		addon:Forfeit()
	else
		addon:BroadcastEvent("BATTLE_OVER")
	end
end

local frame = CreateFrame("Frame")
frame:Hide()
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
frame:RegisterEvent("COMPANION_UPDATE")

frame:SetScript("OnEvent", function(self)
	self.elapsed = 0
	self:Show()
end)

frame:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 1 then
		self.elapsed = 0
		self:Hide()
		addon:UpdatePetList()
	end
end)