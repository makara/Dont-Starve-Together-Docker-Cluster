-- The character select screen lines
STRINGS.CHARACTER_TITLES.aria = "水晶领主"
STRINGS.CHARACTER_NAMES.aria = "艾丽娅"
STRINGS.CHARACTER_DESCRIPTIONS.aria = "*身体虚弱，头脑强壮。\n*心灵控制，建立大规模杀伤性武器。\n*夜视。"
STRINGS.CHARACTER_QUOTES.aria = "\"你好早苗，我想玩个游戏。\""

STRINGS.NAMES.ARIA_HAT = "艾丽娅的帽子"
_G.ChinesePlus.RenameRecipe("ARIA_HAT","快速回精神")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_HAT = "你的心灵已经与艾丽娅建立连接"

STRINGS.NAMES.ARIA_MASTERMIND = "艾丽娅邪恶召唤"
_G.ChinesePlus.RenameRecipe("ARIA_MASTERMIND","对大范围内有跟随AI的生物精神控制")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_MASTERMIND = "精神控制只需3个步骤。"

STRINGS.NAMES.ARIA_ARMOR_RED = "灼热避难所"
_G.ChinesePlus.RenameRecipe("ARIA_ARMOR_RED","抗寒，伤害减少（90%）")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_ARMOR_RED = "躁动的热。"

STRINGS.NAMES.ARIA_ARMOR_BLUE = " 冰封时空"
_G.ChinesePlus.RenameRecipe("ARIA_ARMOR_BLUE","抗热，伤害减少（90%）")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_ARMOR_BLUE = "冷酷的真理。"

STRINGS.NAMES.ARIA_ARMOR_GREEN = "爱亚利亚殿堂"
_G.ChinesePlus.RenameRecipe("ARIA_ARMOR_GREEN","无敌")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_ARMOR_GREEN = "铁幕激活。"

STRINGS.NAMES.ARIA_PARADISE = "爱亚利亚乐园"
_G.ChinesePlus.RenameRecipe("ARIA_PARADISE","回复 30 距离内队友 100 生命")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_PARADISE = "拯救那些信仰艾丽娅的人。"

STRINGS.NAMES.ARIA_METEOR = "爱亚利亚启示录"
_G.ChinesePlus.RenameRecipe("ARIA_METEOR","大规模杀伤性武器")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_METEOR = "这是审判的日子..."

STRINGS.NAMES.ARIA_STORM = "离子风暴召唤者"
_G.ChinesePlus.RenameRecipe("ARIA_STORM","远程闪电攻击")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_STORM = "你的罪恶不可饶恕..."

STRINGS.NAMES.ARIA_TOWER = "水晶领主的愤怒"
_G.ChinesePlus.RenameRecipe("ARIA_TOWER","高级离子防御系统。")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_TOWER = "现在，我很认真。"

--STRINGS.CHARACTERS.ARIA = require(chinesefolder.."/Aria/speech_aria")
STRINGS.CHARACTERS.ARIA = nil

STRINGS.NAMES.aria = "艾丽娅"

local function ForceTranslate()
  STRINGS.NAMES.ARIA_PACK = "超次元口袋"
  _G.ChinesePlus.RenameRecipe("ARIA_PACK","12格保温背包,部署可传送到传送核心")
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_PACK = "我只是讨厌这些装满的包包..."
end

table.insert(ForceTranslateList, ForceTranslate)

STRINGS.CHARACTERS.GENERIC.DESCRIBE.aria =
{
  GENERIC = "那个女孩怎么了？",
  ATTACKER = "艾丽娅看起来很危险...",
  MURDERER = "天啊!她让我受不了！！！",
  REVIVER = "水晶在呼唤...",
  GHOST = "统治死亡的人，死亡。",
}

