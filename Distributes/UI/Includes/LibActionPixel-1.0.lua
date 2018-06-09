-----------------------------------------------------------
-- LibActionPixel-1.0.lua
-----------------------------------------------------------

-- Creates pixel frames to transmit game information between in-game addons
-- and out-game bot programs, through colors of special corners.
--
-- Abin (2010-1-27)

-----------------------------------------------------------
-- API Documentation:
-----------------------------------------------------------

-- local lib = _G.LibActionPixel -- Acquire a reference to this library

-- local actionButton = lib:CreateActionButton(ownerFrame, "name", "actionName")

-- button:SetSpell("name") -- string: spell name
-- button:SetItem("name") -- string: item name
-- button:SetItem(inventoryId) -- number: inventory id
-- button:SetItem(bag, slot) -- number: bag and slot
-- button:SetMacro("text") -- string: macro text
-- button:SetAction("text", arg1, ...) -- string: macro text, altomatically call format("text", arg1, ...) if arg1 presents

-- local pixel = lib:CreatePixelFrame("name", parent, "POINT" [, "COLOR" [, "layer"]])
-- pixel:SetColor("COLOR")
-- pixel:ShowPixel(["COLOR"])
-- pixel:HidePixel()
-- pixel:DelayHide(duration)

-- local frame = lib:CreateAlertPixelFrame("name", "POINT" [, hasIcon [, duration]])
-- frame:SetText("text" [, r, g, b])
-- frame:SetIcon("icon") -- Only valid when "hasIcon" is specified in "UICreateAlertPixelFrame"

-----------------------------------------------------------
-- Callback Methods:
-----------------------------------------------------------

-- pixel:OnTick() -- Called approximately every 0.2 second during shown
-- pixel:OnDelayHide() -- Called when delayed hidden

-----------------------------------------------------------

local type = type
local GetTime = GetTime
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local ClearOverrideBindings = ClearOverrideBindings
local GetBindingKey = GetBindingKey
local SetOverrideBindingClick = SetOverrideBindingClick
local format = format
local strsub = strsub
local tinsert = tinsert
local UIParent = UIParent
local WorldFrame = WorldFrame
local UISpecialFrames = UISpecialFrames
local OKAY = OKAY

local VERSION = 1.3

local lib = _G.LibActionPixel
if lib and lib.version >= VERSION then return end

lib = { version = VERSION }
_G.LibActionPixel = lib

-- Pixel colors are limited to the following 4 values, other complicated colors may not be correctly
-- recognized by the out-game programs
local COLOR_NAMES = {
	RED =		{ r = 1, g = 0, b = 0 }, -- Red
	GREEN =		{ r = 0, g = 1, b = 0 }, -- Green
	BLUE =		{ r = 0, g = 0, b = 1 }, -- Blue
	YELLOW =	{ r = 1, g = 1, b = 0 }, -- Yellow

	-- Purple and cyan are reserved as alert signal colors
	ALERT_START = { r = 1, g = 0, b = 1 }, -- Purple, alert start
	ALERT_STOP = { r = 0, g = 1, b = 1 }, -- Cyan, alert stop
}

local function Button_SetSpell(self, name)
	if not InCombatLockdown() then
		self:SetAttribute("type", "spell")
		self:SetAttribute("spell", name)
		return 1
	end
end

local function Button_SetItem(self, bag, slot)
	if not InCombatLockdown() then
		self:SetAttribute("type", "item")
		if type(bag) == "number" and type(slot) == "number" then
			self:SetAttribute("item", nil)
			self:SetAttribute("bag", bag)
			self:SetAttribute("slot", slot)
		else
			self:SetAttribute("item", bag)
			self:SetAttribute("bag", nil)
			self:SetAttribute("slot", nil)
		end
		return 1
	end
end

local function Button_SetMacro(self, macroText, arg1, ...)
	if not InCombatLockdown() then
		local text
		if type(macroText) == "string" then
			if arg1 then
				text = format(macroText, arg1, ...)
			else
				text = macroText
			end

			if strsub(text, 1, 1) ~= "/" then
				text = "/script "..text
			end
		end

		self:SetAttribute("type", "macro")
		self:SetAttribute("macrotext", text)
		return 1
	end
end

local function EventFrame_OnEvent(self)
	if not InCombatLockdown() then
		ClearOverrideBindings(self.frame)
		local key1, key2 = GetBindingKey(self.actionName)
		if key1 or key2 then
			SetOverrideBindingClick(self.frame, false, key1 or key2, self.buttonName)
		end
	end
end

function lib:CreateActionButton(ownerFrame, name, actionName)
	if type(ownerFrame) ~= "table" or type(ownerFrame[0]) ~= "userdata" then
		error("Invalid parameter #1 in LibActionPixel:CreateActionButton, ownerFrame must be a valid frame.")
		return
	end

	if type(name) ~= "string" then
		error("Invalid parameter #2 in LibActionPixel:CreateActionButton, string expected, got "..type(name)..".")
		return
	end


	if type(actionName) ~= "string" then
		error("Invalid parameter #3 in LibActionPixel:CreateActionButton, string expected, got "..type(actionName)..".")
		return
	end

	local button = CreateFrame("Button", name, UIParent, "SecureActionButtonTemplate")
	button:SetAttribute("type", "macro")

	local eventFrame = CreateFrame("Frame", nil, button)
	eventFrame.frame, eventFrame.actionName, eventFrame.buttonName = ownerFrame, actionName, name
	eventFrame:RegisterEvent("PLAYER_LOGIN")
	eventFrame:RegisterEvent("UPDATE_BINDINGS")
	eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	eventFrame:SetScript("OnEvent", EventFrame_OnEvent)

	button.SetSpell = Button_SetSpell
	button.SetItem = Button_SetItem
	button.SetMacro = Button_SetMacro
	button.SetAction = Button_SetMacro -- Downward compatibility
	return button
