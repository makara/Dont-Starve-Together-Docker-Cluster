_G.ChinesePlus.RenameTab("Annie", "安妮")

STRINGS.NAMES.ANNIEPACK = "安妮的背包"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANNIEPACK = "一个非常黑暗的孩子适合一个可爱的背包。"

STRINGS.NAMES.ANNIEFIRE = "安妮的火球"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANNIEFIRE = "只能由特定小女孩使用的浓缩火焰。"

STRINGS.NAMES.ANNIEBEARHAT = "安妮的小熊帽"
_G.ChinesePlus.RenameRecipe("ANNIEBEARHAT", "我现在就像是提伯斯了！")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANNIEBEARHAT= "多么令人不安的帽子。"

STRINGS.NAMES.ARMOR_FROSTANNIE = "冰霜消防服"
_G.ChinesePlus.RenameRecipe("ARMOR_FROSTANNIE", "用于寒冷的日子！")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR_FROSTANNIE = "这看起来相当舒服！"

STRINGS.NAMES.ARMOR_LITTLEREDANNIE = "小红安妮套装"
_G.ChinesePlus.RenameRecipe("ARMOR_LITTLEREDANNIE", "奶奶做的！")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR_LITTLEREDANNIE = "有人带来了今天的奶奶饼干。"

STRINGS.NAMES.ARMOR_SWEETHEARTANNIE = "甜心安妮套装"
_G.ChinesePlus.RenameRecipe("ARMOR_SWEETHEARTANNIE", "火热燃烧着的爱。")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR_SWEETHEARTANNIE = "这是一个丘比特装备或者..？"

STRINGS.NAMES.TIBBERDOLL = "安妮的小熊娃娃"
_G.ChinesePlus.RenameRecipe("TIBBERDOLL", "我最珍惜你！")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TIBBERDOLL = "捡起这个让我有一种不好的预感..."

STRINGS.NAMES.SUMMONTIBBER = "提伯斯"
_G.ChinesePlus.RenameRecipe("SUMMONTIBBER", "提伯斯! 呀!")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUMMONTIBBER = "这是一只熊...不..等等...什么？"

_G.ChinesePlus.RenameAction("SITCOMMAND", "命令停下")
_G.ChinesePlus.RenameAction("SITCOMMAND_CANCEL", "命令跟随")

-- The character select screen lines
STRINGS.CHARACTER_TITLES.annie = "黑暗的孩子"
STRINGS.CHARACTER_NAMES.annie = "安妮"
STRINGS.CHARACTER_DESCRIPTIONS.annie = "*可以扔火球\n*有小熊提伯斯！\n*燃烧！"
STRINGS.CHARACTER_QUOTES.annie = "\"你见过我的小熊提伯斯吗？\""

-- Custom speech strings
-- STRINGS.CHARACTERS.ANNIE = require(chinesefolder.."/Annie/speech_annie")
STRINGS.CHARACTERS.ANNIE = nil

-- The character's name as appears in-game
STRINGS.NAMES.ANNIE = "安妮"
-- STRINGS.CHARACTERS.ANNIE.DESCRIBE.SUMMONTIBBER = "呀！提伯斯！"

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANNIE =
{
  GENERIC = "这是安妮！",
  ATTACKER = "安妮看起来很狡猾...",
  MURDERER = "凶手！",
  REVIVER = "安妮, 鬼魂朋友！",
  GHOST = "安妮可以使用一颗救赎之心。",
}
