_G.ChinesePlus.SetConfigTranslation(mod_to_c,
  "使世界资源能够随着时间的推移而再生。",
  {
    ["Disabled"] = "关闭",
    ["Enabled"] = "开启",
  },
  {
    {
      name = "WorldResourceRegenerationSpeed",
      label = "世界资源再生速度",
      hover = "资源再生速度。有私用的计时器，不使用世界时间",
      options = {
        {description = "关闭", data = 0},
        {description = "1 天", data = 1},
        {description = "2 天", data = 2},
        {description = "3 天", data = 3},
        {description = "4 天", data = 4},
        {description = "5 天", data = 5},
        {description = "6 天", data = 6},
        {description = "7 天", data = 7},
        {description = "8 天", data = 8},
        {description = "9 天", data = 9},
        {description = "10 天", data = 10},
        {description = "11 天", data = 11},
        {description = "12 天", data = 12},
        {description = "13 天", data = 13},
        {description = "14 天", data = 14},
        {description = "15 天", data = 15},
        {description = "16 天", data = 16},
        {description = "17 天", data = 17},
        {description = "18 天", data = 18},
        {description = "19 天", data = 19},
        {description = "20 天", data = 20},
      },
      default = 5,
    },
    {
      -- format of the value: list of prefab specifications, separated by commas (,)
      -- a prefab specification is "prefabname:number", where number is that prefab's regeneration speed, it has to be an integer in the range of [0,2*WorldResourceRegenerationSpeed)
      -- speed 0 means don't regenerate the prefab
      -- example: berrybush:5,grass:4,beehive:7,spiderden:9,wasphive:0
      -- the option's value doesn't replace settings in modmain, it overwrites/adds to them
      -- that is, if you want to add one new prefab to the regeneration list, specify just it, you don't need to list all other prefabs
      -- if you want to change the regeneration speed of one prefab, specify just it, you don't need to list other prefabs
      -- however, if you want to enable regeneration of just one prefab and disable regeneration of all other prefabs, you will need to specify all those other prefabs with the speed of zero
      name = "CustomPrefabs",
      label = "自定义物品",
      hover = "预设列表（使用专用服务器的 modoverrides.lua 设置）",
    },
    {
      name = "EnableTurfsRegeneration",
      label = "地皮再生",
      hover = "开启地皮的再生",
    },
    {
      name = "SpawnFreeZone",
      label = "自由产生区",
      hover = "设置自由产生区的大小\n4是 1 块地皮的大小\n大小是从区域中的一个建筑计算的",
    },
    {
      name = "EnableGraveStoneRemoval",
      label = "墓碑去除",
      hover = "删除墓碑当它被挖了",
    },
    {
      name = "EnableDebug",
      label = "开启调试",
      hover = "将各种信息写入服务器日志中",
    },

  }
)
