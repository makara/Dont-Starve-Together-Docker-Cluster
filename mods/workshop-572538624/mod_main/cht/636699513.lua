-- The character select screen lines
STRINGS.CHARACTER_TITLES.mokou = "長生不死的人類"
STRINGS.CHARACTER_NAMES.mokou = "藤原妹紅"
STRINGS.CHARACTER_DESCRIPTIONS.mokou = "*抵禦疼痛\n*火焰輝光\n*火焰技能"
STRINGS.CHARACTER_QUOTES.mokou = "\"我是一個開串燒店的普通的健康瘋子。\""

-- Custom speech strings
--STRINGS.CHARACTERS.MOKOU = require(chinesefolder.."/Mokou/speech_mokou")
STRINGS.CHARACTERS.MOKOU = nil

-- The character's name as appears in-game
STRINGS.NAMES.MOKOU = "藤原妹紅"

local function ForceTranslate()
  STRINGS.NAMES.MOKOUFIRE = "妹紅的火焰"
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOKOUFIRE = "我從這得到“永恆的火焰”的共鳴。"
end

table.insert(ForceTranslateList, ForceTranslate)
