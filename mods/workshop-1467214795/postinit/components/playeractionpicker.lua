local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

--replacing the function twice, so logic doesnt need to get copy pasted
local _GetLeftClickActions
local function __GetLeftClickActions(self, position, target, ...)
    if self.leftclickoverride ~= nil then
        local actions, usedefault = self.leftclickoverride(self.inst, target, position)
        if not usedefault or (actions ~= nil and #actions > 0) then
            return _GetLeftClickActions(self, position, target, ...)
        end
    end

    local actions = nil
    local useitem = self.inst.replica.inventory:GetActiveItem()
    local equipitem = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    local boatitem = self.inst.replica.sailor and self.inst.replica.sailor:GetBoat() and self.inst.replica.sailor:GetBoat().replica.container and self.inst.replica.sailor:GetBoat().replica.container:GetItemInBoatSlot(BOATEQUIPSLOTS.BOAT_LAMP)
    local ispassable = self.map:IsPassableAtPoint(position:Get())

	self.disable_right_click = false

	local steering_actions = self:GetSteeringActions(self.inst, position)
	if steering_actions ~= nil then
		self.disable_right_click = true
		return steering_actions
	end

    --if we're specifically using an item, see if we can use it on the target entity
    if useitem ~= nil then
        return _GetLeftClickActions(self, position, target, ...)
    elseif target ~= nil and target ~= self.inst then
        --if we're clicking on a scene entity, see if we can use our equipped object on it, or just use it
        if self.inst.components.playercontroller:IsControlPressed(CONTROL_FORCE_INSPECT) and
            target:HasTag("inspectable") and
            (self.inst.CanExamine == nil or self.inst:CanExamine()) and
            (self.inst.sg == nil or self.inst.sg:HasStateTag("moving") or self.inst.sg:HasStateTag("idle") or self.inst.sg:HasStateTag("channeling")) and
            (self.inst:HasTag("moving") or self.inst:HasTag("idle") or self.inst:HasTag("channeling")) then
            return _GetLeftClickActions(self, position, target, ...)
        elseif self.inst.components.playercontroller:IsControlPressed(CONTROL_FORCE_ATTACK) and target.replica.combat ~= nil and self.inst.replica.combat:CanTarget(target) then
            return _GetLeftClickActions(self, position, target, ...)
        elseif equipitem ~= nil and equipitem:IsValid() and not boatitem then
            return _GetLeftClickActions(self, position, target, ...)
        elseif boatitem ~= nil and boatitem:IsValid() and not equipitem then
            actions = self:GetEquippedItemActions(target, boatitem)
        elseif equipitem ~= nil and equipitem:IsValid() and boatitem ~= nil and boatitem:IsValid() then
            local equip_act = self:GetEquippedItemActions(target, equipitem)

            if self.inst.components.playercontroller:IsControlPressed(CONTROL_FORCE_ATTACK) or GetTableSize(equip_act) == 0 then
                actions = self:GetEquippedItemActions(target, boatitem)
            end

            if not actions or (not self.inst.components.playercontroller:IsControlPressed(CONTROL_FORCE_ATTACK) and GetTableSize(equip_act) > 0) then
                return _GetLeftClickActions(self, position, target, ...)
            end
        end

        if actions == nil or #actions == 0 then
            return _GetLeftClickActions(self, position, target, ...)
        end
    end

    if actions == nil and target == nil and ispassable then
        if equipitem ~= nil and equipitem:IsValid() and not boatitem then
            return _GetLeftClickActions(self, position, target, ...)
        elseif boatitem ~= nil and boatitem:IsValid() and not equipitem then
            actions = self:GetPointActions(position, boatitem)
        elseif equipitem ~= nil and equipitem:IsValid() and boatitem ~= nil and boatitem:IsValid() then
            local equip_act = self:GetPointActions(position, equipitem)

            if self.inst.components.playercontroller:IsControlPressed(CONTROL_FORCE_ATTACK) or GetTableSize(equip_act) == 0 then
                actions = self:GetPointActions(position, boatitem)
            end

            if not actions or (not self.inst.components.playercontroller:IsControlPressed(CONTROL_FORCE_ATTACK) and GetTableSize(equip_act) > 0) then
                return _GetLeftClickActions(self, position, target, ...)
            end
        end
        --this is to make it so you don't auto-drop equipped items when you left click the ground. kinda ugly.
        if actions ~= nil then
            for i, v in ipairs(actions) do
                if v.action == ACTIONS.DROP then
                    table.remove(actions, i)
                    break
                end
            end
        end
        if actions == nil or #actions <= 0 then
            return _GetLeftClickActions(self, position, target, ...)
        end
    end

    return actions or {}
end

local _GetRightClickActions
local function __GetRightClickActions(self, position, target, ...)
	if self.disable_right_click then
		return _GetRightClickActions(self, position, target, ...)
	end
    if self.rightclickoverride ~= nil then
        local actions, usedefault = self.rightclickoverride(self.inst, target, position)
        if not usedefault or (actions ~= nil and #actions > 0) then
            return _GetRightClickActions(self, position, target, ...)
        end
    end

    local actions = nil
    local useitem = self.inst.replica.inventory:GetActiveItem()
    local equipitem = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    local boatitem = self.inst.replica.sailor and self.inst.replica.sailor:GetBoat() and self.inst.replica.sailor:GetBoat().replica.container and self.inst.replica.sailor:GetBoat().replica.container:GetItemInBoatSlot(BOATEQUIPSLOTS.BOAT_LAMP)
    local ispassable = self.map:IsPassableAtPoint(position:Get())

    if target ~= nil and self.containers[target] then
        return _GetRightClickActions(self, position, target, ...)
    elseif useitem ~= nil then
        return _GetRightClickActions(self, position, target, ...)
    elseif target ~= nil and not target:HasTag("walkableplatform") then

        if equipitem ~= nil and equipitem:IsValid() and not boatitem then
            return _GetRightClickActions(self, position, target, ...)
        elseif boatitem ~= nil and boatitem:IsValid() and not equipitem then
            actions = self:GetEquippedItemActions(target, boatitem, true)

            --strip out all other actions for weapons with right click special attacks
            if boatitem.components.aoetargeting ~= nil then
                return (#actions <= 0 or actions[1].action == ACTIONS.CASTAOE) and actions or {}
            end
        elseif equipitem ~= nil and equipitem:IsValid() and boatitem ~= nil and boatitem:IsValid() then
            local equip_act = self:GetEquippedItemActions(target, equipitem, true)

            if self.inst.components.playercontroller:IsControlPressed(CONTROL_FORCE_ATTACK) or GetTableSize(equip_act) == 0 then
                actions = self:GetEquippedItemActions(target, boatitem, true)
                --strip out all other actions for weapons with right click special attacks
                if boatitem.components.aoetargeting ~= nil then
                    return (#actions <= 0 or actions[1].action == ACTIONS.CASTAOE) and actions or {}
                end
            end

            if not actions or (not self.inst.components.playercontroller:IsControlPressed(CONTROL_FORCE_ATTACK) and GetTableSize(equip_act) > 0) then
                return _GetRightClickActions(self, position, target, ...)
            end
        end

        if actions == nil or #actions == 0 then
            return _GetRightClickActions(self, position, target, ...)
        end
    elseif ((equipitem ~= nil and equipitem:IsValid()) or (boatitem ~= nil and boatitem:IsValid())) and (ispassable or (equipitem and equipitem:HasTag("allow_action_on_impassable")) or 
        ((equipitem ~= nil and equipitem.components.aoetargeting ~= nil and equipitem.components.aoetargeting.alwaysvalid and equipitem.components.aoetargeting:IsEnabled()) or
        (boatitem ~= nil and boatitem.components.aoetargeting ~= nil and boatitem.components.aoetargeting.alwaysvalid and boatitem.components.aoetargeting:IsEnabled()))) then
        --can we use our equipped item at the point?

        if (equipitem and equipitem:IsValid()) and not boatitem then
            return _GetRightClickActions(self, position, target, ...)
        elseif (boatitem and boatitem:IsValid()) and not equipitem then
            actions = self:GetPointActions(position, boatitem, true)
        elseif (equipitem and equipitem:IsValid()) and (boatitem and boatitem:IsValid()) then
            local equip_act = self:GetPointActions(position, equipitem, true)

            if self.inst.components.playercontroller:IsControlPressed(CONTROL_FORCE_ATTACK) or GetTableSize(equip_act) == 0 then
                actions = self:GetPointActions(position, boatitem, true)
            end

            if not actions or (not self.inst.components.playercontroller:IsControlPressed(CONTROL_FORCE_ATTACK) and GetTableSize(equip_act) > 0) then
                return _GetRightClickActions(self, position, target, ...)
            end
        end
    end
    if (actions == nil or #actions <= 0) and (target == nil or target:HasTag("walkableplatform")) and ispassable then
        actions = self:GetPointSpecialActions(position, useitem, true)
    end

    if (actions == nil or #actions <= 0) and target == nil and ispassable then
        return _GetRightClickActions(self, position, target, ...)
    end

    return actions or {}
end

local function IsWaterAny(tile)
	return IsWater(tile) or (tile >= GROUND.OCEAN_START and tile <= GROUND.OCEAN_END)
end
local function IsLandRoT(tile)
	return IsLand(tile) and not (tile >= GROUND.OCEAN_START and tile <= GROUND.OCEAN_END)
end

local function GetLeftClickActions(self, position, target, ...)
    local actions = __GetLeftClickActions(self, position, target, ...)

    local x, y, z = self.inst.Transform:GetWorldPosition()
    --lenient player check for water/land, also force the player to be "on land"(if they are technically on water) or "on water"(if they are technically on land) if they have the sailor component.
    local IsWaterBased = IsWaterAny(GetVisualTileType(x, y, z, 1.25 / 4)) and (not self.inst:HasTag("_sailor") or self.inst:HasTag("sailing"))
    local IsLandBased = IsLandRoT(GetVisualTileType(x, y, z, 0.25 / 4)) and (not self.inst:HasTag("_sailor") or not self.inst:HasTag("sailing"))
    --tight cursor check for water/land
    local IsCursorWet = IsWaterAny(GetVisualTileType(position.x, position.y, position.z, 0.001 / 4))
    local IsCursorDry = IsLandRoT(GetVisualTileType(position.x, position.y, position.z, 1.5 / 4))

    if IsWaterBased and not IsCursorWet and not TheInput:ControllerAttached() and (target == nil or not target:CanOnWater()) then 
        if not actions or #actions == 0 or (#actions > 0 and not actions[1].action.instant and not actions[1].action.crosseswaterboundaries) then
            if self.inst:HasTag("_sailor") and self.inst:HasTag("sailing") then
                --Find the landing position, where water meets the land
                local landingPos = nil--position 

                local myPos = self.inst:GetPosition()
                local dir = (position - myPos):GetNormalized()
                local dist = (position - myPos):Length()
                local step = 0.25
                local numSteps = dist/step

                for i = 0, numSteps, 1 do 
                    local testPos = myPos + dir * step * i 
                    local testTile = TheWorld.Map:GetTileAtPoint(testPos.x , testPos.y, testPos.z) 
                    if not IsWaterAny(testTile) then 
                        landingPos = testPos
                        break
                    end 
                end
                if landingPos then 
                    landingPos.x, landingPos.y, landingPos.z = TheWorld.Map:GetTileCenterPoint(landingPos.x, 0, landingPos.z)
                    local action = BufferedAction(self.inst, nil, ACTIONS.DISEMBARK, nil, landingPos)
                    actions = {action}
                end
            else
                actions = nil
            end
        end  
    elseif IsLandBased and not IsCursorDry and not TheInput:ControllerAttached() and (target == nil or not target:CanOnLand()) then 
        if not actions or #actions == 0 or (#actions > 0 and not actions[1].action.instant and not actions[1].action.crosseswaterboundaries) then
            actions = nil
        end 
    end

    return actions or {}
end

local function GetRightClickActions(self, position, target, ...)
    local actions = __GetRightClickActions(self, position, target, ...)

    local x, y, z = self.inst.Transform:GetWorldPosition()
    --lenient player check for water/land, also force the player to be "on land"(if they are technically on water) or "on water"(if they are technically on land) if they have the sailor component.
    local IsWaterBased = IsWater(GetVisualTileType(x, y, z, 1.25 / 4)) and (not self.inst:HasTag("_sailor") or self.inst:HasTag("sailing"))
    local IsLandBased = IsLand(GetVisualTileType(x, y, z, 0.25 / 4)) and (not self.inst:HasTag("_sailor") or not self.inst:HasTag("sailing"))
    --tight cursor check for water/land
    local IsCursorWet = IsWater(GetVisualTileType(position.x, position.y, position.z, 0.001 / 4))
    local IsCursorDry = IsLand(GetVisualTileType(position.x, position.y, position.z, 1.5 / 4))

    if IsWaterBased and not IsCursorWet and not TheInput:ControllerAttached() and (target == nil or not target:CanOnWater()) then 
        if not actions or #actions == 0 or (#actions > 0 and not actions[1].action.instant and not actions[1].action.crosseswaterboundaries) then
            actions = nil
        end  
    elseif IsLandBased and not IsCursorDry and not TheInput:ControllerAttached() and (target == nil or not target:CanOnLand()) then 
        if not actions or #actions == 0 or (#actions > 0 and not actions[1].action.instant and not actions[1].action.crosseswaterboundaries) then
            actions = nil
        end 
    end

    return actions or {}
end

local _SortActionList
local function SortActionList(self, actions, target, useitem)
    local ret = _SortActionList(self, actions, target, useitem)

    if TheWorld.ismastersim then
        for i, action in ipairs(ret) do
            if action.action == ACTIONS.DEPLOY and action.invobject.components.deployable then
				--Why are we doing this anyways? -M
				local pos = action.invobject.components.deployable:GetQuantizedPosition(target)
				action:SetActionPoint(pos)
                return ret
            end
        end
    end

    return ret
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("playeractionpicker", function(cmp)


_GetLeftClickActions = cmp.GetLeftClickActions
cmp.GetLeftClickActions = GetLeftClickActions
_GetRightClickActions = cmp.GetRightClickActions
cmp.GetRightClickActions = GetRightClickActions
_SortActionList = cmp.SortActionList
cmp.SortActionList = SortActionList


end)
