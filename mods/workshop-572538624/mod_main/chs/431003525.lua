-- The character select screen lines
STRINGS.CHARACTER_TITLES.saberlion = "草原之王！"
STRINGS.CHARACTER_NAMES.saberlion = "萌狮萨博"
STRINGS.CHARACTER_DESCRIPTIONS.saberlion = "*肉很好吃！\n*我是大草原之王！\n*我的武器是肉！"
STRINGS.CHARACTER_QUOTES.saberlion = "\"GAOOOOOOOOOOOOOOO!\""

-- Custom speech strings
--STRINGS.CHARACTERS.SABERLION = require(chinesefolder.."/SaberLion/speech_saberlion")
STRINGS.CHARACTERS.SABERLION = nil
--STRINGS.CHARACTERS.SABERLION.DESCRIBE.SABERMEAT = "GAO! GAO! GAO!"

-- The character's name as appears in-game
STRINGS.NAMES.SABERLION = "萌狮萨博"

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SABERLION =
{
  GENERIC = "这是萌狮萨博",
  ATTACKER = "萌狮萨博看起来很狡猾...",
  MURDERER = "凶手！",
  REVIVER = "萌狮萨博, 鬼魂朋友！",
  GHOST = "萌狮萨博可以使用一颗心。",
}

STRINGS.SUMMONCLONE_TALK_PANICFIRE = { "噢~!", "我在燃烧！", "它在燃烧！" }
STRINGS.SUMMONCLONE_TALK_FIGHT = {"GAO GAO GAO!"} --setup in prefab

STRINGS.NAMES.SUMMONCLONE = "萌狮宝宝"
STRINGS.RECIPE_DESC.SUMMONCLONE = "Gao Gao Gao!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUMMONCLONE = {"GAO"}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUMMONCLONE.GENERIC = "GAO?"

_G.ChinesePlus.RenameRecipe("SABERMEAT","动画肉。终极武器。")
STRINGS.NAMES.SABERMEAT = "动画肉"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SABERMEAT = "肉是怎么形成的？"

STRINGS.NAMES.SABERMEATMINI = "动画肉"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SABERMEATMINI = "肉是怎么形成的？"

_G.ChinesePlus.RenameAction("SITCOMMAND","命令停下")
_G.ChinesePlus.RenameAction("SITCOMMAND_CANCEL","命令跟随")

