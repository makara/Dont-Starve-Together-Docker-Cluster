_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"現在你可以變成死侍了！",
	{

	},
	{
		{
			name = "deadpoolbasehp",
			label = "死侍的生命值",
			options =
			{
				{description = "50", data = 50},
				{description = "150(預設)", data = 150},
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
				{description = "20(預設)", data = 20},
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
			label = "死侍的飢餓值",
			options =
			{
				{description = "50", data = 50},
				{description = "100(預設)", data = 100},
				{description = "200", data = 200},
				{description = "500", data = 500},
				{description = "1000", data = 1000},
				{description = "10000", data = 10000},
			},
		},


		{
			name = "deadpoolbasehpregen",
			label = "死侍的生命恢復",
			options =
			{
				{description = "1秒0.5點", data = 0.5,hover = "每秒恢復 0.5 點生命"},
				{description = "1秒1點", data = 1,hover = "每秒恢復 1 點生命"},
				{description = "1秒2點", data = 2,hover = "每秒恢復 2 點生命"},
				{description = "1秒5點", data = 5,hover = "每秒恢復 5 點生命"},
				{description = "1秒10點", data = 10,hover = "每秒恢復 10 點生命"},
				{description = "1秒10000點", data = 10000,hover = "每秒恢復 10000 點生命"},
			},
		},

		{
			name = "deadpoolbasedamage",
			label = "死侍的傷害",
			options =
			{
				{description = "低", data = 0.75,hover = "溫蒂一樣"},
				{description = "正常", data = 1,hover = "威爾遜一樣"},
				{description = "高", data = 2,hover = "2 倍威爾遜"},
				{description = "較高", data = 5,hover = "5 倍威爾遜"},
				{description = "最高", data = 10,hover = "10 倍威爾遜"},
				{description = "1000x", data = 10000,hover = "10000 倍威爾遜"},
			},
		},
	--[[
		{
			name = "deadpoolbasehungerdrains",
			label = "死侍的飢餓速率",
			hover = "改變飢餓速率",
			options =
			{
				{description = "最快", data = 0.4},
				{description = "較快", data = 0.2},
				{description = "快", data = 0.15},
				{description = "正常", data = 0.1,hover = "Like Wilson"},
				{description = "慢", data = 0.01},
				{description = "不會飢餓", data = 0},
			},
		},
	]]
		{
			name = "katanasbasedamage",
			label = "武士刀的傷害",
			options =
			{
				{description = "低", data = 20,hover = "20 傷害"},
				{description = "正常", data = 30,hover = "30 傷害"},
				{description = "高", data = 60,hover = "60 傷害"},
				{description = "較高", data = 100,hover = "100 傷害"},
				{description = "最高", data = 1000,hover = "1000 傷害"},
				{description = "10000", data = 10000,hover = "10000 傷害"},
			},
		},
		{
			name = "teleportdodelta",
			label = "瞬移",
			hover = "瞬移時的精神變化",
			options =
			{
				{description = "+10", data = 10,hover = "+10 精神"},
				{description = "+5", data = 5,hover = "+5 精神"},
				{description = "+3", data = 3,hover = "+3 精神"},
				{description = "無", data = 0,hover = "無變化"},
				{description = "正常", data = -1,hover = "-1 精神"},
				{description = "-3", data = -3,hover = "-3 精神"},
				{description = "-5", data = -5,hover = "-5 精神"},
				{description = "-10", data = -10,hover = "-10 精神"},
			},
		},

	}
)
