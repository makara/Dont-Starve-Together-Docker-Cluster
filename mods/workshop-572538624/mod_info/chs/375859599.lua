_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"在鼠标悬停或控制器自动选择目标生物时，显示生物的确切生命值。",
	{
		["Value"] = "数值",
		["Percentage"] = "百分比",
		["Both"] = "所有",
		["Yes"] = "开",
		["No"] = "关",
		["Always"] = "总是",
	},
	{
		{
				name = "show_type",
				label = "显示方式",
				hover = "生命指示的类型。",
		},
		{
			name = "divider",
			label = "样式",
			hover = "指示的括号样式。",
		},
		{
			name = "use_blacklist",
			label = "黑名单",
			hover = "预置的黑名单。\n建议使用该选项，因为它提高了兼容性\n某些mod可以增加你不可视目标的生命指示。",
		},
		{
			name = "unknwon_prefabs",
			label = "未知目标",
			hover = "未知目标的自动检测，更多类型的对象。兼容性不佳。",
			options =
			{
				{description = "忽略", data = 0, hover = "100% 兼容\n但是mod生物和玩家的生命值不会显示。"},
				{description = "玩家", data = 1, hover = '99% 兼容\n将显示有“玩家”标签目标的生命值。'},
				{description = "生物", data = 2, hover = '97% 兼容\n将显示有“玩家”，“怪物”，“动物”，“小生物”标签目标的生命值。'},
				{description = "所有", data = 3, hover = "90% 兼容\n将显示所有已知标签目标的生命值。"},
			},
		},
		{
			name = "send_unknwon_prefabs",
			label = "发送错误报告",
			hover = "发送未知的目标的报告，或许下个MOD更新会支持。",
		},
		{
			name = "random_health_value",
			label = "机会波动",
			hover = "生命值是不准确的。最大生命值是隐藏的。",
		},
		{
			name = "random_range",
			label = "随机区间",
			hover = "产生随机生命值的时间间隔（最大健康的百分比。）",
		},

	}
)
