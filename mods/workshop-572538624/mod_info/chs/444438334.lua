_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"自动排列您背包里的的物品。",
	{

	},
	{
		{
			label	= "整理按键：",
			name	= "keybind",
		},
		{

			label	= "首选火把数量：",
			name	= "maxLights",
		},
		{
			label	= "在背包存储这些：",
			name	= "backpackCategory",
			options = {
				{ description = "护甲",	 data = "armour" },
				{ description = "食物",		 data = "food" },
				{ description = "垃圾",		 data = "misc" },
				{ description = "火把",	 data = "light" },
				{ description = "资源", data = "resources" },
				{ description = "工具",		data = "tools" },
				{ description = "武器",	data = "weapons" },
			}
		},
		{
			label	= "娱乐模式",
			name	= "funMode",
			options = {
				{ description = "开", data = "yes" },
				{ description = "关",	data = "no" },
			}
		},
	}

)
