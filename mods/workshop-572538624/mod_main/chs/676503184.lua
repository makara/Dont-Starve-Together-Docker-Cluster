STRINGS.NAMES.KATANAS = "武士刀"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KATANAS = "一把锋利的刀。"

STRINGS.NAMES.DPPDA = "传送器"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DPPDA = "我跳！"

STRINGS.NAMES.DPCLIP = "弹匣"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DPCLIP = "死侍枪的弹匣。"

_G.ChinesePlus.RenameTab("Deadpool's Tab", "死侍")

-- Custom Recipe Desc
_G.ChinesePlus.RenameRecipe("KATANAS", "一把锋利的刀。")
_G.ChinesePlus.RenameRecipe("DPGUN", "一把手枪。")
_G.ChinesePlus.RenameRecipe("DPCLIP", "这是死侍的手枪弹药。")
_G.ChinesePlus.RenameRecipe("DPBOMB", "轰~~")

-- The character select screen lines
STRINGS.CHARACTER_TITLES.deadpool = "死侍"
STRINGS.CHARACTER_NAMES.deadpool = "死侍"
STRINGS.CHARACTER_DESCRIPTIONS.deadpool = "*生命恢复\n*不怕怪物\n*低精神值"
STRINGS.CHARACTER_QUOTES.deadpool = "\"呀~~ 大家好！\""

-- Custom speech strings
--STRINGS.CHARACTERS.DEADPOOL = require(chinesefolder.."/Deadpool/speech_deadpool")
STRINGS.CHARACTERS.DEADPOOL = nil

-- The character's name as appears in-game
STRINGS.NAMES.DEADPOOL = "死侍"

local function ForceTranslate()
  STRINGS.NAMES.DPGUN = "手枪"
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.DPGUN = "射击！"
  STRINGS.NAMES.DPBOMB = "手雷"
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.DPBOMB = "轰~~"
end

table.insert(ForceTranslateList, ForceTranslate)

