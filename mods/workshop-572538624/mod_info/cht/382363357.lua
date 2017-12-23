_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"在釣魚的時候獲得一些垃圾或鰻魚。",
	{

	},
	{
		{
        name = "eel_chance",
        label = "鰻魚機率",
		hover = "豬王每條鰻魚交換 5 個金塊！\n所以最好是儘量減少這個機率。",
        options =
        {
            {description = "0%", data = 0},
            {description = "1%", data = 0.01},
            {description = "2%", data = 0.02},
            {description = "3%", data = 0.03},
            {description = "5%", data = 0.05},
            {description = "7%", data = 0.07},
            {description = "10%", data = 0.1},
            {description = "12%", data = 0.12},
            {description = "15%", data = 0.15},
            {description = "20%", data = 0.2},
            {description = "30%(簡單!)", data = 0.3},
            {description = "40%(簡單!)", data = 0.4},
            {description = "50%(簡單!)", data = 0.5},
            {description = "60%(簡單!)", data = 0.6},
            {description = "70%(簡單!)", data = 0.7},
        },
        default = 0.15,
    },
    {
        name = "gears_chance",
        label = "齒輪機率",
        options =
        {
            {description = "0%", data = 0},
            {description = "1%", data = 0.01},
            {description = "2%", data = 0.02},
            {description = "3%", data = 0.03},
            {description = "4%", data = 0.04},
            {description = "5%", data = 0.05},
            {description = "10%(簡單!)", data = 0.1},
            {description = "15%(簡單!)", data = 0.15},
        },
        default = 0.02,
    },
    {
        name = "junk_chance",
        label = "垃圾機率",
        options =
        {
            {description = "5%", data = 0.05},
            {description = "10%", data = 0.1},
            {description = "15%", data = 0.15},
            {description = "20%", data = 0.2},
            {description = "30%", data = 0.3},
            {description = "40%(簡單!)", data = 0.4},
            {description = "50%(簡單!)", data = 0.5},
            {description = "60%(簡單!)", data = 0.6},
        },
        default = 0.2,
    },

	}
)
