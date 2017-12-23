_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"你不能打开，收获，装备，损毁不属于你的东西。",
	{
		["Yes"] = "是",
		["No"] = "否",
	},
	{
		{
			name = "Ownership",
			label = "拥有者的数量",
			hover = "可以注册为拥有者的数量。\n一个是唯一，多人是可以注册多个拥有者，\n公共则是任何人都能用。",
			options =
			{
				{description = "一个", data = "One"},
				{description = "多人", data = "Multi"},
				{description = "公共", data = "All"}
			},
		},
		{
			name = "Share_Container",
			label = "共享容器",
		},
		{
			name = "Drop_Content",
			label = "容器掉落",
			hover = "如果共享容器选项为'是'，则容器总是会掉落所有东西。",
			options =
			{
				{description = "被烧毁时", data = "burn"},
				{description = "被砸时", data = "work"},
			},
		},
		{
			name = "Allow_Harvesting",
			label = "允许收获",
		},
		{
			name = "Share_Equipments",
			label = "共享装备",
		},
		{
			name = "Fortify_Building",
			label = "建筑加强",
		},
		{
			name = "Player_Trap",
			label = "玩家触发陷阱",
		},
	}
)
