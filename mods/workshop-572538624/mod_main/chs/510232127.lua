-- The character select screen lines
STRINGS.CHARACTER_TITLES.ear = "漂亮的耳朵"
STRINGS.CHARACTER_NAMES.ear = "耳朵"
STRINGS.CHARACTER_DESCRIPTIONS.ear = "*5% 几率吃肉升级！ (最大20级)\n*有棒棒糖、连衣裙和魔法帽.\n*逃生很快、害怕黑暗！"
STRINGS.CHARACTER_QUOTES.ear = "\"漂亮的猫！\""

STRINGS.NAMES.EARPOP = "耳朵的棒棒糖"
_G.ChinesePlus.RenameRecipe("EARPOP", "太好了！")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.EARPOP = "抱歉！ 需要一些物品！"

STRINGS.NAMES.EARDRESS = "耳朵的连衣裙"
_G.ChinesePlus.RenameRecipe("EARDRESS", "多漂亮的裙子！")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.EARDRESS = "抱歉！ 需要一些物品！"

STRINGS.NAMES.EARHAT = "耳朵的魔法帽"
_G.ChinesePlus.RenameRecipe("EARHAT", "魔力！")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.EARHAT = "抱歉！ 需要一些物品！"

-- Custom speech strings
-- STRINGS.CHARACTERS.EAR = require(chinesefolder.."/Ear/speech_ear")
STRINGS.CHARACTERS.EAR = nil

-- The character's name as appears in-game
STRINGS.NAMES.EAR = "耳朵"

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.EAR =
{
  GENERIC = "这是耳朵！",
  ATTACKER = "耳朵看起来很狡猾...",
  MURDERER = "凶手！",
  REVIVER = "耳朵, 鬼魂朋友！",
  GHOST = "耳朵可以使用一颗救赎之心。",
}

