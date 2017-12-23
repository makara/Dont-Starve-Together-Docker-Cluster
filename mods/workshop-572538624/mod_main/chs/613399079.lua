local function ForceTranslate()

  STRINGS.NAMES.FLASK = "诗人之瓶"
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLASK = "我要三个..."
  _G.ChinesePlus.RenameRecipe("FLASK","需要一些灵感？")

  ------------------------------EDGAR!------------------------------------

  -- The character select screen lines
  STRINGS.CHARACTER_TITLES.edgar = "战斧人"
  STRINGS.CHARACTER_NAMES.edgar = "埃德加"
  STRINGS.CHARACTER_DESCRIPTIONS.edgar = "*带着世俗的诗歌来到这个世界\n*拥有一些知识\n*失眠，无法入睡"
  STRINGS.CHARACTER_QUOTES.edgar = "\"我变得疯狂，长时间可怕的理智.\""

  -- Custom speech strings
  --STRINGS.CHARACTERS.EDGAR = require(chinesefolder.."/TheTomahawkMen/speech_edgar")
  STRINGS.CHARACTERS.EDGAR = nil

  -- The character's name as appears in-game
  STRINGS.NAMES.EDGAR = "埃德加"

  -- The default responses of examining the character
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.EDGAR =
  {
    GENERIC = "这是埃德加",
    ATTACKER = "埃德加看起来很狡猾...",
    MURDERER = "凶手！",
    REVIVER = "埃德加, 鬼魂朋友！",
    GHOST = "埃德加可以使用一颗心。",
  }

  --------------------------------------LIGEIA!---------------------------------------------
  -- The character select screen lines
  STRINGS.CHARACTER_TITLES.ligeia = "被遗忘的新娘"
  STRINGS.CHARACTER_NAMES.ligeia = "丽姬娅"
  STRINGS.CHARACTER_DESCRIPTIONS.ligeia = "*冬天和黑暗是我的寿衣\n*失去了对永恒的欲望\n*他们叫我蛇蝎美人"
  STRINGS.CHARACTER_QUOTES.ligeia = "\"死还是活，我永远是你的新娘.\""

  -- Custom speech strings
  --STRINGS.CHARACTERS.LIGEIA = require(chinesefolder.."/TheTomahawkMen/speech_ligeia")
  STRINGS.CHARACTERS.LIGEIA = nil

  -- The character's name as appears in-game
  STRINGS.NAMES.LIGEIA = "丽姬娅"

  -- The default responses of examining the character
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.LIGEIA =
  {
    GENERIC = "这是丽姬娅",
    ATTACKER = "丽姬娅看起来很狡猾...",
    MURDERER = "凶手！",
    REVIVER = "丽姬娅, 鬼魂朋友！",
    GHOST = "丽姬娅可以使用一颗心。",
  }

  ------------------------------MORGUE!------------------------------------

  -- The character select screen lines
  STRINGS.CHARACTER_TITLES.morgue = "森林人"
  STRINGS.CHARACTER_NAMES.morgue = "茂歌"
  STRINGS.CHARACTER_DESCRIPTIONS.morgue = "*很强壮但是很慢\n*快速收割者\n*大自然的朋友"
  STRINGS.CHARACTER_QUOTES.morgue = "\"呃~ 呃~ 啊呼~\""

  -- Custom speech strings
  --STRINGS.CHARACTERS.MORGUE = require(chinesefolder.."/TheTomahawkMen/speech_morgue")
  STRINGS.CHARACTERS.MORGUE = nil

  -- The character's name as appears in-game
  STRINGS.NAMES.MORGUE = "茂歌"

  -- The default responses of examining the character
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.MORGUE =
  {
    GENERIC = "这是茂歌",
    ATTACKER = "茂歌看起来很狡猾...",
    MURDERER = "凶手！",
    REVIVER = "茂歌, 鬼魂之友！",
    GHOST = "茂歌可以使用一颗心。",
  }

  --------------------------------------PLUTO!---------------------------------------------
  -- The character select screen lines
  STRINGS.CHARACTER_TITLES.pluto = "黑暗狸猫"
  STRINGS.CHARACTER_NAMES.pluto = "普鲁多"
  STRINGS.CHARACTER_DESCRIPTIONS.pluto = "*夜视\n*讨厌水\n*做猫该做的事情"
  STRINGS.CHARACTER_QUOTES.pluto = "\"喵~~!\""

  -- Custom speech strings
  --STRINGS.CHARACTERS.PLUTO = require(chinesefolder.."/TheTomahawkMen/speech_pluto")
  STRINGS.CHARACTERS.PLUTO = nil

  -- The character's name as appears in-game
  STRINGS.NAMES.PLUTO = "普鲁多"

  -- The default responses of examining the character
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.PLUTO =
  {
    GENERIC = "这是普鲁多",
    ATTACKER = "普鲁多看起来很狡猾...",
    MURDERER = "凶手！",
    REVIVER = "普鲁多, 鬼魂朋友！",
    GHOST = "普鲁多可以使用一颗心。",
  }

  ------------------------------RAVEN!------------------------------------

  -- The character select screen lines
  STRINGS.CHARACTER_TITLES.raven = "邪恶的先知"
  STRINGS.CHARACTER_NAMES.raven = "乌鸦"
  STRINGS.CHARACTER_DESCRIPTIONS.raven = "*别人很讨厌他\n*当吃特殊的食物时候会有意想不到的结果\n*鸟的好朋友"
  STRINGS.CHARACTER_QUOTES.raven = "\"永不超生!\""

  -- Custom speech strings
  STRINGS.CHARACTERS.RAVEN = require(chinesefolder.."/TheTomahawkMen/speech_raven")

  -- The character's name as appears in-game
  STRINGS.NAMES.RAVEN = "乌鸦"

  -- The default responses of examining the character
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAVEN =
  {
    GENERIC = "这是乌鸦",
    ATTACKER = "乌鸦看起来很狡猾...",
    MURDERER = "凶手！",
    REVIVER = "乌鸦, 鬼魂朋友！",
    GHOST = "乌鸦可以使用一颗心。",
  }

end

table.insert(ForceTranslateList, ForceTranslate)

