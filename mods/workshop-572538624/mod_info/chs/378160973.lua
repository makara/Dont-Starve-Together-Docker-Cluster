_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"默认情况下。\n在玩家列表屏幕（TAB），会显示所有玩家的箭头指向图标。\n全地图在小地图上显示玩家图标。\n在营火中燃烧木炭时显示营火图标。",
	{
		["Always"] = "总是",
		["Scoreboard"] = "玩家列表",
		["Never"] = "从不",
		["Show"] = "显示",
		["Hide"] = "隐藏",
		["Charcoal"] = "木炭",
		["Disabled"] = "关闭",
		["Enabled"] = "启用",

	},
	{
		{
			name = "SHOWPLAYERSOPTIONS",
			label = "玩家标识",
			hover = "在屏幕边缘显示玩家的指向箭头。",

		},
		{
			name = "SHOWPLAYERICONS",
			label = "玩家地图图标",
			hover = "地图上显示玩家图标",

		},
		{
			name = "FIREOPTIONS",
			label = "营火标识",
			hover = "显示营火指向箭头，像玩家的一样" ..
					"\n玩家会看到营火冒烟。",

		},
		{
			name = "SHOWFIREICONS",
			label = "营火地图图标",
			hover = "在地图上显示全地图内的营火（当营火被设定为显示）。" ..
					"\n玩家会看到营火冒烟。",

		},
		{
			name = "SHAREMINIMAPPROGRESS",
			label = "共享地图",
			hover = "玩家之间共享探索的地图。仅在" ..
					"\n'玩家标识' 和 '玩家图标' 没有全部关闭下工作" ..
					"\n这种方式会导致探索的地图不能保存/载入。",

		},
		{
			name = "OVERRIDEMODE",
			label = "荒野覆盖",
			hover = "如果启用，它会使用您在荒野模式下设置的其他选项。" ..
					"\n否则，将不显示玩家图标/标识，但所有的营火会冒烟并且会在地图上显示。",

		},
		{
			name = "ENABLEPINGS",
			label = "探索消息",
			hover = "是否允许玩家发送探索地图消息（Alt + 点击）地图。",
		},
	}
)
