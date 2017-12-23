name = "Chinese Plus"
version = "0.7.5"
description = name.."																			版本:"..version.."\n\n增強漢化，修復無漢化的地方。\n\nMOD漢化，支援選項！\n\n\n注意：建立世界頁面管理伺服器mod的選項比主頁面mod選項優先，或許你需要在建立世界時改變選項。"
configuration_options =
{

	{
		name = "IS_CHS_FIX_ALL",
		label = "修復漢化",
		hover = "修復某些未成功漢化的地方",
		options =
		{
			{description = "開", data = true, hover = "開啟修復漢化"},
			{description = "關", data = false, hover = "關閉修復漢化"},
		},
		default = true,
	},
	{
		name = "IS_CHS_ALL_MOD",
		label = "漢化MOD",
		hover = "開啟MOD的漢化。",
		options =
		{
			{description = "開", data = true, hover = "MOD顯示為中文"},
			{description = "關", data = false, hover = "MOD顯示為預設文字"},
		},
		default = true,
	},
	{
		name = "IS_CHS_SETTINGS",
		label = "漢化MOD選項",
		hover = "漢化支援的MOD的選項",
		options =
		{
			{description = "開", data = true, hover = "開啟漢化MOD選項"},
			{description = "關", data = false, hover = "關閉漢化MOD選項"},
		},
		default = true,
	},
	{
		name = "IS_CHS_CHARACTER",
		label = "漢化人物MOD",
		hover = "漢化支援的人物MOD。\n需開啟上面兩個選項之一。",
		options =
		{
			{description = "開", data = true, hover = "開啟漢化人物MOD"},
			{description = "關", data = false, hover = "關閉漢化人物MOD"},
		},
		default = true,
	},
}
