--本文件为mod选项翻译，由 Chinese Plus 自动加载汉化
description = [[(小橘子的在线礼包)服务器MOD。
在线玩家每天可获得随机礼包奖励：日常急救包，基础材料，稀有物品，或者建筑物。还能接受各种挑战任务，击杀怪物赢得奖励。掷骰有几率重置任务类型，越难的任务奖励越丰厚。
欢迎来创意工坊留言和点赞!
]]

configuration_options = {
	{
		name = "NORMAL_ITEMS",
		label = "基础礼包",
		options =
		{
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "RARE_ITEMS",
		label = "稀有礼包",
		options =
		{
			{ description = "开", data = 1 },
			{ description = "仅物品", data = 2 },
			{ description = "仅建筑", data = 3 },
			{ description = "关", data = 0 },
		},
		default = 1,
	},
	{
		name = "BUFF_ITEMS",
		label = "BUFF礼包",
		options =
		{
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "FIRST_AID_KIT",
		label = "急救包",
		options =
		{
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "PACKS_VALUE",
		label = "礼包价值",
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
		label = "礼包冷却(天)",
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
		label = "任务难度",
		options =
		{
			{ description = "随机", data = 0 },
			{ description = "简单", data = 1 },
			{ description = "困难", data = 2 },
			{ description = "地狱", data = 3 },
		},
		default = 0,
	},
	{
		name = "CHALLENGE_MISSION",
		label = "挑战任务(天)",
		options =
		{
			{ description = "关", data = 0 },
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
		label = "掷骰重置(点)",
		options =
		{
			{ description = "关", data = 0 },
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
		label = "任务冷却(天)",
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
		label = "死亡记录",
		options =
		{
			{ description = "开", data = true, hover = "死亡或重生后不再赠送礼包" },
			{ description = "关", data = false, hover = "始终赠送礼包" },
		},
		default = true,
	},
	{
		name = "ANNOUNCE_TIP",
		label = "公告提示",
		options =
		{
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
}