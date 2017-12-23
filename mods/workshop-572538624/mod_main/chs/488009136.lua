STRINGS.NAMES.BOW = "木弓"
_G.ChinesePlus.RenameRecipe("BOW", "如果能够瞄准就很有用")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOW = "我曾经是个好射手.自从我膝盖中了一箭."

STRINGS.NAMES.QUIVER = "箭筒"
_G.ChinesePlus.RenameRecipe("QUIVER", "放你的箭")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.QUIVER = "有了这玩意儿, 我看上去像个专业的了."

STRINGS.NAMES.ARROW = "石箭矢"
_G.ChinesePlus.RenameRecipe("ARROW", "别空手抛投.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARROW = "可能是最实用的箭矢了"

STRINGS.NAMES.GOLDARROW = "金箭矢"
_G.ChinesePlus.RenameRecipe("GOLDARROW", "猎出风格.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDARROW = "我敢肯定我能很好的使用它..."

STRINGS.NAMES.MOONSTONEARROW = "月箭矢"
_G.ChinesePlus.RenameRecipe("MOONSTONEARROW", "贵但有效率.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOONSTONEARROW = "锐利和闪亮!"

STRINGS.NAMES.FIREARROW = "火箭矢"
_G.ChinesePlus.RenameRecipe("FIREARROW", "用的时候格外小心点")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIREARROW = "我应该避免在我的营地中间使用它..."

STRINGS.NAMES.ICEARROW = "冰箭矢"
_G.ChinesePlus.RenameRecipe("ICEARROW", "保持冷静.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICEARROW = "我应该把它放在冰箱里?"

STRINGS.NAMES.THUNDERARROW = "雷箭矢"
_G.ChinesePlus.RenameRecipe("THUNDERARROW", "风暴来了.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.THUNDERARROW = "正极是红线..."

STRINGS.NAMES.DISCHARGEDTHUNDERARROW = "没电的雷箭矢"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISCHARGEDTHUNDERARROW = "看起来它再也没有活力了."

STRINGS.NAMES.CROSSBOW = "弩"
_G.ChinesePlus.RenameRecipe("CROSSBOW", "重但有效.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CROSSBOW = "这玩意儿比我还大."

STRINGS.NAMES.BOLT = "弩箭"
_G.ChinesePlus.RenameRecipe("BOLT", "不是牙签.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOLT = "如此之大的武器用个这么小的弹丸..."

STRINGS.NAMES.POISONBOLT = "毒弩箭"
_G.ChinesePlus.RenameRecipe("POISONBOLT", "砒霜熬制.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.POISONBOLT = "一定要这么丑吗?"

STRINGS.NAMES.EXPLOSIVEBOLT = "爆炸弩箭"
_G.ChinesePlus.RenameRecipe("EXPLOSIVEBOLT", "别近距离使用.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.EXPLOSIVEBOLT = "这真是一个好创意!"

STRINGS.NAMES.MAGICBOW = "魔法弓"
_G.ChinesePlus.RenameRecipe("MAGICBOW", "妖精的尾巴.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAGICBOW = "还有一种燃料可以装填.我不告诉你"

STRINGS.NAMES.MUSKET = "滑膛枪"
_G.ChinesePlus.RenameRecipe("MUSKET", "好吵. 你要注意点.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MUSKET = "我是5号火枪手?"

STRINGS.NAMES.MUSKET_BULLET = "滑膛枪弹药"
_G.ChinesePlus.RenameRecipe("MUSKET_BULLET", "亲, 让我们开打吧.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MUSKET_BULLET = "看起来跟弹珠似得"

STRINGS.NAMES.Z_FIREFLIESBALL = "萤火虫球"
_G.ChinesePlus.RenameRecipe("Z_FIREFLIESBALL", "别吃")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.Z_FIREFLIESBALL = "它可能有某种用途。但不要问我是什么."

STRINGS.NAMES.Z_BLUEGOOP = "蓝汞"
_G.ChinesePlus.RenameRecipe("Z_BLUEGOOP", "千万不要对你的敌人使用它.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.Z_BLUEGOOP = "小时候妈妈给我们涂在膝盖上的治伤口的."

_G.ChinesePlus.RenameTab("Archery", "弓箭")
STRINGS.ACTIONS["ARMCROSSBOW"] = {
  XBOW = "装上弩箭",
  MUSKET = "装填滑膛枪",
}
_G.ChinesePlus.RenameAction("CHANGEARROWTYPE", "更换弹药")

local saytable = {
  ["I do not have anything to put in..."] = "我没有任何东西要放进去…",
  ["I should first get a quiver!"] = "首先我需要箭筒！",
  ["I won't shoot far if I don't arm it first..."] = "我需要装上箭才能射的远。",
  ["If I pull even more on this stuff it will break..."] = "如果我再放就会弄坏这个…",
  ["It is probably not a good idea to pile it up..."] = "把它堆积起来可能不是一个好主意…",
  ["It looks like this stuff ran out of juice."] = "看起来能量已经用完了。",
  ["It's too late now..."] = "现在太迟了…",
  ["My quiver is empty!"] = "我的箭筒是空的。",
  ["There's no potential target on sight."] = "没有看到潜在的目标。",
  ["This won't fit it my current weapon..."] = "这不适合当前武器…",
  ["I should aim better next time!"] = "下一次我会瞄准的好点！",
}

AddPlayerPostInit(function(self)
    if self.components and self.components.talker and self.components.talker.Say then
      local mytalker = self.components.talker
      mytalker.OldSay = mytalker.Say
      function mytalker:Say(script, time, noanim, force, nobroadcast, colour, ...)
        local str = script
        if saytable[str] then
          str = saytable[str]
        end
        mytalker:OldSay(str, time, noanim, force, nobroadcast, colour, ...)
      end
    end

  end)
