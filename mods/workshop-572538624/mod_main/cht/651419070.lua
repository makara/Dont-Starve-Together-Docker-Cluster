AddClassPostConstruct("widgets/aas", function(self)
    if self.servertitle then
      self.servertitle:SetTruncatedString("Auto Actions 配置", 800, 100, true)
    end

    local configuration_options_override = {
      {
        name="autoequipopeningamesettings",
        label="開啟設定按鈕？",
        longlabel="選擇哪個按鈕來開啟遊戲中的設定選單？",
        options = {},
        default="P",
        hover="在遊戲中改變這個是不會工作的。抱歉。",
      },
      {
        name="autoequipignorerestrictions",
        label="Ctrl + 空格覆蓋？",
        longlabel="Ctrl + 空格 覆蓋限制嗎？像挖樹苗。",
        options = {
          {description="否", data=0},
          {description="是", data=1},
        },
        hover="例如，如果啟用，按住 Ctrl 鍵，\n按下空格鍵時將挖出樹苗和草叢。",
        default=1,
      },
      {
        name="autoequipweapon",
        label="戰鬥裝備武器？",
        longlabel="當攻擊敵人時，裝備最好的武器？",
        hover="注：如果啟用，它只會在空手情況下裝備武器。",
        options={
          {description="否", data=0},
          {description="是", data=1}
        },
        default=1,
      },
      {
        name="autoequipcraftornot",
        label="自動製造工具？",
        longlabel="在做任務時自動製造所需的工具？",
        options={
          {description="否", data=0},
          {description="是", data=1}
        },
        default=0,
      },
      {
        name="autoequipgoldornot",
        label="製作黃金工具？",
        longlabel="當製作工具時，你更喜歡他們是黃金嗎？",
        options={
          {description="否", data=0},
          {description="是", data=1}
        },
        default=0,
      },
      --[[{{
      name="autoequipignoretraps",
      label="忽略啟用的陷阱？",
      options={
        {description="否", data=0},
        {description="是", data=1}
      },
      default=0,
    },
    {
      name="autoequipreactivatetraps",
      label="自動重新啟用陷阱?",
      options={
        {description="否", data=0},
        {description="是", data=1}
      },
      default=0,
    },]]
    {
      name="autoequipreplanttrees",
      label="自動重新植樹？",
      longlabel="挖掉樹樁後自動重新種植？",
      hover="注：你必須按住動作鍵直到挖掘出樹樁，否則它不會重新種植！",
      options={
        {description="否", data=0},
        {description="是", data=1}
      },
      default=1,
    },
    {
      name="autoequipignoresaplings",
      label="完全忽略樹苗嗎？",
      longlabel="即使裝備了鏟子也不會挖樹苗？",
      hover="按住空格鍵時將會忽略樹苗, 即使裝備了鏟子。\n在種植很多樹苗時很有用。",
      options={
        {description="否", data=0},
        {description="是", data=1}
      },
      default=0,
    },
    {
      name="autoequiprefuelfires",
      label="(B) 右鍵重新填充燃料？",
      longlabel="(測試) 是否開啟右鍵重新填充燃料?",
      hover="燃燒順序：首選 > 其他兩個選擇 > 別的可燃物",
      options={
        {description="否", data=0},
        {description="木頭優先", data=1, hover="優先使用 木頭 作為燃料，然後是揹包裡面的，最後從右到左檢視。"},
        {description="樹枝優先", data=2, hover="優先使用 樹枝 作為燃料，然後是揹包裡面的，最後從右到左檢視。"},
        {description="草優先", data=3, hover="優先使用 草 作為燃料，然後是揹包裡面的，最後從右到左檢視。"}
      },
      default=0,
    },
    {
      name="autoequiprepairwalls",
      label="(B) 右擊修復牆嗎？",
      longlabel="(測試) 啟用右擊修復牆嗎？",
      hover="注：你需要在你的庫存有牆才能這樣做。",
      options={
        {description="否", data=0},
        {description="是", data=1}
      },
      default=0,
    },
    {
      name="autoequipboomerang",
      label="對小動物使用迴旋鏢嗎？",
      options={
        {description="否", data=0},
        {description="是", data=1}
      },
      default=0,
    },
    {
      name="autoequiplight",
      label="(B) 黑暗中製作照明？",
      longlabel="(測試) 當站在黑暗中的時候製作照明工具？",
      hover="(測試) 這個功能是非常基本的，將在以後製作。",
      options={
        {description="否", data=0},
        {description="裝備", data=1},
        {description="製造&裝備", data=2}
      },
      default=0,
    }
  }

  local options_override = {}
  for i,v in ipairs(configuration_options_override) do
    if v.name and v.options then
      options_override[v.name] = {name = v.name, label = v.longlabel or v.label, options = v.options, hover = v.hover}
    end
  end

  if self.options then
    for k,v in pairs(self.options) do
      if v.name and options_override[v.name] then
        v.label = options_override[v.name].longlabel and options_override[v.name].longlabel or options_override[v.name].label
        v.options = options_override[v.name].options and options_override[v.name].options or v.options
        v.hover = options_override[v.name].hover and options_override[v.name].hover or v.hover
      end
    end
  end

  if self.optionwidgets then
    for k,v in pairs(self.optionwidgets) do
      v:Kill()
    end
    self.optionwidgets = {}
    if self.options_scroll_list then
      self.options_scroll_list:Kill()
      self.options_scroll_list = {}
    end
    local Widget = require "widgets/widget"
    local Text = require "widgets/text"
    local Spinner = require "widgets/spinner"
    local ScrollableList = require "widgets/scrollablelist"

    local lepanel = Widget("option")
    lepanel.letext = lepanel:AddChild(Text( _G.NEWFONT, 25, [[大家好! 這裡是遊戲內選單!
        在這裡你可以在遊戲時改變設定，而不必重新啟動 / 重新連線。
        我希望這個 MOD 是有用的，可以使你的遊戲體驗更好！
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]] ))
    lepanel.letext:SetColour( 255, 255, 255, 1 )
    lepanel.letext:SetPosition( 325, 10 )
    lepanel.letext:SetRegionSize( 650, 130 )
    lepanel.letext:SetHAlign( _G.ANCHOR_MIDDLE )
    lepanel.letext:SetHoverText( "感謝你使用這個 MOD <3 如果你有什麼建議的話，可以在創意工坊頁面回覆 :)\n（漢化者說明：漢化不完整或導致遊戲奔潰，請反饋！）" )
    lepanel.focus_forward = lepanel.letext
    table.insert(self.optionwidgets, lepanel)

    local i = 1
    local label_width = 340
    while i <= #self.options do
      if self.options[i] then
        local spin_options = {} --{{text="default"..tostring(idx), data="default"},{text="2", data="2"}, }
        local spin_options_hover = {}
        local idx = i
        for _,v in ipairs(self.options[idx].options) do
          table.insert(spin_options, {text=v.description, data=v.data, colour={ 1, 1, 1, 1 }})
          spin_options_hover[v.data] = v.hover
        end

        local opt = Widget("option"..idx)

        local spinner_height = 40
        local spinner_width = 240
        opt.spinner = opt:AddChild(Spinner( spin_options, spinner_width, nil, {font=_G.NEWFONT, size=25}, nil, nil, nil, true, 200, nil))
        opt.spinner:SetTextColour(255,255,255,1)
        local default_value = self.options[idx].value
        if default_value == nil then default_value = self.options[idx].default end

        opt.spinner.OnChanged =
        function( _, data )
          self.options[idx].value = data
          opt.spinner:SetHoverText( spin_options_hover[data] or "" )
          self:MakeDirty()
        end
        opt.spinner:SetSelected(default_value)
        opt.spinner:SetHoverText( spin_options_hover[default_value] or "" )
        opt.spinner:SetPosition( 475+70, 0, 0 )

        local label = opt.spinner:AddChild( Text( _G.NEWFONT, 25, (self.options[idx].label or self.options[idx].name) or STRINGS.UI.MODSSCREEN.UNKNOWN_MOD_CONFIG_SETTING ) )
        label:SetColour( 255, 255, 255, 1 )
        label:SetPosition( -label_width/2 - 220, 0, 0 )
        label:SetRegionSize( label_width+150, 50 )
        label:SetHAlign( _G.ANCHOR_RIGHT )
        label:SetHoverText( self.options[idx].hover or "" )
        if _G.TheInput:ControllerAttached() then
          opt:SetHoverText( self.options[idx].hover or "" )
        end

        opt.spinner.OnGainFocus = function()
          Spinner._base.OnGainFocus(self)
          opt.spinner:UpdateBG()
        end
        opt.focus_forward = opt.spinner

        opt.id = idx

        table.insert(self.optionwidgets, opt)
        i = i + 1
      end
    end

    self.default_focus = self.optionwidgets[1]

    self.options_scroll_list = self.optionspanel:AddChild(ScrollableList(self.optionwidgets, 700, 350, 40, 10))
    if self.options_scroll_list.scroll_bar_line:IsVisible() then
      self.options_scroll_list:SetPosition(20, 0)
    else
      self.options_scroll_list:SetPosition(0, 0)
    end
  end
end)
