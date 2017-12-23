local function ChangeSeasonClockStrings(self)
  if self.seasonclock and self.seasonclock.UpdateRemainingString then
    local function NewUpdateRemainingString()
      local str = _G.TheWorld.state.remainingdaysinseason
      self.seasonclock._text:SetString("还剩\n" .. _G.math.floor(str+0.5) .. " 天")
      self.seasonclock._showingseasons = false
    end
    self.seasonclock.UpdateRemainingString = NewUpdateRemainingString
  end
end
AddClassPostConstruct( "widgets/controls", ChangeSeasonClockStrings )
local function ChangeUIClockStrings(self)
  STRINGS.UI.HUD.WORLD_CLOCKDAY = "世界\n天数"
end
AddClassPostConstruct("widgets/uiclock", ChangeUIClockStrings)
