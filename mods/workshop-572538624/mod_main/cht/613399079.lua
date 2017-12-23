local function ForceTranslate()

  STRINGS.NAMES.FLASK = "詩人之瓶"
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLASK = "我要三個..."
  _G.ChinesePlus.RenameRecipe("FLASK","需要一些靈感？")

  ------------------------------EDGAR!------------------------------------

  -- The character select screen lines
  STRINGS.CHARACTER_TITLES.edgar = "戰斧人"
  STRINGS.CHARACTER_NAMES.edgar = "埃德加"
  STRINGS.CHARACTER_DESCRIPTIONS.edgar = "*帶著世俗的詩歌來到這個世界\n*擁有一些知識\n*失眠，無法入睡"
  STRINGS.CHARACTER_QUOTES.edgar = "\"我變得瘋狂，長時間可怕的理智.\""

  -- Custom speech strings
  --STRINGS.CHARACTERS.EDGAR = require(chinesefolder.."/TheTomahawkMen/speech_edgar")
  STRINGS.CHARACTERS.EDGAR = nil

  -- The character's name as appears in-game
  STRINGS.NAMES.EDGAR = "埃德加"

  -- The default responses of examining the character
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.EDGAR =
  {
    GENERIC = "這是埃德加",
    ATTACKER = "埃德加看起來很狡猾...",
    MURDERER = "凶手！",
    REVIVER = "埃德加, 鬼魂朋友！",
    GHOST = "埃德加可以使用一顆心。",
  }

  --------------------------------------LIGEIA!---------------------------------------------
  -- The character select screen lines
  STRINGS.CHARACTER_TITLES.ligeia = "被遺忘的新娘"
  STRINGS.CHARACTER_NAMES.ligeia = "麗姬婭"
  STRINGS.CHARACTER_DESCRIPTIONS.ligeia = "*冬天和黑暗是我的壽衣\n*失去了對永恆的慾望\n*他們叫我蛇蠍美人"
  STRINGS.CHARACTER_QUOTES.ligeia = "\"死還是活，我永遠是你的新娘.\""

  -- Custom speech strings
  --STRINGS.CHARACTERS.LIGEIA = require(chinesefolder.."/TheTomahawkMen/speech_ligeia")
  STRINGS.CHARACTERS.LIGEIA = nil

  -- The character's name as appears in-game
  STRINGS.NAMES.LIGEIA = "麗姬婭"

  -- The default responses of examining the character
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.LIGEIA =
  {
    GENERIC = "這是麗姬婭",
    ATTACKER = "麗姬婭看起來很狡猾...",
    MURDERER = "凶手！",
    REVIVER = "麗姬婭, 鬼魂朋友！",
    GHOST = "麗姬婭可以使用一顆心。",
  }

  ------------------------------MORGUE!------------------------------------

  -- The character select screen lines
  STRINGS.CHARACTER_TITLES.morgue = "森林人"
  STRINGS.CHARACTER_NAMES.morgue = "茂歌"
  STRINGS.CHARACTER_DESCRIPTIONS.morgue = "*很強壯但是很慢\n*快速收割者\n*大自然的朋友"
  STRINGS.CHARACTER_QUOTES.morgue = "\"呃~ 呃~ 啊呼~\""

  -- Custom speech strings
  --STRINGS.CHARACTERS.MORGUE = require(chinesefolder.."/TheTomahawkMen/speech_morgue")
  STRINGS.CHARACTERS.MORGUE = nil

  -- The character's name as appears in-game
  STRINGS.NAMES.MORGUE = "茂歌"

  -- The default responses of examining the character
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.MORGUE =
  {
    GENERIC = "這是茂歌",
    ATTACKER = "茂歌看起來很狡猾...",
    MURDERER = "凶手！",
    REVIVER = "茂歌, 鬼魂之友！",
    GHOST = "茂歌可以使用一顆心。",
  }

  --------------------------------------PLUTO!---------------------------------------------
  -- The character select screen lines
  STRINGS.CHARACTER_TITLES.pluto = "黑暗狸貓"
  STRINGS.CHARACTER_NAMES.pluto = "普魯多"
  STRINGS.CHARACTER_DESCRIPTIONS.pluto = "*夜視\n*討厭水\n*做貓該做的事情"
  STRINGS.CHARACTER_QUOTES.pluto = "\"喵~~!\""

  -- Custom speech strings
  --STRINGS.CHARACTERS.PLUTO = require(chinesefolder.."/TheTomahawkMen/speech_pluto")
  STRINGS.CHARACTERS.PLUTO = nil

  -- The character's name as appears in-game
  STRINGS.NAMES.PLUTO = "普魯多"

  -- The default responses of examining the character
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.PLUTO =
  {
    GENERIC = "這是普魯多",
    ATTACKER = "普魯多看起來很狡猾...",
    MURDERER = "凶手！",
    REVIVER = "普魯多, 鬼魂朋友！",
    GHOST = "普魯多可以使用一顆心。",
  }

  ------------------------------RAVEN!------------------------------------

  -- The character select screen lines
  STRINGS.CHARACTER_TITLES.raven = "邪惡的先知"
  STRINGS.CHARACTER_NAMES.raven = "烏鴉"
  STRINGS.CHARACTER_DESCRIPTIONS.raven = "*別人很討厭他\n*當吃特殊的食物時候會有意想不到的結果\n*鳥的好朋友"
  STRINGS.CHARACTER_QUOTES.raven = "\"永不超生!\""

  -- Custom speech strings
  STRINGS.CHARACTERS.RAVEN = require(chinesefolder.."/TheTomahawkMen/speech_raven")

  -- The character's name as appears in-game
  STRINGS.NAMES.RAVEN = "烏鴉"

  -- The default responses of examining the character
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAVEN =
  {
    GENERIC = "這是烏鴉",
    ATTACKER = "烏鴉看起來很狡猾...",
    MURDERER = "凶手！",
    REVIVER = "烏鴉, 鬼魂朋友！",
    GHOST = "烏鴉可以使用一顆心。",
  }

end

table.insert(ForceTranslateList, ForceTranslate)

