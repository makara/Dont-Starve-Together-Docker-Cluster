_G.ChinesePlus.SetConfigTranslation(mod_to_c,
	"會自動裝備適合手頭的任務的工具。舉幾個例子：\n- 按住空格鍵，讓一切不動手就可以完成。\n- 攻擊敵人時，它會裝備你最好的武器。\n- 攻擊小動物，如果你有一個迴旋鏢，它就會自動使用。\n- 在黑暗中，如果在你有照明物，會自動裝備一個。\n（按住空格鍵不會挖樹苗，灌木等，但可以通過按住CTRL強行挖）\n\n如果出現任何錯誤或其他事情，你想獲得幫助，那麼在這個MOD的討論發表評論，我會在那裡看看。\n\n這mod最初是由noobler製作，由Jespercal定製並製作成客戶端MOD。",
	{
		["No"] = "否",
		["Yes"] = "是",
		["Equip only"] = "裝備",
		["Craft & Equip"] = "製造&裝備",
		["Yes - Logs"] = "木頭優先",
		["Yes - Twigs"] = "樹枝優先",
		["Yes - Grass"] = "草優先",
		["Will prefer to use Logs as fuel, else it'll go from backpack, then from right to left."] = "優先使用 木頭 作為燃料，然後是揹包裡面的，最後從右到左檢視。",
		["Will prefer to use Twigs as fuel, else it'll go from backpack, then from right to left."] = "優先使用 樹枝 作為燃料，然後是揹包裡面的，最後從右到左檢視。",
		["Will prefer to use Cut-Grass as fuel, else it'll go from backpack, then from right to left."] = "優先使用 草 作為燃料，然後是揹包裡面的，最後從右到左檢視。",

	},
	{
		{
			name="autoequipopeningamesettings",
			label="開啟設定按鈕？",
			longlabel="選擇哪個按鈕來開啟遊戲中的設定選單？",
			hover="在遊戲中改變這個是不會工作的。抱歉。",
		},
		{
			name="autoequipignorerestrictions",
			label="Ctrl + 空格覆蓋？",
			longlabel="Ctrl + 空格 覆蓋限制嗎？像挖樹苗。",
			hover="例如，如果啟用，按住 Ctrl 鍵，\n按下空格鍵時將挖出樹苗和草叢。",
		},
		{
			name="autoequipweapon",
			label="戰鬥裝備武器？",
			longlabel="當攻擊敵人時，裝備最好的武器？",
			hover="注：如果啟用，它只會在空手情況下裝備武器。",
		},
		{
			name="autoequipcraftornot",
			label="自動製造工具？",
			longlabel="在做任務時自動製造所需的工具？",
		},
		{
			name="autoequipgoldornot",
			label="製作黃金工具？",
			longlabel="當製作工具時，你更喜歡他們是黃金嗎？",
		},
		--[[{{
			name="autoequipignoretraps",
			label="忽略啟用的陷阱？",
		},
		{
			name="autoequipreactivatetraps",
			label="自動重新啟用陷阱?",
		},]]
		{
			name="autoequipreplanttrees",
			label="自動重新植樹？",
			longlabel="挖掉樹樁後自動重新種植？",
			hover="注：你必須按住動作鍵直到挖掘出樹樁，否則它不會重新種植！",
		},
		{
			name="autoequipignoresaplings",
			label="完全忽略樹苗嗎？",
			longlabel="即使裝備了鏟子也不會挖樹苗？",
			hover="按住空格鍵時將會忽略樹苗, 即使裝備了鏟子。\n在種植很多樹苗時很有用。",
		},
		{
			name="autoequiprefuelfires",
			label="(B) 右鍵重新填充燃料？",
			longlabel="(測試) 是否開啟右鍵重新填充燃料?",
			hover="燃燒順序：首選 > 其他兩個選擇 > 別的可燃物",
		},
		{
			name="autoequiprepairwalls",
			label="(B) 右擊修復牆嗎？",
			longlabel="(測試) 啟用右擊修復牆嗎？",
			hover="注：你需要在你的庫存有牆才能這樣做。",
		},
		{
			name="autoequipboomerang",
			label="對小動物使用迴旋鏢嗎？",
		},
		{
			name="autoequiplight",
			label="(B) 黑暗中製作照明？",
			longlabel="(測試) 當站在黑暗中的時候製作照明工具？",
			hover="(測試) 這個功能是非常基本的，將在以後製作。",
		}
	}
)
