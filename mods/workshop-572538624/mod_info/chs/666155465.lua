_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"在鼠标指向时显示目标的各种信息。",
	{
		["undefined"]= "未设置",
		["?"]= "使用服务器设置",
		["No"]= "否",
		["Yes"]= "是",
		["long"]= "长",
		["short"]= "短",
		["Hunger: +12.5 / Sanity: -10 / Health: +3"]= "饥饿: +12.5 / 精神: -10 / 生命: +3",
		["interface"]= "游戏",
		["wikia"]= "维基亚",
		["Hunger / Sanity / Health"]= "饥饿 / 精神 / 生命",
		["Health / Hunger / Sanity"]= "生命 / 饥饿 / 精神",
		["Forbidden"]= "禁止",
		["Server won't send food info to clients\nand their settings will not matter."]= "服务器不会向客户端发送食物信息，所以无所谓他们是否设置。",
	},
	{
		{
					name = "food_style",
					label = "食物样式",
		},
		{
					name = "food_order",
					label = "食品属性顺序",
		},
		{
					name = "food_estimation",
					label = "估算食物腐败状态",
					hover = "应该估算食物腐败状态吗？",
		},
		{
					name = "show_food_units",
					label = "显示食品的单位",
					hover = "例： 肉、蔬菜等单位",
		},
	}
)
