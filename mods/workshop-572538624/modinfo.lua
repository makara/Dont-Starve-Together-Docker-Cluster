name = "Chinese Plus"
forumthread = "" --http://steamcommunity.com/sharedfiles/filedetails/?id=572538624
author = "Skull & LongFei"
version = "0.7.6"
description = name.."																				版本:"..version.."\n\n增强汉化，修复无汉化的地方。\n\nMOD汉化，支持选项！\n\n\n注意：创建世界页面管理服务器mod的选项比主页面mod选项优先，或许你需要在创建世界时改变选项。"
api_version = 10
priority = -9999
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true
version_compatible  = "0.7.4"
all_clients_require_mod = false
client_only_mod = true
server_filter_tags = { "中文" }

icon_atlas = "Chinese.xml"
icon = "Chinese.tex"


configuration_options =
{

	{
		name = "IS_CHS_FIX_ALL",
		label = "修复汉化",
		hover = "修复某些未成功汉化的地方",
		options =
		{
			{description = "开", data = true, hover = "开启修复汉化"},
			{description = "关", data = false, hover = "关闭修复汉化"},
		},
		default = true,
	},
	{
		name = "IS_CHS_ALL_MOD",
		label = "汉化MOD",
		hover = "开启MOD的汉化。",
		options =
		{
			{description = "开", data = true, hover = "MOD显示为中文"},
			{description = "关", data = false, hover = "MOD显示为默认文字"},
		},
		default = true,
	},
	{
		name = "IS_CHS_SETTINGS",
		label = "汉化MOD选项",
		hover = "汉化支持的MOD的选项",
		options =
		{
			{description = "开", data = true, hover = "开启汉化MOD选项"},
			{description = "关", data = false, hover = "关闭汉化MOD选项"},
		},
		default = true,
	},
	{
		name = "IS_CHS_CHARACTER",
		label = "汉化人物MOD",
		hover = "汉化支持的人物MOD。\n需开启上面两个选项之一。",
		options =
		{
			{description = "开", data = true, hover = "开启汉化人物MOD"},
			{description = "关", data = false, hover = "关闭汉化人物MOD"},
		},
		default = true,
	},
}
