------------------------------------------------------------
-- TickThread-1.0.lua
------------------------------------------------------------

-- Creates tick threads for lengthy tasks.

-- Abin (2013/5/11)

------------------------------------------------------------------------
-- API Documentation
------------------------------------------------------------------------

-- local thread = UICreateTickThread() -- Creates a new tick thread

-- thread:Start(state) -- Start the thread with initial state
-- thread:Stop() -- Stop the thread and discard all states
-- thread:SetState(state) -- Set state for the thread, can be anything
-- thread:GetState() -- Retrieve the thread state
-- thread:Sleep([duration]) -- Sleep the thread for duration, in seconds, during which thread:OnTick() will not be called, if not specified the sleep duration is infinite
-- thread:IsSleeping() -- Check if the thread is sleeping
-- thread:WakeUp() -- Wake up the thread if it's sleeping, so thread:OnTick() will continue being called

-----------------------------------------------------------
-- Callback Methods:
-----------------------------------------------------------

-- thread:OnTick(state) -- Called when the thread ticks, state is the current state

------------------------------------------------------------------------

local type = type
local GetTime = GetTime
local CreateFrame = CreateFrame

local MAJOR_VERSION = 1
local MINOR_VERSION = 1

-- To prevent older libraries from over-riding newer ones...
if type(UICreateTickThread_IsNewerVersion) == "function" and not UICreateTickThread_IsNewerVersion(MAJOR_VERSION, MINOR_VERSION) then return end

local function Thread_SetState(self, state)
	self.state = state
end

local function Thread_GetState(self)
	return self.state
end

local function Thread_Sleep(self, duration)
	if not duration then
		self._tickFrame.sleepUntil = -1
	elseif type(duration) == "number" then
		self._tickFrame.sleepUntil = GetTime() + duration
	end
end

local function Thread_IsSleeping(self)
	return self._tickFrame.sleepUntil
end

local function Thread_WakeUp(self)
	self._tickFrame.sleepUntil = nil
end

local function Thread_Stop(self)
	self._tickFrame:Hide()
	Thread_SetState(self)
	Thread_WakeUp(self)
end

local function Thread_Start(self, state)
	Thread_Stop(self)
	Thread_SetState(self, state)
	self._tickFrame.elapsed = 0
	self._tickFrame:Show()
end

local function Frame_OnUpdate(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed > 0.2 then
		self.elapsed = 0
		local sleepUntil = self.sleepUntil
		if sleepUntil then
			if sleepUntil == -1 or GetTime() < sleepUntil then
				return
			else
				self.sleepUntil = nil
			end
		end

		local thread = self.thread
		if thread.OnTick then
			thread:OnTick(thread.state)
		end
	end
end

function UICreateTickThread()
	local thread = {}
	local frame = CreateFrame("Frame")
	frame:Hide()

	thread._tickFrame = frame
	frame.thread = thread
	frame.elapsed = 0
	frame:SetScript("OnUpdate", Frame_OnUpdate)

	thread.Start = Thread_Start
	thread.Stop = Thread_Stop
	thread.SetState = Thread_SetState
	thread.GetState = Thread_GetState
	thread.Sleep = Thread_Sleep
	thread.IsSleeping = Thread_IsSleeping
	thread.WakeUp = Thread_WakeUp

	return thread
end

-- Provides version check
function UICreateTickThread_IsNewerVersion(major, minor)
	if type(major) ~= "number" or type(minor) ~= "number" then
		return false
	end

	if major > MAJOR_VERSION then
		return true
	elseif major < MAJOR_VERSION then
		return false
	else -- major equal, check minor
		return minor > MINOR_VERSION
	end
end