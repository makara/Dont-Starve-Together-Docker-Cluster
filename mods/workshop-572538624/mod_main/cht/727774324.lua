local MY_TEX_TAGS = {
  ["Alkaline"] = "鹼類",
  ["Cactus"] = "仙人掌類",
  ["Citrus"] = "柑橘類",
  ["Dairies"] = "乳製品",
  ["Dairy"] = "乳製品",
  ["Decoration"] = "飾品",
  ["Eggs"] = "蛋類",
  ["Fat"] = "脂肪",
  ["Fish"] = "魚",
  ["Flora"] = "植物",
  ["Fruits"] = "水果類",
  ["Fungi"] = "菌類",
  ["Grapes"] = "葡萄",
  ["Ice"] = "冰",
  ["Inedibles"] = "不可食",
  ["Leek"] = "韭蔥類",
  ["Magic"] = "魔法類",
  ["Meats"] = "肉類",
  ["Monster Foods"] = "怪物",
  ["Mushrooms"] = "蘑菇",
  ["Nuts"] = "堅果",
  ["Poultries"] = "家禽",
  ["Precooked"] = "熟食",
  ["Pungents"] = "樹脂",
  ["Roots"] = "根類",
  ["Seafood"] = "海鮮",
  ["Seeds"] = "種子",
  ["Shellfish"] = "貝類",
  ["Spices"] = "香料",
  ["Squash"] = "番瓜類",
  ["Starch"] = "澱粉",
  ["Sweets"] = "甜食",
  ["Tuber"] = "塊莖",
  ["Vegetables"] = "蔬菜",
  ["Wings"] = "翅膀",
}

AddClassPostConstruct("widgets/foodingredientui", function(self)
    local tip = MY_TEX_TAGS[self.localized_name] or self.localized_name
    self:SetTooltip(tip)
  end)

AddClassPostConstruct("widgets/foodrecipepopup", function(self)
    self.excludes_title:SetString('限制')
  end)

