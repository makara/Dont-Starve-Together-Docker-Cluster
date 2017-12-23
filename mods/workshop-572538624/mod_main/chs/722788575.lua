if _G.ChinesePlus.mod_names["Rezecib's Rebalance"] then
  STRINGS.NAMES.UNITYLOCKET = "破损吊坠"
  _G.ChinesePlus.RenameRecipe("UNITYLOCKET", "有什么东西封印了吊坠的力量。")
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.UNITYLOCKET = "有外面的东西禁止我使用它！\nRezecib 的 Rebalance 模组吸收了所有的力量！"
else

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

  STRINGS.NAMES.UNITYLOCKET = "团结吊坠"
  _G.ChinesePlus.RenameRecipe("UNITYLOCKET", "用来保护你的牛的魔法辅助。")

  STRINGS.CHARACTERS.GENERIC.DESCRIBE.UNITYLOCKET = "它可能有些臭，但它是我的。"
  STRINGS.CHARACTERS.WX78.DESCRIBE.UNITYLOCKET = "目标将是我永远的奴隶"
  STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.UNITYLOCKET = "护身符与野兽的灵魂。"
  STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.UNITYLOCKET = "这会把名字放在头发上方。"
  STRINGS.CHARACTERS.WAXWELL.DESCRIBE.UNITYLOCKET = "这不会会使它不那么愚蠢，但它会使它变成我的。"
  STRINGS.CHARACTERS.WENDY.DESCRIBE.UNITYLOCKET = "这将会把野兽绑定我，像是阿比盖尔的花绑定了它。"
  STRINGS.CHARACTERS.WEBBER.DESCRIBE.UNITYLOCKET = "这是不是意味着我们将把它当作自己呢？"
  STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.UNITYLOCKET = "这似乎不仅仅是一个衣领。"
  STRINGS.CHARACTERS.WOODIE.DESCRIBE.UNITYLOCKET = "一个牛叫我，嗯？"
  STRINGS.CHARACTERS.WILLOW.DESCRIBE.UNITYLOCKET = "这可能会让它的火持续更长的时间。"

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

end

_G.ChinesePlus.RenameRecipe("KRAMPUS_SACK", "一个真正无底的背包。")
_G.ChinesePlus.RenameRecipe("DUG_BERRYBUSH_JUICY", "试着搜索那里的神奇宝贝。")

