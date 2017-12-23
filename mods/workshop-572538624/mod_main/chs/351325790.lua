AddClassPostConstruct("screens/geometricoptionsscreen", function(self)
    self.title:SetString("Geometric Placement 选项")
    self.subtitle_geometry:SetString("几何形状")
    self.subtitle_geometry1:SetString("中轴\n对齐")
    self.subtitle_geometry2:SetString("默认\n视角")
    self.subtitle_color:SetString("颜色")
    self.subtitle_misc:SetString("其他")
    self.subtitle_refresh:SetString("刷新速度:")
    self.subtitle_gridsize:SetString("网格大小")
    self.subtitle_gridsize1:SetString("物品")
    self.subtitle_gridsize2:SetString("墙壁")
    self.subtitle_gridsize3:SetString("沙袋")
    self.subtitle_gridsize4:SetString("地皮")
    if self.close_button then self.close_button.text:SetString("关闭") end

    self.grid_button:SetHoverText("是否显示建筑的网格。")
    self.placer_button:SetHoverText("是否隐藏要安置建筑标志\n（你放置建筑的鬼魂版本）。")
    self.cursor_button:SetHoverText("是否隐藏要安置的物品光标")

    --self.geometry_buttons.square:SetText("方形")
    --self.geometry_buttons.diamond:SetText("菱形")
    --self.geometry_buttons.x_hexagon:SetText("X轴六边形")
    --self.geometry_buttons.flat_hexagon:SetText("扁六边形")
    --self.geometry_buttons.z_hexagon:SetText("Z轴六边形")
    --self.geometry_buttons.pointy_hexagon:SetText("尖六边形")

    self.geometry_buttons.square:SetHoverText("与X-Z轴坐标系对齐\n墙壁和地面通常使用这种几何形状")
    self.geometry_buttons.diamond:SetHoverText("旋转 45\176\n默认视角看起来是方形")
    self.geometry_buttons.x_hexagon:SetHoverText("顶边平行于 X 轴的六边形")
    self.geometry_buttons.flat_hexagon:SetHoverText("默认视角看起来顶部是边的六边形")
    self.geometry_buttons.z_hexagon:SetHoverText("顶边平行于 Z 轴的六边形")
    self.geometry_buttons.pointy_hexagon:SetHoverText("默认视角看起来顶部是角的六边形")

    self.color_buttons.redgreen:SetText("红/绿")
    self.color_buttons.redblue:SetText("红/蓝")
    self.color_buttons.blackwhite:SetText("黑/白")
    self.color_buttons.blackwhiteoutline:SetText("黑/白描边")

    self.color_buttons.redgreen:SetHoverText("游戏通常使用的标准的红色和绿色。")
    self.color_buttons.redblue:SetHoverText("蓝色代替绿色，\n帮助红/绿色盲。")
    self.color_buttons.blackwhite:SetHoverText("黑色和白色的网格标识，\n通常更为明显。")
    self.color_buttons.blackwhiteoutline:SetHoverText("黑色和白色，增加了描边来提高可视性。")

    local toggle_strings = {[true] = "关闭这个Mod, 除非按住了控制按键",
      [false]= "启用这个Mod, 除非按住了控制按键"}
    local toggle_state = true
    self.toggle_button:SetOnClick( function()
        toggle_state = not toggle_state
        self.toggle_button.text:SetString(toggle_state and "开" or "关")
        self.toggle_button.image:SetTint(toggle_state and .5 or 1, toggle_state and 1 or .5, .5, 1)
        self.toggle_button.hovertext:SetString(toggle_strings[toggle_state])
        self.callbacks.toggle(toggle_state)
      end)
    self.toggle_button:SetText("开")
    self.toggle_button:SetHoverText("关闭这个Mod, 除非按住了控制按键")

    if self.refresh.options then self.refresh.options[11] = {text = "无限制", data = false} end
    local refreshtext = self.refresh.text
    self.refresh.text = nil
    self.refresh:SetHoverText(
      "多久刷新一次网格。\n停用或设定过高可能会造成延迟。",
      {font = _G.NEWFONT_OUTLINE, size = 22, offset_x = -4, offset_y = 45, colour = {1,1,1,1}})
    self.refresh.text = refreshtext

  end)

