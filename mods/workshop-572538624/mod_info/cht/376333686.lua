_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"顯示健康，飢餓，精神，溫度，和世界天數。",
	{
		["Show"] = "顯示",
		["Hide"] = "隱藏",
		["Celsius"] = "攝氏",
		["Fahrenheit"] = "華氏",
		["Don't"] = "不顯示",
		["Night Only"] = "僅夜晚",
		["Dusk"] = "加黃昏",
		["Always"] = "總是",
		["Yes"] = "是",
		["No"] = "否",
		["Micro"] = "微型",
		["Compact"] = "緊湊型",
		["Clock"] = "時鐘",
		["Badges will only be shown if both temperatures are shown."] = "當兩個溫度都顯示時標識才會顯示。",
		["Badges will never be shown."] = "標識不會顯示。",
		["Show the moon only at night, like usual."] = "像通常一樣僅在夜晚顯示月亮。",
		["Show the moon during both night and dusk."] = "在夜晚和黃昏顯示月亮。",
		["Show the moon at all times."] = "總是顯示月亮！",
		["Beaver"] = "海狸",
		["Show the moon like it is in Southern Hemisphere."] = "顯示在南半球的月亮。",
		["Show the moon like it is in the Northern Hemisphere."] = "顯示在北半球的月亮。",
		["Hover"] = "懸停",

	},
	{
		{
			name = "SHOWTEMPERATURE",
			label = "溫度",
			hover = "顯示玩家的溫度",
		},
		{
			name = "SHOWWORLDTEMP",
			label = "顯示世界溫度",
			hover = "顯示世界的溫度 \n(這並不考慮熱源(如火災)。",
		},
		{
			name = "SHOWTEMPBADGES",
			label = "顯示溫度圖示",
			hover = "顯示圖示來區分不同溫度。",
		},
		{
			name = "UNIT",
			label = "溫度單位",
			hover = "做正確的事情，把這東西放在遊戲裡。",
			options =	{
					{description = "遊戲單位", data = "T",
						hover = "遊戲使用的溫度資料。"
							.."\n凍結0，過熱70；得到警告5來自每個。"},
					{description = "攝氏度", data = "C",
						hover = "遊戲所使用的溫度資料，更合理的減少了一半。"
							.."\n凍結0，過熱35；得到警告2.5來自每個。"},
					{description = "華氏度", data = "F",
						hover = "你最喜歡的溫度單位，但是沒有意義。"
							.."\n凍結32，過熱158；得到警告9來自每個。"},
				},
		},
		{
			name = "SHOWWANINGMOON",
			label = "顯示衰退",
			hover = "分別顯示滿月和月相變化階段。"
				 .. "\n可能是錯誤的當你第一次進入遊戲(直到月相變化)",
		},
		{
			name = "SHOWMOON",
			label = "顯示月亮",
			hover = "顯示白天和黃昏的月相。",
		},
		{
			name = "SHOWNEXTFULLMOON",
			label = "預測滿月",
			hover = "預測下一個滿月的天數"
				 .. "\n在滑鼠懸停時顯示。",
		},
		{
			name = "PREDICTMOONPHASE",
			label = "預測月相",
			hover = "在天數的基礎上預測計算月相"
				 .. "\n（技術上游戲在黃昏改變月相）。"
				 .. "\n這可能是不正確的，如果一個 mod/設定 改變了月相階段。",
		},
		{
			name = "FLIPMOON",
			label = "翻轉月相",
			hover = "翻轉的月相 (恢復舊的行為)."
				.. "\n顯示南半球的月相",
		},
		{
			name = "SEASONOPTIONS",
			label = "季節時鐘",
			hover = "新增一個時鐘，顯示了季節並重新排列了更合適的狀態標識。"
			.."\n另外，增加了一個標識來顯示這個季節的已過天數和滑鼠懸停時顯示到下個季節天數。",
		},
		{
			name = "SHOWNAUGHTINESS",
			label = "顯示淘氣值",
			hover = "顯示玩家的淘氣值。聯機版無效。",
		},
		{
			name = "SHOWBEAVERNESS",
			label = "木頭值",
			hover = "顯示伍迪人形狀態的木頭值。聯機版無效。",
		},
		{
			name = "HIDECAVECLOCK",
			label = "洞穴時鐘",
			hover = "在洞穴裡面顯示時鐘。 通常無效。",
		},
		{
			name = "SHOWSTATNUMBERS",
			label = "狀態數字",
			hover = "顯示健康，飢餓和理智的數字。",
		},
		{
			name = "SHOWMAXONNUMBERS",
			label = "顯示最大（Max）字元",
			hover = "狀態顯示 最大\"Max:\" 字元。",
		},
		{
			name = "HUDSCALEFACTOR",
			label = "HUD 尺寸",
			hover = "你可以依據遊戲的HUD介面的剩餘部分調整三圍屬性顯示器和時鐘的大小。",
		},

	}
)
