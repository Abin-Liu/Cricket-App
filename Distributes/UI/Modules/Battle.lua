-----------------------------------------------
-- Battle.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local GetTime = GetTime
local C_PetBattles = C_PetBattles
local LE_BATTLE_PET_ALLY = LE_BATTLE_PET_ALLY
local LE_BATTLE_PET_ENEMY = LE_BATTLE_PET_ENEMY

local _, addon = ...
local L = addon.L

local startTime

local manager = EmbedEventObject()
addon.battleManager = manager

manager:RegisterEvent("PET_BATTLE_OPENING_START")

function manager:PET_BATTLE_OPENING_START()
	startTime = nil
	addon:ClearPixel()
	if not addon:IsCricketBattle() then
		return
	end

	startTime = GetTime()
	addon:StopThread()
	addon:AddSpecialLog("SYSTEM", L["log battle started"])
	addon:BroadcastEvent("BATTLE_START")
	self:RegisterEvent("PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE")
	self:RegisterEvent("PET_BATTLE_CLOSE")
end

function manager:PET_BATTLE_CLOSE()
	self:UnregisterEvent("PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE")
	self:UnregisterEvent("PET_BATTLE_CLOSE")
	addon:ClearPixel()
	addon:StopThread()

	if not addon:IsActivated() then
		return
	end

	if startTime then
		local totalTime = GetTime() - startTime
		if totalTime > 0 then
			addon:AddSpecialLog("SYSTEM", L["log battle total time"], totalTime)
		end
		startTime = nil
	end

	addon:AddSpecialLog("SYSTEM", L["log battle over"])
	addon:BroadcastEvent("BATTLE_OVER")
end

local function GetHealthFlag(index, enemy)
	local health = C_PetBattles.GetHealth(enemy and LE_BATTLE_PET_ENEMY or LE_BATTLE_PET_ALLY, index) or 0
	if health > 0 then
		return health
	end
end

function manager:PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE(arg1)
	addon:ClearPixel()
	if not addon:IsCricketBattle() then
		return
	end

	local enemyHealth = GetHealthFlag(1, 1)
	if not enemyHealth then
		addon:AddSpecialLog("READY", L["log battle won"])
		return -- we won
	end

	local round = (arg1 or 0) + 1
	addon:AddSpecialLog("SYSTEM", L["log battle round"], round)

	if round > 40 then
		-- Something went wrong
		addon:Forfeit()
		return
	end

	if C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY) ~= 1 or not GetHealthFlag(1) then
		addon:Forfeit()
		return
	end

	if not C_PetBattles.IsSkipAvailable() then
		addon:AddLog(L["log not controlled"])
		return
	end

	local speciesId = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ALLY, 1)
	if not addon:GetFighterAbilities(speciesId) then
		addon:Forfeit()
		return
	end


	addon:BroadcastEvent("BATTLE_ROUND", speciesId, enemyHealth)
end