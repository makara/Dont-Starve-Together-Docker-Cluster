local function ForceTranslate()
  STRINGS.NAMES.TOPTOPTOPHAT = "高禮帽"
  _G.ChinesePlus.RenameRecipe("TOPTOPTOPHAT", "帽子無極限。")

  STRINGS.CHARACTERS.GENERIC.DESCRIBE.TOPTOPTOPHAT = "這是一個很好的帽子，我這樣對自己說。"
  STRINGS.CHARACTERS.WX78.DESCRIBE.TOPTOPTOPHAT = "我自言自語：這是一個帽子的升級。"
end

table.insert(ForceTranslateList, ForceTranslate)
