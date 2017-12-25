local SpawnPrefab = GLOBAL.SpawnPrefab

local function ModifyTrapComponent(self)
    -- Remove the inventoryitem component before harvesting, re-add it and
    -- rearm the trap after.
    -- This assumes there are no additional component attributes set, which
    -- currently is the case for trap/birdtrap. In the future, either store/restore
    -- the component or its attributes, or limit it to specific prefabs and check
    -- for future changes.
    local Harvest_original = self.Harvest
    function self:Harvest(doer, ...)
        local was_inventoryitem = self.inst.components.inventoryitem ~= nil

        if was_inventoryitem then
            self.inst:RemoveComponent("inventoryitem")
        end

        Harvest_original(self, doer, ...)

        if self.inst:IsValid() and
           (self.inst.components.finiteuses == nil or
            self.inst.components.finiteuses:GetUses() > 0) then
            if was_inventoryitem then
                self.inst:AddComponent("inventoryitem")
            end

            -- Event handlers (e.g. in stategraphs/SGtrap.lua) will
            -- disarm the trap; thus schedule setting it.
            --~ self.inst:DoTaskInTime(2.0,
                                   --~ function()
                                       --~ -- TODO: Check if it has been picked up in the meantime
                                       --~ self:Set()
                                   --~ end)
            -- Or, assuming event order is kept and processed in a single thread,
            -- simply call the ondropped event handler, which should set it.
            self.inst:PushEvent("ondropped")
        end
    end

    -- Fix a bug which causes traps whose target became invalid
    -- to be uncheckable and prevents them from losing durability.
    local DoSpring_original = self.DoSpring
    function self:DoSpring(...)
        local return_value = DoSpring_original(self, ...)

        self.isset = false
        self.issprung = true

        return return_value
    end
end

AddComponentPostInit("trap", ModifyTrapComponent)
