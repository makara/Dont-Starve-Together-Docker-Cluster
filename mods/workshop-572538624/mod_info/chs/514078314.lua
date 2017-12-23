_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"增加一些自定义地皮的饥荒联机版MOD",
	{
		["Nope"] = "否",
		["Yep"] = "是",
	},
	{
		{
			name = "InsulatingTurfs",
			label = "地皮保温",
			hover = "启用地皮保温?",
			options =	{
							{description = "是", data = 1, hover = ""},
							{description = "否", data = 0, hover = ""},
						},
		},
		{
			name = "InsulationDuration",
			label = "保温时间",
			hover = "保温时间选项",
			options =	{
							{description = "短", data = 120, hover = ""},
							{description = "中", data = 240, hover = ""},
							{description = "长", data = 480, hover = ""},
							{description = "很长", data = 960, hover = ""},
							{description = "一直", data = 99999999999999, hover = ""},
						},
			default = 480,
		},
		{
			name = "SanityTurfs",
			label = "地皮理智",
			hover = "启用地皮理智?",
			options =	{
							{description = "是", data = 1, hover = ""},
							{description = "否", data = 0, hover = ""},
						},
		},
		{
			name = "RainProtectingTurfs",
			label = "降雨保护地皮",
			hover = "启用降雨保护地皮?",
			options =	{
							{description = "是", data = 1, hover = ""},
							{description = "否", data = 0, hover = ""},
						},
		},
		{
			name = "SpeedyTurfs",
			label = "地皮加速",
			hover = "启用地皮加速?",
			options =	{
							{description = "是", data = 1, hover = ""},
							{description = "否", data = 0, hover = ""},
						},
		},
		{
			name = "SpeedyTurfSpeeds",
			label = "地皮加速选项",
			hover = "地皮加速开启才会有用。",
			options =	{
							{description = "1.25", data = 1.25,	hover = "正常 1.25倍(默认)"},
							{description = "1.5",	data = 1.50,	hover = "正常 1.5倍"},
							{description = "1.75", data = 1.75,	hover = "正常 1.75倍"},
							{description = "2",	data = 2,	 hover = "正常 2倍"},
							{description = "2.5",	data = 2.50,	hover = "正常 2.5倍"},
						},
		},
		{
			name = "EnableGameTurfRecipes",
			label = "制造默认地皮",
			hover = "可以制造默认地皮?",
			options =	{
							{description = "否", data = 0},
							{description = "是", data = 1},
						},
		},
		{
			name = "EnableTurfedTurfRecipes",
			label = "制造mod地皮",
			hover = "可以制造mod地皮?",
			options =	{
							{description = "否", data = 0, hover = "为什么？"},
							{description = "是", data = 1, hover = "这样才对!"},
						},
		},
		{
			name = "EnableFlooringPlanting",
			label = "地板上可种植",
			hover = "启用地板上可种植?",
			options =	{
							{description = "否", data = false},
							{description = "是", data = true},
						},
		},

	}
)
