local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function SetPoisonous(self) 
    self.stimuli = "poisonous" 
end

local _OnAttack
local function OnAttack(self, attacker, target, ...)
    _OnAttack(self, attacker, target, ...)
    
    if self.inst.components.obsidiantool then
        self.inst.components.obsidiantool:Use(attacker, target)
    end
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("weapon", function(cmp)


cmp.SetPoisonous = SetPoisonous
_OnAttack = cmp.OnAttack
cmp.OnAttack = OnAttack


end)
