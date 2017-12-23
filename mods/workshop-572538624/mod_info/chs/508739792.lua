_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"这些哨兵治疗玩家或者提高你基地的防护力量。",
	{
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
		["10 (blowdartt)"] = "10 (吹箭)",
		["no overheating"] = "没有过热",
		["very slow"] = "很慢",
		["slow"] = "慢",
		["default"] = "默认",
		["fast"] = "快",
		["very fast"] = "很快",
		["yes"] = "是",
		["no"] = "否",
		["None"] = "无",
		["Sc. Mach."] = "一本",
		["Alch. Eng."] = "二本",
		["Log"] = "木头",
		["Twigs"] = "树枝",
		["Reeds"] = "芦苇",
		["Flint"] = "燧石",
		["Stinger"] = "蜂刺",
		["Tooth"] = "狗牙",
	},
	{
		{
			name = "HeavySentryDmg",
			label = "重型哨兵伤害",
			hover = "重型哨兵造成伤害的数值",
		},

		{
			name = "HeavySentryRange",
			label = "重型哨兵范围",
			hover = "重型哨兵查看的范围",
		},

		{
			name = "HeavySentryAtkRate",
			label = "重型哨兵攻击速度",
			hover = "重型哨兵攻击速度",
		},

		{
			name = "HeavySentryMaxFuel",
			label = "重型哨兵最大燃料",
			hover = "重型哨兵最多可以储存多少燃料",
		},

		{
			name = "FuelMode",
			label = "哨兵燃料模式",
			hover = "哪种类型的燃料可被用于哨兵",
			options =
			{
				{description = "可燃物", data = "burnable", hover="使用木头或任何你可以用于雪球发射机的燃料"},
				{description = "弹药", data = "projectiles", hover="使用箭矢或弹药来填充你的哨兵"},
			},
		},

		{
			name = "FuelPerUnit",
			label = "燃料单位",
			hover = "如果燃料是可燃物，一个木头的数量增加一个弹药",
		},

		{
			name = "SentryOverheatIncRate",
			label = "过热增加速度",
			hover = "过热出现的速度",
		},

		{
			name = "SentryOverheatDecRate",
			label = "过热减少速度",
			hover = "过热减少的速度",
		},

		{
			name = "SentryTargetPlayer",
			label = "玩家=目标？",
			hover = "哨兵可以吧玩家当成目标",
		},

		{
			name = "HeavySentryGears_req",
			label = "配方：齿轮",
			hover = "制造重型哨兵所需齿轮的数量",
		},

		{
			name = "HeavySentryGold_req",
			label = "配方：金块",
			hover = "制造重型哨兵所需金块的数量",
		},

		{
			name = "HeavySentryDoodad_req",
			label = "配方：电器元件",
			hover = "制造重型哨兵所需电器元件的数量",
		},

		{
			name = "HeavySentryTechLevel",
			label = "重型哨兵科技",
			hover = "制造重型哨兵所需的科技",
		},

	-------------------------------IF ARCHERY MOD IS NOT INSTALLED-----------------------------------------

		{
			name = "ProjShaftType",
			label = "箭矢箭杆",
			hover = "制造哨兵箭矢箭杆所需的材料",
		},

		{
			name = "ArrowLog_req",
			label = "箭矢配方箭杆",
			hover = "制造哨兵箭矢所需箭杆的数量",
		},

		{
			name = "ArrowFeather_req",
			label = "箭矢配方羽毛",
			hover = "制造哨兵箭矢所需乌鸦羽毛的数量",
		},

		{
			name = "ArrowHeadType",
			label = "箭矢头部",
			hover = "制造哨兵箭矢头部所需的材料",
		},

		{
			name = "ArrowHead_req",
			label = "箭矢配方头部",
			hover = "制造哨兵箭矢头部所需材料的数量",
		},

		{
			name = "ArrowCraftAmount",
			label = "箭矢配方收获",
			hover = "从配方中得到的哨兵箭矢的数量",
		},

		{
			name = "ArrowTechLevel",
			label = "哨兵箭矢科技",
			hover = "制造哨兵箭矢所需的科技",
		},

	}
)
