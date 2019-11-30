local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _DoControllerUseItemOnSceneFromInvTile
local function DoControllerUseItemOnSceneFromInvTile(self, item)
    local is_equipped = item ~= nil and item:IsValid() and item.replica.equippable and item.replica.equippable:IsEquipped()
    if is_equipped then
        self.inst.replica.inventory:ControllerUseItemOnSceneFromInvTile(item)
    else
        _DoControllerUseItemOnSceneFromInvTile(self, item)
    end
end

local _GetGroundUseAction
local function GetGroundUseAction(self, position)
    if self.inst:HasTag("_sailor") and self.inst:HasTag("sailing") then
        if position ~= nil then
            local landingPos = Vector3(TheWorld.Map:GetTileCenterPoint(position.x, 0, position.z))
            if landingPos.x == position.x and landingPos.z == position.z then
                local l = nil
                local r = BufferedAction(self.inst, nil, ACTIONS.DISEMBARK, nil, landingPos)
                return l, r
            end
        else
            --Check if the player is close to land and facing towards it
            local angle = self.inst.Transform:GetRotation() * DEGREES
            local dir = Vector3(math.cos(angle), 0, -math.sin(angle))
            dir = dir:GetNormalized()

            local myPos = self.inst:GetPosition()
            local step = 0.4
            local numSteps = 8 
            local landingPos = nil 

            for i = 0, numSteps, 1 do 
                local testPos = myPos + dir * step * i 
                local testTile = TheWorld.Map:GetTileAtPoint(testPos.x , testPos.y, testPos.z) 
                if not IsWater(testTile) then 
                    landingPos = testPos
                    break
                end 
            end 
            if landingPos then 
                landingPos.x, landingPos.y, landingPos.z = TheWorld.Map:GetTileCenterPoint(landingPos.x, 0, landingPos.z)
                local l = nil
                local r = BufferedAction(self.inst, nil, ACTIONS.DISEMBARK, nil, landingPos)
                return l, r
            end
        end
    end
    return _GetGroundUseAction(self, position)
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("playercontroller", function(cmp)


_DoControllerUseItemOnSceneFromInvTile = cmp.DoControllerUseItemOnSceneFromInvTile
cmp.DoControllerUseItemOnSceneFromInvTile = DoControllerUseItemOnSceneFromInvTile
_GetGroundUseAction = cmp.GetGroundUseAction
cmp.GetGroundUseAction = GetGroundUseAction


if not TheNet:IsDedicated() then
    local _IsVisible = Entity.IsVisible
    local function NO(self)
        return not IsLocalNOCLICKed(self) and _IsVisible(self)
    end

    local _UpdateControllerInteractionTarget = UpvalueHacker.GetUpvalue(cmp.UpdateControllerTargets, "UpdateControllerInteractionTarget")
    UpvalueHacker.SetUpvalue(cmp.UpdateControllerTargets, function(self, dt, x, y, z, dirx, dirz)
        Entity.IsVisible = NO
        _UpdateControllerInteractionTarget(self, dt, x, y, z, dirx, dirz)
        Entity.IsVisible = _IsVisible
    end, "UpdateControllerInteractionTarget")

    --YEAH YEAH, this isn't a player controller post init, but it fits the theme of preventing selection of a entity on the client. -Z
    local TheSimIndex = getmetatable(TheSim).__index
    local _GetEntitiesAtScreenPoint = TheSimIndex.GetEntitiesAtScreenPoint
    function TheSimIndex:GetEntitiesAtScreenPoint(...)
        local entlist = {}
        for i, ent in ipairs(_GetEntitiesAtScreenPoint(self, ...)) do
            if not IsLocalNOCLICKed(ent) then
                entlist[#entlist + 1] = ent
            end
        end
        return entlist
    end
end


end)