end

local function Frame_SetColor(self, color)
	local data = COLOR_NAMES[color]
	if data then
		self.texture:SetTexture(data.r, data.g, data.b, 1)
	end
end

local function Frame_ShowPixel(self, color)
	self._delayHideTime = nil
	if color then
		Frame_SetColor(self, color)
	end
	self.texture:Show()
	self:Show()
end

local function Frame_HidePixel(self)
	self._delayHideTime = nil
	self.texture:Hide()
end

local function Frame_OnUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 0.2 then
		self.elapsed = 0

		local parent = self.parent
		if parent.OnTick then
			parent:OnTick()
		end

		local hideTime = parent._delayHideTime
		if hideTime and GetTime() >= hideTime then
			parent:Hide()
			parent._delayHideTime = nil
			if parent.OnDelayHide then
				parent:OnDelayHide()
			end
		end
	end
end

local function Frame_DelayHide(self, duration)
	self.elapsed = 0
	self._delayHideTime = GetTime() + duration
	self:Show()
end

function lib:CreatePixelFrame(name, parent, point, color, layer)
	local frame = CreateFrame("Frame", name, parent or UIParent)
	frame:SetSize(2, 2)
	frame:SetPoint(point, WorldFrame, point)
	frame:SetFrameStrata("TOOLTIP")

	frame.texture = frame:CreateTexture(nil, layer or "ARTWORK")
	frame.texture:SetAllPoints(frame)

	if color then
		Frame_SetColor(frame, color)
	end

	local updateFrame = CreateFrame("Frame", nil, frame)
	updateFrame.parent = frame
	updateFrame:SetScript("OnUpdate", Frame_OnUpdate)

	frame.SetColor = Frame_SetColor
	frame.ShowPixel = Frame_ShowPixel
	frame.HidePixel = Frame_HidePixel
	frame.DelayHide = Frame_DelayHide

	return frame
end

local function AlertFrame_SetText(self, text, r, g, b)
	self.text:SetText(text)
	if r then
		self.text:SetTextColor(r, g, b)
	end
end

local function AlertFrame_SetIcon(self, icon)
	self.icon:SetTexture(icon)
end

local function AlertFrameButton_OnClick(self)
	self:GetParent():Hide()
end

local function AlertFrame_OnUpdate(self)
	if self._autoHideTime and GetTime() > self._autoHideTime then
		self:Hide()
	end
end

local function AlertFrame_OnShow(self)
	self.alertPixel:ShowPixel("ALERT_START")
	if self.OnShow then
		self:OnShow()
	end
end

local function AlertFrame_OnHide(self)
	self.alertPixel:ShowPixel("ALERT_STOP")
	self.alertPixel:DelayHide(2)
	if self.OnHide then
		self:OnHide()
	end
end

function lib:CreateAlertPixelFrame(name, point, hasIcon, duration)
	if type(name) ~= "string" then
		error("Invalid parameter #1 in LibActionPixel:CreateAlertPixelFrame, string expected, got "..type(name)..".")
		return
	end

	local frame = CreateFrame("Frame", name, UIParent)
	frame:Hide()
	frame:SetSize(320, 100)
	frame:SetPoint("CENTER", 0, 160)
	frame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 32, edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 32, insets = {left = 11, right = 12, top = 12, bottom = 11 } })
	frame:SetFrameStrata("DIALOG")
	frame:SetScript("OnShow", AlertFrame_OnShow)
	frame:SetScript("OnHide", AlertFrame_OnHide)

	local text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	frame.text = text
	frame.SetText = AlertFrame_SetText

	if hasIcon then
		local icon = frame:CreateTexture(nil, "ARTWORK")
		frame.icon = icon
		icon:SetSize(32, 32)
		icon:SetPoint("TOPLEFT", 16, -16)
		text:SetPoint("LEFT", icon, "RIGHT", 4, 0)
		frame.SetIcon = AlertFrame_SetIcon
	else
		text:SetPoint("TOP", 0, -24)
	end

	local pixel = lib:CreatePixelFrame(name.."PixelFrame", UIParent, point, nil, "OVERLAY")
	frame.alertPixel = pixel
	pixel:Hide()

	local button = CreateFrame("Button", name.."Button", frame, "UIPanelButtonTemplate")
	button:SetSize(96, 22)
	button:SetPoint("BOTTOM", 0, 20)
	button:SetText(OKAY)
	button:SetScript("OnClick", AlertFrameButton_OnClick)

	if type(duration) == "number" and duration > 0 then
		frame._autoHideDuration = duration
		frame:SetScript("OnUpdate", AlertFrame_OnUpdate)
	end

	tinsert(UISpecialFrames, name)
	return frame
end