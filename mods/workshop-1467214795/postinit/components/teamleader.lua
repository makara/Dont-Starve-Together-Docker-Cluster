local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function SetKeepThreatFn(self, fn)
  self.keepthreatfn = fn
end

local function KeepThreat(self)
  if self.threat and self.keepthreatfn then
    return self.keepthreatfn(self.inst, self.threat)
  else
    return true
  end
end

local _OnUpdate
local function OnUpdate(self, dt)
  _OnUpdate(self, dt)

  if self.inst and self.inst:IsValid() then
    if self.threat and not self:KeepThreat() then
      self:DisbandTeam()
    end
  end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("teamleader", function(cmp)


-- cmp.keepthreatfn = nil

cmp.SetKeepThreatFn = SetKeepThreatFn
cmp.KeepThreat = KeepThreat
_OnUpdate = cmp.OnUpdate
cmp.OnUpdate = OnUpdate


end)
