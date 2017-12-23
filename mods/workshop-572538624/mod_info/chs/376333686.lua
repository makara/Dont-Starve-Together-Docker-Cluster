_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"显示健康，饥饿，精神，温度，和世界天数。",
	{
		["Show"] = "显示",
		["Hide"] = "隐藏",
		["Celsius"] = "摄氏",
		["Fahrenheit"] = "华氏",
		["Don't"] = "不显示",
		["Night Only"] = "仅夜晚",
		["Dusk"] = "加黄昏",
		["Always"] = "总是",
		["Yes"] = "是",
		["No"] = "否",
		["Micro"] = "微型",
		["Compact"] = "紧凑型",
		["Clock"] = "时钟",
		["Badges will only be shown if both temperatures are shown."] = "当两个温度都显示时标识才会显示。",
		["Badges will never be shown."] = "标识不会显示。",
		["Show the moon only at night, like usual."] = "像通常一样仅在夜晚显示月亮。",
		["Show the moon during both night and dusk."] = "在夜晚和黄昏显示月亮。",
		["Show the moon at all times."] = "总是显示月亮！",
		["Beaver"] = "海狸",
		["Show the moon like it is in Southern Hemisphere."] = "显示在南半球的月亮。",
		["Show the moon like it is in the Northern Hemisphere."] = "显示在北半球的月亮。",
		["Hover"] = "悬停",

	},
	{
		{
			name = "SHOWTEMPERATURE",
			label = "温度",
			hover = "显示玩家的温度",
		},
		{
			name = "SHOWWORLDTEMP",
			label = "显示世界温度",
			hover = "显示世界的温度 \n(这并不考虑热源(如火灾)。",
		},
		{
			name = "SHOWTEMPBADGES",
			label = "显示温度图标",
			hover = "显示图标来区分不同温度。",
		},
		{
			name = "UNIT",
			label = "温度单位",
			hover = "做正确的事情，把这东西放在游戏里。",
			options =	{
					{description = "游戏单位", data = "T",
						hover = "游戏使用的温度数据。"
							.."\n冻结0，过热70；得到警告5来自每个。"},
					{description = "摄氏度", data = "C",
						hover = "游戏所使用的温度数据，更合理的减少了一半。"
							.."\n冻结0，过热35；得到警告2.5来自每个。"},
					{description = "华氏度", data = "F",
						hover = "你最喜欢的温度单位，但是没有意义。"
							.."\n冻结32，过热158；得到警告9来自每个。"},
				},
		},
		{
			name = "SHOWWANINGMOON",
			label = "显示衰退",
			hover = "分别显示满月和月相变化阶段。"
				 .. "\n可能是错误的当你第一次进入游戏(直到月相变化)",
		},
		{
			name = "SHOWMOON",
			label = "显示月亮",
			hover = "显示白天和黄昏的月相。",
		},
		{
			name = "SHOWNEXTFULLMOON",
			label = "预测满月",
			hover = "预测下一个满月的天数"
				 .. "\n在鼠标悬停时显示。",
		},
		{
			name = "PREDICTMOONPHASE",
			label = "预测月相",
			hover = "在天数的基础上预测计算月相"
				 .. "\n（技术上游戏在黄昏改变月相）。"
				 .. "\n这可能是不正确的，如果一个 mod/设置 改变了月相阶段。",
		},
		{
			name = "FLIPMOON",
			label = "翻转月相",
			hover = "翻转的月相 (恢复旧的行为)."
				.. "\n显示南半球的月相",
		},
		{
			name = "SEASONOPTIONS",
			label = "季节时钟",
			hover = "添加一个时钟，显示了季节并重新排列了更合适的状态标识。"
			.."\n另外，增加了一个标识来显示这个季节的已过天数和鼠标悬停时显示到下个季节天数。",
		},
		{
			name = "SHOWNAUGHTINESS",
			label = "显示淘气值",
			hover = "显示玩家的淘气值。联机版无效。",
		},
		{
			name = "SHOWBEAVERNESS",
			label = "木头值",
			hover = "显示伍迪人形状态的木头值。联机版无效。",
		},
		{
			name = "HIDECAVECLOCK",
			label = "洞穴时钟",
			hover = "在洞穴里面显示时钟。 通常无效。",
		},
		{
			name = "SHOWSTATNUMBERS",
			label = "状态数字",
			hover = "显示健康，饥饿和理智的数字。",
		},
		{
			name = "SHOWMAXONNUMBERS",
			label = "显示最大（Max）字符",
			hover = "状态显示 最大\"Max:\" 字符。",
		},
		{
			name = "HUDSCALEFACTOR",
			label = "HUD 尺寸",
			hover = "你可以依据游戏的HUD界面的剩余部分调整三围属性显示器和时钟的大小。",
		},

	}
)
