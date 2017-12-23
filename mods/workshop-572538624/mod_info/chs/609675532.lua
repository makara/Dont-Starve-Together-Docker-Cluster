_G.ChinesePlus.SetConfigTranslation(mod_to_c, [[
限制物品生成的数量
限制任何你想要限制的！
与 “Less lags” 相同的理论，但用了更聪明的方式！
如果生成的物品达到限制，将在0.1秒后自动发 “反生成”（默认）
配置:
	- 反生成延迟: 到达限制时自动反生成的延迟时间
	- 计数模式: 计算物品的方法
		- 更多运行内存: 使用表+事件计数
		- 更多中央处理器 : 循环所有
	- 反生成模式: 决定哪一个物品要反生成
		- 删除最新 : 使用更少的资源，但看起来不是很自然
		- 删除最早 : 正如其名一样，应该时最自然的
		- 删除随机 : 使用最多的资源，但更自然
许可证：MIT，版权所有（c）2016 cs8425
]],
	{
		["more RAM"] = "更多运行内存",
		["more CPU"] = "更多中央处理器",
		["remove newest"] = "删除最新",
		["remove oldest"] = "删除最早",
		["remove random"] = "删除随机",
		["Yes"] = "是",
		["No"] = "否",
		["default"] = "默认-无限制",
		["set your self"] = "最好自己改",
	},
	{
		{
			name = "despawn_delay",
			label = "反生成延迟",
		},
		{
			name = "res_mode",
			label = "计数模式",
		},
		{
			name = "despawn_mode",
			label = "反生成模式",
		},
		{
			name = "_debug",
			label = "调试模式",
		},
		{
			name = "limit_table",
			label = "限制物品的表",
			hover = "建议 modoverrides.lua 更改",
		},

	}
)
