-----------------------------------------------
-- enUS.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local _, addon = ...

addon.L = {
	["title"] = "Cricket",
	["control action"] = "Main action control",
	["boss name"] = "Lucky Yi",
	["scroll bottom"] = "Bottom",
	["pets"] = "Pets",
	["log"] = "Log",
	["toggle frame"] = "Show/hide addon frame.",
	["add to team"] = "Alt-click: Assign this pet to battle team.",
	["log battle total time"] = "Recent battle took |cff00ff00%d|r seconds.",

	["tooltip log up"] = "Click: Scroll the log up.",
	["tooltip log up shift"] = "Shift-click: Scroll the log to top.",
	["tooltip log down"] = "Click: Scroll the log down.",
	["tooltip log down shift"] = "Shift-click: Scroll the log to bottom.",
	["tooltip log clear"] = "Click: Clear all log.",

	["log manager activate"] = "Npc close enough, addon activated.",
	["log manager deactivate"] = "Npc too far, addon deactivated.\n",
	["log all states"] = "Clear all states.\n",
	["log battle started"] = "Battle started.",
	["log battle round"] = "Battle round %d.",
	["log battle over"] = "Battle over.\n",
	["log wait thread start"] = "Waiting for team module...",
	["log team module started"] = "Team module started.",
	["log team choosing pets"] = "Choosing pets for new team.",
	["log team heal"] = "Try to heal pets.",
	["log team form"] = "Forming a team.",
	["log team choose abilities"] = "Choosing abilities for team pets.",
	["log team ready"] = "Team formed successfully.",

	["log team pet choosing ok"] = "Chosen pet \124T%s:0:0:0:0\124t%s.",
	["log team pet choosing fail"] = "Cannot choose %s (%s).",
	["log team fail error not configured"] = "Not configured",
	["log team fail error health low"] = "Health below %d",
	["log team heal cooldown"] = "\124T%s:0:0:0:0\124t%s cooldown %d sec.",
	["log team cast heal"] = "Cast \124T%s:0:0:0:0\124t%s.",
	["log team pet list changed"] = "Pet list changed, restarting team module...",

	["log interact targeting npc"] = "Targeting npc.",
	["log interact interacting"] = "Interacting with npc.",
	["log interact starting battle"] = "Starting battle.",

	["log battle using ability"] = "Using ability \124T%s:0:0:0:0\124t%s.",
	["log battle change pet"] = "Changing pet \124T%s:0:0:0:0\124t%s.",
	["log battle won"] = "Battle won.",

	["log module stop"] = "Module stopped.",
	["log use bandage"] = "Use \124T%s:0:0:0:0\124t%s.",
	["log not controlled"] = "Not controlled.",
}