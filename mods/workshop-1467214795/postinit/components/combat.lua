local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function onnotags(self, notags)
    self.inst.replica.combat.notags = notags
end

local function AddDamageModifier(self, key, mod)
    self.attack_damage_modifiers[key] = mod
end
local function RemoveDamageModifier(self, key)
    self.attack_damage_modifiers[key] = nil
end
local function GetDamageModifier(self)
    local mod = 1
    for k,v in pairs(self.attack_damage_modifiers) do
        mod = mod + v
    end
    return mod
end

local function AddPeriodModifier(self, key, mod)
    self.attack_period_modifiers[key] = { mod = mod, effective = self.min_attack_period * mod }
    self:SetAttackPeriod(self.min_attack_period * (1+mod))
end
local function RemovePeriodModifier(self, key)
    if not self.attack_damage_modifiers[key] then return end
    self:SetAttackPeriod(self.min_attack_period - self.attack_period_modifiers[key].effective)
    self.attack_period_modifiers[key] = nil
end

local function GetIsAttackPoison(self, attacker)
    local poisonAttack = false 
    local poisonGasAttack = false 

    if self.inst:HasTag("poisonable") and attacker then 
        if (attacker.components.combat and attacker.components.combat.poisonous) or 
        ((attacker.components.poisonable and attacker.components.poisonable:IsPoisoned() and attacker.components.poisonable.transfer_poison_on_attack) 
        and (attacker.components.combat and not attacker.components.combat:GetWeapon())) then

            poisonAttack = true 

            if (attacker.components.combat and attacker.components.combat.poisonous and attacker.components.combat.gasattack) then 
                poisonGasAttack = true 
            end 
        end 
    end   

    return poisonAttack, poisonGasAttack
end


local _GetAttacked
local function GetAttacked(self, attacker, damage, weapon, stimuli, ...)
    local poisonAttack, poisonGasAttack = self:GetIsAttackPoison(attacker)

    if poisonGasAttack and self.inst.components.poisonable then 
        self.inst.components.poisonable:Poison(true)
        return
    end

    local blocked = false

    if TUNING.DO_SEA_DAMAGE_TO_BOAT and damage and (self.inst.components.sailor and self.inst.components.sailor.boat and self.inst.components.sailor.boat.components.boathealth) then
        local boathealth = self.inst.components.sailor.boat.components.boathealth
        if damage > 0 and not boathealth:IsInvincible() then
            boathealth:DoDelta(-damage, "combat", attacker and attacker.prefab or "NIL")
        else
            blocked = true
        end

        if not blocked then
            self.inst:PushEvent("boatattacked", {attacker = attacker, damage = damage, weapon = weapon, stimuli = stimuli, redirected=false})

            if self.onhitfn then
                self.onhitfn(self.inst, attacker, damage)
            end

            if attacker then
                attacker:PushEvent("onhitother", {target = self.inst, damage = damage, stimuli = stimuli, redirected=false})
                if attacker.components.combat and attacker.components.combat.onhitotherfn then
                    attacker.components.combat.onhitotherfn(attacker, self.inst, damage, stimuli)
                end
            end
        else
            self.inst:PushEvent("blocked", {attacker = attacker})
        end

        return not blocked
    end

    local notblocked = _GetAttacked(self, attacker, damage, weapon, stimuli, ...)

    if notblocked and attacker and poisonAttack and self.inst.components and self.inst.components.poisonable then
        self.inst.components.poisonable:Poison()
    end
end

local _CalcDamage
local function CalcDamage(self, target, weapon, multiplier, ...)
    local dmg = _CalcDamage(self, target, weapon, multiplier, ...)
    local bonus = self.damagebonus or 0 --not affected by multipliers

    return (dmg-bonus) * self:GetDamageModifier() + bonus
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

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("combat", function(cmp)


cmp.poisonstrength = 1

cmp.poisonous = nil
cmp.gasattack = nil

cmp.attack_damage_modifiers = {} -- % modifiers on cmp:CalcDamage()
cmp.attack_period_modifiers = {} -- % modifiers on cmp.min_attack_period

addsetter(cmp, "notags", onnotags)

cmp.AddDamageModifier = AddDamageModifier
cmp.RemoveDamageModifier = RemoveDamageModifier
cmp.GetDamageModifier = GetDamageModifier
cmp.AddPeriodModifier = AddPeriodModifier
cmp.RemovePeriodModifier = RemovePeriodModifier
cmp.GetIsAttackPoison = GetIsAttackPoison

_GetAttacked = cmp.GetAttacked
cmp.GetAttacked = GetAttacked

_CalcDamage = cmp.CalcDamage
cmp.CalcDamage = CalcDamage

_CanAttack = cmp.CanAttack
cmp.CanAttack = CanAttack


end)
