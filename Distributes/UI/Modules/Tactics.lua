-----------------------------------------------
-- Tactics.lua
--
-- In this file we define battle tectics for our pets!
--
-- Abin
-- 2013-3-24
-----------------------------------------------

local _, addon = ...
local _ = addon.L

local tactics = {}

local function RegisterTactics(key, func)
	tactics[key] = func
end

-----------------------------------------------
-- Hook the "BATTLE_ROUND" event and execute an appropriate tactics function
-----------------------------------------------

addon:RegisterEventCallback("BATTLE_ROUND", function(speciesId, health)
	local func = tactics[speciesId]
	if func then
		func(health)
	end
end)

-----------------------------------------------
-- Zandalari Anklerender
--
-- Abilities:
-- (1) Hunting Party, (2) Leap, (3) Black Claw
-----------------------------------------------

RegisterTactics(1211, function(health)
	local debuff = addon:PetHasAura(1, 918, 1)
	if not debuff then
		if health < addon:GetAmplifiedDamage(1, 400) then
			addon:UsePetAbility(2)
		else
			addon:UsePetAbility(3)
		end
	elseif addon:IsAbilityUsable(1, 1) then
		addon:UsePetAbility(1)
	else
		addon:UsePetAbility(2)
	end
end)

-----------------------------------------------
-- Zandalari Kneebiter
--
-- Abilities:
-- (1) Hunting Party, (2) Black Claw, (3) Bloodfang
-----------------------------------------------

RegisterTactics(1180, function(health)
	local debuff = addon:PetHasAura(1, 918, 1)

	-- If one Bloodfang can kill the opponent then just do it
	local bloodFangDamage = addon:GetAmplifiedDamage(1, (570 + (debuff and 180 or 0)))
	if health < bloodFangDamage and addon:IsAbilityUsable(1, 3) then
		addon:UsePetAbility(3)
		return
	end

	if not debuff and health > 1000 then
		addon:UsePetAbility(2)
	elseif addon:IsAbilityUsable(1, 1) then
		addon:UsePetAbility(1)
	elseif addon:IsAbilityUsable(1, 3) then
		addon:UsePetAbility(3)
	else
		addon:UsePetAbility(2)
	end
end)

-----------------------------------------------
-- Zandalari Footslasher
--
-- Abilities:
-- (1) Hunting Party, (2) Leap, (3) Exposed Wounds
-----------------------------------------------

RegisterTactics(1212, function(health)
	local debuff = addon:PetHasAura(1, 306, 1)
	if not debuff then
		if health < addon:GetAmplifiedDamage(1, 400)  then
			addon:UsePetAbility(2)
		else
			addon:UsePetAbility(3)
		end
	elseif addon:IsAbilityUsable(1, 1) then
		addon:UsePetAbility(1)
	else
		addon:UsePetAbility(2)
	end
end)