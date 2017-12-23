_G.ChinesePlus.SetConfigTranslation(mod_to_c,
  "高亮周围含有手中物品或在建造栏指向物品的容器（比如箱子），有助于管理物品的存储。\n兼容 Craft Pot Mod，悬停在配方的材料上面，可以找到蔬菜等。",
  {

  },
  {
    {
      name = "active",
      label = "激活?",
      hover = "你想开启还是关闭高亮功能?\n客户端也可以在这里关闭或开启高亮。",
      options = {
        {description = "关闭", data = false}, -- to allow clients to disable highlighting
        {description = "开启", data = true},
      },
    },

  }
)
