local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

--copy with our stuff
local function sink_item(item)
    if not item:IsValid() or item:CanOnWater() then
        return
    end

    local px, py, pz = 0, 0, 0
    if item.Transform ~= nil then
        px, py, pz = item.Transform:GetWorldPosition()
    end

    local fx = SpawnPrefab("splash_water_sink")
    -- local fx = SpawnPrefab("splash_sink")
    fx.Transform:SetPosition(px, py, pz)
	if item.SoundEmitter then
		item.SoundEmitter:PlaySound("ia/common/item_sink")
	end

    -- If the item is irreplaceable, respawn it at the player
    if item:HasTag("irreplaceable") then
        if TheWorld.components.playerspawner ~= nil then
            item.Transform:SetPosition(TheWorld.components.playerspawner:GetAnySpawnPoint())
        else
            -- Our reasonable cases are out... so let's loop to find the portal and respawn there.
            for k, v in pairs(Ents) do
                if v:IsValid() and v:HasTag("multiplayer_portal") then
                    item.Transform:SetPosition(v.Transform:GetWorldPosition())
                end
            end
        end
    else
        local tile = TheWorld.Map:GetTileAtPoint(px, py, pz)

        if (item:HasTag("irreplaceable") or tile ~= GROUND.OCEAN_DEEP)
        and item.components.inventoryitem
        and item.components.inventoryitem.cangoincontainer
        and item.persists
        and not item.nosunkenprefab then
            SpawnPrefab("sunkenprefab"):Initialize(item)
		end
        item:Remove()
    end
end

local function TryToSink(self)
    if self:ShouldSink() then
        self.inst:DoTaskInTime(0, sink_item)
    end
end

local ShouldSink_old
local function ShouldSink(self, ...)
	--as of right now, the effect only runs if not on a land tile, and IA water is land to the game...
	return ShouldSink_old(self, ...) or (self.sinks and not self:IsHeld() and IsOnWater(self.inst))
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("inventoryitem", function(cmp)


	cmp.TryToSink = TryToSink
	ShouldSink_old = cmp.ShouldSink
	cmp.ShouldSink = ShouldSink


end)
