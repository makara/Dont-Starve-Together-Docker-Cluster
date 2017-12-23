_G.ChinesePlus.SetConfigTranslation(mod_to_c,
  "允许你改变雪球发射机行为。",
  {
    ["no"] = "否",
    ["yes"] = "是",
  },
  {
    {
      name = "ExtinguishMode",
      label = "灭火模式",
      hover = "忽略哪种目标？",
      options =
      {
        {description = "默认", data = "default" , hover = "默认行为" },
        {description = "冷", data = "coldsource" , hover = "放过冷火" },
        {description = "所有", data = "anysource" , hover = "放过所有营火或光源" },
      },
      default = "coldsource",
    },

    {
      name = "FuelRateMod",
      label = "燃料",
      hover = "配置雪球机消耗燃料的速度。",
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
        {description = "默认", data = 1.0 , hover = "默认消耗速度" },
        {description = "-100%", data = 0.5 , hover = "100% 减慢消耗" },
        {description = "-200%", data = 0.33 , hover = "200% 减慢消耗" },
        {description = "-300%", data = 0.25 , hover = "300% 减慢消耗" },
        {description = "-400%", data = 0.2 , hover = "400% 减慢消耗" },
        {description = "-500%", data = 0.17 , hover = "500% 减慢消耗" },
        {description = "-600%", data = 0.14 , hover = "600% 减慢消耗" },
        {description = "-700%", data = 0.13 , hover = "700% 减慢消耗" },
        {description = "-800%", data = 0.11 , hover = "800% 减慢消耗" },
        {description = "-900%", data = 0.1 , hover = "900% 减慢消耗" },
        {description = "无限", data = 0 , hover = "无限燃料" },
      },
      default = 1.0,
    },

    {
      name = "RangeMod",
      label = "范围",
      hover = "调整雪球机覆盖的范围。",
      options =
      {
        {description = "50%", data = 0.5, hover = "一半"},
        {description = "60%", data = 0.6, hover = "0.6 倍"},
        {description = "70%", data = 0.7, hover = "0.7 倍"},
        {description = "80%", data = 0.8, hover = "0.8 倍"},
        {description = "90%", data = 0.9, hover = "0.9 倍"},
        {description = "默认", data = 1.0 , hover = "默认范围" },
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
      label = "目标可为玩家",
      hover = "雪球机夏天可以为玩家降温?",
    },

    {
      name = "PlayerTempThreshold",
      label = "玩家温度临界值",
      hover = "温度超过这个就会尝试降温。",
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
      label = "玩家每次温度下降",
      hover = "每个雪球减少多少温度？",
    },

    {
      name = "PlayerCanFreeze",
      label = "冻结玩家",
      hover = "雪球机可以冰冻玩家?",
    },

  }
)
