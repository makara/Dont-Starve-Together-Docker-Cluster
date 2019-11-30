local function IsWaterAny(tile)
	return IsWater(tile) or (tile >= GROUND.OCEAN_START and tile <= GROUND.OCEAN_END)
end

local KeepOnLand = Class(function(self, inst)
    self.inst = inst
    self.inst:StartUpdatingComponent(self)
end)

function KeepOnLand:OnUpdateSw(dt)
    --Ignore if the player is any of this
    if self.inst.sg:HasStateTag("busy") or self.inst:IsAmphibious() or
        (self.inst.components.health and self.inst.components.health:IsDead()) then
        return
    end
    
    local pt = self.inst:GetPosition()

    if self.inst:CanOnLand() and not IsLand(GetVisualTileType(pt.x, pt.y, pt.z, 0.25 / 4)) then
        --Might have run onto water on accident
        local angle = self.inst.Transform:GetRotation()
        angle = angle * DEGREES
        local dist = -1
        local newpt = Vector3(pt.x + dist * math.cos(angle), pt.y, pt.z + dist * -math.sin(angle))
        if not IsLand(GetVisualTileType(newpt.x, newpt.y, newpt.z, 1.5 / 4)) then
            --Okay, try to find any point nearby
            local result_offset = FindGroundOffset(pt, 0, 5, 12)
            newpt = result_offset and pt + result_offset or nil
        end

        if newpt then
            self.inst.Transform:SetPosition(newpt.x, newpt.y, newpt.z)
            if self.inst.components.locomotor then
                self.inst.components.locomotor:Stop()
            end
        elseif self.inst.components.health then 
            self.inst.components.health:Drown()
        end
    elseif self.inst:CanOnWater() and not IsWaterAny(GetVisualTileType(pt.x, pt.y, pt.z, 1.25 / 4))
	and (not GROUND.OCEAN_START or TheWorld.Map:GetTileAtPoint(pt.x,pt.y,pt.z) < GROUND.OCEAN_START) then
        --Failsafe in case there's shore within the edge fog
        if self.inst.components.mapwrapper and self.inst.components.mapwrapper._state ~= 0 then return end

        --Might have run onto land on accident
        local angle = self.inst.Transform:GetRotation()
        angle = angle * DEGREES
        local dist = -1
        local newpt = Vector3(pt.x + dist * math.cos(angle), pt.y, pt.z + dist * -math.sin(angle))
        if not IsWater(GetVisualTileType(newpt.x, newpt.y, newpt.z, 0.001 / 4)) then
            --Okay, try to find any point nearby
            local result_offset = FindWaterOffset(pt, 0, 5, 12)
            newpt = result_offset and pt + result_offset or nil
        end

        if newpt then
            self.inst.Transform:SetPosition(newpt.x, newpt.y, newpt.z)
            if self.inst.components.locomotor then
                self.inst.components.locomotor:Stop()
            end
        elseif self.inst.components.health then
            if self.inst.components.sailor and self.inst.components.sailor.boat then
                local boat = self.inst.components.sailor.boat
                self.inst.components.sailor:Disembark(pt)
                if boat.components.boathealth then
                    boat.components.boathealth:MakeEmpty()
                elseif boat.components.workable then
                    boat.components.workable:Destroy(self.inst)
                end
            else
                --TODO, implement dry drowning properly. -Z
                self.inst.components.health:Kill()
            end
        end
    end
end

function KeepOnLand:OnUpdate(dt)
    --if TheWorld:IsVolcano() then
        --self:OnUpdateVolcano(dt)
    --else
        self:OnUpdateSw(dt)
    --end
end


return KeepOnLand
