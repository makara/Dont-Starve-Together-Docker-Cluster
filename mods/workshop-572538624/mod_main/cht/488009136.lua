STRINGS.NAMES.BOW = "木弓"
_G.ChinesePlus.RenameRecipe("BOW", "如果能夠瞄準就很有用")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOW = "我曾經是個好射手.自從我膝蓋中了一箭."

STRINGS.NAMES.QUIVER = "箭筒"
_G.ChinesePlus.RenameRecipe("QUIVER", "放你的箭")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.QUIVER = "有了這玩意兒, 我看上去像個專業的了."

STRINGS.NAMES.ARROW = "石箭矢"
_G.ChinesePlus.RenameRecipe("ARROW", "別空手拋投.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARROW = "可能是最實用的箭矢了"

STRINGS.NAMES.GOLDARROW = "金箭矢"
_G.ChinesePlus.RenameRecipe("GOLDARROW", "獵出風格.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDARROW = "我敢肯定我能很好的使用它..."

STRINGS.NAMES.MOONSTONEARROW = "月箭矢"
_G.ChinesePlus.RenameRecipe("MOONSTONEARROW", "貴但有效率.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOONSTONEARROW = "銳利和閃亮!"

STRINGS.NAMES.FIREARROW = "火箭矢"
_G.ChinesePlus.RenameRecipe("FIREARROW", "用的時候格外小心點")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIREARROW = "我應該避免在我的營地中間使用它..."

STRINGS.NAMES.ICEARROW = "冰箭矢"
_G.ChinesePlus.RenameRecipe("ICEARROW", "保持冷靜.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICEARROW = "我應該把它放在冰箱裡?"

STRINGS.NAMES.THUNDERARROW = "雷箭矢"
_G.ChinesePlus.RenameRecipe("THUNDERARROW", "風暴來了.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.THUNDERARROW = "正極是紅線..."

STRINGS.NAMES.DISCHARGEDTHUNDERARROW = "沒電的雷箭矢"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISCHARGEDTHUNDERARROW = "看起來它再也沒有活力了."

STRINGS.NAMES.CROSSBOW = "弩"
_G.ChinesePlus.RenameRecipe("CROSSBOW", "重但有效.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CROSSBOW = "這玩意兒比我還大."

STRINGS.NAMES.BOLT = "弩箭"
_G.ChinesePlus.RenameRecipe("BOLT", "不是牙籤.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOLT = "如此之大的武器用個這麼小的彈丸..."

STRINGS.NAMES.POISONBOLT = "毒弩箭"
_G.ChinesePlus.RenameRecipe("POISONBOLT", "砒霜熬製.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.POISONBOLT = "一定要這麼醜嗎?"

STRINGS.NAMES.EXPLOSIVEBOLT = "爆炸弩箭"
_G.ChinesePlus.RenameRecipe("EXPLOSIVEBOLT", "別近距離使用.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.EXPLOSIVEBOLT = "這真是一個好創意!"

STRINGS.NAMES.MAGICBOW = "魔法弓"
_G.ChinesePlus.RenameRecipe("MAGICBOW", "妖精的尾巴.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAGICBOW = "還有一種燃料可以裝填.我不告訴你"

STRINGS.NAMES.MUSKET = "滑膛槍"
_G.ChinesePlus.RenameRecipe("MUSKET", "好吵. 你要注意點.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MUSKET = "我是5號火槍手?"

STRINGS.NAMES.MUSKET_BULLET = "滑膛槍彈藥"
_G.ChinesePlus.RenameRecipe("MUSKET_BULLET", "親, 讓我們開打吧.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MUSKET_BULLET = "看起來跟彈珠似得"

STRINGS.NAMES.Z_FIREFLIESBALL = "螢火蟲球"
_G.ChinesePlus.RenameRecipe("Z_FIREFLIESBALL", "別吃")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.Z_FIREFLIESBALL = "它可能有某種用途。但不要問我是什麼."

STRINGS.NAMES.Z_BLUEGOOP = "藍汞"
_G.ChinesePlus.RenameRecipe("Z_BLUEGOOP", "千萬不要對你的敵人使用它.")
STRINGS.CHARACTERS.GENERIC.DESCRIBE.Z_BLUEGOOP = "小時候媽媽給我們塗在膝蓋上的治傷口的."

_G.ChinesePlus.RenameTab("Archery", "弓箭")
STRINGS.ACTIONS["ARMCROSSBOW"] = {
  XBOW = "裝上弩箭",
  MUSKET = "裝填滑膛槍",
}
_G.ChinesePlus.RenameAction("CHANGEARROWTYPE", "更換彈藥")

local saytable = {
  ["I do not have anything to put in..."] = "我沒有任何東西要放進去…",
  ["I should first get a quiver!"] = "首先我需要箭筒！",
  ["I won't shoot far if I don't arm it first..."] = "我需要裝上箭才能射的遠。",
  ["If I pull even more on this stuff it will break..."] = "如果我再放就會弄壞這個…",
  ["It is probably not a good idea to pile it up..."] = "把它堆積起來可能不是一個好主意…",
  ["It looks like this stuff ran out of juice."] = "看起來能量已經用完了。",
  ["It's too late now..."] = "現在太遲了…",
  ["My quiver is empty!"] = "我的箭筒是空的。",
  ["There's no potential target on sight."] = "沒有看到潛在的目標。",
  ["This won't fit it my current weapon..."] = "這不適合當前武器…",
  ["I should aim better next time!"] = "下一次我會瞄準的好點！",
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
