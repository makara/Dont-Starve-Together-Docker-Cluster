_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"专注于为游戏带来更多的远程武器。 \n现在完全支持控制器！ \n结合药剂师 mod 增加一个提高你射击效率的药物！",
	{
		["150 (spear)"] = "150 (长矛)",
		["Inf."] = "无限",
		["10 (blowdartt)"] = "10 (吹箭)",
		["yes"] = "是",
		["no"] = "否",
		["Disabled"] = "禁用",
		["None"] = "无",
		["Sc. Mach."] = "科技一本",
		["Alch. Eng."] = "科技二本",
		["same"] = "相同",
		["Prestihat."] = "魔法一本",
		["Sh. Manip."] = "魔法二本",
		["30 (~spear damage)"] = "30(长矛伤害)",
		["Log"] = "木头",
		["Twigs"] = "树枝",
		["Reeds"] = "芦苇",
		["Flint"] = "燧石",
		["Stinger"] = "蜂针",
		["Tooth"] = "狗牙",
		["Charcoal"] = "木炭",
		["Ice"] = "冰",
		["Blue Gem"] = "蓝宝石",
		["Volt Goat Horn"] = "电羊角",
		["Elec. Doodad"] = "电器元件",
		["Gun Powd."] = "火药",
		["Red Gem"] = "红宝石",
		["Hammer damage"] = "锤子的伤害",
		["A bit less than the Axe"] = "比斧头少一点",
		["Axe damage"] = "斧头的伤害",
		["A bit less than the Spear"] = "比长矛少一点",
		["Spear damage"] = "长矛的伤害",
		["A bit more than the spear"] = "比长矛多一点",
		["Batbat damage"] = "蝙蝠斧棍的伤害",
		["Slightly more than the Batbat"] = "略多于蝙蝠斧棍",
		["Intermediate between Batbat and Ruinbat"] = "蝙蝠斧棍和铥矿棒之间的中间",
		["Slightly less than Ruinbat"] = "略低于铥矿棒",
		["Hambat/Ruinbat damage"] = "铥矿棒/火腿球棒的伤害",
		["Slightly more than the Ruinbat"] = "略多于铥矿棒",
		["are you serious?"] = "你是认真的吗？",
		["are you serious?!"] = "你是认真的吗？！",
		["are you serious?!!"] = "你是认真的吗？！！",
		["use c_godmode() instead"] = "不如去开上帝模式吧！",
	},
	{
		{
			name = "BowUses",
			label = "木弓使用次数",
			hover = "使用多少次后损毁？",
		},

		{
			name = "BowDmg",
			label = "木弓的伤害",
			hover = "弓伤害是数值？",
		},

		{
			name = "BowRange",
			label = "木弓的范围",
			hover = "木弓射击的范围",
		},

		{
			name = "BowMissChanceSmall",
			label = "小目标脱靶",
			hover = "可能在射击小目标时脱靶",
		},

		{
			name = "BowMissChanceBig",
			label = "大目标脱靶",
			hover = "可能在射击大目标时脱靶",
		},

		{
			name = "HitChanceBugs",
			label = "微小目标脱靶",
			hover = "射击蝴蝶和蜜蜂时的脱靶",
			options =
			{
				{description = "否", data = false, hover= "不减少对蜜蜂和蝴蝶的命中"},
				{description = "是", data = true, hover= "减少对蜜蜂和蝴蝶的命中到 1%"},
			},
		},

		{
			name = "HitChanceTakeOff",
			label = "鸟的脱靶",
			hover = "射击鸟时的脱靶",
			options =
			{
				{description = "否", data = false, hover= "不减少对鸟的命中"},
				{description = "是", data = true, hover= "减少对鸟的命中到 1%"},
			},
		},

		{
			name = "ActivateCollisions",
			label = "激活碰撞",
			hover = "你的箭/箭杆会被障碍物阻止（墙壁，树木，等等）。",
		},

		{
			name = "ArrowHitRecovery",
			label = "命中回收",
			hover = "成功射击命中后收回箭的几率",
		},

		{
			name = "ArrowMissRecovery",
			label = "脱靶回收",
			hover = "脱靶后收回箭的几率",
		},

		{
			name = "CritPvE",
			label = "致命一击 % 怪物",
			hover = "对生物出现致命一击的几率",
		},

		{
			name = "CritDmgModPvE",
			label = "怪物致命伤害",
			hover = "对生物致命一击的伤害",
		},

		{
			name = "CritPvP",
			label = "致命一击 % 玩家",
			hover = "对玩家出现致命一击的几率",
		},

		{
			name = "CritDmgModPvP",
			label = "玩家致命伤害",
			hover = "对玩家致命一击的伤害",
		},

		{
			name = "AccuracyDrugEffect",
			label = "维生素R效果",
			hover = "维生素R影响射击精度和弹药恢复的机会（要求药剂师 medicamento MOD）",
			options =
			{
				{description = "小", data = "small", hover = "30% 的脱靶几率，增加 15% 弹药的恢复"},
				{description = "中", data = "medium", hover = "60% 的脱靶几率，增加 35% 弹药的恢复"},
				{description = "大", data = "strong", hover = "85% 的脱靶几率，增加 60% 弹药的恢复"},
				{description = "罗宾汉", data = "robinhood", hover = "你永远不会脱靶，总是恢复弹药。骗子!"},
			},
		},

		{
			name = "BowTwigs_req",
			label = "木弓配方-树枝",
			hover = "制造弓所需树枝的数量",
		},

		{
			name = "BowSilk_req",
			label = "木弓配方-蛛网",
			hover = "制造弓所需蛛网的数量",
		},

		{
			name = "BowTechLevel",
			label = "木弓-科技",
			hover = "制造弓所需科技",
		},

		{
			name = "CrossbowDmgMod",
			label = "弩-伤害",
			hover = "弩对比普通弓箭的伤害",
		},

		{
			name = "CrossbowRangeMod",
			label = "弩-范围",
			hover = "弩对比普通弓箭的范围",
		},

		{
			name = "CrossbowAccMod",
			label = "弩-准度",
			hover = "弩对比普通弓箭的准度",
		},

		{
			name = "CrossbowBoards_req",
			label = "弩配方-木板",
			hover = "制造弩所需木板的数量",
		},

		{
			name = "CrossbowSilk_req",
			label = "弩配方-蛛网",
			hover = "制造弩所需蛛网的数量",
		},

		{
			name = "CrossbowHammer_req",
			label = "弩配方-锤子",
			hover = "制造弩所需锤子的数量",
		},

		{
			name = "CrossbowTechLevel",
			label = "弩-科技",
			hover = "制造弩所需科技",
		},

		{
			name = "MagicBowDmgMod",
			label = "魔法弓-伤害",
			hover = "魔法弓对比普通弓箭的伤害",
		},

		{
			name = "MagicBowLivingLog_req",
			label = "魔法弓配方-活木",
			hover = "制造魔法弓所需活木的数量",
		},

		{
			name = "MagicBowPurpleGem_req",
			label = "魔法弓配方-紫宝石",
			hover = "制造魔法弓所需紫宝石的数量",
		},

		{
			name = "MagicBowGlommerFlower_req",
			label = "魔法弓配方-格罗姆的花",
			hover = "制造魔法弓所需格罗姆的花的数量",
		},

		{
			name = "MagicBowTechLevel",
			label = "魔法弓-科技",
			hover = "制造魔法弓所需科技",
		},

		{
			name = "QuiverPigskin_req",
			label = "箭筒配方-猪皮",
			hover = "制造箭筒所需猪皮的数量",
		},

		{
			name = "QuiverRope_req",
			label = "箭筒配方-绳子",
			hover = "制造魔法弓所需绳子的数量",
		},

		{
			name = "QuiverTechLevel",
			label = "箭筒-科技",
			hover = "制造箭筒所需科技",
		},

		{
			name = "MusketDmgMod",
			label = "滑膛枪-伤害",
			hover = "滑膛枪对比普通弓箭的伤害",
		},

		{
			name = "MusketRangeMod",
			label = "滑膛枪-范围",
			hover = "滑膛枪对比普通弓箭的范围",
		},

		{
			name = "MusketAccMod",
			label = "滑膛枪-准度",
			hover = "滑膛枪对比普通弓箭的准度",
		},

		{
			name = "MusketBoards_req",
			label = "滑膛枪配方-木板",
			hover = "制造滑膛枪所需木板的数量",
		},

		{
			name = "MusketGold_req",
			label = "滑膛枪配方-金块",
			hover = "制造滑膛枪所需金块的数量",
		},

		{
			name = "MusketIron_req",
			label = "滑膛枪配方-铁矿石",
			hover = "(需要 挖矿机 Mining Machine Mod) 制造滑膛枪所需铁矿石的数量",
		},

		{
			name = "MusketFlint_req",
			label = "滑膛枪配方-燧石",
			hover = "制造滑膛枪所需紫宝石的数量",
		},

		{
			name = "MusketTechLevel",
			label = "滑膛枪-科技",
			hover = "制造滑膛枪所需的科技",
		},

		{
			name = "ProjShaftType",
			label = "箭轴材料：",
			hover = "这些材料将用于制造箭轴",
		},

		{
			name = "ArrowLog_req",
			label = "石箭矢配方-箭轴",
			hover = "制造石箭矢所需箭轴的数量",
		},

		{
			name = "ArrowFeather_req",
			label = "石箭矢配方-羽毛",
			hover = "制造石箭矢所需乌鸦羽毛的数量",
		},

		{
			name = "ArrowHeadType",
			label = "箭头材料:",
			hover = "这些材料将用于制造箭头",
		},

		{
			name = "ArrowHead_req",
			label = "石箭矢配方-箭头",
			hover = "制造石箭矢所需箭头的数量",
		},

		{
			name = "ArrowCraftAmount",
			label = "石箭矢配方-收获",
			hover = "制造石箭矢获得物品的数量",
		},

		{
			name = "ArrowTechLevel",
			label = "石箭矢-科技",
			hover = "制造石箭矢所需的科技",
		},

		{
			name = "GoldArrowLog_req",
			label = "金箭矢配方-箭轴",
			hover = "制造金箭矢所需箭轴的数量",
		},

		{
			name = "GoldArrowFeather_req",
			label = "金箭矢配方-羽毛",
			hover = "制造金箭矢所需乌鸦羽毛的数量",
		},

		{
			name = "GoldArrowHead_req",
			label = "金箭矢配方-金块",
			hover = "制造金箭矢所需金块的数量",
		},

		{
			name = "GoldArrowCraftAmount",
			label = "金箭矢配方-收获",
			hover = "制造金箭矢获得物品的数量",
		},

		{
			name = "GoldArrowTechLevel",
			label = "金箭矢-科技",
			hover = "制造金箭矢所需的科技",
		},

		{
			name = "GoldArrowDmgMod",
			label = "金箭矢-伤害",
			hover = "金箭矢对比石箭矢的伤害",
		},

		{
			name = "GoldArrowRecoveryMod",
			label = "金箭矢-回收",
			hover = "金箭矢对比石箭矢的回收",
		},

		{
			name = "MoonstoneArrowLog_req",
			label = "月箭矢配方-箭轴",
			hover = "制造月箭矢所需箭轴的数量",
		},

		{
			name = "MoonstoneArrowFeather_req",
			label = "月箭矢配方-羽毛",
			hover = "制造月箭矢所需羽毛的数量",
		},

		{
			name = "MoonstoneArrowHead_req",
			label = "月箭矢配方-箭头",
			hover = "制造月箭矢所需箭头的数量",
		},

		{
			name = "MoonstoneArrowCraftAmount",
			label = "月箭矢配方-收获",
			hover = "制造月箭矢获得物品的数量",
		},

		{
			name = "MoonstoneArrowTechLevel",
			label = "月箭矢-科技",
			hover = "制造月箭矢所需的科技",
		},

		{
			name = "MoonstoneArrowDmgMod",
			label = "月箭矢-伤害",
			hover = "月箭矢对比石箭矢的伤害",
		},

		{
			name = "FireArrowLog_req",
			label = "火箭矢配方-箭轴",
			hover = "制造火箭矢所需箭轴的数量",
		},

		{
			name = "FireArrowFeather_req",
			label = "火箭矢配方-羽毛",
			hover = "制造火箭矢所需红色羽毛的数量",
		},

		{
			name = "FireArrowGrass_req",
			label = "火箭矢配方-草",
			hover = "制造火箭矢所需割下来的草的数量",
		},

		{
			name = "FireArrowHeadType",
			label = "火箭头材料",
			hover = "这些材料将用于制造火箭头",
		},

		{
			name = "FireArrowHead_req",
			label = "火箭矢配方-箭头",
			hover = "制造火箭矢所需箭头的数量",
		},

		{
			name = "FireArrowCraftAmount",
			label = "火箭矢配方-收获",
			hover = "制造火箭矢获得物品的数量",
		},

			{
			name = "FireArrowTechLevel",
			label = "火箭矢-科技",
			hover = "制造火箭矢所需的科技",
		},

		{
			name = "FireArrowDmgMod",
			label = "火箭矢-伤害",
			hover = "火箭矢对比石箭矢的伤害",
		},

		{
			name = "IceArrowLog_req",
			label = "冰箭矢配方-箭轴",
			hover = "制造冰箭矢所需箭轴的数量",
		},

		{
			name = "IceArrowFeather_req",
			label = "冰箭矢配方-羽毛",
			hover = "制造冰箭矢所需蓝色羽毛的数量",
		},

		{
			name = "IceArrowHeadType",
			label = "冰箭头材料",
			hover = "这些材料将用于制造冰箭头",
		},

		{
			name = "IceArrowHead_req",
			label = "冰箭矢配方-箭头",
			hover = "制造冰箭矢所需箭头的数量",
		},

		{
			name = "IceArrowCraftAmount",
			label = "冰箭矢配方-收获",
			hover = "制造冰箭矢获得物品的数量",
		},

			{
			name = "IceArrowTechLevel",
			label = "冰箭矢-科技",
			hover = "制造冰箭矢所需的科技",
		},

		{
			name = "IceArrowDmgMod",
			label = "冰箭矢-伤害",
			hover = "冰箭矢对比石箭矢的伤害",
		},

		{
			name = "ThunderArrowLog_req",
			label = "雷箭矢配方-箭轴",
			hover = "制造雷箭矢所需箭轴的数量",
		},

		{
			name = "ThunderArrowFeather_req",
			label = "雷箭矢配方-羽毛",
			hover = "制造雷箭矢所需蓝色羽毛的数量",
		},

		{
			name = "ThunderArrowHeadType",
			label = "雷箭头材料",
			hover = "这些材料将用于制造雷箭头",
		},

		{
			name = "ThunderArrowHead_req",
			label = "雷箭矢配方-箭头",
			hover = "制造雷箭矢所需箭头的数量",
		},

		{
			name = "ThunderArrowCraftAmount",
			label = "雷箭矢配方-收获",
			hover = "制造雷箭矢获得物品的数量",
		},

			{
			name = "ThunderArrowTechLevel",
			label = "雷箭矢-科技",
			hover = "制造雷箭矢所需的科技",
		},

		{
			name = "ThunderArrowDmgMod",
			label = "雷箭矢-伤害",
			hover = "雷箭矢对比石箭矢的伤害",
		},

		{
			name = "LightningRodChargesNum",
			label = "避雷针充能时间",
			hover = "避雷针充能雷箭矢所需的时间",
		},

		{
			name = "BoltLog_req",
			label = "弩箭配方-箭轴",
			hover = "制造弩箭所需箭轴的数量",
		},

		{
			name = "BoltFeather_req",
			label = "弩箭配方-羽毛",
			hover = "制造弩箭所需乌鸦羽毛的数量",
		},

		{
			name = "BoltHeadType",
			label = "弩箭头材料",
			hover = "这些材料将用于制造弩箭头",
		},

		{
			name = "BoltHead_req",
			label = "弩箭配方-弩箭头",
			hover = "制造弩箭所需弩箭头的数量",
		},

		{
			name = "BoltCraftAmount",
			label = "弩箭配方-收获",
			hover = "制造弩箭获得物品的数量",
		},

		{
			name = "BoltTechLevel",
			label = "弩箭-科技",
			hover = "制造弩箭所需的科技",
		},

		{
			name = "PoisonBoltLog_req",
			label = "毒弩箭配方-箭轴",
			hover = "制造毒弩箭所需箭轴的数量",
		},

		{
			name = "PoisonBoltFeather_req",
			label = "毒弩箭配方-羽毛",
			hover = "制造毒弩箭所需乌鸦羽毛的数量",
		},

		{
			name = "PoisonBoltRedCap_req",
			label = "毒弩箭配方-红菇头",
			hover = "制造毒弩箭所需红菇头的数量",
		},

		{
			name = "PoisonBoltHeadType",
			label = "毒弩箭头材料",
			hover = "这些材料将用于制造毒弩箭头",
		},

		{
			name = "PoisonBoltHead_req",
			label = "毒弩箭配方-毒弩箭头",
			hover = "制造毒弩箭所需毒弩箭头的数量",
		},

		{
			name = "PoisonBoltCraftAmount",
			label = "毒弩箭配方-收获",
			hover = "制造毒弩箭获得物品的数量",
		},

		{
			name = "PoisonBoltTechLevel",
			label = "毒弩箭-科技",
			hover = "制造毒弩箭所需的科技",
		},

		{
			name = "PoisonBoltDmgMod",
			label = "毒弩箭-伤害",
			hover = "毒弩箭超时后的附加伤害对比石箭矢的伤害",
		},

		{
			name = "PoisonBoltDuration",
			label = "毒弩箭-持续时间",
			hover = "毒弩箭中毒效果持续时间",
		},

		{
			name = "ExplosiveBoltLog_req",
			label = "爆炸弩箭配方-箭轴",
			hover = "制造爆炸弩箭所需箭轴的数量",
		},

		{
			name = "ExplosiveBoltFeather_req",
			label = "爆炸弩箭配方-羽毛",
			hover = "制造爆炸弩箭所需乌鸦羽毛的数量",
		},

		{
			name = "ExplosiveBoltMosquitoSack_req",
			label = "爆炸弩箭配方-蚊子血袋",
			hover = "制造爆炸弩箭所需蚊子血袋的数量",
		},

		{
			name = "ExplosiveBoltHeadType",
			label = "爆炸弩箭头材料",
			hover = "这些材料将用于制造爆炸弩箭头",
		},

		{
			name = "ExplosiveBoltHead_req",
			label = "爆炸弩箭配方-箭头",
			hover = "制造爆炸弩箭所需爆炸弩箭头的数量",
		},

		{
			name = "ExplosiveBoltCraftAmount",
			label = "爆炸弩箭配方-收获",
			hover = "制造爆炸弩箭获得物品的数量",
		},

		{
			name = "ExplosiveBoltTechLevel",
			label = "爆炸弩箭-科技",
			hover = "制造爆炸弩箭所需的科技",
		},

		{
			name = "ExplosiveBoltRadius",
			label = "爆炸弩箭-范围",
			hover = "爆炸弩箭爆炸生效的范围半径",
		},

		{
			name = "ExplosiveBoltExpDmg",
			label = "爆炸弩箭-伤害",
			hover = "爆炸弩箭的爆炸伤害",
		},

		{
			name = "MusketBulletType",
			label = "滑膛枪弹药-材料",
			hover = "这些材料将用于制造滑膛枪弹药头",
			options =
			{
				{description = "岩石", data = "rocks", hover = "岩石将作为基础"},
				{description = "铁矿石", data = "mnzironore", hover = "(需要 挖矿机-Mining Machine Mod) 铁矿石将作为基础"},
			},
		},

		{
			name = "MusketBulletHead_req",
			label = "滑膛枪弹药配方-材料",
			hover = "制造滑膛枪弹药所需你选择材料的数量",
		},

		{
			name = "MusketBulletGP_req",
			label = "滑膛枪弹药配方-火药",
			hover = "制造滑膛枪弹药所需火药的数量",
		},

		{
			name = "MusketBulletCraftAmount",
			label = "滑膛枪弹药配方-收获",
			hover = "制造滑膛枪弹药获得物品的数量",
		},

	}
)
