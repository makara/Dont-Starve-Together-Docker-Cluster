local MY_TEX_TAGS = {
  ["Alkaline"] = "碱类",
  ["Cactus"] = "仙人掌类",
  ["Citrus"] = "柑橘类",
  ["Dairies"] = "乳制品",
  ["Dairy"] = "乳制品",
  ["Decoration"] = "饰品",
  ["Eggs"] = "蛋类",
  ["Fat"] = "脂肪",
  ["Fish"] = "鱼",
  ["Flora"] = "植物",
  ["Fruits"] = "水果类",
  ["Fungi"] = "菌类",
  ["Grapes"] = "葡萄",
  ["Ice"] = "冰",
  ["Inedibles"] = "不可食",
  ["Leek"] = "韭葱类",
  ["Magic"] = "魔法类",
  ["Meats"] = "肉类",
  ["Monster Foods"] = "怪物",
  ["Mushrooms"] = "蘑菇",
  ["Nuts"] = "坚果",
  ["Poultries"] = "家禽",
  ["Precooked"] = "熟食",
  ["Pungents"] = "树脂",
  ["Roots"] = "根类",
  ["Seafood"] = "海鲜",
  ["Seeds"] = "种子",
  ["Shellfish"] = "贝类",
  ["Spices"] = "香料",
  ["Squash"] = "番瓜类",
  ["Starch"] = "淀粉",
  ["Sweets"] = "甜食",
  ["Tuber"] = "块茎",
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

