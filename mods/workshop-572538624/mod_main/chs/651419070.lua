AddClassPostConstruct("widgets/aas", function(self)
    if self.servertitle then
      self.servertitle:SetTruncatedString("Auto Actions 配置", 800, 100, true)
    end

    local configuration_options_override = {
      {
        name="autoequipopeningamesettings",
        label="打开设置按钮？",
        longlabel="选择哪个按钮来打开游戏中的设置菜单？",
        options = {},
        default="P",
        hover="在游戏中改变这个是不会工作的。抱歉。",
      },
      {
        name="autoequipignorerestrictions",
        label="Ctrl + 空格覆盖？",
        longlabel="Ctrl + 空格 覆盖限制吗？像挖树苗。",
        options = {
          {description="否", data=0},
          {description="是", data=1},
        },
        hover="例如，如果启用，按住 Ctrl 键，\n按下空格键时将挖出树苗和草丛。",
        default=1,
      },
      {
        name="autoequipweapon",
        label="战斗装备武器？",
        longlabel="当攻击敌人时，装备最好的武器？",
        hover="注：如果启用，它只会在空手情况下装备武器。",
        options={
          {description="否", data=0},
          {description="是", data=1}
        },
        default=1,
      },
      {
        name="autoequipcraftornot",
        label="自动制造工具？",
        longlabel="在做任务时自动制造所需的工具？",
        options={
          {description="否", data=0},
          {description="是", data=1}
        },
        default=0,
      },
      {
        name="autoequipgoldornot",
        label="制作黄金工具？",
        longlabel="当制作工具时，你更喜欢他们是黄金吗？",
        options={
          {description="否", data=0},
          {description="是", data=1}
        },
        default=0,
      },
      --[[{{
      name="autoequipignoretraps",
      label="忽略激活的陷阱？",
      options={
        {description="否", data=0},
        {description="是", data=1}
      },
      default=0,
    },
    {
      name="autoequipreactivatetraps",
      label="自动重新激活陷阱?",
      options={
        {description="否", data=0},
        {description="是", data=1}
      },
      default=0,
    },]]
    {
      name="autoequipreplanttrees",
      label="自动重新植树？",
      longlabel="挖掉树桩后自动重新种植？",
      hover="注：你必须按住动作键直到挖掘出树桩，否则它不会重新种植！",
      options={
        {description="否", data=0},
        {description="是", data=1}
      },
      default=1,
    },
    {
      name="autoequipignoresaplings",
      label="完全忽略树苗吗？",
      longlabel="即使装备了铲子也不会挖树苗？",
      hover="按住空格键时将会忽略树苗, 即使装备了铲子。\n在种植很多树苗时很有用。",
      options={
        {description="否", data=0},
        {description="是", data=1}
      },
      default=0,
    },
    {
      name="autoequiprefuelfires",
      label="(B) 右键重新填充燃料？",
      longlabel="(测试) 是否开启右键重新填充燃料?",
      hover="燃烧顺序：首选 > 其他两个选择 > 别的可燃物",
      options={
        {description="否", data=0},
        {description="木头优先", data=1, hover="优先使用 木头 作为燃料，然后是背包里面的，最后从右到左查看。"},
        {description="树枝优先", data=2, hover="优先使用 树枝 作为燃料，然后是背包里面的，最后从右到左查看。"},
        {description="草优先", data=3, hover="优先使用 草 作为燃料，然后是背包里面的，最后从右到左查看。"}
      },
      default=0,
    },
    {
      name="autoequiprepairwalls",
      label="(B) 右击修复墙吗？",
      longlabel="(测试) 启用右击修复墙吗？",
      hover="注：你需要在你的库存有墙才能这样做。",
      options={
        {description="否", data=0},
        {description="是", data=1}
      },
      default=0,
    },
    {
      name="autoequipboomerang",
      label="对小动物使用回旋镖吗？",
      options={
        {description="否", data=0},
        {description="是", data=1}
      },
      default=0,
    },
    {
      name="autoequiplight",
      label="(B) 黑暗中制作照明？",
      longlabel="(测试) 当站在黑暗中的时候制作照明工具？",
      hover="(测试) 这个功能是非常基本的，将在以后制作。",
      options={
        {description="否", data=0},
        {description="装备", data=1},
        {description="制造&装备", data=2}
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
    lepanel.letext = lepanel:AddChild(Text( _G.NEWFONT, 25, [[大家好! 这里是游戏内菜单!
        在这里你可以在游戏时改变设置，而不必重新启动 / 重新连接。
        我希望这个 MOD 是有用的，可以使你的游戏体验更好！
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]] ))
    lepanel.letext:SetColour( 255, 255, 255, 1 )
    lepanel.letext:SetPosition( 325, 10 )
    lepanel.letext:SetRegionSize( 650, 130 )
    lepanel.letext:SetHAlign( _G.ANCHOR_MIDDLE )
    lepanel.letext:SetHoverText( "感谢你使用这个 MOD <3 如果你有什么建议的话，可以在创意工坊页面回复 :)\n（汉化者说明：汉化不完整或导致游戏奔溃，请反馈！）" )
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
