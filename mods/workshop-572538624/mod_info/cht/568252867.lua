_G.ChinesePlus.SetConfigTranslation(mod_to_c,
  "使世界資源能夠隨著時間的推移而再生。",
  {
    ["Disabled"] = "關閉",
    ["Enabled"] = "開啟",
  },
  {
    {
      name = "WorldResourceRegenerationSpeed",
      label = "世界資源再生速度",
      hover = "資源再生速度。有私用的計時器，不使用世界時間",
      options = {
        {description = "關閉", data = 0},
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
      label = "自定義物品",
      hover = "預設列表（使用專用伺服器的 modoverrides.lua 設定）",
    },
    {
      name = "EnableTurfsRegeneration",
      label = "地皮再生",
      hover = "開啟地皮的再生",
    },
    {
      name = "SpawnFreeZone",
      label = "自由產生區",
      hover = "設定自由產生區的大小\n4是 1 塊地皮的大小\n大小是從區域中的一個建築計算的",
    },
    {
      name = "EnableGraveStoneRemoval",
      label = "墓碑去除",
      hover = "刪除墓碑當它被挖了",
    },
    {
      name = "EnableDebug",
      label = "開啟除錯",
      hover = "將各種資訊寫入伺服器日誌中",
    },

  }
)
