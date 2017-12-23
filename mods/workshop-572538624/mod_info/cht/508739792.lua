_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"這些哨兵治療玩家或者提高你基地的防護力量。",
	{
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
		["10 (blowdartt)"] = "10 (吹箭)",
		["no overheating"] = "沒有過熱",
		["very slow"] = "很慢",
		["slow"] = "慢",
		["default"] = "預設",
		["fast"] = "快",
		["very fast"] = "很快",
		["yes"] = "是",
		["no"] = "否",
		["None"] = "無",
		["Sc. Mach."] = "一本",
		["Alch. Eng."] = "二本",
		["Log"] = "木頭",
		["Twigs"] = "樹枝",
		["Reeds"] = "蘆葦",
		["Flint"] = "燧石",
		["Stinger"] = "蜂刺",
		["Tooth"] = "狗牙",
	},
	{
		{
			name = "HeavySentryDmg",
			label = "重型哨兵傷害",
			hover = "重型哨兵造成傷害的數值",
		},

		{
			name = "HeavySentryRange",
			label = "重型哨兵範圍",
			hover = "重型哨兵檢視的範圍",
		},

		{
			name = "HeavySentryAtkRate",
			label = "重型哨兵攻擊速度",
			hover = "重型哨兵攻擊速度",
		},

		{
			name = "HeavySentryMaxFuel",
			label = "重型哨兵最大燃料",
			hover = "重型哨兵最多可以儲存多少燃料",
		},

		{
			name = "FuelMode",
			label = "哨兵燃料模式",
			hover = "哪種型別的燃料可被用於哨兵",
			options =
			{
				{description = "可燃物", data = "burnable", hover="使用木頭或任何你可以用於雪球發射機的燃料"},
				{description = "彈藥", data = "projectiles", hover="使用箭矢或彈藥來填充你的哨兵"},
			},
		},

		{
			name = "FuelPerUnit",
			label = "燃料單位",
			hover = "如果燃料是可燃物，一個木頭的數量增加一個彈藥",
		},

		{
			name = "SentryOverheatIncRate",
			label = "過熱增加速度",
			hover = "過熱出現的速度",
		},

		{
			name = "SentryOverheatDecRate",
			label = "過熱減少速度",
			hover = "過熱減少的速度",
		},

		{
			name = "SentryTargetPlayer",
			label = "玩家=目標？",
			hover = "哨兵可以吧玩家當成目標",
		},

		{
			name = "HeavySentryGears_req",
			label = "配方：齒輪",
			hover = "製造重型哨兵所需齒輪的數量",
		},

		{
			name = "HeavySentryGold_req",
			label = "配方：金塊",
			hover = "製造重型哨兵所需金塊的數量",
		},

		{
			name = "HeavySentryDoodad_req",
			label = "配方：電器元件",
			hover = "製造重型哨兵所需電器元件的數量",
		},

		{
			name = "HeavySentryTechLevel",
			label = "重型哨兵科技",
			hover = "製造重型哨兵所需的科技",
		},

	-------------------------------IF ARCHERY MOD IS NOT INSTALLED-----------------------------------------

		{
			name = "ProjShaftType",
			label = "箭矢箭桿",
			hover = "製造哨兵箭矢箭桿所需的材料",
		},

		{
			name = "ArrowLog_req",
			label = "箭矢配方箭桿",
			hover = "製造哨兵箭矢所需箭桿的數量",
		},

		{
			name = "ArrowFeather_req",
			label = "箭矢配方羽毛",
			hover = "製造哨兵箭矢所需烏鴉羽毛的數量",
		},

		{
			name = "ArrowHeadType",
			label = "箭矢頭部",
			hover = "製造哨兵箭矢頭部所需的材料",
		},

		{
			name = "ArrowHead_req",
			label = "箭矢配方頭部",
			hover = "製造哨兵箭矢頭部所需材料的數量",
		},

		{
			name = "ArrowCraftAmount",
			label = "箭矢配方收穫",
			hover = "從配方中得到的哨兵箭矢的數量",
		},

		{
			name = "ArrowTechLevel",
			label = "哨兵箭矢科技",
			hover = "製造哨兵箭矢所需的科技",
		},

	}
)
