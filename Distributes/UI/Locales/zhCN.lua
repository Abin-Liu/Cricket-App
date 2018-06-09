-----------------------------------------------
-- zhCN.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

if GetLocale() ~= "zhCN" then return end

local _, addon = ...

addon.L = {
	["title"] = "魔兽大蛐",
	["control action"] = "主动作控制",
	["boss name"] = "幸运的小艺",
	["scroll bottom"] = "最后",
	["pets"] = "宠物",
	["log"] = "日志",
	["tooltip log"] = "查看最近的动作日志。",
	["toggle frame"] = "显示/隐藏插件主窗口。",
	["add to team"] = "Alt-点击：将这只宠物放入战队。",
	["log battle total time"] = "本场战斗历时 |cff00ff00%d|r 秒。",

	["tooltip log up"] = "点击：将日志内容向上滚动。",
	["tooltip log up shift"] = "Shift-点击：将日志内容滚动到顶部。",
	["tooltip log down"] = "点击：将日志内容向下滚动。",
	["tooltip log down shift"] = "Shift-点击：将日志内容滚动到底部。",
	["tooltip log clear"] = "点击：清空日志内容。",

	["log manager activate"] = "Npc距离接近，组件已激活。",
	["log manager deactivate"] = "Npc距离过远，组件已休眠。\n",
	["log all states"] = "清除所有状态。\n",
	["log battle started"] = "战斗开始。",
	["log battle round"] = "战斗回合 %d。",
	["log battle over"] = "战斗结束。\n",
	["log wait thread start"] = "等待组队模块启动...",
	["log team module started"] = "组队模块已启动。",
	["log team choosing pets"] = "遴选战队宠物。",
	["log team heal"] = "尝试复活宠物。",
	["log team form"] = "正在组队。",
	["log team choose abilities"] = "为战队宠物设置技能。",
	["log team ready"] = "战队组建成功。",

	["log team pet choosing ok"] = "已选择宠物 \124T%s:0:0:0:0\124t%s。",
	["log team pet choosing fail"] = "无法选择%s（%s）。",
	["log team fail error not configured"] = "未设置",
	["log team fail error health low"] = "血量低于%d",
	["log team heal cooldown"] = "\124T%s:0:0:0:0\124t%s冷却剩余%d秒。",
	["log team cast heal"] = "施放 \124T%s:0:0:0:0\124t%s。",
	["log team pet list changed"] = "宠物列表更改，重启组队模块...",

	["log interact targeting npc"] = "选中Npc为目标。",
	["log interact interacting"] = "与Npc互动。",
	["log interact starting battle"] = "尝试启动战斗。",

	["log battle using ability"] = "使用技能 \124T%s:0:0:0:0\124t%s。",
	["log battle change pet"] = "切换宠物 \124T%s:0:0:0:0\124t%s。",
	["log battle won"] = "战斗胜利。",
	["log module stop"] = "模块已停止。",
	["log use bandage"] = "使用 \124T%s:0:0:0:0\124t%s。",
	["log not controlled"] = "无法控制。",
}