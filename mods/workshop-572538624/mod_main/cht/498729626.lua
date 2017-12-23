_G.ChinesePlus.RenameTab("Annie", "安妮")

STRINGS.NAMES.ANNIEPACK = "安妮的揹包"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANNIEPACK = "一個非常黑暗的孩子適合一個可愛的揹包。"

STRINGS.NAMES.ANNIEFIRE = "安妮的火球"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANNIEFIRE = "只能由特定小女孩使用的濃縮火焰。"

STRINGS.NAMES.ANNIEBEARHAT = "安妮的小熊帽"
_G.ChinesePlus.RenameRecipe("ANNIEBEARHAT", "我現在就像是提伯斯了！")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANNIEBEARHAT= "多麼令人不安的帽子。"

STRINGS.NAMES.ARMOR_FROSTANNIE = "冰霜消防服"
_G.ChinesePlus.RenameRecipe("ARMOR_FROSTANNIE", "用於寒冷的日子！")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR_FROSTANNIE = "這看起來相當舒服！"

STRINGS.NAMES.ARMOR_LITTLEREDANNIE = "小紅安妮套裝"
_G.ChinesePlus.RenameRecipe("ARMOR_LITTLEREDANNIE", "奶奶做的！")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR_LITTLEREDANNIE = "有人帶來了今天的奶奶餅乾。"

STRINGS.NAMES.ARMOR_SWEETHEARTANNIE = "甜心安妮套裝"
_G.ChinesePlus.RenameRecipe("ARMOR_SWEETHEARTANNIE", "火熱燃燒著的愛。")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR_SWEETHEARTANNIE = "這是一個丘位元裝備或者..？"

STRINGS.NAMES.TIBBERDOLL = "安妮的小熊娃娃"
_G.ChinesePlus.RenameRecipe("TIBBERDOLL", "我最珍惜你！")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TIBBERDOLL = "撿起這個讓我有一種不好的預感..."

STRINGS.NAMES.SUMMONTIBBER = "提伯斯"
_G.ChinesePlus.RenameRecipe("SUMMONTIBBER", "提伯斯! 呀!")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUMMONTIBBER = "這是一隻熊...不..等等...什麼？"

_G.ChinesePlus.RenameAction("SITCOMMAND", "命令停下")
_G.ChinesePlus.RenameAction("SITCOMMAND_CANCEL", "命令跟隨")

-- The character select screen lines
STRINGS.CHARACTER_TITLES.annie = "黑暗的孩子"
STRINGS.CHARACTER_NAMES.annie = "安妮"
STRINGS.CHARACTER_DESCRIPTIONS.annie = "*可以扔火球\n*有小熊提伯斯！\n*燃燒！"
STRINGS.CHARACTER_QUOTES.annie = "\"你見過我的小熊提伯斯嗎？\""

-- Custom speech strings
-- STRINGS.CHARACTERS.ANNIE = require(chinesefolder.."/Annie/speech_annie")
STRINGS.CHARACTERS.ANNIE = nil

-- The character's name as appears in-game
STRINGS.NAMES.ANNIE = "安妮"
-- STRINGS.CHARACTERS.ANNIE.DESCRIBE.SUMMONTIBBER = "呀！提伯斯！"

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANNIE =
{
  GENERIC = "這是安妮！",
  ATTACKER = "安妮看起來很狡猾...",
  MURDERER = "凶手！",
  REVIVER = "安妮, 鬼魂朋友！",
  GHOST = "安妮可以使用一顆救贖之心。",
}
