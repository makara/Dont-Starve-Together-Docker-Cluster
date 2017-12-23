local UpvalueHacker = require("tools/upvaluehacker")
local writeables = require("writeables")
local kinds = UpvalueHacker.GetUpvalue(writeables.makescreen, "kinds")
local beefalo_names = {
  "二狗",
  "大黑",
  "美芽",
  "壮壮",
  "土豆泥",
  "小强",
  "一筒",
  "艾迪",
  "黑风",
  "闪电",
  "长毛",
  "达芬奇",
  "铜锤",
  "牛牛",
  "无敌",
  "小哈",
}

_G.TUNING.BUT_CANCEL = "取消"
_G.TUNING.BUT_RANDOM = "随机"
_G.TUNING.BUT_ACCEPT = "命名！"

kinds.beefalo = {
  prompt = "在这里输入你的牛的名字...",
  animbank = "ui_board_5x3",
  animbuild = "ui_board_5x3",
  menuoffset = GLOBAL.Vector3(6, -70, 0),

  cancelbtn = { text = TUNING.BUT_CANCEL, cb = nil, control = GLOBAL.CONTROL_CANCEL },
  middlebtn = { text = TUNING.BUT_RANDOM, cb = function(inst, doer, widget) widget:OverrideText( beefalo_names[math.random(#beefalo_names)] ) end, control = GLOBAL.CONTROL_MENU_MISC_2 },
  acceptbtn = { text = TUNING.BUT_ACCEPT, cb = nil, control = GLOBAL.CONTROL_ACCEPT },
}

STRINGS.NAMES.BEEFALOCOLLAR = "牛圈"
_G.ChinesePlus.RenameRecipe("BEEFALOCOLLAR", "如果你喜欢它，就给它戴上项圈。")

STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEEFALOCOLLAR = "它可能有些臭，但它是我的。"
STRINGS.CHARACTERS.WX78.DESCRIBE.BEEFALOCOLLAR = "目标将是我永远的奴隶"
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BEEFALOCOLLAR = "护身符与野兽的灵魂。"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BEEFALOCOLLAR = "这会把名字放在头发上方。"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BEEFALOCOLLAR = "这不会会使它不那么愚蠢，但它会使它变成我的。"
STRINGS.CHARACTERS.WENDY.DESCRIBE.BEEFALOCOLLAR = "这将会把野兽绑定我，像是阿比盖尔的花绑定了它。"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.BEEFALOCOLLAR = "这是不是意味着我们将把它当作自己呢？"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BEEFALOCOLLAR = "这似乎不仅仅是一个衣领。"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.BEEFALOCOLLAR = "一个牛叫我，嗯？"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.BEEFALOCOLLAR = "这可能会让它的火持续更长的时间。"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEEFALO.NEARDEATH = "没有帮助，它不会活得长得多。"
STRINGS.CHARACTERS.WX78.DESCRIBE.BEEFALO.NEARDEATH = "目标是会死的。哈。"
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BEEFALO.NEARDEATH = "野兽将会在瓦尔哈拉很快…"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BEEFALO.NEARDEATH = "长毛牛是死的很快！"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BEEFALO.NEARDEATH = "我几乎为垂死的野兽感到难过。"
STRINGS.CHARACTERS.WENDY.DESCRIBE.BEEFALO.NEARDEATH = "野兽不渴望这个世界。"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.BEEFALO.NEARDEATH = "我们认为它需要药物，马上。"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BEEFALO.NEARDEATH = "它需要立即就医"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.BEEFALO.NEARDEATH = "野兽的生活就像是一个包裹。"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.BEEFALO.NEARDEATH = "它的火几乎熄灭了！"

STRINGS.NAMES.SHADOWTORCHBEARER_BUILDER = "暗影火炬手"
STRINGS.NAMES.SHADOWPORTER_BUILDER = "暗影行李工"
_G.ChinesePlus.RenameRecipe("SHADOWTORCHBEARER_BUILDER", "让查理在家呆着！")
_G.ChinesePlus.RenameRecipe("SHADOWPORTER_BUILDER", "您要我搬这个吗，先生？")

STRINGS.NAMES.SHADOWWAXWELL = nil
STRINGS.NAMES.SHADOWLUMBER = "暗影伐木工"
STRINGS.NAMES.SHADOWMINER = "暗影矿工"
STRINGS.NAMES.SHADOWDIGGER = "暗影挖掘者"
STRINGS.NAMES.SHADOWDUELIST = "暗影斗士"
STRINGS.NAMES.SHADOWTORCHBEARER = "暗影火炬手"
STRINGS.NAMES.SHADOWPORTER = "暗影行李工"

STRINGS.ACTIONS.TOGGLEAGGRO = { STOPAGGRO = "仇恨解除", STARTAGGRO = "仇恨生成" }

STRINGS.CHARACTER_DESCRIPTIONS.willow = ""
.."*为了自己的爱好了解了很多火的知识 \n"
.."*可以制作可爱的熊和甜美的打火机 \n"
.."*疯狂的时候不能保持温暖"

STRINGS.NAMES.SHADOWLIGHTER = "暗影打火机"
_G.ChinesePlus.RenameRecipe("SHADOWLIGHTER", "烧掉！烧掉所有！")

STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOWLIGHTER = "对我来说这个没什么用..."
STRINGS.CHARACTERS.WX78.DESCRIBE.SHADOWLIGHTER = "它的黑魔法不起作用"
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SHADOWLIGHTER = "战士利用光，而不是影子！"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SHADOWLIGHTER = "微小、可怕的燃烧照不亮沃尔夫冈。"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SHADOWLIGHTER = "哦，她放进去了什么..."
STRINGS.CHARACTERS.WENDY.DESCRIBE.SHADOWLIGHTER = "盒子里有一个更黑暗的死亡..."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.SHADOWLIGHTER = "这是一个可怕的打火机。让我们远离它。"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SHADOWLIGHTER = "我不理解或信任它的机制。"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.SHADOWLIGHTER = "打火机，阴影？猜猜这是为什么它没有光，嗯？"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.SHADOWLIGHTER = "当我在宝座上的时候，我学到了一两件事。"

STRINGS.ACTIONS.STARTSHADOWFIRE = "启动暗影之火"

STRINGS.CHARACTERS.WILLOW.ANNOUNCE_WANTFIRE = "我不记得我最后一次烧毁的东西..."
STRINGS.CHARACTERS.WILLOW.ANNOUNCE_REALLYWANTFIRE = "我的手指渴望燃烧的东西..."

STRINGS.CHARACTERS.GENERIC.DESCRIBE.WINTEROMETER = {
  "我最好穿暖和的衣服！",
  "我可能需要一件毛衣。",
  "这有点冷。",
  "好天气。",
  "有点热。",
  "我应该远离太阳。",
  "我最好带些冷的东西在身上。",
}
STRINGS.CHARACTERS.WILLOW.DESCRIBE.WINTEROMETER = {
  "让我们点燃熊熊烈火，保持温暖！",
  "冷到要点燃篝火。",
  "寒冷的微风吹过。",
  "天气很好。",
  "炎热的微风吹过。",
  "我要晒伤了…我更喜欢其他种类的燃烧。",
  "太热了，甚至像火。",
}
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.WINTEROMETER = {
  "需要很温暖的帽子！",
  "需要温暖的帽子！",
  "寒冷。",
  "好天气。",
  "热。",
  "今天的太阳比沃尔夫冈强。",
  "天空像火一样！",
}
STRINGS.CHARACTERS.WENDY.DESCRIBE.WINTEROMETER = {
  "空气比我的心冷...",
  "我需要一些东西来避开寒冷.",
  "我感到凉。",
  "完全无聊的天气。",
  "相当暖和。",
  "这是很惨的热。",
  "我将灭亡，而没有东西让我冷静下来...",
}
STRINGS.CHARACTERS.WX78.DESCRIBE.WINTEROMETER = {
  "温度: 极低",
  "温度: 较低",
  "温度: 低",
  "温度: 可接受",
  "温度: 高",
  "温度: 较高",
  "温度: 极高",
}
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.WINTEROMETER = {
  "我们需要一个热的火和大量的温暖的衣服！",
  "一件暖和的毛衣可能会很有秩序。",
  "相当寒冷。",
  "可爱的天气。",
  "相当炎热。",
  "明确的闷热",
  "我们需要一些吸热反应来生存！",
}
STRINGS.CHARACTERS.WOODIE.DESCRIBE.WINTEROMETER = {
  "呵，哦！冻住了。",
  "我今天需要一些比格子衬衫暖和的衣物。",
  "格子衬衫足够应付这个天气。",
  "好天气，是吗？",
  "有点热了。",
  "我应该找点东西来把太阳从我的头拿掉。",
  "比燃烧的森林更热！",
}
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.WINTEROMETER = {
  "冰川的温度。",
  "我一个人挨冻的时候不那么有趣。",
  "比我想的更冷。",
  "完全普通天气。",
  "比我想的热。",
  "非常热。",
  "地狱的温度。",
}
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.WINTEROMETER = {
  "我将用战斗的愤怒温暖我自己！",
  "冬天的力量在我们身上。",
  "丝卡蒂（雪靴女神）给我们带来了令人不寒而栗的警告。",
  "斗殴的好天气！",
  "这有点温暖。",
  "这种热即使是一个战士也无法忍受。",
  "世界还没有准备好接受苏鲁特（火焰巨人）的怒火！",
}
STRINGS.CHARACTERS.WEBBER.DESCRIBE.WINTEROMETER = {
  "如果有我父亲的毛皮大衣！",
  "柔滑的胡子可能是不够的。",
  "寒冷。",
  "最好的天气！",
  "有点热。",
  "我们的皮毛在这种天气下太过温暖了。",
  "天啊，热死了！",
}
