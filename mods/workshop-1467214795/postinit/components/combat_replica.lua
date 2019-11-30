local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _IsValidTarget
local function IsValidTarget(self, target, ...)
    local isvalidtarget = _IsValidTarget(self, target, ...)
    if isvalidtarget then
        for i, v in ipairs(self.notags or {}) do
            if target:HasTag(v) then
                return false
            end
        end
        return isvalidtarget
    end
    return false
end

local _CanAttack
local function CanAttack(self, target, ...)
    local canattack, idk = _CanAttack(self, target, ...)
    if canattack then
        for i, v in ipairs(self.notags or {}) do
            if target:HasTag(v) then
                return false, nil
            end
        end
        return canattack, idk
    end
    return canattack, idk
end

local _CanBeAttacked
local function CanBeAttacked(self, attacker, ...)
    if self.canbeattackedfn and not self.canbeattackedfn(self.inst, attacker) then
        return false
    end
    return _CanBeAttacked(self, attacker, ...)
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddClassPostConstruct("components/combat_replica", function(cmp)


_IsValidTarget = cmp.IsValidTarget
cmp.IsValidTarget = IsValidTarget
_CanAttack = cmp.CanAttack
cmp.CanAttack = CanAttack
_CanBeAttacked = cmp.CanBeAttacked
cmp.CanBeAttacked = CanBeAttacked


end)
