_G.ChinesePlus.SetConfigTranslation(mod_to_c,[[
  加入了無敵的超級牆和自動門。
  剛造好牆高度為最高，可以用錘子一節一節砸矮。
  不會掉血、著火，免疫 boss 攻擊。只有錘子能破壞！
  牆可以反彈傷害給攻擊者。
  自動門在玩家靠近時自動開啟。
  加入了海難中的石灰石牆。]],
  {

  },
  {
    {
      name = "dist",
      label = "自動門感應距離",
      hover = "",
      options = {
        {description = "2", data = 2, hover = ""},
        {description = "2.5", data = 2.5, hover = ""},
        {description = "3", data = 3, hover = ""},
        {description = "4", data = 4, hover = ""},
        {description = "5", data = 5, hover = ""},
      },
      default = 2.5,
    },

    {
      name = "rebounddmg",
      label = "反彈傷害",
      hover = "受到攻擊時，牆反彈多少傷害？",
      options = {
        {description = "0", data = 0, hover = " "},
        {description = "1", data = 1, hover = " "},
        {description = "5", data = 5, hover = " "},
        {description = "10", data = 10, hover = " "},
        {description = "20", data = 20, hover = " "},
        {description = "50", data = 50, hover = " "},
        {description = "100", data = 100, hover = " "},
        {description = "200", data = 200, hover = "..."},
        {description = "500", data = 500, hover = "什麼?!.."},
      },
      default = 0,
    },

    {
      name = "bossres",
      label = "建築傷害抗性",
      hover = "",
      options = {
        {description = "免疫", data = true, hover = "不會被boss、隕石、火藥等摧毀"},
        {description = "可破壞", data = false, hover = "會被boss、隕石、火藥等摧毀"},
      },
      default = true,
    },

    {
      name = "recipe",
      label = "製作難度",
      hover = "",
      options = {
        {description = "普通", data = "normal", hover = " "},
        {description = "困難", data = "hard", hover = "牆=普通材料+電子元件*4，門=普通材料+電子元件*4+齒輪*2"},
      },
      default = "normal",
    },

    {
      name = "companion",
      label = "切斯特觸發門",
      hover = "自動門是否為切斯特、哈奇、寵物開啟",
      options = {
        {description = "是", data = true, hover = ""},
        {description = "否", data = false, hover = ""},
      },
      default = true,
    },

    {
      name = "ownership",
      label = "使用權",
      hover = "誰能用自動門，誰能摧毀？",
      options = {
        {description = "公共", data = 0, hover = "誰都可以使用和摧毀"},
        {description = "授權的人", data = 1, hover = "只有建造者和授權的人能使用和摧毀"},
      },
      default = 0,
    },

    {
      name = "language",
      label = "語言",
      hover = "",
      options = {
        {description = "自動檢測", data = "AUTO", hover = ""},
        {description = "English", data = "EN", hover = ""},
        {description = "簡體中文", data = "CHS", hover = ""},
        {description = "繁體中文", data = "CHT", hover = ""},
      },
      default = "AUTO",
    },
  }
)
