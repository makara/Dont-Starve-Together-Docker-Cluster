_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"会自动装备适合手头的任务的工具。举几个例子：\n- 按住空格键，让一切不动手就可以完成。\n- 攻击敌人时，它会装备你最好的武器。\n- 攻击小动物，如果你有一个回旋镖，它就会自动使用。\n- 在黑暗中，如果在你有照明物，会自动装备一个。\n（按住空格键不会挖树苗，灌木等，但可以通过按住CTRL强行挖）\n\n如果出现任何错误或其他事情，你想获得帮助，那么在这个MOD的讨论发表评论，我会在那里看看。\n\n这mod最初是由noobler制作，由Jespercal定制并制作成客户端MOD。",
	{
		["No"] = "否",
		["Yes"] = "是",
		["Equip only"] = "装备",
		["Craft & Equip"] = "制造&装备",
		["Yes - Logs"] = "木头优先",
		["Yes - Twigs"] = "树枝优先",
		["Yes - Grass"] = "草优先",
		["Will prefer to use Logs as fuel, else it'll go from backpack, then from right to left."] = "优先使用 木头 作为燃料，然后是背包里面的，最后从右到左查看。",
		["Will prefer to use Twigs as fuel, else it'll go from backpack, then from right to left."] = "优先使用 树枝 作为燃料，然后是背包里面的，最后从右到左查看。",
		["Will prefer to use Cut-Grass as fuel, else it'll go from backpack, then from right to left."] = "优先使用 草 作为燃料，然后是背包里面的，最后从右到左查看。",

	},
	{
		{
			name="autoequipopeningamesettings",
			label="打开设置按钮？",
			longlabel="选择哪个按钮来打开游戏中的设置菜单？",
			hover="在游戏中改变这个是不会工作的。抱歉。",
		},
		{
			name="autoequipignorerestrictions",
			label="Ctrl + 空格覆盖？",
			longlabel="Ctrl + 空格 覆盖限制吗？像挖树苗。",
			hover="例如，如果启用，按住 Ctrl 键，\n按下空格键时将挖出树苗和草丛。",
		},
		{
			name="autoequipweapon",
			label="战斗装备武器？",
			longlabel="当攻击敌人时，装备最好的武器？",
			hover="注：如果启用，它只会在空手情况下装备武器。",
		},
		{
			name="autoequipcraftornot",
			label="自动制造工具？",
			longlabel="在做任务时自动制造所需的工具？",
		},
		{
			name="autoequipgoldornot",
			label="制作黄金工具？",
			longlabel="当制作工具时，你更喜欢他们是黄金吗？",
		},
		--[[{{
			name="autoequipignoretraps",
			label="忽略激活的陷阱？",
		},
		{
			name="autoequipreactivatetraps",
			label="自动重新激活陷阱?",
		},]]
		{
			name="autoequipreplanttrees",
			label="自动重新植树？",
			longlabel="挖掉树桩后自动重新种植？",
			hover="注：你必须按住动作键直到挖掘出树桩，否则它不会重新种植！",
		},
		{
			name="autoequipignoresaplings",
			label="完全忽略树苗吗？",
			longlabel="即使装备了铲子也不会挖树苗？",
			hover="按住空格键时将会忽略树苗, 即使装备了铲子。\n在种植很多树苗时很有用。",
		},
		{
			name="autoequiprefuelfires",
			label="(B) 右键重新填充燃料？",
			longlabel="(测试) 是否开启右键重新填充燃料?",
			hover="燃烧顺序：首选 > 其他两个选择 > 别的可燃物",
		},
		{
			name="autoequiprepairwalls",
			label="(B) 右击修复墙吗？",
			longlabel="(测试) 启用右击修复墙吗？",
			hover="注：你需要在你的库存有墙才能这样做。",
		},
		{
			name="autoequipboomerang",
			label="对小动物使用回旋镖吗？",
		},
		{
			name="autoequiplight",
			label="(B) 黑暗中制作照明？",
			longlabel="(测试) 当站在黑暗中的时候制作照明工具？",
			hover="(测试) 这个功能是非常基本的，将在以后制作。",
		}
	}
)
