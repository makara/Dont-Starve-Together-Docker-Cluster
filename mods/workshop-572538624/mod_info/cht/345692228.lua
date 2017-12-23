_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"在遊戲時的控制螢幕增加一個小地圖。",
	{
		["None"] = "無",
		["Very Tiny"] = "極其小",
		["Tiny"] = "微小",
		["Very Small"] = "很小",
		["Small"] = "小",
		["Medium"] = "中等",
		["Large"] = "大",
		["Very Large"] = "很大",
		["Huge"] = "巨大",
		["Giant"] = "超級大",
	},
	{
		{
			name = "Minimap Size",
			label = "小地圖大小",
			options =
			{
				{description = "微小", data = 0.125},
				{description = "小", data = 0.175},
				{description = "中等", data = 0.225},
				{description = "大", data = 0.275},
				{description = "巨大", data = 0.325},
				{description = "超級大", data = 0.375},
			},
		},
		{
			name = "Position",
			label = "位置",
			options =
			{
				{description = "右上", data = "top_right"},
				{description = "左上", data = "top_left"},
				{description = "頂中", data = "top_center"},
				{description = "居中左", data = "middle_left"},
				{description = "中心", data = "middle_center"},
				{description = "居中右", data = "middle_right"},
				{description = "左下", data = "bottom_left"},
				{description = "底中", data = "bottom_center"},
				{description = "右下", data = "bottom_right"},
			},
		},
		{
			name = "Horizontal Margin",
			label = "水平邊距",
		},
		{
			name = "Vertical Margin",
			label = "垂直邊距",
		},
		{
			name = "Updates Per Second",
			label = "更新限制",
			hover = "小地圖限制每秒更新幾次，有助於減小FPS下降",
			options =
			{
				{description = "預設", data = 0, hover = "更新限制關閉，一直保持小地圖最新"},
				{description = "10 次", data = 0.1, hover = "每秒更新10次。"},
				{description = "8 次", data = 0.125, hover = "每秒更新8次。"},
				{description = "6 次", data = 0.166, hover = "每秒更新6次。"},
				{description = "5 次", data = 0.20, hover = "每秒更新5次。"},
				{description = "4 次", data = 0.25, hover = "每秒更新4次。"},
				{description = "3 次", data = 0.333, hover = "每秒更新3次。"},
				{description = "2 次", data = 0.5, hover = "每秒更新2次。"},
				{description = "1 次", data = 1, hover = "每秒更新1次。"},
				{description = "4/5 次", data = 1.25, hover = "5秒更新4次。"},
				{description = "2/3 次", data = 1.5, hover = "3秒更新2次。"},
				{description = "1/2 次", data = 2, hover = "2秒更新1次。"},
				{description = "1/3 次", data = 3, hover = "3秒更新1次。"},
				{description = "1/4 次", data = 4, hover = "4秒更新1次。"},
				{description = "1/5 次", data = 5, hover = "5秒更新1次。"},
				{description = "1/6 次", data = 6, hover = "6秒更新1次。"},
				{description = "1/8 次", data = 8, hover = "8秒更新1次。"},
				{description = "1/10 次", data = 10, hover = "10秒更新1次。"},
				{description = "1/30 次", data = 30, hover = "30秒更新1次。"},
			},
		},

	}
)
