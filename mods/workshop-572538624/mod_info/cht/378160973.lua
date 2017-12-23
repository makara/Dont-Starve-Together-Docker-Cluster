_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"預設情況下。\n在玩家列表螢幕（TAB），會顯示所有玩家的箭頭指向圖示。\n全地圖在小地圖上顯示玩家圖示。\n在營火中燃燒木炭時顯示營火圖示。",
	{
		["Always"] = "總是",
		["Scoreboard"] = "玩家列表",
		["Never"] = "從不",
		["Show"] = "顯示",
		["Hide"] = "隱藏",
		["Charcoal"] = "木炭",
		["Disabled"] = "關閉",
		["Enabled"] = "啟用",

	},
	{
		{
			name = "SHOWPLAYERSOPTIONS",
			label = "玩家標識",
			hover = "在螢幕邊緣顯示玩家的指向箭頭。",

		},
		{
			name = "SHOWPLAYERICONS",
			label = "玩家地圖圖示",
			hover = "地圖上顯示玩家圖示",

		},
		{
			name = "FIREOPTIONS",
			label = "營火標識",
			hover = "顯示營火指向箭頭，像玩家的一樣" ..
					"\n玩家會看到營火冒煙。",

		},
		{
			name = "SHOWFIREICONS",
			label = "營火地圖圖示",
			hover = "在地圖上顯示全地圖內的營火（當營火被設定為顯示）。" ..
					"\n玩家會看到營火冒煙。",

		},
		{
			name = "SHAREMINIMAPPROGRESS",
			label = "共享地圖",
			hover = "玩家之間共享探索的地圖。僅在" ..
					"\n'玩家標識' 和 '玩家圖示' 沒有全部關閉下工作" ..
					"\n這種方式會導致探索的地圖不能儲存/載入。",

		},
		{
			name = "OVERRIDEMODE",
			label = "荒野覆蓋",
			hover = "如果啟用，它會使用您在荒野模式下設定的其他選項。" ..
					"\n否則，將不顯示玩家圖示/標識，但所有的營火會冒煙並且會在地圖上顯示。",

		},
		{
			name = "ENABLEPINGS",
			label = "探索訊息",
			hover = "是否允許玩家傳送探索地圖訊息（Alt + 點選）地圖。",
		},
	}
)
