-- The character select screen lines
STRINGS.CHARACTER_TITLES.mokou = "长生不死的人类"
STRINGS.CHARACTER_NAMES.mokou = "藤原妹红"
STRINGS.CHARACTER_DESCRIPTIONS.mokou = "*抵御疼痛\n*火焰辉光\n*火焰技能"
STRINGS.CHARACTER_QUOTES.mokou = "\"我是一个开串烧店的普通的健康疯子。\""

-- Custom speech strings
--STRINGS.CHARACTERS.MOKOU = require(chinesefolder.."/Mokou/speech_mokou")
STRINGS.CHARACTERS.MOKOU = nil

-- The character's name as appears in-game
STRINGS.NAMES.MOKOU = "藤原妹红"

local function ForceTranslate()
  STRINGS.NAMES.MOKOUFIRE = "妹红的火焰"
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOKOUFIRE = "我从这得到“永恒的火焰”的共鸣。"
end

table.insert(ForceTranslateList, ForceTranslate)
