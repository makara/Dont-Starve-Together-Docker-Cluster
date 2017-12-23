local function ForceTranslate()
  STRINGS.NAMES.TOPTOPTOPHAT = "高礼帽"
  _G.ChinesePlus.RenameRecipe("TOPTOPTOPHAT", "帽子无极限。")

  STRINGS.CHARACTERS.GENERIC.DESCRIBE.TOPTOPTOPHAT = "这是一个很好的帽子，我这样对自己说。"
  STRINGS.CHARACTERS.WX78.DESCRIBE.TOPTOPTOPHAT = "我自言自语：这是一个帽子的升级。"
end

table.insert(ForceTranslateList, ForceTranslate)
