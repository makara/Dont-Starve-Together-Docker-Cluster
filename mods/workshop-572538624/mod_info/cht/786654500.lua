_G.ChinesePlus.SetConfigTranslation(mod_to_c,
  "高亮周圍含有手中物品或在建造欄指向物品的容器（比如箱子），有助於管理物品的儲存。\n相容 Craft Pot Mod，懸停在配方的材料上面，可以找到蔬菜等。",
  {

  },
  {
    {
      name = "active",
      label = "啟用?",
      hover = "你想開啟還是關閉高亮功能?\n客戶端也可以在這裡關閉或開啟高亮。",
      options = {
        {description = "關閉", data = false}, -- to allow clients to disable highlighting
        {description = "開啟", data = true},
      },
    },

  }
)
