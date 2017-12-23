_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"魔法冰箱：发光、冷冻、更大的空间！这是最好的！！",
	{
		["Enabled"] = "可以",
		["Disabled"] = "不能",
	},
	{
		{
			name = "Craft",
			label = "制作难度",
			hover = "更改魔法冰箱的制作材料。",
			options =
		{
			{description = "简单", data = "Easy"},
			{description = "正常", data = "Normal"},
			{description = "困难", data = "Hard"},
		},
		},

		{
			name = "Slots",
			label = "格子数量大小",
		},
		--[[
		{
			name = "FoodSpoilage",
			label = "Food Spoilage",
			hover = "Change the spoilage time of our food.",
			options =
		{
			{description = "Spoilage!", data = 999, hover = "rotten very quickly!!!"},
			{description = "Default", data = 1, hover = "normal Spoilage"},
			{description = "Little Slower", data = 0.85, hover = "Little Slower"},
			{description = "As Winter", data = 0.75, hover = "Like Winter"},
			{description = "Like Ice Box", data = 0.5, hover = "Like Ice Box"},
			{description = "Better than Ice Box", data = 0.25, hover = "Better than Ice Box"},
			{description = "Stop Spoilage", data = 0, hover = "never spoilage of food"},

		},
			default = 0,
		},
		]]
		{
			name = "chilltime",
			label = "腐烂时间",
			hover = "改变食物的腐烂时间。",
			options =
		{
			{description = "冰箱", data = .5, hover = "和普通冰箱一样。"},
			{description = "多25%", data = .37, hover = "比普通冰箱多25%多时间。"},
			{description = "多50%", data = .25, hover = "比普通冰箱多50%多时间。"},
			{description = "多75%", data = .12, hover = "比普通冰箱多75%多时间。"},
			{description = "不腐烂", data = .01, hover = "食物停止腐烂。"},
		},
		},

		{
			name = "lightradius",
			label = "发光的范围",
			options =
			{
				{description = "小", data = 4, hover = "狭窄"},
				{description = "正常", data = 6, hover = "普通"},
				{description = "大", data = 8, hover = "宽广"},
				{description = "很大", data = 10, hover = "广阔"}
			},
		},

		{
			name = "Position",
			label = "位置",
			options =
		{
			{description = "左", data = "Left"},
			{description = "中间", data = "Center"},
		},
		},

		{
			name = "Destroyable",
			label = "可被摧毁？",
			options =
		{
			{description = "可以", data = "yees", hover = "可以拆除。"},
			{description = "不能 ", data = "noo", hover = "不能拆除。"},
		},
		},
	}
)
