_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"增加一些自定義地皮的饑荒聯機版MOD",
	{
		["Nope"] = "否",
		["Yep"] = "是",
	},
	{
		{
			name = "InsulatingTurfs",
			label = "地皮保溫",
			hover = "啟用地皮保溫?",
			options =	{
							{description = "是", data = 1, hover = ""},
							{description = "否", data = 0, hover = ""},
						},
		},
		{
			name = "InsulationDuration",
			label = "保溫時間",
			hover = "保溫時間選項",
			options =	{
							{description = "短", data = 120, hover = ""},
							{description = "中", data = 240, hover = ""},
							{description = "長", data = 480, hover = ""},
							{description = "很長", data = 960, hover = ""},
							{description = "一直", data = 99999999999999, hover = ""},
						},
			default = 480,
		},
		{
			name = "SanityTurfs",
			label = "地皮理智",
			hover = "啟用地皮理智?",
			options =	{
							{description = "是", data = 1, hover = ""},
							{description = "否", data = 0, hover = ""},
						},
		},
		{
			name = "RainProtectingTurfs",
			label = "降雨保護地皮",
			hover = "啟用降雨保護地皮?",
			options =	{
							{description = "是", data = 1, hover = ""},
							{description = "否", data = 0, hover = ""},
						},
		},
		{
			name = "SpeedyTurfs",
			label = "地皮加速",
			hover = "啟用地皮加速?",
			options =	{
							{description = "是", data = 1, hover = ""},
							{description = "否", data = 0, hover = ""},
						},
		},
		{
			name = "SpeedyTurfSpeeds",
			label = "地皮加速選項",
			hover = "地皮加速開啟才會有用。",
			options =	{
							{description = "1.25", data = 1.25,	hover = "正常 1.25倍(預設)"},
							{description = "1.5",	data = 1.50,	hover = "正常 1.5倍"},
							{description = "1.75", data = 1.75,	hover = "正常 1.75倍"},
							{description = "2",	data = 2,	 hover = "正常 2倍"},
							{description = "2.5",	data = 2.50,	hover = "正常 2.5倍"},
						},
		},
		{
			name = "EnableGameTurfRecipes",
			label = "製造預設地皮",
			hover = "可以製造預設地皮?",
			options =	{
							{description = "否", data = 0},
							{description = "是", data = 1},
						},
		},
		{
			name = "EnableTurfedTurfRecipes",
			label = "製造mod地皮",
			hover = "可以製造mod地皮?",
			options =	{
							{description = "否", data = 0, hover = "為什麼？"},
							{description = "是", data = 1, hover = "這樣才對!"},
						},
		},
		{
			name = "EnableFlooringPlanting",
			label = "地板上可種植",
			hover = "啟用地板上可種植?",
			options =	{
							{description = "否", data = false},
							{description = "是", data = true},
						},
		},

	}
)
