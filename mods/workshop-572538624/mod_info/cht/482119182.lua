_G.ChinesePlus.SetConfigTranslation(mod_to_c,
  "允許你改變雪球發射機行為。",
  {
    ["no"] = "否",
    ["yes"] = "是",
  },
  {
    {
      name = "ExtinguishMode",
      label = "滅火模式",
      hover = "忽略哪種目標？",
      options =
      {
        {description = "預設", data = "default" , hover = "預設行為" },
        {description = "冷", data = "coldsource" , hover = "放過冷火" },
        {description = "所有", data = "anysource" , hover = "放過所有營火或光源" },
      },
      default = "coldsource",
    },

    {
      name = "FuelRateMod",
      label = "燃料",
      hover = "配置雪球機消耗燃料的速度。",
      options =
      {
        {description = "+1000%", data = 11.0 , hover = "1000% 加速消耗" },
        {description = "+900%", data = 10.0 , hover = "900% 加速消耗" },
        {description = "+800%", data = 9.0 , hover = "800% 加速消耗" },
        {description = "+700%", data = 8.0 , hover = "700% 加速消耗" },
        {description = "+600%", data = 7.0 , hover = "600% 加速消耗" },
        {description = "+500%", data = 6.0 , hover = "500% 加速消耗" },
        {description = "+400%", data = 5.0 , hover = "400% 加速消耗" },
        {description = "+300%", data = 4.0 , hover = "300% 加速消耗" },
        {description = "+200%", data = 3.0 , hover = "200% 加速消耗" },
        {description = "+100%", data = 2.0 , hover = "100% 加速消耗" },
        {description = "預設", data = 1.0 , hover = "預設消耗速度" },
        {description = "-100%", data = 0.5 , hover = "100% 減慢消耗" },
        {description = "-200%", data = 0.33 , hover = "200% 減慢消耗" },
        {description = "-300%", data = 0.25 , hover = "300% 減慢消耗" },
        {description = "-400%", data = 0.2 , hover = "400% 減慢消耗" },
        {description = "-500%", data = 0.17 , hover = "500% 減慢消耗" },
        {description = "-600%", data = 0.14 , hover = "600% 減慢消耗" },
        {description = "-700%", data = 0.13 , hover = "700% 減慢消耗" },
        {description = "-800%", data = 0.11 , hover = "800% 減慢消耗" },
        {description = "-900%", data = 0.1 , hover = "900% 減慢消耗" },
        {description = "無限", data = 0 , hover = "無限燃料" },
      },
      default = 1.0,
    },

    {
      name = "RangeMod",
      label = "範圍",
      hover = "調整雪球機覆蓋的範圍。",
      options =
      {
        {description = "50%", data = 0.5, hover = "一半"},
        {description = "60%", data = 0.6, hover = "0.6 倍"},
        {description = "70%", data = 0.7, hover = "0.7 倍"},
        {description = "80%", data = 0.8, hover = "0.8 倍"},
        {description = "90%", data = 0.9, hover = "0.9 倍"},
        {description = "預設", data = 1.0 , hover = "預設範圍" },
        {description = "110%", data = 1.1, hover = "1.1 倍"},
        {description = "120%", data = 1.2, hover = "1.2 倍"},
        {description = "130%", data = 1.3, hover = "1.3 倍"},
        {description = "140%", data = 1.4, hover = "1.4 倍"},
        {description = "150%", data = 1.5, hover = "1.5 倍"},
        {description = "160%", data = 1.6, hover = "1.6 倍"},
        {description = "170%", data = 1.7, hover = "1.7 倍"},
        {description = "180%", data = 1.8, hover = "1.8 倍"},
        {description = "190%", data = 1.9, hover = "1.9 倍"},
        {description = "200%", data = 2.0, hover = "2 倍"},
      },
      default = 1.0,
    },

    {
      name = "TargetPlayer",
      label = "目標可為玩家",
      hover = "雪球機夏天可以為玩家降溫?",
    },

    {
      name = "PlayerTempThreshold",
      label = "玩家溫度臨界值",
      hover = "溫度超過這個就會嘗試降溫。",
      options =
      {
        {description = "40 ℃", data = 40},
        {description = "45 ℃", data = 45},
        {description = "50 ℃", data = 50},
        {description = "55 ℃", data = 55},
        {description = "60 ℃", data = 60},
        {description = "65 ℃", data = 65},
        {description = "70 ℃", data = 70},
      },
      default = 60,
    },

    {
      name = "PlayerTempReduction",
      label = "玩家每次溫度下降",
      hover = "每個雪球減少多少溫度？",
    },

    {
      name = "PlayerCanFreeze",
      label = "凍結玩家",
      hover = "雪球機可以冰凍玩家?",
    },

  }
)
