STRINGS.NAMES.WSTAFF = "地精玩偶法杖"
_G.ChinesePlus.RenameRecipe("WSTAFF", "你只需要有信念！")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WSTAFF = "地精玩偶!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MNOME = "他相当大，嗯？"

AddPrefabPostInit("wstaff", function(inst)
  inst.components.inspectable.nameoverride = "地精玩偶法杖"
  inst.components.named:SetName("地精玩偶法杖")
end)