-----------------------------------------------
-- Thread.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local _, addon = ...
local L = addon.L

local pickedPetId, pickedAbility1, pickedAbility2, pickedAbility3

local thread = UICreateTickThread()

-- Do not call it in your code, this function is only executed by key press
function addon:StartThread()
	self:AddSpecialLog("READY", L["log team module started"])
	thread:Start("start")
	thread:Sleep(1.5)
	addon:BroadcastEvent("THREAD_START")
end

function addon:StopThread()
	thread:Stop()
	addon:BroadcastEvent("THREAD_STOP")
end

function thread:OnTick(state)
	if state == "start" then
		addon:AddLog(L["log team choosing pets"])
		local petId, wounded = addon:PickFighter()
		if petId then
			pickedPetId = petId
			pickedAbility1, pickedAbility2, pickedAbility3 = addon:GetFighterAbilities(petId)
			self:SetState("form team")
		elseif wounded then
			addon:AddLog(L["log team heal"])
			self:SetState("heal")
		else
			self:Stop()
			addon:NotifyClick("Cricket:StartThread()")
		end

	elseif state == "heal" then
		if addon:HealPets() then
			self:SetState("start")
			self:Sleep(2)
		else
			self:Sleep(1)
		end

	elseif state == "form team" then
		addon:AddLog(L["log team form"])
		addon:SetLoadout(1, pickedPetId)
		self:SetState("check team")

	elseif state == "check team" then
		if addon:IsPetInLoadOut(pickedPetId) == 1 then
			local _, link, icon = addon:GetPetInfo(pickedPetId)
			addon:AddLog(L["log team pet choosing ok"], icon or "", link or "")
			self:SetState("form abilities")
		else
			self:SetState("form team")
		end

	elseif state == "form abilities" then
		addon:AddLog(L["log team choose abilities"])
		addon:ChooseAbilities(1, pickedAbility1, pickedAbility2, pickedAbility3)
		self:SetState("check abilities")

	elseif state == "check abilities" then
		if addon:VerifyAbilities(1, pickedAbility1, pickedAbility2, pickedAbility3) then
			addon:AddLog(L["log team ready"])
			self:SetState("target")
		else
			self:SetState("form abilities")
		end

	elseif state == "target" then

		if addon:TargetNpc() then
			self:SetState("interact")
		end

	elseif state == "interact" then
		if addon:IsNpcTargeted() then
			addon:InteractNpc()
			self:Sleep(1.5)
		else
			self:SetState("target")
		end
	end
end

addon:RegisterEventCallback("BATTLE_OVER", function()
	addon:StopThread()
	addon:AddLog(L["log wait thread start"])
	addon:NotifyClick("Cricket:StartThread()")
end)

addon:RegisterEventCallback("PETLIST_CHANGED", function()
	if thread:GetState() then
		addon:AddLog(L["log team pet list changed"])
		addon:StartThread()
	end
end)

addon:RegisterEventCallback("BATTLE_START", function()
	addon:StopThread()
end)

if AutoLFD then
	AutoLFD:RegisterEventCallback("OnDungeonEntered", function()
		addon:StopThread()
	end)
end