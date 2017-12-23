-- The character select screen lines
STRINGS.CHARACTER_TITLES.aria = "水晶領主"
STRINGS.CHARACTER_NAMES.aria = "艾麗婭"
STRINGS.CHARACTER_DESCRIPTIONS.aria = "*身體虛弱，頭腦強壯。\n*心靈控制，建立大規模殺傷性武器。\n*夜視。"
STRINGS.CHARACTER_QUOTES.aria = "\"你好早苗，我想玩個遊戲。\""

STRINGS.NAMES.ARIA_HAT = "艾麗婭的帽子"
_G.ChinesePlus.RenameRecipe("ARIA_HAT","快速回精神")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_HAT = "你的心靈已經與艾麗婭建立連線"

STRINGS.NAMES.ARIA_MASTERMIND = "艾麗婭邪惡召喚"
_G.ChinesePlus.RenameRecipe("ARIA_MASTERMIND","對大範圍內有跟隨AI的生物精神控制")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_MASTERMIND = "精神控制只需3個步驟。"

STRINGS.NAMES.ARIA_ARMOR_RED = "灼熱避難所"
_G.ChinesePlus.RenameRecipe("ARIA_ARMOR_RED","抗寒，傷害減少（90%）")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_ARMOR_RED = "躁動的熱。"

STRINGS.NAMES.ARIA_ARMOR_BLUE = " 冰封時空"
_G.ChinesePlus.RenameRecipe("ARIA_ARMOR_BLUE","抗熱，傷害減少（90%）")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_ARMOR_BLUE = "冷酷的真理。"

STRINGS.NAMES.ARIA_ARMOR_GREEN = "愛亞利亞殿堂"
_G.ChinesePlus.RenameRecipe("ARIA_ARMOR_GREEN","無敵")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_ARMOR_GREEN = "鐵幕啟用。"

STRINGS.NAMES.ARIA_PARADISE = "愛亞利亞樂園"
_G.ChinesePlus.RenameRecipe("ARIA_PARADISE","回覆 30 距離內隊友 100 生命")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_PARADISE = "拯救那些信仰艾麗婭的人。"

STRINGS.NAMES.ARIA_METEOR = "愛亞利亞啟示錄"
_G.ChinesePlus.RenameRecipe("ARIA_METEOR","大規模殺傷性武器")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_METEOR = "這是審判的日子..."

STRINGS.NAMES.ARIA_STORM = "離子風暴召喚者"
_G.ChinesePlus.RenameRecipe("ARIA_STORM","遠端閃電攻擊")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_STORM = "你的罪惡不可饒恕..."

STRINGS.NAMES.ARIA_TOWER = "水晶領主的憤怒"
_G.ChinesePlus.RenameRecipe("ARIA_TOWER","高階離子防禦系統。")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_TOWER = "現在，我很認真。"

--STRINGS.CHARACTERS.ARIA = require(chinesefolder.."/Aria/speech_aria")
STRINGS.CHARACTERS.ARIA = nil

STRINGS.NAMES.aria = "艾麗婭"

local function ForceTranslate()
  STRINGS.NAMES.ARIA_PACK = "超次元口袋"
  _G.ChinesePlus.RenameRecipe("ARIA_PACK","12格保溫揹包,部署可傳送到傳送核心")
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARIA_PACK = "我只是討厭這些裝滿的包包..."
end

table.insert(ForceTranslateList, ForceTranslate)

STRINGS.CHARACTERS.GENERIC.DESCRIBE.aria =
{
  GENERIC = "那個女孩怎麼了？",
  ATTACKER = "艾麗婭看起來很危險...",
  MURDERER = "天啊!她讓我受不了！！！",
  REVIVER = "水晶在呼喚...",
  GHOST = "統治死亡的人，死亡。",
}

