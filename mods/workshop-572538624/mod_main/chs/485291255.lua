STRINGS.NAMES.LAWHAT = "罗的帽子"
STRINGS.NAMES.LAWSWORD = "鬼哭"
STRINGS.NAMES.LAWROOM = "空间"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAWHAT= "一顶旧的帽子，有许多回忆。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAWSWORD= "死亡外科医生挥舞的剑。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAWROOM= "一种奇怪的能力来开关抗击你的敌人。"

_G.ChinesePlus.RenameRecipe("LAWREVIVER","一个更好的告密者的心脏。")
STRINGS.NAMES.LAWREVIVER = "罗造的心"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAWREVIVER = "医生的签名用具"

_G.ChinesePlus.RenameTab("Law","罗")

-- The character select screen lines
STRINGS.CHARACTER_TITLES.law = "死亡外科医生"
STRINGS.CHARACTER_NAMES.law = "罗"
STRINGS.CHARACTER_DESCRIPTIONS.law = "*'空间' 能力\n*恢复生命\n*复活者"
STRINGS.CHARACTER_QUOTES.law = "\"我不喜欢面包。\""

-- Custom speech strings
--STRINGS.CHARACTERS.LAW = require(chinesefolder.."/Law/speech_law")
STRINGS.CHARACTERS.LAW = nil

-- The character's name as appears in-game
STRINGS.NAMES.LAW = "罗"

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LAW =
{
  GENERIC = "这是罗！",
  ATTACKER = "罗看起来很狡猾...",
  MURDERER = "凶手！",
  REVIVER = "罗, 鬼魂朋友！",
  GHOST = "罗可以使用一颗心。",
}

