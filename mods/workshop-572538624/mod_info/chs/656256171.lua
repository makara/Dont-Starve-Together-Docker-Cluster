_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"用来赌博的老虎机！",
	{

	},
	{
		{
			name = "position",
			label = "位置",
			hover = "如果你想转移到新的随机的地方，切换两个随机选项。",
			options = {
				{description = "关", data = 0},
				{description = "靠近大门", data = 1},
				{description = "中央", data = 2},
				{description = "随机 1", data = 3},
				{description = "随机 2", data = 4},
			},
		},
		{
			name = "give_dubloons",
			label = "每天发放金币",
			hover = "每天发放多少金币\n 0.5 意思是 50% 几率。",
			options = {
				{description = "关", data = 0},
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
			label = "不会发放金币",
			hover = "从世界开始的多少天停止发放金币。",
			options = {
				{description = "关", data = 0},
				{description = "1 天", data = 1},
				{description = "2 天", data = 2},
				{description = "3 天", data = 3},
				{description = "5 天", data = 5},
				{description = "10 天", data = 10},
			},
		},
		{
			name = "rec_gold",
			label = "金块制造",
			--hover = "",
			options = {
				{description = "关", data = 0},
				{description = "1 金币", data = 1},
				{description = "2 金币", data = 2},
				{description = "3 金币", data = 3},
				{description = "4 金币", data = 4},
				{description = "5 金币", data = 5},
			},
		},
		{
			name = "rec_dubloon",
			label = "金币制造",
			--hover = "",
			options = {
				{description = "关", data = 0},
				{description = "1 金块", data = 1},
				{description = "2 金块", data = 2},
				{description = "3 金块", data = 3},
				{description = "4 金块", data = 4},
				{description = "5 金块", data = 5},
			},
		},

	}
)
