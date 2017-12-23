_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"用來賭博的老虎機！",
	{

	},
	{
		{
			name = "position",
			label = "位置",
			hover = "如果你想轉移到新的隨機的地方，切換兩個隨機選項。",
			options = {
				{description = "關", data = 0},
				{description = "靠近大門", data = 1},
				{description = "中央", data = 2},
				{description = "隨機 1", data = 3},
				{description = "隨機 2", data = 4},
			},
		},
		{
			name = "give_dubloons",
			label = "每天發放金幣",
			hover = "每天發放多少金幣\n 0.5 意思是 50% 機率。",
			options = {
				{description = "關", data = 0},
				{description = "0.1", data = 0.1},
				{description = "0.2", data = 0.2},
				{description = "0.3", data = 0.3},
				{description = "0.5", data = 0.5},
				{description = "1", data = 1},
				{description = "2", data = 2},
				{description = "3", data = 3},
			},
		},
		{
			name = "dont_give_dubloons",
			label = "不會發放金幣",
			hover = "從世界開始的多少天停止發放金幣。",
			options = {
				{description = "關", data = 0},
				{description = "1 天", data = 1},
				{description = "2 天", data = 2},
				{description = "3 天", data = 3},
				{description = "5 天", data = 5},
				{description = "10 天", data = 10},
			},
		},
		{
			name = "rec_gold",
			label = "金塊製造",
			--hover = "",
			options = {
				{description = "關", data = 0},
				{description = "1 金幣", data = 1},
				{description = "2 金幣", data = 2},
				{description = "3 金幣", data = 3},
				{description = "4 金幣", data = 4},
				{description = "5 金幣", data = 5},
			},
		},
		{
			name = "rec_dubloon",
			label = "金幣制造",
			--hover = "",
			options = {
				{description = "關", data = 0},
				{description = "1 金塊", data = 1},
				{description = "2 金塊", data = 2},
				{description = "3 金塊", data = 3},
				{description = "4 金塊", data = 4},
				{description = "5 金塊", data = 5},
			},
		},

	}
)
