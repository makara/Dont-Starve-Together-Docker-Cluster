local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _NeedsRepairs
local function NeedsRepairs(self)
    local need = _NeedsRepairs(self)

    if not need and self.inst.components.boathealth then
        return self.inst.components.boathealth:GetPercent() < 1
    end

    return need
end

local _Repair
local function Repair(self, doer, repair_item)
    if self.inst.components.boathealth then
        if repair_item.components.repairer == nil or self.repairmaterial ~= repair_item.components.repairer.repairmaterial then
            --wrong material
            return false
        elseif self.checkmaterialfn ~= nil then
            local success, reason = self.checkmaterialfn(self.inst, repair_item)
            if not success then
                return false, reason
            end
        end

        if self.inst.components.boathealth:GetPercent() >= 1 then
            return false
        end
        self.inst.components.boathealth:DoDelta(repair_item.components.repairer.healthrepairvalue, "repair", repair_item, true)

        if repair_item.components.stackable then
            repair_item.components.stackable:Get():Remove()
        elseif repair_item.components.finiteuses then
            repair_item.components.finiteuses:Use(1)
        else
            repair_item:Remove()
        end

        if self.onrepaired then
            self.onrepaired(self.inst, doer, repair_item)
        end
        return true
    end

    return _Repair(self, doer, repair_item)
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("repairable", function(cmp)


_NeedsRepairs = cmp.NeedsRepairs
cmp.NeedsRepairs = NeedsRepairs
_Repair = cmp.Repair
cmp.Repair = Repair


end)
