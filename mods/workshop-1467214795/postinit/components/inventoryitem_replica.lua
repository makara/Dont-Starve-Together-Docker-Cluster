local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _CanDeploy
local function CanDeploy(self, pt, ...)
	local result = _CanDeploy(self, pt, ...)
	
	if result and self.inst.components.deployable == nil then
		--The item is deployable, but we still need to check for ocean
		--This is client-side by the way
		local tile = GetVisualTileType(pt.x, pt.y, pt.z, 0.375)
		local tileinfo = GetTileInfo(tile)
        local isbuildable, island, iswater = tileinfo.buildable or false, tileinfo.land ~= false, tileinfo.water or false

		if (self.classified.candeployonland:value() and island) or
		(self.classified.candeployonshallowocean:value() and tile == GROUND.OCEAN_SHALLOW) or
		(iswater and
        ((self.classified.candeployonbuildableocean:value() and isbuildable) or
        (self.classified.candeployonunbuildableocean:value() and not isbuildable))) then
			return result
		else
			return false
		end
	end
	
	return result
end

local function DeployAtRange(self)
    if self.inst.components.deployable then
        self.inst.components.deployable:DeployAtRange()
    end
    return self.classified ~= nil and self.classified.deployatrange:value() or false
end

local _SerializeUsage
local function SerializeUsage(self, ...)
    _SerializeUsage(self, ...)
    if self.inst.components.obsidiantool then
        local charge, maxcharge = self.inst.components.obsidiantool:GetCharge()
        self.classified:SerializeObsidianCharge(charge / maxcharge)
    else
        self.classified:SerializeObsidianCharge(nil)
    end

    if self.inst.components.inventory then
        self.classified:SerializeInvSpace(self.inst.components.inventory:NumItems() / self.inst.components.inventory.maxslots)
    else
        self.classified:SerializeInvSpace(nil)
    end
end

local _DeserializeUsage
local function DeserializeUsage(self, ...)
    _DeserializeUsage(self, ...)
    if self.classified ~= nil then
        self.classified:DeserializeObsidianCharge()
        self.classified:DeserializeInvSpace()
    end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddClassPostConstruct("components/inventoryitem_replica", function(cmp)


if TheWorld.ismastersim then
    cmp.inst:ListenForEvent("obsidianchargechange", function(inst, data)
		cmp.classified:SerializeObsidianCharge(data.percent)
	end)
    cmp.inst:ListenForEvent("invspacechange", function(inst, data)
		cmp.classified:SerializeInvSpace(data.percent)
	end)

	local deployable = cmp.inst.components.deployable
	if deployable ~= nil then
		cmp.classified.deployatrange:set(deployable.deployatrange)
		cmp.classified.candeployonland:set(deployable.candeployonland)
		cmp.classified.candeployonshallowocean:set(deployable.candeployonshallowocean)
		cmp.classified.candeployonbuildableocean:set(deployable.candeployonbuildableocean)
		cmp.classified.candeployonunbuildableocean:set(deployable.candeployonunbuildableocean)
	end
end

_CanDeploy = cmp.CanDeploy
cmp.CanDeploy = CanDeploy
cmp.DeployAtRange = DeployAtRange
_SerializeUsage = cmp.SerializeUsage
cmp.SerializeUsage = SerializeUsage
_DeserializeUsage = cmp.DeserializeUsage
cmp.DeserializeUsage = DeserializeUsage


end)