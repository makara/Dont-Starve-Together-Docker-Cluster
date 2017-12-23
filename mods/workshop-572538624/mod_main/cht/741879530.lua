local UpvalueHacker = require("tools/upvaluehacker")
local writeables = require("writeables")
local kinds = UpvalueHacker.GetUpvalue(writeables.makescreen, "kinds")
local beefalo_names = {
  "二狗",
  "大黑",
  "美芽",
  "壯壯",
  "土豆泥",
  "小強",
  "一筒",
  "艾迪",
  "黑風",
  "閃電",
  "長毛",
  "達芬奇",
  "銅錘",
  "牛牛",
  "無敵",
  "小哈",
}

_G.TUNING.BUT_CANCEL = "取消"
_G.TUNING.BUT_RANDOM = "隨機"
_G.TUNING.BUT_ACCEPT = "命名！"

kinds.beefalo = {
  prompt = "在這裡輸入你的牛的名字...",
  animbank = "ui_board_5x3",
  animbuild = "ui_board_5x3",
  menuoffset = GLOBAL.Vector3(6, -70, 0),

  cancelbtn = { text = TUNING.BUT_CANCEL, cb = nil, control = GLOBAL.CONTROL_CANCEL },
  middlebtn = { text = TUNING.BUT_RANDOM, cb = function(inst, doer, widget) widget:OverrideText( beefalo_names[math.random(#beefalo_names)] ) end, control = GLOBAL.CONTROL_MENU_MISC_2 },
  acceptbtn = { text = TUNING.BUT_ACCEPT, cb = nil, control = GLOBAL.CONTROL_ACCEPT },
}

STRINGS.NAMES.BEEFALOCOLLAR = "牛圈"
_G.ChinesePlus.RenameRecipe("BEEFALOCOLLAR", "如果你喜歡它，就給它戴上項圈。")

STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEEFALOCOLLAR = "它可能有些臭，但它是我的。"
STRINGS.CHARACTERS.WX78.DESCRIBE.BEEFALOCOLLAR = "目標將是我永遠的奴隸"
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BEEFALOCOLLAR = "護身符與野獸的靈魂。"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BEEFALOCOLLAR = "這會把名字放在頭髮上方。"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BEEFALOCOLLAR = "這不會會使它不那麼愚蠢，但它會使它變成我的。"
STRINGS.CHARACTERS.WENDY.DESCRIBE.BEEFALOCOLLAR = "這將會把野獸繫結我，像是阿比蓋爾的花綁定了它。"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.BEEFALOCOLLAR = "這是不是意味著我們將把它當作自己呢？"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BEEFALOCOLLAR = "這似乎不僅僅是一個衣領。"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.BEEFALOCOLLAR = "一個牛叫我，嗯？"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.BEEFALOCOLLAR = "這可能會讓它的火持續更長的時間。"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEEFALO.NEARDEATH = "沒有幫助，它不會活得長得多。"
STRINGS.CHARACTERS.WX78.DESCRIBE.BEEFALO.NEARDEATH = "目標是會死的。哈。"
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BEEFALO.NEARDEATH = "野獸將會在瓦爾哈拉很快…"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BEEFALO.NEARDEATH = "長毛牛是死的很快！"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BEEFALO.NEARDEATH = "我幾乎為垂死的野獸感到難過。"
STRINGS.CHARACTERS.WENDY.DESCRIBE.BEEFALO.NEARDEATH = "野獸不渴望這個世界。"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.BEEFALO.NEARDEATH = "我們認為它需要藥物，馬上。"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BEEFALO.NEARDEATH = "它需要立即就醫"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.BEEFALO.NEARDEATH = "野獸的生活就像是一個包裹。"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.BEEFALO.NEARDEATH = "它的火幾乎熄滅了！"

STRINGS.NAMES.SHADOWTORCHBEARER_BUILDER = "暗影火炬手"
STRINGS.NAMES.SHADOWPORTER_BUILDER = "暗影行李工"
_G.ChinesePlus.RenameRecipe("SHADOWTORCHBEARER_BUILDER", "讓查理在家呆著！")
_G.ChinesePlus.RenameRecipe("SHADOWPORTER_BUILDER", "您要我搬這個嗎，先生？")

STRINGS.NAMES.SHADOWWAXWELL = nil
STRINGS.NAMES.SHADOWLUMBER = "暗影伐木工"
STRINGS.NAMES.SHADOWMINER = "暗影礦工"
STRINGS.NAMES.SHADOWDIGGER = "暗影挖掘者"
STRINGS.NAMES.SHADOWDUELIST = "暗影鬥士"
STRINGS.NAMES.SHADOWTORCHBEARER = "暗影火炬手"
STRINGS.NAMES.SHADOWPORTER = "暗影行李工"

STRINGS.ACTIONS.TOGGLEAGGRO = { STOPAGGRO = "仇恨解除", STARTAGGRO = "仇恨生成" }

STRINGS.CHARACTER_DESCRIPTIONS.willow = ""
.."*為了自己的愛好了解了很多火的知識 \n"
.."*可以製作可愛的熊和甜美的打火機 \n"
.."*瘋狂的時候不能保持溫暖"

STRINGS.NAMES.SHADOWLIGHTER = "暗影打火機"
_G.ChinesePlus.RenameRecipe("SHADOWLIGHTER", "燒掉！燒掉所有！")

STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOWLIGHTER = "對我來說這個沒什麼用..."
STRINGS.CHARACTERS.WX78.DESCRIBE.SHADOWLIGHTER = "它的黑魔法不起作用"
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SHADOWLIGHTER = "戰士利用光，而不是影子！"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SHADOWLIGHTER = "微小、可怕的燃燒照不亮沃爾夫岡。"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SHADOWLIGHTER = "哦，她放進去了什麼..."
STRINGS.CHARACTERS.WENDY.DESCRIBE.SHADOWLIGHTER = "盒子裡有一個更黑暗的死亡..."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.SHADOWLIGHTER = "這是一個可怕的打火機。讓我們遠離它。"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SHADOWLIGHTER = "我不理解或信任它的機制。"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.SHADOWLIGHTER = "打火機，陰影？猜猜這是為什麼它沒有光，嗯？"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.SHADOWLIGHTER = "當我在寶座上的時候，我學到了一兩件事。"

STRINGS.ACTIONS.STARTSHADOWFIRE = "啟動暗影之火"

STRINGS.CHARACTERS.WILLOW.ANNOUNCE_WANTFIRE = "我不記得我最後一次燒燬的東西..."
STRINGS.CHARACTERS.WILLOW.ANNOUNCE_REALLYWANTFIRE = "我的手指渴望燃燒的東西..."

STRINGS.CHARACTERS.GENERIC.DESCRIBE.WINTEROMETER = {
  "我最好穿暖和的衣服！",
  "我可能需要一件毛衣。",
  "這有點冷。",
  "好天氣。",
  "有點熱。",
  "我應該遠離太陽。",
  "我最好帶些冷的東西在身上。",
}
STRINGS.CHARACTERS.WILLOW.DESCRIBE.WINTEROMETER = {
  "讓我們點燃熊熊烈火，保持溫暖！",
  "冷到要點燃篝火。",
  "寒冷的微風吹過。",
  "天氣很好。",
  "炎熱的微風吹過。",
  "我要晒傷了…我更喜歡其他種類的燃燒。",
  "太熱了，甚至像火。",
}
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.WINTEROMETER = {
  "需要很溫暖的帽子！",
  "需要溫暖的帽子！",
  "寒冷。",
  "好天氣。",
  "熱。",
  "今天的太陽比沃爾夫岡強。",
  "天空像火一樣！",
}
STRINGS.CHARACTERS.WENDY.DESCRIBE.WINTEROMETER = {
  "空氣比我的心冷...",
  "我需要一些東西來避開寒冷.",
  "我感到涼。",
  "完全無聊的天氣。",
  "相當暖和。",
  "這是很慘的熱。",
  "我將滅亡，而沒有東西讓我冷靜下來...",
}
STRINGS.CHARACTERS.WX78.DESCRIBE.WINTEROMETER = {
  "溫度: 極低",
  "溫度: 較低",
  "溫度: 低",
  "溫度: 可接受",
  "溫度: 高",
  "溫度: 較高",
  "溫度: 極高",
}
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.WINTEROMETER = {
  "我們需要一個熱的火和大量的溫暖的衣服！",
  "一件暖和的毛衣可能會很有秩序。",
  "相當寒冷。",
  "可愛的天氣。",
  "相當炎熱。",
  "明確的悶熱",
  "我們需要一些吸熱反應來生存！",
}
STRINGS.CHARACTERS.WOODIE.DESCRIBE.WINTEROMETER = {
  "呵，哦！凍住了。",
  "我今天需要一些比格子襯衫暖和的衣物。",
  "格子襯衫足夠應付這個天氣。",
  "好天氣，是嗎？",
  "有點熱了。",
  "我應該找點東西來把太陽從我的頭拿掉。",
  "比燃燒的森林更熱！",
}
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.WINTEROMETER = {
  "冰川的溫度。",
  "我一個人挨凍的時候不那麼有趣。",
  "比我想的更冷。",
  "完全普通天氣。",
  "比我想的熱。",
  "非常熱。",
  "地獄的溫度。",
}
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.WINTEROMETER = {
  "我將用戰鬥的憤怒溫暖我自己！",
  "冬天的力量在我們身上。",
  "絲卡蒂（雪靴女神）給我們帶來了令人不寒而慄的警告。",
  "鬥毆的好天氣！",
  "這有點溫暖。",
  "這種熱即使是一個戰士也無法忍受。",
  "世界還沒有準備好接受蘇魯特（火焰巨人）的怒火！",
}
STRINGS.CHARACTERS.WEBBER.DESCRIBE.WINTEROMETER = {
  "如果有我父親的毛皮大衣！",
  "柔滑的鬍子可能是不夠的。",
  "寒冷。",
  "最好的天氣！",
  "有點熱。",
  "我們的皮毛在這種天氣下太過溫暖了。",
  "天啊，熱死了！",
}
