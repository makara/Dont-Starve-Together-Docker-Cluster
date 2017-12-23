_G.ChinesePlus.SetConfigTranslation(mod_to_c, [[
限制物品生成的數量
限制任何你想要限制的！
與 “Less lags” 相同的理論，但用了更聰明的方式！
如果生成的物品達到限制，將在0.1秒後自動發 “反生成”（預設）
配置:
	- 反生成延遲: 到達限制時自動反生成的延遲時間
	- 計數模式: 計算物品的方法
		- 更多執行記憶體: 使用表+事件計數
		- 更多中央處理器 : 迴圈所有
	- 反生成模式: 決定哪一個物品要反生成
		- 刪除最新 : 使用更少的資源，但看起來不是很自然
		- 刪除最早 : 正如其名一樣，應該時最自然的
		- 刪除隨機 : 使用最多的資源，但更自然
許可證：MIT，版權所有（c）2016 cs8425
]],
	{
		["more RAM"] = "更多執行記憶體",
		["more CPU"] = "更多中央處理器",
		["remove newest"] = "刪除最新",
		["remove oldest"] = "刪除最早",
		["remove random"] = "刪除隨機",
		["Yes"] = "是",
		["No"] = "否",
		["default"] = "預設-無限制",
		["set your self"] = "最好自己改",
	},
	{
		{
			name = "despawn_delay",
			label = "反生成延遲",
		},
		{
			name = "res_mode",
			label = "計數模式",
		},
		{
			name = "despawn_mode",
			label = "反生成模式",
		},
		{
			name = "_debug",
			label = "除錯模式",
		},
		{
			name = "limit_table",
			label = "限制物品的表",
			hover = "建議 modoverrides.lua 更改",
		},

	}
)
