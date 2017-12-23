AddClassPostConstruct("widgets/minimapwidget", function(self)
    function self:SetOpen( state )
      if state == nil then state = true end

      if state then
        self.open = true
        local newbuttonpos = _G.Point(0, -self.mapsize.h/2, 0)
        self.togglebutton.o_pos = newbuttonpos
        self.togglebutton:SetPosition(newbuttonpos:Get())
        self.togglebutton:SetText("关闭小地图")
        self.togglebutton.image:SetTint(1, 1, 1, 0.75)
        self.img:Show()
        self.bg:SetPosition( 0,0,0 )
        self.bg:SetSize( self.mapsize.w, self.mapsize.h )
        self:EnableMinimapUpdating()
      else
        self.open = false
        local newbuttonpos = _G.Point(0, self.mapsize.h/2 - 20, 0)
        self.togglebutton.o_pos = newbuttonpos
        self.togglebutton:SetPosition(newbuttonpos:Get())
        self.togglebutton:SetText("打开小地图")
        self.togglebutton.image:SetTint(1, 1, 1, 0.2)
        self.img:Hide()
        self.bg:SetPosition( 0, self.mapsize.h/2 - 20, 0 )
        self.bg:SetSize( self.mapsize.w, 5 )
        self:DisableMinimapUpdating()
      end
    end

    if self.togglebutton then
      if self:IsOpen() then
        self.togglebutton:SetText("关闭小地图")
        self.togglebutton.image:SetTint(1, 1, 1, 0.75)
      else
        self.togglebutton:SetText("打开小地图")
        self.togglebutton.image:SetTint(1, 1, 1, 0.2)
      end
    end

  end)
