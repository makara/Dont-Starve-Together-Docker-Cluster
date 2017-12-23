STRINGS.NAMES.PING_GENERIC = "有趣的地点！"
STRINGS.NAMES.PING_DANGER = "危险！"
STRINGS.NAMES.PING_OMW = "在路上。"
STRINGS.NAMES.PING_EXPLORE = "探索这里！"
STRINGS.NAMES.PING_GOHERE = "到这里来！"

local function Set_gestures(self)
  if self.gestures then
    if self.gestures.omw and self.gestures.omw.text then
      self.gestures.omw.text:SetString("在路上。")
      self.gestures.omw.text:SetSize(30)
      self.gestures.omw.text:SetScale(1,1,1)
      self.gestures.omw.bg:SetScale(.23*4,.5,0)
    end
    if self.gestures.gohere and self.gestures.gohere.text then
      self.gestures.gohere.text:SetString("到这里来！")
      self.gestures.gohere.text:SetSize(30)
      self.gestures.gohere.text:SetScale(1,1,1)
      self.gestures.gohere.bg:SetScale(.23*5,.5,0)
    end
    if self.gestures.explore and self.gestures.explore.text then
      self.gestures.explore.text:SetString("探索这里！")
      self.gestures.explore.text:SetSize(30)
      self.gestures.explore.text:SetScale(1,1,1)
      self.gestures.explore.bg:SetScale(.23*5,.5,0)
    end
    if self.gestures.danger and self.gestures.danger.text then
      self.gestures.danger.text:SetString("危险！")
      self.gestures.danger.text:SetSize(30)
      self.gestures.danger.text:SetScale(1,1,1)
      self.gestures.danger.bg:SetScale(.23*3,.5,0)
    end
    if self.gestures.generic and self.gestures.generic.text then
      self.gestures.generic.text:SetString("有趣的地点！")
      self.gestures.generic.text:SetSize(30)
      self.gestures.generic.text:SetScale(1,1,1)
      self.gestures.generic.bg:SetScale(.23*6,.5,0)
    end
    if self.gestures.cancel and self.gestures.cancel.text then
      self.gestures.cancel.text:SetString("取消")
      self.gestures.cancel.text:SetSize(30)
      self.gestures.cancel.text:SetScale(1,1,1)
      self.gestures.cancel.bg:SetScale(.23*2,.5,0)
    end
    if self.gestures.delete and self.gestures.delete.text then
      self.gestures.delete.text:SetString("删除")
      self.gestures.delete.text:SetSize(30)
      self.gestures.delete.text:SetScale(1,1,1)
      self.gestures.delete.bg:SetScale(.23*2,.5,0)
    end
    if self.gestures.clear and self.gestures.clear.text then
      self.gestures.clear.text:SetString("全部清除")
      self.gestures.clear.text:SetSize(30)
      self.gestures.clear.text:SetScale(1,1,1)
      self.gestures.clear.bg:SetScale(.23*4,.5,0)
    end
  end
end
--AddClassPostConstruct("widgets/pingwheel", Set_gestures)
AddClassPostConstruct("widgets/mapwidget", function(self) if self.pingwheel then Set_gestures(self.pingwheel) end end)
