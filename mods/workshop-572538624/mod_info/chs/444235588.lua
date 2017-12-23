_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"一个惊人的改进！\n [ver 2.11 (DST 0.51 beta)]\n增加4种照明建筑，更漂亮，更有用，当然，也更费资源。",
	{
		["1 day"] = "一天",
		["3/4 day (default)"] = "3/4 天（默认）",
		["1/2 day"] = "半天",
		["yes (default)"] = "是（默认）",
		["no"] = "否",
		["no (default)"] = "否（默认）",
		["yes"] = "是",
	},
	{
		{name = "deluxeFirepitBurnRate",label = "奢华火坑燃烧时间",
		 options =
			{
				{description = "延长25%(默认)", data = 0.75, hover = "延长25%(默认)"},
				{description = "延长50%", data = 0.5, hover = "延长50%"},
				{description = "延长75%", data = 0.25, hover = "延长50%"}
			},
		},
		{name = "deluxeEndoFirepitBurnRate",label = "奢华冰火坑燃烧时间",
		 options =
			{
				{description = "延长25%(默认)", data = 0.75, hover = "延长25%(默认)"},
				{description = "延长50%", data = 0.5, hover = "延长50%"},
				{description = "延长75%", data = 0.25, hover = "延长50%"}
			},
		},
		{name = "iceStarBurnRate",label = "玻瑞阿斯之星燃烧时间",	},
		{name = "heatStarBurnRate",label = "安科阿勒之星燃烧时间", },
		{name = "recipeCost",label = "建造成本",
		 options =
			{
				{description = "仅仅测试", data = "testing"},
				{description = "新手", data = "cheap"},
				{description = "标准（默认）", data = "standard"},
				{description = "高手", data = "expensive"}
			},
		},
		{name = "dropLoot",label = "奢华火坑掉落物品", },
		{name = "endoDropLoot",label = "奢华冰火坑掉落物品", },
		{name = "iceStarDropLoot",label = "玻瑞阿斯之星掉落物品", },
		{name = "heatStarDropLoot",label = "安科阿勒之星掉落物品", },
		{name = "starsSpawnHounds",label = "两种星星会产生猎狗", hover ="星星熄灭后会产生猎狗"},
	}

)
