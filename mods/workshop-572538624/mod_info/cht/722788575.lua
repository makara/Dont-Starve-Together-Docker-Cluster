_G.ChinesePlus.SetConfigTranslation(mod_to_c,
  "建立你自己的規則！\n改變你想改變的一切！",
  {

  },
  {
    {
      name = "rule_balance",
      label = ":-:-:-:-:-:-:-:-:-:-:-:-:-:-:-",
      hover = "",
      options =
      {
        {description = "1. 平衡性!", data = "nope", hover = "這個類別中的選項對遊戲有整體影響。"},
      },

    },
    {
      name = "rule_armor",
      label = "護甲耐久",
      hover = "聯機版中生物的生命值增加了很多，但是我們的護甲沒有變化。",
      options =
      {
        --{description = "上帝模式！", data = "cheaty", hover = "完全無懈可擊的護甲。"},
        {description = "永恆！", data = "cheat", hover = "無限的護甲"},
        {description = "不改變", data = "nope", hover = "含糊蟲有 1,200 的血量.\n你確定?"},
        {description = "增強 50%!", data = "50", hover = "護甲更強大\n增強 +50% (1.5 倍)."},
        {description = "增強 100%!", data = "100", hover = "現在護甲與生物平衡了。好多了。"},
      },

    },
    {
      name = "rule_fight",
      label = "武器",
      hover = "改變回旋鏢、暗夜劍、銩礦棒和鎬斧的傷害。",
      options =
      {
        {description = "不改變", data = "nope", hover = "標準武器已經滿意了嗎？"},
        {description = "改變", data = "yep", hover = "將平衡這些武器。"},
      },

    },
    {
      name = "rule_tool",
      label = "工具",
      hover = "平衡 17% 的工具。",
      options =
      {
        {description = "不改變", data = "nope", hover = "標準工具已經滿意了嗎？"},
        {description = "改變", data = "yep", hover = "將平衡這些工具。"},
      },

    },
    {
      name = "rule_magic",
      label = "魔法",
      hover = "重新平衡遊戲中的所有魔法。",
      options =
      {
        {description = "限制", data = "block", hover = "魔法欄的東西將被封印。"},
        {description = "不改變", data = "nope", hover = "已經足夠了。 666"},
        {description = "改變", data = "yep", hover = "將平衡魔法。"},
      },

    },
    {
      name = "rule_dress",
      label = "衣物",
      hover = "改變所有衣物的耐久?",
      options =
      {
        {description = "不改變", data = "nope", hover = "'衣物很好，我不想改變。'"},
        {description = "改變", data = "yep", hover = "耶! 新的 2016 範兒!"},
      },

    },
    {
      name = "rule_spdpen",
      label = "速度衰減",
      hover = "可以讓自己關掉大理石盔甲、小豬揹包和冰塊帽的速度懲罰。",
      options =
      {
        {description = "鐵桿!", data = "hard", hover = "2 倍的速度懲罰.\n*除了大理石盔甲*"},
        {description = "不改變", data = "nope", hover = "噢，得了吧！"},
        {description = "50%!", data = "half", hover = "一半的速度懲罰。"},
        {description = "移除!", data = "remove", hover = "沒有什麼會阻礙你優雅的行走了。"},
      },

    },
    {
      name = "rule_pets",
      label = "寵物生命",
      hover = "給你的寵物更多的生命值並且增加輕微的自動恢復。",
      options =
      {
        {description = "不改變", data = "nope", hover = "你對幾乎死去的寵物滿意嗎？！"},
        {description = "改變!", data = "yep", hover = "切斯特, 哈奇, 格羅姆, 高鳥 和 大象 更加強壯了。"},
      },

    },
    {
      name = "rule_boost",
      label = ":-:-:-:-:-:-:-:-:-:-:-:-:-:-:-",
      hover = "",
      options =
      {
        {description = "2. 強化!", data = "nope", hover = "這一類別中的選項改進了遊戲的某部分。"},
      },

    },
    {
      name = "rule_saddle",
      label = "牛的忠誠",
      hover = "Feel free to include, if they\nseem too weak for you.",
      options =
      {
        {description = "不改變", data = "nope", hover = "開啟這個。 就現在!"},
        {description = "輕微改變!", data = "yep", hover = "現在它們會更好，更快、更強。"},
        {description = "大幅改變!", data = "yeppie", hover = "現在他們會非常好、非常快、非常強。"},
      },

    },
    {
      name = "rule_salve",
      label = "現代醫學",
      hover = "治療藥膏和繃帶的製作太貴了嗎？",
      options =
      {
        {description = "不改變", data = "nope", hover = "不."},
        {description = "改變!", data = "yep", hover = "現在你可以在製作治療物品得到 2 個，而不是 1 個。"},
        {description = "極大!", data = "both", hover = "現在你可以在製作治療物品得到 2 個，而不是 1 個。\nAGV 試驗藥完全移除所有懲罰。"},

      },

    },
    {
      name = "rule_dart",
      label = "吹箭",
      hover = "花了太多的血汗，只有 1 個？",
      options =
      {
        --{description = "OnlyBeta:4", data = "b4", hover = "ONLY WORKS FOR BETA!!!\nNow you can craft 4 (FOUR)\ndarts instead of 1."},
        --{description = "OnlyBeta:2", data = "b2", hover = "ONLY WORKS FOR BETA!!!\nNow you can craft 2 (TWO)\ndarts instead of 1."},
        {description = "限制!", data = "0", hover = "不允許製造吹箭"},
        {description = "不改變", data = "1", hover = "不，它很好。"},
        {description = "輕微改變!", data = "2", hover = "現在你可以製作吹箭時獲得 2 個。"},
        {description = "大幅改變!", data = "4", hover = "現在你可以製作吹箭時獲得 4 個。"},
      },

    },
    {
      name = "rule_tent",
      label = "帳篷質量",
      hover = "如果你對在愚蠢的帳篷和簡易小木棚一遍又一遍的睡覺厭煩了。",
      options =
      {
        {description = "不改變", data = "nope", hover = "讓他們土崩瓦解"},
        {description = "永久!", data = "yep", hover = "讓他們挺立一個年代，阿門"},
      },

    },
    {
      name = "rule_bedroll",
      label = "睡袋",
      hover = "相信我，你會喜歡它的。",
      options =
      {
        {description = "不改變", data = "nope", hover = "預設睡袋。草做的睡1次、毛做的睡3次。"},
        {description = "改變!", data = "yep", hover = "改進睡袋。草做的睡3次、毛做的睡12次。\n可以被修復。"},
      },

    },
    {
      name = "rule_icebox",
      label = "冰箱功率",
      hover = "想要冰箱更好地減慢腐敗嗎？",
      options =
      {
        --{description = "Rot x4!", data = "4", hover = "Icebox will SPEED UP perishing\nto four times."},
        {description = "不改變", data = "0.5", hover = "'我對預設的永久很滿意了。'"},
        {description = "增強 50%!", data = "0.375", hover = "冰箱將減慢一半腐敗速度（1.5 倍）。"},
        {description = "增強 100%!", data = "0.25", hover = "冰箱將 2 倍的減慢腐敗速度（2 倍）。"},
        {description = "增強 200%!", data = "0.125", hover = "冰箱將 4 倍的減慢腐敗速度（4 倍）。"},
        {description = "永久保鮮!", data = "0", hover = "冰箱裡面的食物將永久保鮮。"},
      },

    },
    {
      name = "rule_lighting",
      label = "新的照明",
      hover = "調整或輕微簡化生存難度。僅影響移動光源。",
      options =
      {
        {description = "昏暗!", data = "dark", hover = "夢魘吞噬寶貴的光。\n光源枯竭快一倍"},
        {description = "不改變", data = "nope", hover = "選擇你的命運."},
        {description = "光亮!", data = "glow", hover = "火炬有更多的燃料。地鼠帽容易充能.."},
      },

    },
    {
      name = "rule_snow",
      label = "雪球發射機",
      hover = "不穩定。將在未來更新。", --"Сделай ИИ снежкомёта лучше." or "Make Flingomatic's AI better.",
      options =
      {
        {description = "不改變", data = "nope", hover = "你不生氣篝火被熄滅？"},
        --{description = "改變!", data = "yep", hover = "不會再向營火扔雪球了。\n投擲範圍增��� 30%。"},
      },

    },
    {
      name = "rule_tele",
      label = "傳送",
      hover = "允許自由進入傳送核心。",
      options =
      {
        {description = "不改變", data = "nope", hover = "有什麼能比每次傳送都要收集寶石更加糟糕？"},
        {description = "改變!", data = "yep", hover = "傳送核心上面的紫色寶石在傳送後不會消失了。"},
      },

    },
    {
      name = "rule_whip",
      label = "三尾貓的教誨",
      hover = "如此昂貴，但沒什麼卵用。我們可以解決它。",
      options =
      {
        {description = "不改變", data = "nope", hover = "預設傷害 (28)\n使用次數 (175)."},
        {description = "改變!", data = "yep", hover = "現在它的傷害像觸手尖刺 (51)\n更多的使用次數 (300)."},
      },

    },
    {
      name = "rule_mrstar",
      label = "晨星",
      hover = "把這個發光的魔杖變成粉碎所有生物的權杖。",
      options =
      {
        {description = "便宜貨..", data = "tran", hover = "預設傷害（43 ~ 72）。\n可以被便宜貨修復（+50%）。"},
        {description = "不改變", data = "nope", hover = "預設傷害（43 ~ 72）。"},
        {description = "硝石!", data = "nit0", hover = "預設傷害（43 ~ 72）。.\n可以被硝石修復（+50%）。"},
        {description = "改變!", data = "nit1", hover = "增加傷害（51 ~ 85）。\n可以被硝石修復（+50%）。"}, --RUS: и прочность (6 минут) \\ ENG: and durability (6 minutes)
      },

    },
    {
      name = "rule_oneman",
      label = "獨奏樂器",
      hover = "使這坨屎..哦，我的意思是儀器，的更方便有用！",
      options =
      {
        {description = "不改變", data = "nope", hover = "它的耐久損耗快的就像我的童年。"},
        {description = "改變!", data = "yep", hover = "更耐用，而且現在能夠用噩夢燃料修復它。"},
      },
    },

    {
      name = "rule_redamul",
      label = "紅色護身符",
      hover = "是時候讓它真正可以賦予人生命",
      options =
      {
        {description = "不改變", data = "nope", hover = "預設治療: 每 30 秒 +5 生命， -5 飢餓。"},
        {description = "改變!", data = "yep", hover = "增強治療: 每 20 秒 +15 生命， -5 飢餓。"},
      },

    },
    {
      name = "rule_magilum",
      label = "魔力之光",
      hover = "犧牲一個得到第二個。",
      options =
      {
        {description = "不改變", data = "nope", hover = "有20%的速度加成，\n但可笑的是光的範圍。"},
        {description = "改變!", data = "yep", hover = "大發光半徑，\n但沒有速度加成。"},
      },
    },
    {
      name = "rule_htrock",
      label = "保暖石",
      hover = "對於那些不想在寒冷的夜晚挨凍的人。無限耐久意味著永遠100%。", --"Посвящается любителям не мёрзнуть\nхолодными ночами." or "For people who don't want freeze\nduring the cold nights.",
      options =
      {
        {description = "不改變", data = "nope", hover = "沒有變化."},
        {description = "增強 50%!", data = "yep12", hover = "現在它多 50% 的使用次數 (8->12)."},
        {description = "永久!", data = "infin", hover = "現在它不會損壞，像經典單機版中一樣。"},
      },

    },
    {
      name = "rule_fulight",
      label = "薇洛的打火機",
      hover = "現在你可以使打火機更有用，更方便。",
      options =
      {
        {description = "不改變", data = "nope", hover = "嘿?"},
        {description = "改變!", data = "yep", hover = "現在每個人都可以在上面做飯，\n並可以用蝴蝶翅膀加油。"},
      },

    },
    {
      name = "rule_cutestla",
      label = "可愛的熔岩蟲",
      hover = "也許這個小型的熔岩要學會禮貌\n並且成為有史以來最可愛的幼蟲？^-^'",
      options =
      {
        {description = "不改變", data = "nope", hover = "如果你做改變，熔岩蟲會燒傷你的小屋。"},
        {description = "改變!", data = "yep", hover = "它停止點著一切東西，並將學習生命恢復。"},
      },

    },
    {
      name = "rule_abigail",
      label = "阿比蓋爾的鬼魂",
      hover = "讓她升級。",
      options =
      {
        {description = "不改變", data = "nope", hover = "她已經夠好了嗎？"},
        {description = "改變!", data = "yep", hover = "她會增多 +50% 的傷害，也有稍微多的生命。"},
      },

    },
    --[[{
    name = "rule_library",
    label = "Thick Books",
    hover = "Add more pages for\nWickerbotoom's library.",
    options =
    {
      {description = "不", data = "nope", hover = "大笑, 沒有為你準備的文字。"},
      {description = "改變!", data = "yep", hover = "書籍的使用次數會增加兩倍。"},
    },

  },]]
  {
    name = "rule_tooth",
    label = "狗牙陷阱",
    hover = "增加了自動重設，但也使製作更加困難。",
    options =
    {
      {description = "不改變", data = "nope", hover = "製作需要 1 個狗牙。\n無自動重設。"},
      {description = "輕微改變!", data = "yep3", hover = "製作需要 3 個狗牙。\n40 秒後自動重設。"},
      {description = "大幅改變!", data = "yep5", hover = "製作需要 5 個狗牙。\n20 秒後自動重設。"},
    },

  },
  {
    name = "rule_turret",
    label = "恆迪尤斯·舒提尤斯",
    hover = "在聯機版，你只能建造一個，不公平！但我們可以解決它。",
    options =
    {
      {description = "不改變", data = "nope", hover = "滿足整個世界只有 1 個弱的恆迪尤斯？"},
      {description = "改變!", data = "yep", hover = "恆迪尤斯將 3 倍的強大和結實."},
    },

  },
  {
    name = "rule_novel",
    label = ":-:-:-:-:-:-:-:-:-:-:-:-:-:-:-",
    hover = "",
    options =
    {
      {description = "3. 新事物!", data = "nope", hover = "這些選項帶來了一些新的特性，這是原遊戲沒有的。"},
    },

  },
  {
    name = "rule_mandra",
    label = "曼德拉草",
    hover = "聽說樹精守衛有些曼德拉草？",
    options =
    {
      {description = "不改變", data = "false", hover = "呃呃呃.. 它可能只是看起來像？"},
      {description = "改變!", data = "true", hover = "是的!樹精守衛有曼德拉草！也許它們是朋友？"},
    },

  },
  {
    name = "rule_graves",
    label = "盜墓",
    hover = "準備好你的鏟子，盜墓賊!",
    options =
    {
      {description = "不改變", data = "nope", hover = "讓我們開啟吧。"},
      {description = "改變!", data = "yep", hover = "在滿月之夜，所有的墳墓都會有新的寶藏生成。"},
    },

  },
  {
    name = "rule_birdey",
    label = "羽毛農場",
    hover = "是時候種些羽毛了！",
    options =
    {
      {description = "不改變", data = "nope", hover = "與新的統治測試版有相容性問題。\n此選項當前不可用。"}, --"你喜歡殺了它們再取出來嗎？"},
      --{description = "改變!", data = "yep", hover = "籠子裡的鳥有時會掉他們的羽毛。"},
    },

  },
  {
    name = "rule_petsta",
    label = "一群活物",
    hover = "如果地鼠，蠕蟲，兔子，鳥和格羅姆翅膀\n佔據了很大的空間,\n會把他們擠著放在一起。",
    options =
    {
      {description = "不改變", data = "nope", hover = "不要害怕，會好的。"},
      {description = "改變!", data = "yep10", hover = "現在，他們可以一組 10 個的合在一起。"},
    },

  },
  {
    name = "rule_homeli",
    label = "尋常",
    hover = "當他們在家的時候，\n他們的心情會很好。",
    options =
    {
      {description = "不改變", data = "nope", hover = "安心 - 還有什麼會更好嗎？"},
      {description = "改變!", data = "yep", hover = "你會在地毯或木/棋盤地板上時\n安心、乾燥、冬暖且夏涼。"},
    },

  },
  {
    name = "rule_dresir",
    label = "特殊修理",
    hover = "修復之前不能修復的！",
    options =
    {
      {description = "不改變", data = "nope", hover = "方便、高效。\n不要放棄！"},
      {description = "改變!", data = "yep", hover = "獨奏樂器 -> 縫紉工具包,\n蜘蛛帽 -> 蜘蛛腺體,\n花環 -> 花瓣."},
    },

  },
  {
    name = "rule_skill",
    label = ":-:-:-:-:-:-:-:-:-:-:-:-:-:-:-",
    hover = "",
    options =
    {
      {description = "4. 技能!", data = "nope", hover = "這裡的選項簡化了與世界的互動。"},
    },

  },
  {
    name = "rule_bee",
    label = "職業養蜂人",
    hover = "與這些昆蟲在一起的幾個月過去了。\n新階段到了。",
    options =
    {
      {description = "不改變", data = "nope", hover = "當你拿蜜蜂的蜂蜜時，\n它們可能不是很開心。"},
      {description = "學習!", data = "yep", hover = "蜜蜂信任養蜂人。\n養蜂人的帽子免疫刺痛。"},
    },

  },
  {
    name = "rule_trap",
    label = "獵人大師",
    hover = "成為一個專業陷阱獵人。",
    options =
    {
      {description = "不改變", data = "nope", hover = "沒有足夠的技巧嗎？"},
      {description = "學習!", data = "yep", hover = "在不撿起陷阱的情況下檢視獵物。\n像上帝一樣接住迴旋鏢。"},
    },

  },
  {
    name = "rule_chef",
    label = "冷火廚師",
    hover = "在那藍色的火焰上烹飪。",
    options =
    {
      {description = "不改變", data = "nope", hover = "吸熱篝火 - 用於烹飪？\n哦，垃圾！"},
      {description = "學習!", data = "yep", hover = "你可以在冷火上面做零食。"},
    },

  },
  {
    name = "rule_razor",
    label = "王牌理髮師",
    hover = "剃鬚漂亮整潔。",
    options =
    {
      {description = "不改變", data = "nope", hover = "用剃刀剃鬚一定很危險。"},
      {description = "學習!", data = "yep", hover = "現在你是剃刀專家。\n只刮這個階段的頭髮。"},
    },

  },
  {
    name = "rule_plmult",
    label = "偉大的農民",
    hover = "使你無用的農場更有用和有效！",
    options =
    {
      {description = "不改變", data = "nope", hover = "你喜歡在這堆肥料中熬幾個小時嗎？"},
      {description = "學習!", data = "yep", hover = "生產力提高3倍！\n美味的蔬菜，呵呵。"},
    },

  },
  {
    name = "rule_recipe",
    label = ":-:-:-:-:-:-:-:-:-:-:-:-:-:-:-",
    hover = "",
    options =
    {
      {description = "5. 配方!", data = "nope", hover = "新增新的配方，\n甚至是以前不存在的物件。"},
    },

  },
  {
    name = "rule_truefriend",
    label = "團結吊墜",
    hover = "可以訂立你和牛之間牢不可破的契約。",
    options =
    {
      {description = "不改變", data = "nope", hover = "這將給你的牛第二次生命。\n 不要...放棄。"},
      {description = "啟用", data = "yep", hover = "陰影操縱器, 魔法欄:\n6 月之石, 2 黃寶石, 1 羽毛帽."}, --1 радужник 1 iridescent gem
    },

  },
  {
    name = "rule_craftjuicy",
    label = "多汁漿果叢",
    hover = "隨意的嘲笑你? 種植你自己的多汁漿果叢！",
    options =
    {
      {description = "關閉", data = "nope", hover = "我不想製作非天然灌木。"},
      {description = "啟用", data = "yep", hover = "暗影操縱儀, 食物欄:\n1 簡單漿果叢, 1 便便籃, 3 噩夢燃料."},
    },

  },
  {
    name = "rule_craftfern",
    label = "盆栽的蕨類植物",
    hover = "太難收集5個樹葉？\n改變配方吧！",
    options =
    {
      {description = "關閉", data = "nope", hover = "預設:\n5 樹葉, 1 破碎的背殼."},
      {description = "啟用", data = "yep", hover = "增強:\n1 樹葉, 1 格羅姆的粘液, 2 破碎的背殼."},
    },

  },
  {
    name = "rule_craftfur",
    label = "厚皮毛",
    hover = "這將需要三倍的毛簇..\n卻只能製作 1 厚皮毛.",
    options =
    {
      {description = "關閉", data = "nope", hover = "預設:\n 90 毛簇 = 3 厚皮毛."},
      {description = "啟用", data = "yep", hover = "增強:\n 30 毛簇 = 1 厚皮毛."},
    },
  },
  {
    name = "rule_craftkrampus",
    label = "坎普斯揹包",
    hover = "真的很複雜的配方！\n真的不幸的人！",
    options =
    {
      {description = "關閉", data = "nope", hover = "不, 謝謝. \n我最好還是殺坎普斯爆吧！"},
      {description = "啟用", data = "yep", hover = "遠古遺蹟, 生存欄:\n9 格羅姆的翅膀, 96 蜘蛛網, 69 噩夢燃料."},
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
    label = "其他改變",
    hover = "這些變化不能被禁用。 抱歉.\n不能選擇什麼東西，它只是一個文字。",
    options =
    {
      {description = "點選", data = "0", hover = "點選這裡 ->"},
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
      {description = "無!", data = "11", hover = "您當前的版本沒有強制啟用的選項！ :)"},
    },

  },
  {
    name = "rule_author",
    label = "你希望的改變",
    hover = "向作者傳送你的願望和要求。",
    options =
    {
      {description = "連結", data = "any", hover = "tykvesh@gmail.com"},
    },

  },

}
)
