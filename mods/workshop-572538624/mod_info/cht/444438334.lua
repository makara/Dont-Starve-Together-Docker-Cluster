_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"自動排列您揹包裡的的物品。",
	{

	},
	{
		{
			label	= "整理按鍵：",
			name	= "keybind",
		},
		{

			label	= "首選火把數量：",
			name	= "maxLights",
		},
		{
			label	= "在揹包儲存這些：",
			name	= "backpackCategory",
			options = {
				{ description = "護甲",	 data = "armour" },
				{ description = "食物",		 data = "food" },
				{ description = "垃圾",		 data = "misc" },
				{ description = "火把",	 data = "light" },
				{ description = "資源", data = "resources" },
				{ description = "工具",		data = "tools" },
				{ description = "武器",	data = "weapons" },
			}
		},
		{
			label	= "娛樂模式",
			name	= "funMode",
			options = {
				{ description = "開", data = "yes" },
				{ description = "關",	data = "no" },
			}
		},
	}

)
