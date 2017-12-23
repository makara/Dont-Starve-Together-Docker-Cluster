_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"專注於為遊戲帶來更多的遠端武器。 \n現在完全支援控制器！ \n結合藥劑師 mod 增加一個提高你射擊效率的藥物！",
	{
		["150 (spear)"] = "150 (長矛)",
		["Inf."] = "無限",
		["10 (blowdartt)"] = "10 (吹箭)",
		["yes"] = "是",
		["no"] = "否",
		["Disabled"] = "禁用",
		["None"] = "無",
		["Sc. Mach."] = "科技一本",
		["Alch. Eng."] = "科技二本",
		["same"] = "相同",
		["Prestihat."] = "魔法一本",
		["Sh. Manip."] = "魔法二本",
		["30 (~spear damage)"] = "30(長矛傷害)",
		["Log"] = "木頭",
		["Twigs"] = "樹枝",
		["Reeds"] = "蘆葦",
		["Flint"] = "燧石",
		["Stinger"] = "蜂針",
		["Tooth"] = "狗牙",
		["Charcoal"] = "木炭",
		["Ice"] = "冰",
		["Blue Gem"] = "藍寶石",
		["Volt Goat Horn"] = "電羊角",
		["Elec. Doodad"] = "電器元件",
		["Gun Powd."] = "火藥",
		["Red Gem"] = "紅寶石",
		["Hammer damage"] = "錘子的傷害",
		["A bit less than the Axe"] = "比斧頭少一點",
		["Axe damage"] = "斧頭的傷害",
		["A bit less than the Spear"] = "比長矛少一點",
		["Spear damage"] = "長矛的傷害",
		["A bit more than the spear"] = "比長矛多一點",
		["Batbat damage"] = "蝙蝠斧棍的傷害",
		["Slightly more than the Batbat"] = "略多於蝙蝠斧棍",
		["Intermediate between Batbat and Ruinbat"] = "蝙蝠斧棍和銩礦棒之間的中間",
		["Slightly less than Ruinbat"] = "略低於銩礦棒",
		["Hambat/Ruinbat damage"] = "銩礦棒/火腿球棒的傷害",
		["Slightly more than the Ruinbat"] = "略多於銩礦棒",
		["are you serious?"] = "你是認真的嗎？",
		["are you serious?!"] = "你是認真的嗎？！",
		["are you serious?!!"] = "你是認真的嗎？！！",
		["use c_godmode() instead"] = "不如去開上帝模式吧！",
	},
	{
		{
			name = "BowUses",
			label = "木弓使用次數",
			hover = "使用多少次後損毀？",
		},

		{
			name = "BowDmg",
			label = "木弓的傷害",
			hover = "弓傷害是數值？",
		},

		{
			name = "BowRange",
			label = "木弓的範圍",
			hover = "木弓射擊的範圍",
		},

		{
			name = "BowMissChanceSmall",
			label = "小目標脫靶",
			hover = "可能在射擊小目標時脫靶",
		},

		{
			name = "BowMissChanceBig",
			label = "大目標脫靶",
			hover = "可能在射擊大目標時脫靶",
		},

		{
			name = "HitChanceBugs",
			label = "微小目標脫靶",
			hover = "射擊蝴蝶和蜜蜂時的脫靶",
			options =
			{
				{description = "否", data = false, hover= "不減少對蜜蜂和蝴蝶的命中"},
				{description = "是", data = true, hover= "減少對蜜蜂和蝴蝶的命中到 1%"},
			},
		},

		{
			name = "HitChanceTakeOff",
			label = "鳥的脫靶",
			hover = "射擊鳥時的脫靶",
			options =
			{
				{description = "否", data = false, hover= "不減少對鳥的命中"},
				{description = "是", data = true, hover= "減少對鳥的命中到 1%"},
			},
		},

		{
			name = "ActivateCollisions",
			label = "啟用碰撞",
			hover = "你的箭/箭桿會被障礙物阻止（牆壁，樹木，等等）。",
		},

		{
			name = "ArrowHitRecovery",
			label = "命中回收",
			hover = "成功射擊命中後收回箭的機率",
		},

		{
			name = "ArrowMissRecovery",
			label = "脫靶回收",
			hover = "脫靶後收回箭的機率",
		},

		{
			name = "CritPvE",
			label = "致命一擊 % 怪物",
			hover = "對生物出現致命一擊的機率",
		},

		{
			name = "CritDmgModPvE",
			label = "怪物致命傷害",
			hover = "對生物致命一擊的傷害",
		},

		{
			name = "CritPvP",
			label = "致命一擊 % 玩家",
			hover = "對玩家出現致命一擊的機率",
		},

		{
			name = "CritDmgModPvP",
			label = "玩家致命傷害",
			hover = "對玩家致命一擊的傷害",
		},

		{
			name = "AccuracyDrugEffect",
			label = "維生素R效果",
			hover = "維生素R影響射擊精度和彈藥恢復的機會（要求藥劑師 medicamento MOD）",
			options =
			{
				{description = "小", data = "small", hover = "30% 的脫靶機率，增加 15% 彈藥的恢復"},
				{description = "中", data = "medium", hover = "60% 的脫靶機率，增加 35% 彈藥的恢復"},
				{description = "大", data = "strong", hover = "85% 的脫靶機率，增加 60% 彈藥的恢復"},
				{description = "羅賓漢", data = "robinhood", hover = "你永遠不會脫靶，總是恢復彈藥。騙子!"},
			},
		},

		{
			name = "BowTwigs_req",
			label = "木弓配方-樹枝",
			hover = "製造弓所需樹枝的數量",
		},

		{
			name = "BowSilk_req",
			label = "木弓配方-蛛網",
			hover = "製造弓所需蛛網的數量",
		},

		{
			name = "BowTechLevel",
			label = "木弓-科技",
			hover = "製造弓所需科技",
		},

		{
			name = "CrossbowDmgMod",
			label = "弩-傷害",
			hover = "弩對比普通弓箭的傷害",
		},

		{
			name = "CrossbowRangeMod",
			label = "弩-範圍",
			hover = "弩對比普通弓箭的範圍",
		},

		{
			name = "CrossbowAccMod",
			label = "弩-準度",
			hover = "弩對比普通弓箭的準度",
		},

		{
			name = "CrossbowBoards_req",
			label = "弩配方-木板",
			hover = "製造弩所需木板的數量",
		},

		{
			name = "CrossbowSilk_req",
			label = "弩配方-蛛網",
			hover = "製造弩所需蛛網的數量",
		},

		{
			name = "CrossbowHammer_req",
			label = "弩配方-錘子",
			hover = "製造弩所需錘子的數量",
		},

		{
			name = "CrossbowTechLevel",
			label = "弩-科技",
			hover = "製造弩所需科技",
		},

		{
			name = "MagicBowDmgMod",
			label = "魔法弓-傷害",
			hover = "魔法弓對比普通弓箭的傷害",
		},

		{
			name = "MagicBowLivingLog_req",
			label = "魔法弓配方-活木",
			hover = "製造魔法弓所需活木的數量",
		},

		{
			name = "MagicBowPurpleGem_req",
			label = "魔法弓配方-紫寶石",
			hover = "製造魔法弓所需紫寶石的數量",
		},

		{
			name = "MagicBowGlommerFlower_req",
			label = "魔法弓配方-格羅姆的花",
			hover = "製造魔法弓所需格羅姆的花的數量",
		},

		{
			name = "MagicBowTechLevel",
			label = "魔法弓-科技",
			hover = "製造魔法弓所需科技",
		},

		{
			name = "QuiverPigskin_req",
			label = "箭筒配方-豬皮",
			hover = "製造箭筒所需豬皮的數量",
		},

		{
			name = "QuiverRope_req",
			label = "箭筒配方-繩子",
			hover = "製造魔法弓所需繩子的數量",
		},

		{
			name = "QuiverTechLevel",
			label = "箭筒-科技",
			hover = "製造箭筒所需科技",
		},

		{
			name = "MusketDmgMod",
			label = "滑膛槍-傷害",
			hover = "滑膛槍對比普通弓箭的傷害",
		},

		{
			name = "MusketRangeMod",
			label = "滑膛槍-範圍",
			hover = "滑膛槍對比普通弓箭的範圍",
		},

		{
			name = "MusketAccMod",
			label = "滑膛槍-準度",
			hover = "滑膛槍對比普通弓箭的準度",
		},

		{
			name = "MusketBoards_req",
			label = "滑膛槍配方-木板",
			hover = "製造滑膛槍所需木板的數量",
		},

		{
			name = "MusketGold_req",
			label = "滑膛槍配方-金塊",
			hover = "製造滑膛槍所需金塊的數量",
		},

		{
			name = "MusketIron_req",
			label = "滑膛槍配方-鐵礦石",
			hover = "(需要 挖礦機 Mining Machine Mod) 製造滑膛槍所需鐵礦石的數量",
		},

		{
			name = "MusketFlint_req",
			label = "滑膛槍配方-燧石",
			hover = "製造滑膛槍所需紫寶石的數量",
		},

		{
			name = "MusketTechLevel",
			label = "滑膛槍-科技",
			hover = "製造滑膛槍所需的科技",
		},

		{
			name = "ProjShaftType",
			label = "箭軸材料：",
			hover = "這些材料將用於製造箭軸",
		},

		{
			name = "ArrowLog_req",
			label = "石箭矢配方-箭軸",
			hover = "製造石箭矢所需箭軸的數量",
		},

		{
			name = "ArrowFeather_req",
			label = "石箭矢配方-羽毛",
			hover = "製造石箭矢所需烏鴉羽毛的數量",
		},

		{
			name = "ArrowHeadType",
			label = "箭頭材料:",
			hover = "這些材料將用於製造箭頭",
		},

		{
			name = "ArrowHead_req",
			label = "石箭矢配方-箭頭",
			hover = "製造石箭矢所需箭頭的數量",
		},

		{
			name = "ArrowCraftAmount",
			label = "石箭矢配方-收穫",
			hover = "製造石箭矢獲得物品的數量",
		},

		{
			name = "ArrowTechLevel",
			label = "石箭矢-科技",
			hover = "製造石箭矢所需的科技",
		},

		{
			name = "GoldArrowLog_req",
			label = "金箭矢配方-箭軸",
			hover = "製造金箭矢所需箭軸的數量",
		},

		{
			name = "GoldArrowFeather_req",
			label = "金箭矢配方-羽毛",
			hover = "製造金箭矢所需烏鴉羽毛的數量",
		},

		{
			name = "GoldArrowHead_req",
			label = "金箭矢配方-金塊",
			hover = "製造金箭矢所需金塊的數量",
		},

		{
			name = "GoldArrowCraftAmount",
			label = "金箭矢配方-收穫",
			hover = "製造金箭矢獲得物品的數量",
		},

		{
			name = "GoldArrowTechLevel",
			label = "金箭矢-科技",
			hover = "製造金箭矢所需的科技",
		},

		{
			name = "GoldArrowDmgMod",
			label = "金箭矢-傷害",
			hover = "金箭矢對比石箭矢的傷害",
		},

		{
			name = "GoldArrowRecoveryMod",
			label = "金箭矢-回收",
			hover = "金箭矢對比石箭矢的回收",
		},

		{
			name = "MoonstoneArrowLog_req",
			label = "月箭矢配方-箭軸",
			hover = "製造月箭矢所需箭軸的數量",
		},

		{
			name = "MoonstoneArrowFeather_req",
			label = "月箭矢配方-羽毛",
			hover = "製造月箭矢所需羽毛的數量",
		},

		{
			name = "MoonstoneArrowHead_req",
			label = "月箭矢配方-箭頭",
			hover = "製造月箭矢所需箭頭的數量",
		},

		{
			name = "MoonstoneArrowCraftAmount",
			label = "月箭矢配方-收穫",
			hover = "製造月箭矢獲得物品的數量",
		},

		{
			name = "MoonstoneArrowTechLevel",
			label = "月箭矢-科技",
			hover = "製造月箭矢所需的科技",
		},

		{
			name = "MoonstoneArrowDmgMod",
			label = "月箭矢-傷害",
			hover = "月箭矢對比石箭矢的傷害",
		},

		{
			name = "FireArrowLog_req",
			label = "火箭矢配方-箭軸",
			hover = "製造火箭矢所需箭軸的數量",
		},

		{
			name = "FireArrowFeather_req",
			label = "火箭矢配方-羽毛",
			hover = "製造火箭矢所需紅色羽毛的數量",
		},

		{
			name = "FireArrowGrass_req",
			label = "火箭矢配方-草",
			hover = "製造火箭矢所需割下來的草的數量",
		},

		{
			name = "FireArrowHeadType",
			label = "火箭頭材料",
			hover = "這些材料將用於製造火箭頭",
		},

		{
			name = "FireArrowHead_req",
			label = "火箭矢配方-箭頭",
			hover = "製造火箭矢所需箭頭的數量",
		},

		{
			name = "FireArrowCraftAmount",
			label = "火箭矢配方-收穫",
			hover = "製造火箭矢獲得物品的數量",
		},

			{
			name = "FireArrowTechLevel",
			label = "火箭矢-科技",
			hover = "製造火箭矢所需的科技",
		},

		{
			name = "FireArrowDmgMod",
			label = "火箭矢-傷害",
			hover = "火箭矢對比石箭矢的傷害",
		},

		{
			name = "IceArrowLog_req",
			label = "冰箭矢配方-箭軸",
			hover = "製造冰箭矢所需箭軸的數量",
		},

		{
			name = "IceArrowFeather_req",
			label = "冰箭矢配方-羽毛",
			hover = "製造冰箭矢所需藍色羽毛的數量",
		},

		{
			name = "IceArrowHeadType",
			label = "冰箭頭材料",
			hover = "這些材料將用於製造冰箭頭",
		},

		{
			name = "IceArrowHead_req",
			label = "冰箭矢配方-箭頭",
			hover = "製造冰箭矢所需箭頭的數量",
		},

		{
			name = "IceArrowCraftAmount",
			label = "冰箭矢配方-收穫",
			hover = "製造冰箭矢獲得物品的數量",
		},

			{
			name = "IceArrowTechLevel",
			label = "冰箭矢-科技",
			hover = "製造冰箭矢所需的科技",
		},

		{
			name = "IceArrowDmgMod",
			label = "冰箭矢-傷害",
			hover = "冰箭矢對比石箭矢的傷害",
		},

		{
			name = "ThunderArrowLog_req",
			label = "雷箭矢配方-箭軸",
			hover = "製造雷箭矢所需箭軸的數量",
		},

		{
			name = "ThunderArrowFeather_req",
			label = "雷箭矢配方-羽毛",
			hover = "製造雷箭矢所需藍色羽毛的數量",
		},

		{
			name = "ThunderArrowHeadType",
			label = "雷箭頭材料",
			hover = "這些材料將用於製造雷箭頭",
		},

		{
			name = "ThunderArrowHead_req",
			label = "雷箭矢配方-箭頭",
			hover = "製造雷箭矢所需箭頭的數量",
		},

		{
			name = "ThunderArrowCraftAmount",
			label = "雷箭矢配方-收穫",
			hover = "製造雷箭矢獲得物品的數量",
		},

			{
			name = "ThunderArrowTechLevel",
			label = "雷箭矢-科技",
			hover = "製造雷箭矢所需的科技",
		},

		{
			name = "ThunderArrowDmgMod",
			label = "雷箭矢-傷害",
			hover = "雷箭矢對比石箭矢的傷害",
		},

		{
			name = "LightningRodChargesNum",
			label = "避雷針充能時間",
			hover = "避雷針充能雷箭矢所需的時間",
		},

		{
			name = "BoltLog_req",
			label = "弩箭配方-箭軸",
			hover = "製造弩箭所需箭軸的數量",
		},

		{
			name = "BoltFeather_req",
			label = "弩箭配方-羽毛",
			hover = "製造弩箭所需烏鴉羽毛的數量",
		},

		{
			name = "BoltHeadType",
			label = "弩箭頭材料",
			hover = "這些材料將用於製造弩箭頭",
		},

		{
			name = "BoltHead_req",
			label = "弩箭配方-弩箭頭",
			hover = "製造弩箭所需弩箭頭的數量",
		},

		{
			name = "BoltCraftAmount",
			label = "弩箭配方-收穫",
			hover = "製造弩箭獲得物品的數量",
		},

		{
			name = "BoltTechLevel",
			label = "弩箭-科技",
			hover = "製造弩箭所需的科技",
		},

		{
			name = "PoisonBoltLog_req",
			label = "毒弩箭配方-箭軸",
			hover = "製造毒弩箭所需箭軸的數量",
		},

		{
			name = "PoisonBoltFeather_req",
			label = "毒弩箭配方-羽毛",
			hover = "製造毒弩箭所需烏鴉羽毛的數量",
		},

		{
			name = "PoisonBoltRedCap_req",
			label = "毒弩箭配方-紅菇頭",
			hover = "製造毒弩箭所需紅菇頭的數量",
		},

		{
			name = "PoisonBoltHeadType",
			label = "毒弩箭頭材料",
			hover = "這些材料將用於製造毒弩箭頭",
		},

		{
			name = "PoisonBoltHead_req",
			label = "毒弩箭配方-毒弩箭頭",
			hover = "製造毒弩箭所需毒弩箭頭的數量",
		},

		{
			name = "PoisonBoltCraftAmount",
			label = "毒弩箭配方-收穫",
			hover = "製造毒弩箭獲得物品的數量",
		},

		{
			name = "PoisonBoltTechLevel",
			label = "毒弩箭-科技",
			hover = "製造毒弩箭所需的科技",
		},

		{
			name = "PoisonBoltDmgMod",
			label = "毒弩箭-傷害",
			hover = "毒弩箭超時後的附加傷害對比石箭矢的傷害",
		},

		{
			name = "PoisonBoltDuration",
			label = "毒弩箭-持續時間",
			hover = "毒弩箭中毒效果持續時間",
		},

		{
			name = "ExplosiveBoltLog_req",
			label = "爆炸弩箭配方-箭軸",
			hover = "製造爆炸弩箭所需箭軸的數量",
		},

		{
			name = "ExplosiveBoltFeather_req",
			label = "爆炸弩箭配方-羽毛",
			hover = "製造爆炸弩箭所需烏鴉羽毛的數量",
		},

		{
			name = "ExplosiveBoltMosquitoSack_req",
			label = "爆炸弩箭配方-蚊子血袋",
			hover = "製造爆炸弩箭所需蚊子血袋的數量",
		},

		{
			name = "ExplosiveBoltHeadType",
			label = "爆炸弩箭頭材料",
			hover = "這些材料將用於製造爆炸弩箭頭",
		},

		{
			name = "ExplosiveBoltHead_req",
			label = "爆炸弩箭配方-箭頭",
			hover = "製造爆炸弩箭所需爆炸弩箭頭的數量",
		},

		{
			name = "ExplosiveBoltCraftAmount",
			label = "爆炸弩箭配方-收穫",
			hover = "製造爆炸弩箭獲得物品的數量",
		},

		{
			name = "ExplosiveBoltTechLevel",
			label = "爆炸弩箭-科技",
			hover = "製造爆炸弩箭所需的科技",
		},

		{
			name = "ExplosiveBoltRadius",
			label = "爆炸弩箭-範圍",
			hover = "爆炸弩箭爆炸生效的範圍半徑",
		},

		{
			name = "ExplosiveBoltExpDmg",
			label = "爆炸弩箭-傷害",
			hover = "爆炸弩箭的爆炸傷害",
		},

		{
			name = "MusketBulletType",
			label = "滑膛槍彈藥-材料",
			hover = "這些材料將用於製造滑膛槍彈藥頭",
			options =
			{
				{description = "岩石", data = "rocks", hover = "岩石將作為基礎"},
				{description = "鐵礦石", data = "mnzironore", hover = "(需要 挖礦機-Mining Machine Mod) 鐵礦石將作為基礎"},
			},
		},

		{
			name = "MusketBulletHead_req",
			label = "滑膛槍彈藥配方-材料",
			hover = "製造滑膛槍彈藥所需你選擇材料的數量",
		},

		{
			name = "MusketBulletGP_req",
			label = "滑膛槍彈藥配方-火藥",
			hover = "製造滑膛槍彈藥所需火藥的數量",
		},

		{
			name = "MusketBulletCraftAmount",
			label = "滑膛槍彈藥配方-收穫",
			hover = "製造滑膛槍彈藥獲得物品的數量",
		},

	}
)
