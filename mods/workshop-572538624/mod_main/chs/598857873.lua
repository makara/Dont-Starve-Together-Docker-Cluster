_G.ChinesePlus.RenameTab("Momiji's Tab","犬走椛")

local function ForceTranslate()
  STRINGS.NAMES.MOMIJISWORDANDSHIELD = "犬走椛的剑与盾"
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOMIJISWORDANDSHIELD = "被白狼天狗使用的武器。"
  STRINGS.NAMES.MOMIJIHAT = "犬走椛的帽子"
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOMIJIHAT = "小的，可爱的，非常舒适的，在头上正好合适！"
end

table.insert(ForceTranslateList, ForceTranslate)

-- Custom Recipe Desc
_G.ChinesePlus.RenameRecipe("MOMIJISWORDANDSHIELD","进攻与防守！")

-- The character select screen lines
STRINGS.CHARACTER_TITLES.momiji = "下端哨戒天狗"
STRINGS.CHARACTER_NAMES.momiji = "犬走椛"
STRINGS.CHARACTER_DESCRIPTIONS.momiji = "*看到的比别人多\n*良好的战斗能力\n*一个中等BOSS"
STRINGS.CHARACTER_QUOTES.momiji = "\"汪~ 汪~ 呜~!\""

-- Custom speech strings
--STRINGS.CHARACTERS.MOMIJI = require(chinesefolder.."/Momiji/speech_momiji")
STRINGS.CHARACTERS.MOMIJI = nil

-- The character's name as appears in-game
STRINGS.NAMES.MOMIJI = "犬走椛"

