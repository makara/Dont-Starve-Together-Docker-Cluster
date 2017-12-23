_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"在滑鼠懸停或控制器自動選擇目標生物時，顯示生物的確切生命值。",
	{
		["Value"] = "數值",
		["Percentage"] = "百分比",
		["Both"] = "所有",
		["Yes"] = "開",
		["No"] = "關",
		["Always"] = "總是",
	},
	{
		{
				name = "show_type",
				label = "顯示方式",
				hover = "生命指示的型別。",
		},
		{
			name = "divider",
			label = "樣式",
			hover = "指示的括號樣式。",
		},
		{
			name = "use_blacklist",
			label = "黑名單",
			hover = "預置的黑名單。\n建議使用該選項，因為它提高了相容性\n某些mod可以增加你不可視目標的生命指示。",
		},
		{
			name = "unknwon_prefabs",
			label = "未知目標",
			hover = "未知目標的自動檢測，更多型別的物件。相容性不佳。",
			options =
			{
				{description = "忽略", data = 0, hover = "100% 相容\n但是mod生物和玩家的生命值不會顯示。"},
				{description = "玩家", data = 1, hover = '99% 相容\n將顯示有“玩家”標籤目標的生命值。'},
				{description = "生物", data = 2, hover = '97% 相容\n將顯示有“玩家”，“怪物”，“動物”，“小生物”標籤目標的生命值。'},
				{description = "所有", data = 3, hover = "90% 相容\n將顯示所有已知標籤目標的生命值。"},
			},
		},
		{
			name = "send_unknwon_prefabs",
			label = "傳送錯誤報告",
			hover = "傳送未知的目標的報告，或許下個MOD更新會支援。",
		},
		{
			name = "random_health_value",
			label = "機會波動",
			hover = "生命值是不準確的。最大生命值是隱藏的。",
		},
		{
			name = "random_range",
			label = "隨機區間",
			hover = "產生隨機生命值的時間間隔（最大健康的百分比。）",
		},

	}
)
