-----------------------------------------------
-- zhTW.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

if GetLocale() ~= "zhTW" then return end

local _, addon = ...

addon.L = {
	["title"] = "魔獸大蛐",
	["control action"] = "主動作控制",
	["boss name"] = "幸運益",
	["scroll bottom"] = "最後",
	["pets"] = "寵物",
	["log"] = "日誌",
	["tooltip log"] = "查看最近的動作日誌。",
	["toggle frame"] = "顯示/隱藏插件主窗口。",
	["add to team"] = "Alt-點擊：將這隻寵物放入戰隊。",
	["log battle total time"] = "本場戰鬥歷時 |cff00ff00%d|r 秒。",

	["tooltip log up"] = "點擊：將日誌內容向上滾動。",
	["tooltip log up shift"] = "Shift-點擊：將日誌內容滾動到頂部。",
	["tooltip log down"] = "點擊：將日誌內容向下滾動。",
	["tooltip log down shift"] = "Shift-點擊：將日誌內容滾動到底部。",
	["tooltip log clear"] = "點擊：清空日誌內容。",

	["log manager activate"] = "Npc距離接近，組件已激活。",
	["log manager deactivate"] = "Npc距離過遠，組件已休眠。\n",
	["log all states"] = "清除所有狀態。\n",
	["log battle started"] = "戰鬥開始。",
	["log battle round"] = "戰鬥回合 %d。",
	["log battle over"] = "戰鬥結束。\n",
	["log wait thread start"] = "等待組隊模塊啟動...",
	["log team module started"] = "組隊模塊已啟動。",
	["log team choosing pets"] = "遴選戰隊寵物。",
	["log team heal"] = "嘗試復活寵物。",
	["log team form"] = "正在組隊。",
	["log team choose abilities"] = "為戰隊寵物設置技能。",
	["log team ready"] = "戰隊組建成功。",

	["log team pet choosing ok"] = "已選擇寵物 \124T%s:0:0:0:0\124t%s。",
	["log team pet choosing fail"] = "無法選擇%s（%s）。",
	["log team fail error not configured"] = "未設置",
	["log team fail error health low"] = "血量低於%d",
	["log team heal cooldown"] = "\124T%s:0:0:0:0\124t%s冷卻剩餘%d秒。",
	["log team cast heal"] = "施放 \124T%s:0:0:0:0\124t%s。",
	["log team pet list changed"] = "寵物列表更改，重啟組隊模塊...",

	["log interact targeting npc"] = "選中Npc為目標。",
	["log interact interacting"] = "與Npc互動。",
	["log interact starting battle"] = "嘗試啟動戰鬥。",

	["log battle using ability"] = "使用技能 \124T%s:0:0:0:0\124t%s。",
	["log battle change pet"] = "切換寵物 \124T%s:0:0:0:0\124t%s。",
	["log battle won"] = "戰鬥勝利。",
	["log module stop"] = "模塊已停止。",
	["log use bandage"] = "使用 \124T%s:0:0:0:0\124t%s。",
	["log not controlled"] = "無法控制。",
}