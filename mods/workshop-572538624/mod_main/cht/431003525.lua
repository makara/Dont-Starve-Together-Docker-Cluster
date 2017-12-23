-- The character select screen lines
STRINGS.CHARACTER_TITLES.saberlion = "草原之王！"
STRINGS.CHARACTER_NAMES.saberlion = "萌獅薩博"
STRINGS.CHARACTER_DESCRIPTIONS.saberlion = "*肉很好吃！\n*我是大草原之王！\n*我的武器是肉！"
STRINGS.CHARACTER_QUOTES.saberlion = "\"GAOOOOOOOOOOOOOOO!\""

-- Custom speech strings
--STRINGS.CHARACTERS.SABERLION = require(chinesefolder.."/SaberLion/speech_saberlion")
STRINGS.CHARACTERS.SABERLION = nil
--STRINGS.CHARACTERS.SABERLION.DESCRIBE.SABERMEAT = "GAO! GAO! GAO!"

-- The character's name as appears in-game
STRINGS.NAMES.SABERLION = "萌獅薩博"

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SABERLION =
{
  GENERIC = "這是萌獅薩博",
  ATTACKER = "萌獅薩博看起來很狡猾...",
  MURDERER = "凶手！",
  REVIVER = "萌獅薩博, 鬼魂朋友！",
  GHOST = "萌獅薩博可以使用一顆心。",
}

STRINGS.SUMMONCLONE_TALK_PANICFIRE = { "噢~!", "我在燃燒！", "它在燃燒！" }
STRINGS.SUMMONCLONE_TALK_FIGHT = {"GAO GAO GAO!"} --setup in prefab

STRINGS.NAMES.SUMMONCLONE = "萌獅寶寶"
STRINGS.RECIPE_DESC.SUMMONCLONE = "Gao Gao Gao!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUMMONCLONE = {"GAO"}
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUMMONCLONE.GENERIC = "GAO?"

_G.ChinesePlus.RenameRecipe("SABERMEAT","動畫肉。終極武器。")
STRINGS.NAMES.SABERMEAT = "動畫肉"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SABERMEAT = "肉是怎麼形成的？"

STRINGS.NAMES.SABERMEATMINI = "動畫肉"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SABERMEATMINI = "肉是怎麼形成的？"

_G.ChinesePlus.RenameAction("SITCOMMAND","命令停下")
_G.ChinesePlus.RenameAction("SITCOMMAND_CANCEL","命令跟隨")

