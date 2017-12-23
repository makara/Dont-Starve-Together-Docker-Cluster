_G.ChinesePlus.SetConfigTranslation(mod_to_c,[[
  加入了无敌的超级墙和自动门。
  刚造好墙高度为最高，可以用锤子一节一节砸矮。
  不会掉血、着火，免疫 boss 攻击。只有锤子能破坏！
  墙可以反弹伤害给攻击者。
  自动门在玩家靠近时自动打开。
  加入了海难中的石灰石墙。]],
  {

  },
  {
    {
      name = "dist",
      label = "自动门感应距离",
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
      label = "反弹伤害",
      hover = "受到攻击时，墙反弹多少伤害？",
      options = {
        {description = "0", data = 0, hover = " "},
        {description = "1", data = 1, hover = " "},
        {description = "5", data = 5, hover = " "},
        {description = "10", data = 10, hover = " "},
        {description = "20", data = 20, hover = " "},
        {description = "50", data = 50, hover = " "},
        {description = "100", data = 100, hover = " "},
        {description = "200", data = 200, hover = "..."},
        {description = "500", data = 500, hover = "什么?!.."},
      },
      default = 0,
    },

    {
      name = "bossres",
      label = "建筑伤害抗性",
      hover = "",
      options = {
        {description = "免疫", data = true, hover = "不会被boss、陨石、火药等摧毁"},
        {description = "可破坏", data = false, hover = "会被boss、陨石、火药等摧毁"},
      },
      default = true,
    },

    {
      name = "recipe",
      label = "制作难度",
      hover = "",
      options = {
        {description = "普通", data = "normal", hover = " "},
        {description = "困难", data = "hard", hover = "墙=普通材料+电子元件*4，门=普通材料+电子元件*4+齿轮*2"},
      },
      default = "normal",
    },

    {
      name = "companion",
      label = "切斯特触发门",
      hover = "自动门是否为切斯特、哈奇、宠物打开",
      options = {
        {description = "是", data = true, hover = ""},
        {description = "否", data = false, hover = ""},
      },
      default = true,
    },

    {
      name = "ownership",
      label = "使用权",
      hover = "谁能用自动门，谁能摧毁？",
      options = {
        {description = "公共", data = 0, hover = "谁都可以使用和摧毁"},
        {description = "授权的人", data = 1, hover = "只有建造者和授权的人能使用和摧毁"},
      },
      default = 0,
    },

    {
      name = "language",
      label = "语言",
      hover = "",
      options = {
        {description = "自动检测", data = "AUTO", hover = ""},
        {description = "English", data = "EN", hover = ""},
        {description = "简体中文", data = "CHS", hover = ""},
        {description = "繁體中文", data = "CHT", hover = ""},
      },
      default = "AUTO",
    },
  }
)
