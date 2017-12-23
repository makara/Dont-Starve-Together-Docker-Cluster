STRINGS.NAMES.LAWHAT = "羅的帽子"
STRINGS.NAMES.LAWSWORD = "鬼哭"
STRINGS.NAMES.LAWROOM = "空間"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAWHAT= "一頂舊的帽子，有許多回憶。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAWSWORD= "死亡外科醫生揮舞的劍。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAWROOM= "一種奇怪的能力來開關抗擊你的敵人。"

_G.ChinesePlus.RenameRecipe("LAWREVIVER","一個更好的告密者的心臟。")
STRINGS.NAMES.LAWREVIVER = "羅造的心"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAWREVIVER = "醫生的簽名用具"

_G.ChinesePlus.RenameTab("Law","羅")

-- The character select screen lines
STRINGS.CHARACTER_TITLES.law = "死亡外科醫生"
STRINGS.CHARACTER_NAMES.law = "羅"
STRINGS.CHARACTER_DESCRIPTIONS.law = "*'空間' 能力\n*恢復生命\n*復活者"
STRINGS.CHARACTER_QUOTES.law = "\"我不喜歡麵包。\""

-- Custom speech strings
--STRINGS.CHARACTERS.LAW = require(chinesefolder.."/Law/speech_law")
STRINGS.CHARACTERS.LAW = nil

-- The character's name as appears in-game
STRINGS.NAMES.LAW = "羅"

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAW =
{
  GENERIC = "這是羅！",
  ATTACKER = "羅看起來很狡猾...",
  MURDERER = "凶手！",
  REVIVER = "羅, 鬼魂朋友！",
  GHOST = "羅可以使用一顆心。",
}

