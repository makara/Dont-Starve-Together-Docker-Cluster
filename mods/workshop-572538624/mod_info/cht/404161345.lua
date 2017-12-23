_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"你不能開啟，收穫，裝備，損毀不屬於你的東西。",
	{
		["Yes"] = "是",
		["No"] = "否",
	},
	{
		{
			name = "Ownership",
			label = "擁有者的數量",
			hover = "可以註冊為擁有者的數量。\n一個是唯一，多人是可以註冊多個擁有者，\n公共則是任何人都能用。",
			options =
			{
				{description = "一個", data = "One"},
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
			hover = "如果共享容器選項為'是'，則容器總是會掉落所有東西。",
			options =
			{
				{description = "被燒燬時", data = "burn"},
				{description = "被砸時", data = "work"},
			},
		},
		{
			name = "Allow_Harvesting",
			label = "允許收穫",
		},
		{
			name = "Share_Equipments",
			label = "共享裝備",
		},
		{
			name = "Fortify_Building",
			label = "建築加強",
		},
		{
			name = "Player_Trap",
			label = "玩家觸發陷阱",
		},
	}
)
