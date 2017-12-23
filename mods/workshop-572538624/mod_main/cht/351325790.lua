AddClassPostConstruct("screens/geometricoptionsscreen", function(self)
    self.title:SetString("Geometric Placement 選項")
    self.subtitle_geometry:SetString("幾何形狀")
    self.subtitle_geometry1:SetString("中軸\n對齊")
    self.subtitle_geometry2:SetString("預設\n視角")
    self.subtitle_color:SetString("顏色")
    self.subtitle_misc:SetString("其他")
    self.subtitle_refresh:SetString("重新整理速度:")
    self.subtitle_gridsize:SetString("網格大小")
    self.subtitle_gridsize1:SetString("物品")
    self.subtitle_gridsize2:SetString("牆壁")
    self.subtitle_gridsize3:SetString("沙袋")
    self.subtitle_gridsize4:SetString("地皮")
    if self.close_button then self.close_button.text:SetString("關閉") end

    self.grid_button:SetHoverText("是否顯示建築的網格。")
    self.placer_button:SetHoverText("是否隱藏要安置建築標誌\n（你放置建築的鬼魂版本）。")
    self.cursor_button:SetHoverText("是否隱藏要安置的物品游標")

    --self.geometry_buttons.square:SetText("方形")
    --self.geometry_buttons.diamond:SetText("菱形")
    --self.geometry_buttons.x_hexagon:SetText("X軸六邊形")
    --self.geometry_buttons.flat_hexagon:SetText("扁六邊形")
    --self.geometry_buttons.z_hexagon:SetText("Z軸六邊形")
    --self.geometry_buttons.pointy_hexagon:SetText("尖六邊形")

    self.geometry_buttons.square:SetHoverText("與X-Z軸座標系對齊\n牆壁和地面通常使用這種幾何形狀")
    self.geometry_buttons.diamond:SetHoverText("旋轉 45\176\n預設視角看起來是方形")
    self.geometry_buttons.x_hexagon:SetHoverText("頂邊平行於 X 軸的六邊形")
    self.geometry_buttons.flat_hexagon:SetHoverText("預設視角看起來頂部是邊的六邊形")
    self.geometry_buttons.z_hexagon:SetHoverText("頂邊平行於 Z 軸的六邊形")
    self.geometry_buttons.pointy_hexagon:SetHoverText("預設視角看起來頂部是角的六邊形")

    self.color_buttons.redgreen:SetText("紅/綠")
    self.color_buttons.redblue:SetText("紅/藍")
    self.color_buttons.blackwhite:SetText("黑/白")
    self.color_buttons.blackwhiteoutline:SetText("黑/白描邊")

    self.color_buttons.redgreen:SetHoverText("遊戲通常使用的標準的紅色和綠色。")
    self.color_buttons.redblue:SetHoverText("藍色代替綠色，\n幫助紅/綠色盲。")
    self.color_buttons.blackwhite:SetHoverText("黑色和白色的網格標識，\n通常更為明顯。")
    self.color_buttons.blackwhiteoutline:SetHoverText("黑色和白色，增加了描邊來提高可視性。")

    local toggle_strings = {[true] = "關閉這個Mod, 除非按住了控制按鍵",
      [false]= "啟用這個Mod, 除非按住了控制按鍵"}
    local toggle_state = true
    self.toggle_button:SetOnClick( function()
        toggle_state = not toggle_state
        self.toggle_button.text:SetString(toggle_state and "開" or "關")
        self.toggle_button.image:SetTint(toggle_state and .5 or 1, toggle_state and 1 or .5, .5, 1)
        self.toggle_button.hovertext:SetString(toggle_strings[toggle_state])
        self.callbacks.toggle(toggle_state)
      end)
    self.toggle_button:SetText("開")
    self.toggle_button:SetHoverText("關閉這個Mod, 除非按住了控制按鍵")

    if self.refresh.options then self.refresh.options[11] = {text = "無限制", data = false} end
    local refreshtext = self.refresh.text
    self.refresh.text = nil
    self.refresh:SetHoverText(
      "多久重新整理一次網格。\n停用或設定過高可能會造成延遲。",
      {font = _G.NEWFONT_OUTLINE, size = 22, offset_x = -4, offset_y = 45, colour = {1,1,1,1}})
    self.refresh.text = refreshtext

  end)

