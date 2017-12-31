--本檔案為mod選項翻譯，由 Chinese Plus 自動加載漢化
description = [[(小橘子的線上禮包)服務器MOD。
線上玩家每天可獲得隨機禮包獎勵：日常急救包，基礎資料，稀有物品，或者建築物。還能接受各種挑戰任務，擊殺怪物贏得獎勵。擲骰有幾率重置任務類型，越難的任務獎勵越豐厚。
歡迎來創意工坊留言和點贊!
]]

configuration_options = {
	{
		name = "NORMAL_ITEMS",
		label = "基礎禮包",
		options =
		{
			{ description = "開", data = true },
			{ description = "關", data = false },
		},
		default = true,
	},
	{
		name = "RARE_ITEMS",
		label = "稀有禮包",
		options =
		{
			{ description = "開", data = 1 },
			{ description = "僅物品", data = 2 },
			{ description = "僅建築", data = 3 },
			{ description = "關", data = 0 },
		},
		default = 1,
	},
	{
		name = "BUFF_ITEMS",
		label = "BUFF禮包",
		options =
		{
			{ description = "開", data = true },
			{ description = "關", data = false },
		},
		default = true,
	},
	{
		name = "FIRST_AID_KIT",
		label = "急救包",
		options =
		{
			{ description = "開", data = true },
			{ description = "關", data = false },
		},
		default = true,
	},
	{
		name = "PACKS_VALUE",
		label = "禮包價值",
		options =
		{
			{ description = "x 0.5", data = 0.5 },
			{ description = "x 1", data = 1 },
			{ description = "x 2", data = 2 },
			{ description = "x 3", data = 3 },
			{ description = "x 4", data = 4 },
			{ description = "x 5", data = 5 },
		},
		default = 1,
	},
	{
		name = "PACKS_CD",
		label = "禮包冷卻(天)",
		options =
		{
			{ description = "每天", data = 1 },
			{ description = "2", data = 2 },
			{ description = "3", data = 3 },
			{ description = "4", data = 4 },
			{ description = "5", data = 5 },
		},
		default = 2,
	},
	{
		name = "CHALLENGE_MISSION_DIFFICULTY",
		label = "任務難度",
		options =
		{
			{ description = "隨機", data = 0 },
			{ description = "簡單", data = 1 },
			{ description = "困難", data = 2 },
			{ description = "地獄", data = 3 },
		},
		default = 0,
	},
	{
		name = "CHALLENGE_MISSION",
		label = "挑戰任務(天)",
		options =
		{
			{ description = "關", data = 0 },
			{ description = "5", data = 5 },
			{ description = "10", data = 10 },
			{ description = "15", data = 15 },
			{ description = "20", data = 20 },
			{ description = "25", data = 25 },
			{ description = "30", data = 30 },
		},
		default = 5,
	},
	{
		name = "CHALLENGE_MISSION_ROLL",
		label = "擲骰重置(點)",
		options =
		{
			{ description = "關", data = 0 },
			{ description = "5", data = 5 },
			{ description = "50", data = 50 },
			{ description = "60", data = 60 },
			{ description = "70", data = 70 },
			{ description = "80", data = 80 },
			{ description = "85", data = 85 },
			{ description = "90", data = 90 },
			{ description = "95", data = 95 },
		},
		default = 70,
	},
	{
		name = "CHALLENGE_MISSION_CD",
		label = "任務冷卻(天)",
		options =
		{
			{ description = "每天", data = 1 },
			{ description = "2", data = 2 },
			{ description = "3", data = 3 },
			{ description = "5", data = 5 },
			{ description = "8", data = 8 },
			{ description = "10", data = 10 },
		},
		default = 3,
	},
	{
		name = "RECORD_DEATH",
		label = "死亡記錄",
		options =
		{
			{ description = "開", data = true, hover = "死亡或重生後不再贈送禮包" },
			{ description = "關", data = false, hover = "始終贈送禮包" },
		},
		default = true,
	},
	{
		name = "ANNOUNCE_TIP",
		label = "公告提示",
		options =
		{
			{ description = "開", data = true },
			{ description = "關", data = false },
		},
		default = true,
	},
}