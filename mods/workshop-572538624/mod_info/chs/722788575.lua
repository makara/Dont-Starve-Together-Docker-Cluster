_G.ChinesePlus.SetConfigTranslation(mod_to_c,
  "创建你自己的规则！\n改变你想改变的一切！",
  {

  },
  {
    {
      name = "rule_balance",
      label = ":-:-:-:-:-:-:-:-:-:-:-:-:-:-:-",
      hover = "",
      options =
      {
        {description = "1. 平衡性!", data = "nope", hover = "这个类别中的选项对游戏有整体影响。"},
      },

    },
    {
      name = "rule_armor",
      label = "护甲耐久",
      hover = "联机版中生物的生命值增加了很多，但是我们的护甲没有变化。",
      options =
      {
        --{description = "上帝模式！", data = "cheaty", hover = "完全无懈可击的护甲。"},
        {description = "永恒！", data = "cheat", hover = "无限的护甲"},
        {description = "不改变", data = "nope", hover = "含糊虫有 1,200 的血量.\n你确定?"},
        {description = "增强 50%!", data = "50", hover = "护甲更强大\n增强 +50% (1.5 倍)."},
        {description = "增强 100%!", data = "100", hover = "现在护甲与生物平衡了。好多了。"},
      },

    },
    {
      name = "rule_fight",
      label = "武器",
      hover = "改变回旋镖、暗夜剑、铥矿棒和镐斧的伤害。",
      options =
      {
        {description = "不改变", data = "nope", hover = "标准武器已经满意了吗？"},
        {description = "改变", data = "yep", hover = "将平衡这些武器。"},
      },

    },
    {
      name = "rule_tool",
      label = "工具",
      hover = "平衡 17% 的工具。",
      options =
      {
        {description = "不改变", data = "nope", hover = "标准工具已经满意了吗？"},
        {description = "改变", data = "yep", hover = "将平衡这些工具。"},
      },

    },
    {
      name = "rule_magic",
      label = "魔法",
      hover = "重新平衡游戏中的所有魔法。",
      options =
      {
        {description = "限制", data = "block", hover = "魔法栏的东西将被封印。"},
        {description = "不改变", data = "nope", hover = "已经足够了。 666"},
        {description = "改变", data = "yep", hover = "将平衡魔法。"},
      },

    },
    {
      name = "rule_dress",
      label = "衣物",
      hover = "改变所有衣物的耐久?",
      options =
      {
        {description = "不改变", data = "nope", hover = "'衣物很好，我不想改变。'"},
        {description = "改变", data = "yep", hover = "耶! 新的 2016 范儿!"},
      },

    },
    {
      name = "rule_spdpen",
      label = "速度衰减",
      hover = "可以让自己关掉大理石盔甲、小猪背包和冰块帽的速度惩罚。",
      options =
      {
        {description = "铁杆!", data = "hard", hover = "2 倍的速度惩罚.\n*除了大理石盔甲*"},
        {description = "不改变", data = "nope", hover = "噢，得了吧！"},
        {description = "50%!", data = "half", hover = "一半的速度惩罚。"},
        {description = "移除!", data = "remove", hover = "没有什么会阻碍你优雅的行走了。"},
      },

    },
    {
      name = "rule_pets",
      label = "宠物生命",
      hover = "给你的宠物更多的生命值并且增加轻微的自动恢复。",
      options =
      {
        {description = "不改变", data = "nope", hover = "你对几乎死去的宠物满意吗？！"},
        {description = "改变!", data = "yep", hover = "切斯特, 哈奇, 格罗姆, 高鸟 和 大象 更加强壮了。"},
      },

    },
    {
      name = "rule_boost",
      label = ":-:-:-:-:-:-:-:-:-:-:-:-:-:-:-",
      hover = "",
      options =
      {
        {description = "2. 强化!", data = "nope", hover = "这一类别中的选项改进了游戏的某部分。"},
      },

    },
    {
      name = "rule_saddle",
      label = "牛的忠诚",
      hover = "Feel free to include, if they\nseem too weak for you.",
      options =
      {
        {description = "不改变", data = "nope", hover = "开启这个。 就现在!"},
        {description = "轻微改变!", data = "yep", hover = "现在它们会更好，更快、更强。"},
        {description = "大幅改变!", data = "yeppie", hover = "现在他们会非常好、非常快、非常强。"},
      },

    },
    {
      name = "rule_salve",
      label = "现代医学",
      hover = "治疗药膏和绷带的制作太贵了吗？",
      options =
      {
        {description = "不改变", data = "nope", hover = "不."},
        {description = "改变!", data = "yep", hover = "现在你可以在制作治疗物品得到 2 个，而不是 1 个。"},
        {description = "极大!", data = "both", hover = "现在你可以在制作治疗物品得到 2 个，而不是 1 个。\nAGV 试验药完全移除所有惩罚。"},

      },

    },
    {
      name = "rule_dart",
      label = "吹箭",
      hover = "花了太多的血汗，只有 1 个？",
      options =
      {
        --{description = "OnlyBeta:4", data = "b4", hover = "ONLY WORKS FOR BETA!!!\nNow you can craft 4 (FOUR)\ndarts instead of 1."},
        --{description = "OnlyBeta:2", data = "b2", hover = "ONLY WORKS FOR BETA!!!\nNow you can craft 2 (TWO)\ndarts instead of 1."},
        {description = "限制!", data = "0", hover = "不允许制造吹箭"},
        {description = "不改变", data = "1", hover = "不，它很好。"},
        {description = "轻微改变!", data = "2", hover = "现在你可以制作吹箭时获得 2 个。"},
        {description = "大幅改变!", data = "4", hover = "现在你可以制作吹箭时获得 4 个。"},
      },

    },
    {
      name = "rule_tent",
      label = "帐篷质量",
      hover = "如果你对在愚蠢的帐篷和简易小木棚一遍又一遍的睡觉厌烦了。",
      options =
      {
        {description = "不改变", data = "nope", hover = "让他们土崩瓦解"},
        {description = "永久!", data = "yep", hover = "让他们挺立一个年代，阿门"},
      },

    },
    {
      name = "rule_bedroll",
      label = "睡袋",
      hover = "相信我，你会喜欢它的。",
      options =
      {
        {description = "不改变", data = "nope", hover = "默认睡袋。草做的睡1次、毛做的睡3次。"},
        {description = "改变!", data = "yep", hover = "改进睡袋。草做的睡3次、毛做的睡12次。\n可以被修复。"},
      },

    },
    {
      name = "rule_icebox",
      label = "冰箱功率",
      hover = "想要冰箱更好地减慢腐败吗？",
      options =
      {
        --{description = "Rot x4!", data = "4", hover = "Icebox will SPEED UP perishing\nto four times."},
        {description = "不改变", data = "0.5", hover = "'我对默认的永久很满意了。'"},
        {description = "增强 50%!", data = "0.375", hover = "冰箱将减慢一半腐败速度（1.5 倍）。"},
        {description = "增强 100%!", data = "0.25", hover = "冰箱将 2 倍的减慢腐败速度（2 倍）。"},
        {description = "增强 200%!", data = "0.125", hover = "冰箱将 4 倍的减慢腐败速度（4 倍）。"},
        {description = "永久保鲜!", data = "0", hover = "冰箱里面的食物将永久保鲜。"},
      },

    },
    {
      name = "rule_lighting",
      label = "新的照明",
      hover = "调整或轻微简化生存难度。仅影响移动光源。",
      options =
      {
        {description = "昏暗!", data = "dark", hover = "梦魇吞噬宝贵的光。\n光源枯竭快一倍"},
        {description = "不改变", data = "nope", hover = "选择你的命运."},
        {description = "光亮!", data = "glow", hover = "火炬有更多的燃料。地鼠帽容易充能.."},
      },

    },
    {
      name = "rule_snow",
      label = "雪球发射机",
      hover = "不稳定。将在未来更新。", --"Сделай ИИ снежкомёта лучше." or "Make Flingomatic's AI better.",
      options =
      {
        {description = "不改变", data = "nope", hover = "你不生气篝火被熄灭？"},
        --{description = "改变!", data = "yep", hover = "不会再向营火扔雪球了。\n投掷范围增��� 30%。"},
      },

    },
    {
      name = "rule_tele",
      label = "传送",
      hover = "允许自由进入传送核心。",
      options =
      {
        {description = "不改变", data = "nope", hover = "有什么能比每次传送都要收集宝石更加糟糕？"},
        {description = "改变!", data = "yep", hover = "传送核心上面的紫色宝石在传送后不会消失了。"},
      },

    },
    {
      name = "rule_whip",
      label = "三尾猫的教诲",
      hover = "如此昂贵，但没什么卵用。我们可以解决它。",
      options =
      {
        {description = "不改变", data = "nope", hover = "默认伤害 (28)\n使用次数 (175)."},
        {description = "改变!", data = "yep", hover = "现在它的伤害像触手尖刺 (51)\n更多的使用次数 (300)."},
      },

    },
    {
      name = "rule_mrstar",
      label = "晨星",
      hover = "把这个发光的魔杖变成粉碎所有生物的权杖。",
      options =
      {
        {description = "便宜货..", data = "tran", hover = "默认伤害（43 ~ 72）。\n可以被便宜货修复（+50%）。"},
        {description = "不改变", data = "nope", hover = "默认伤害（43 ~ 72）。"},
        {description = "硝石!", data = "nit0", hover = "默认伤害（43 ~ 72）。.\n可以被硝石修复（+50%）。"},
        {description = "改变!", data = "nit1", hover = "增加伤害（51 ~ 85）。\n可以被硝石修复（+50%）。"}, --RUS: и прочность (6 минут) \\ ENG: and durability (6 minutes)
      },

    },
    {
      name = "rule_oneman",
      label = "独奏乐器",
      hover = "使这坨屎..哦，我的意思是仪器，的更方便有用！",
      options =
      {
        {description = "不改变", data = "nope", hover = "它的耐久损耗快的就像我的童年。"},
        {description = "改变!", data = "yep", hover = "更耐用，而且现在能够用噩梦燃料修复它。"},
      },
    },

    {
      name = "rule_redamul",
      label = "红色护身符",
      hover = "是时候让它真正可以赋予人生命",
      options =
      {
        {description = "不改变", data = "nope", hover = "默认治疗: 每 30 秒 +5 生命， -5 饥饿。"},
        {description = "改变!", data = "yep", hover = "增强治疗: 每 20 秒 +15 生命， -5 饥饿。"},
      },

    },
    {
      name = "rule_magilum",
      label = "魔力之光",
      hover = "牺牲一个得到第二个。",
      options =
      {
        {description = "不改变", data = "nope", hover = "有20%的速度加成，\n但可笑的是光的范围。"},
        {description = "改变!", data = "yep", hover = "大发光半径，\n但没有速度加成。"},
      },
    },
    {
      name = "rule_htrock",
      label = "保暖石",
      hover = "对于那些不想在寒冷的夜晚挨冻的人。无限耐久意味着永远100%。", --"Посвящается любителям не мёрзнуть\nхолодными ночами." or "For people who don't want freeze\nduring the cold nights.",
      options =
      {
        {description = "不改变", data = "nope", hover = "没有变化."},
        {description = "增强 50%!", data = "yep12", hover = "现在它多 50% 的使用次数 (8->12)."},
        {description = "永久!", data = "infin", hover = "现在它不会损坏，像经典单机版中一样。"},
      },

    },
    {
      name = "rule_fulight",
      label = "薇洛的打火机",
      hover = "现在你可以使打火机更有用，更方便。",
      options =
      {
        {description = "不改变", data = "nope", hover = "嘿?"},
        {description = "改变!", data = "yep", hover = "现在每个人都可以在上面做饭，\n并可以用蝴蝶翅膀加油。"},
      },

    },
    {
      name = "rule_cutestla",
      label = "可爱的熔岩虫",
      hover = "也许这个小型的熔岩要学会礼貌\n并且成为有史以来最可爱的幼虫？^-^'",
      options =
      {
        {description = "不改变", data = "nope", hover = "如果你做改变，熔岩虫会烧伤你的小屋。"},
        {description = "改变!", data = "yep", hover = "它停止点着一切东西，并将学习生命恢复。"},
      },

    },
    {
      name = "rule_abigail",
      label = "阿比盖尔的鬼魂",
      hover = "让她升级。",
      options =
      {
        {description = "不改变", data = "nope", hover = "她已经够好了吗？"},
        {description = "改变!", data = "yep", hover = "她会增多 +50% 的伤害，也有稍微多的生命。"},
      },

    },
    --[[{
    name = "rule_library",
    label = "Thick Books",
    hover = "Add more pages for\nWickerbotoom's library.",
    options =
    {
      {description = "不", data = "nope", hover = "大笑, 没有为你准备的文本。"},
      {description = "改变!", data = "yep", hover = "书籍的使用次数会增加两倍。"},
    },

  },]]
  {
    name = "rule_tooth",
    label = "狗牙陷阱",
    hover = "增加了自动重设，但也使制作更加困难。",
    options =
    {
      {description = "不改变", data = "nope", hover = "制作需要 1 个狗牙。\n无自动重设。"},
      {description = "轻微改变!", data = "yep3", hover = "制作需要 3 个狗牙。\n40 秒后自动重设。"},
      {description = "大幅改变!", data = "yep5", hover = "制作需要 5 个狗牙。\n20 秒后自动重设。"},
    },

  },
  {
    name = "rule_turret",
    label = "恒迪尤斯·舒提尤斯",
    hover = "在联机版，你只能建造一个，不公平！但我们可以解决它。",
    options =
    {
      {description = "不改变", data = "nope", hover = "满足整个世界只有 1 个弱的恒迪尤斯？"},
      {description = "改变!", data = "yep", hover = "恒迪尤斯将 3 倍的强大和结实."},
    },

  },
  {
    name = "rule_novel",
    label = ":-:-:-:-:-:-:-:-:-:-:-:-:-:-:-",
    hover = "",
    options =
    {
      {description = "3. 新事物!", data = "nope", hover = "这些选项带来了一些新的特性，这是原游戏没有的。"},
    },

  },
  {
    name = "rule_mandra",
    label = "曼德拉草",
    hover = "听说树精守卫有些曼德拉草？",
    options =
    {
      {description = "不改变", data = "false", hover = "呃呃呃.. 它可能只是看起来像？"},
      {description = "改变!", data = "true", hover = "是的!树精守卫有曼德拉草！也许它们是朋友？"},
    },

  },
  {
    name = "rule_graves",
    label = "盗墓",
    hover = "准备好你的铲子，盗墓贼!",
    options =
    {
      {description = "不改变", data = "nope", hover = "让我们打开吧。"},
      {description = "改变!", data = "yep", hover = "在满月之夜，所有的坟墓都会有新的宝藏生成。"},
    },

  },
  {
    name = "rule_birdey",
    label = "羽毛农场",
    hover = "是时候种些羽毛了！",
    options =
    {
      {description = "不改变", data = "nope", hover = "与新的统治测试版有兼容性问题。\n此选项当前不可用。"}, --"你喜欢杀了它们再取出来吗？"},
      --{description = "改变!", data = "yep", hover = "笼子里的鸟有时会掉他们的羽毛。"},
    },

  },
  {
    name = "rule_petsta",
    label = "一群活物",
    hover = "如果地鼠，蠕虫，兔子，鸟和格罗姆翅膀\n占据了很大的空间,\n会把他们挤着放在一起。",
    options =
    {
      {description = "不改变", data = "nope", hover = "不要害怕，会好的。"},
      {description = "改变!", data = "yep10", hover = "现在，他们可以一组 10 个的合在一起。"},
    },

  },
  {
    name = "rule_homeli",
    label = "寻常",
    hover = "当他们在家的时候，\n他们的心情会很好。",
    options =
    {
      {description = "不改变", data = "nope", hover = "安心 - 还有什么会更好吗？"},
      {description = "改变!", data = "yep", hover = "你会在地毯或木/棋盘地板上时\n安心、干燥、冬暖且夏凉。"},
    },

  },
  {
    name = "rule_dresir",
    label = "特殊修理",
    hover = "修复之前不能修复的！",
    options =
    {
      {description = "不改变", data = "nope", hover = "方便、高效。\n不要放弃！"},
      {description = "改变!", data = "yep", hover = "独奏乐器 -> 缝纫工具包,\n蜘蛛帽 -> 蜘蛛腺体,\n花环 -> 花瓣."},
    },

  },
  {
    name = "rule_skill",
    label = ":-:-:-:-:-:-:-:-:-:-:-:-:-:-:-",
    hover = "",
    options =
    {
      {description = "4. 技能!", data = "nope", hover = "这里的选项简化了与世界的互动。"},
    },

  },
  {
    name = "rule_bee",
    label = "职业养蜂人",
    hover = "与这些昆虫在一起的几个月过去了。\n新阶段到了。",
    options =
    {
      {description = "不改变", data = "nope", hover = "当你拿蜜蜂的蜂蜜时，\n它们可能不是很开心。"},
      {description = "学习!", data = "yep", hover = "蜜蜂信任养蜂人。\n养蜂人的帽子免疫刺痛。"},
    },

  },
  {
    name = "rule_trap",
    label = "猎人大师",
    hover = "成为一个专业陷阱猎人。",
    options =
    {
      {description = "不改变", data = "nope", hover = "没有足够的技巧吗？"},
      {description = "学习!", data = "yep", hover = "在不捡起陷阱的情况下查看猎物。\n像上帝一样接住回旋镖。"},
    },

  },
  {
    name = "rule_chef",
    label = "冷火厨师",
    hover = "在那蓝色的火焰上烹饪。",
    options =
    {
      {description = "不改变", data = "nope", hover = "吸热篝火 - 用于烹饪？\n哦，垃圾！"},
      {description = "学习!", data = "yep", hover = "你可以在冷火上面做零食。"},
    },

  },
  {
    name = "rule_razor",
    label = "王牌理发师",
    hover = "剃须漂亮整洁。",
    options =
    {
      {description = "不改变", data = "nope", hover = "用剃刀剃须一定很危险。"},
      {description = "学习!", data = "yep", hover = "现在你是剃刀专家。\n只刮这个阶段的头发。"},
    },

  },
  {
    name = "rule_plmult",
    label = "伟大的农民",
    hover = "使你无用的农场更有用和有效！",
    options =
    {
      {description = "不改变", data = "nope", hover = "你喜欢在这堆肥料中熬几个小时吗？"},
      {description = "学习!", data = "yep", hover = "生产力提高3倍！\n美味的蔬菜，呵呵。"},
    },

  },
  {
    name = "rule_recipe",
    label = ":-:-:-:-:-:-:-:-:-:-:-:-:-:-:-",
    hover = "",
    options =
    {
      {description = "5. 配方!", data = "nope", hover = "添加新的配方，\n甚至是以前不存在的对象。"},
    },

  },
  {
    name = "rule_truefriend",
    label = "团结吊坠",
    hover = "可以订立你和牛之间牢不可破的契约。",
    options =
    {
      {description = "不改变", data = "nope", hover = "这将给你的牛第二次生命。\n 不要...放弃。"},
      {description = "启用", data = "yep", hover = "阴影操纵器, 魔法栏:\n6 月之石, 2 黄宝石, 1 羽毛帽."}, --1 радужник 1 iridescent gem
    },

  },
  {
    name = "rule_craftjuicy",
    label = "多汁浆果丛",
    hover = "随意的嘲笑你? 种植你自己的多汁浆果丛！",
    options =
    {
      {description = "关闭", data = "nope", hover = "我不想制作非天然灌木。"},
      {description = "启用", data = "yep", hover = "暗影操纵仪, 食物栏:\n1 简单浆果丛, 1 便便篮, 3 噩梦燃料."},
    },

  },
  {
    name = "rule_craftfern",
    label = "盆栽的蕨类植物",
    hover = "太难收集5个树叶？\n改变配方吧！",
    options =
    {
      {description = "关闭", data = "nope", hover = "默认:\n5 树叶, 1 破碎的背壳."},
      {description = "启用", data = "yep", hover = "增强:\n1 树叶, 1 格罗姆的粘液, 2 破碎的背壳."},
    },

  },
  {
    name = "rule_craftfur",
    label = "厚皮毛",
    hover = "这将需要三倍的毛簇..\n却只能制作 1 厚皮毛.",
    options =
    {
      {description = "关闭", data = "nope", hover = "默认:\n 90 毛簇 = 3 厚皮毛."},
      {description = "启用", data = "yep", hover = "增强:\n 30 毛簇 = 1 厚皮毛."},
    },
  },
  {
    name = "rule_craftkrampus",
    label = "坎普斯背包",
    hover = "真的很复杂的配方！\n真的不幸的人！",
    options =
    {
      {description = "关闭", data = "nope", hover = "不, 谢谢. \n我最好还是杀坎普斯爆吧！"},
      {description = "启用", data = "yep", hover = "远古遗迹, 生存栏:\n9 格罗姆的翅膀, 96 蜘蛛网, 69 噩梦燃料."},
    },

  },
  {
    name = "rule_anything",
    label = ":-:-:-:-:-:-:-:-:-:-:-:-:-:-:-",
    hover = "",
    options =
    {
      {description = "┗(＾0＾)┓", data = "0"}
    },

  },
  {
    name = "rule_other",
    label = "其他改变",
    hover = "这些变化不能被禁用。 抱歉.\n不能选择什么东西，它只是一个文本。",
    options =
    {
      {description = "点击", data = "0", hover = "点击这里 ->"},
      --{description = "Disease", data = "1", hover = "While the disease mechanics does not work\nproperly, so this mode disables it."}, Deleted in 070
      --{description = "Bedrolls", data = "2", hover = "Now a straw roll does not stack but have\ndurability and restores health."}, Moved to main rules in 081
      --{description = "Lighter", data = "3", hover = "Now everybody can cook on it (like a Willow),\nand can refuel it with petals or butterfly wings."}, Moved to main rules in 091
      --{description = "Orchestra", data = "4", hover = "'One-man Band' now can be\nrepaired with sewing kit."}, Moved to main rules in 097
      --{description = "Vegans!", data = "5", hover = "Teen- and Tallbirds no more eating\nmeat, only seeds, only hardcore!"}, Deleted in 096
      --{description = "Red Amulet", data = "6", hover = "Changed the heal mechanics\nof Life Giving Amulet."}, Moved to main rules in 081
      --{description = "Morning Star", data = "7", hover = "'Morning Star' weapon now refuelable with nitre\nand deals more damage if 'weapon balance' is ON."}, Moved to main rules in 090
      --{description = "Telebase", data = "8", hover = "Purple Gems on the Telelocator Focus towers\nno longer destroys after teleportation."}, Moved to main rules in 080
      --{description = "Stackable", data = "9", hover = "Rabbits, moleworms, birds, glommer wings\n now little stackable."}, Moved to main rules in 080
      --{description = "Lighting", data = "10", hover = "Rebalanced all mobile\nlight sources."}, Moved to main rules in 091
      {description = "无!", data = "11", hover = "您当前的版本没有强制启用的选项！ :)"},
    },

  },
  {
    name = "rule_author",
    label = "你希望的改变",
    hover = "向作者发送你的愿望和要求。",
    options =
    {
      {description = "链接", data = "any", hover = "tykvesh@gmail.com"},
    },

  },

}
)
