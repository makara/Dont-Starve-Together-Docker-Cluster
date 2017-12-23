_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"现在你可以变成死侍了！",
	{

	},
	{
		{
			name = "deadpoolbasehp",
			label = "死侍的生命值",
			options =
			{
				{description = "50", data = 50},
				{description = "150(默认)", data = 150},
				{description = "200", data = 200},
				{description = "500", data = 500},
				{description = "1000", data = 1000},
				{description = "10000", data = 10000},
			},
		},

		{
			name = "deadpoolbasesanity",
			label = "死侍的精神值",
			options =
			{
				{description = "20(默认)", data = 20},
				{description = "50", data = 50},
				{description = "100", data = 100},
				{description = "200", data = 200},
				{description = "500", data = 500},
				{description = "1000", data = 1000},
				{description = "10000", data = 10000},
			},
		},

		{
			name = "deadpoolbasehunger",
			label = "死侍的饥饿值",
			options =
			{
				{description = "50", data = 50},
				{description = "100(默认)", data = 100},
				{description = "200", data = 200},
				{description = "500", data = 500},
				{description = "1000", data = 1000},
				{description = "10000", data = 10000},
			},
		},


		{
			name = "deadpoolbasehpregen",
			label = "死侍的生命恢复",
			options =
			{
				{description = "1秒0.5点", data = 0.5,hover = "每秒恢复 0.5 点生命"},
				{description = "1秒1点", data = 1,hover = "每秒恢复 1 点生命"},
				{description = "1秒2点", data = 2,hover = "每秒恢复 2 点生命"},
				{description = "1秒5点", data = 5,hover = "每秒恢复 5 点生命"},
				{description = "1秒10点", data = 10,hover = "每秒恢复 10 点生命"},
				{description = "1秒10000点", data = 10000,hover = "每秒恢复 10000 点生命"},
			},
		},

		{
			name = "deadpoolbasedamage",
			label = "死侍的伤害",
			options =
			{
				{description = "低", data = 0.75,hover = "温蒂一样"},
				{description = "正常", data = 1,hover = "威尔逊一样"},
				{description = "高", data = 2,hover = "2 倍威尔逊"},
				{description = "较高", data = 5,hover = "5 倍威尔逊"},
				{description = "最高", data = 10,hover = "10 倍威尔逊"},
				{description = "1000x", data = 10000,hover = "10000 倍威尔逊"},
			},
		},
	--[[
		{
			name = "deadpoolbasehungerdrains",
			label = "死侍的饥饿速率",
			hover = "改变饥饿速率",
			options =
			{
				{description = "最快", data = 0.4},
				{description = "较快", data = 0.2},
				{description = "快", data = 0.15},
				{description = "正常", data = 0.1,hover = "Like Wilson"},
				{description = "慢", data = 0.01},
				{description = "不会饥饿", data = 0},
			},
		},
	]]
		{
			name = "katanasbasedamage",
			label = "武士刀的伤害",
			options =
			{
				{description = "低", data = 20,hover = "20 伤害"},
				{description = "正常", data = 30,hover = "30 伤害"},
				{description = "高", data = 60,hover = "60 伤害"},
				{description = "较高", data = 100,hover = "100 伤害"},
				{description = "最高", data = 1000,hover = "1000 伤害"},
				{description = "10000", data = 10000,hover = "10000 伤害"},
			},
		},
		{
			name = "teleportdodelta",
			label = "瞬移",
			hover = "瞬移时的精神变化",
			options =
			{
				{description = "+10", data = 10,hover = "+10 精神"},
				{description = "+5", data = 5,hover = "+5 精神"},
				{description = "+3", data = 3,hover = "+3 精神"},
				{description = "无", data = 0,hover = "无变化"},
				{description = "正常", data = -1,hover = "-1 精神"},
				{description = "-3", data = -3,hover = "-3 精神"},
				{description = "-5", data = -5,hover = "-5 精神"},
				{description = "-10", data = -10,hover = "-10 精神"},
			},
		},

	}
)
