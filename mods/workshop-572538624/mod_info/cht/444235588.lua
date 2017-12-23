_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"一個驚人的改進！\n [ver 2.11 (DST 0.51 beta)]\n增加4種照明建築，更漂亮，更有用，當然，也更費資源。",
	{
		["1 day"] = "一天",
		["3/4 day (default)"] = "3/4 天（預設）",
		["1/2 day"] = "半天",
		["yes (default)"] = "是（預設）",
		["no"] = "否",
		["no (default)"] = "否（預設）",
		["yes"] = "是",
	},
	{
		{name = "deluxeFirepitBurnRate",label = "奢華火坑燃燒時間",
		 options =
			{
				{description = "延長25%(預設)", data = 0.75, hover = "延長25%(預設)"},
				{description = "延長50%", data = 0.5, hover = "延長50%"},
				{description = "延長75%", data = 0.25, hover = "延長50%"}
			},
		},
		{name = "deluxeEndoFirepitBurnRate",label = "奢華冰火坑燃燒時間",
		 options =
			{
				{description = "延長25%(預設)", data = 0.75, hover = "延長25%(預設)"},
				{description = "延長50%", data = 0.5, hover = "延長50%"},
				{description = "延長75%", data = 0.25, hover = "延長50%"}
			},
		},
		{name = "iceStarBurnRate",label = "玻瑞阿斯之星燃燒時間",	},
		{name = "heatStarBurnRate",label = "安科阿勒之星燃燒時間", },
		{name = "recipeCost",label = "建造成本",
		 options =
			{
				{description = "僅僅測試", data = "testing"},
				{description = "新手", data = "cheap"},
				{description = "標準（預設）", data = "standard"},
				{description = "高手", data = "expensive"}
			},
		},
		{name = "dropLoot",label = "奢華火坑掉落物品", },
		{name = "endoDropLoot",label = "奢華冰火坑掉落物品", },
		{name = "iceStarDropLoot",label = "玻瑞阿斯之星掉落物品", },
		{name = "heatStarDropLoot",label = "安科阿勒之星掉落物品", },
		{name = "starsSpawnHounds",label = "兩種星星會產生獵狗", hover ="星星熄滅後會產生獵狗"},
	}

)
