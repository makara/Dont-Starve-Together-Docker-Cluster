if _G.ChinesePlus.mod_names["Rezecib's Rebalance"] then
  STRINGS.NAMES.UNITYLOCKET = "破損吊墜"
  _G.ChinesePlus.RenameRecipe("UNITYLOCKET", "有什麼東西封印了吊墜的力量。")
  STRINGS.CHARACTERS.GENERIC.DESCRIBE.UNITYLOCKET = "有外面的東西禁止我使用它！\nRezecib 的 Rebalance 模組吸收了所有的力量！"
else

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

  STRINGS.NAMES.UNITYLOCKET = "團結吊墜"
  _G.ChinesePlus.RenameRecipe("UNITYLOCKET", "用來保護你的牛的魔法輔助。")

  STRINGS.CHARACTERS.GENERIC.DESCRIBE.UNITYLOCKET = "它可能有些臭，但它是我的。"
  STRINGS.CHARACTERS.WX78.DESCRIBE.UNITYLOCKET = "目標將是我永遠的奴隸"
  STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.UNITYLOCKET = "護身符與野獸的靈魂。"
  STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.UNITYLOCKET = "這會把名字放在頭髮上方。"
  STRINGS.CHARACTERS.WAXWELL.DESCRIBE.UNITYLOCKET = "這不會會使它不那麼愚蠢，但它會使它變成我的。"
  STRINGS.CHARACTERS.WENDY.DESCRIBE.UNITYLOCKET = "這將會把野獸繫結我，像是阿比蓋爾的花綁定了它。"
  STRINGS.CHARACTERS.WEBBER.DESCRIBE.UNITYLOCKET = "這是不是意味著我們將把它當作自己呢？"
  STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.UNITYLOCKET = "這似乎不僅僅是一個衣領。"
  STRINGS.CHARACTERS.WOODIE.DESCRIBE.UNITYLOCKET = "一個牛叫我，嗯？"
  STRINGS.CHARACTERS.WILLOW.DESCRIBE.UNITYLOCKET = "這可能會讓它的火持續更長的時間。"

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

end

_G.ChinesePlus.RenameRecipe("KRAMPUS_SACK", "一個真正無底的揹包。")
_G.ChinesePlus.RenameRecipe("DUG_BERRYBUSH_JUICY", "試著搜尋那裡的神奇寶貝。")

