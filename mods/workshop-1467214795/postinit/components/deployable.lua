local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function ondeployatrange(self, deployatrange)
    if self.inst.replica.inventoryitem ~= nil and self.inst.replica.inventoryitem.classified ~= nil then
        self.inst.replica.inventoryitem.classified.deployatrange:set(deployatrange)
    end
end

local function oncandeployonland(self, candeployonland)
    if self.inst.replica.inventoryitem ~= nil and self.inst.replica.inventoryitem.classified ~= nil then
        self.inst.replica.inventoryitem.classified.candeployonland:set(candeployonland)
    end
end

local function oncandeployonshallowocean(self, candeployonshallowocean)
    if self.inst.replica.inventoryitem ~= nil and self.inst.replica.inventoryitem.classified ~= nil then
        self.inst.replica.inventoryitem.classified.candeployonshallowocean:set(candeployonshallowocean)
    end
end

local function oncandeployonbuildableocean(self, candeployonbuildableocean)
    if self.inst.replica.inventoryitem ~= nil and self.inst.replica.inventoryitem.classified ~= nil then
        self.inst.replica.inventoryitem.classified.candeployonbuildableocean:set(candeployonbuildableocean)
    end
end

local function oncandeployonunbuildableocean(self, candeployonunbuildableocean)
    if self.inst.replica.inventoryitem ~= nil and self.inst.replica.inventoryitem.classified ~= nil then
        self.inst.replica.inventoryitem.classified.candeployonunbuildableocean:set(candeployonunbuildableocean)
    end
end

local function SetQuantizeFunction(self, fn) 
    self.quantizefn = fn 
end 

local function GetQuantizedPosition(self, pt)
    if self.quantizefn then 
        return self.quantizefn(pt)
    end 
    return pt
end

local function DeployAtRange(self)
    return self.deployatrange
end

local _CanDeploy
local function CanDeploy(self, pt, mouseover, deployer, ...)
	local result = _CanDeploy(self, pt, mouseover, deployer, ...)

	if result then
		local tile = GetVisualTileType(pt.x, pt.y, pt.z, 0.375)
		local tileinfo = GetTileInfo(tile)
        local isbuildable, island, iswater = tileinfo.buildable or false, tileinfo.land ~= false, tileinfo.water or false

        if (self.candeployonland and island) or
        (self.candeployonshallowocean and tile == GROUND.OCEAN_SHALLOW) or
        (iswater and
        ((self.candeployonbuildableocean and isbuildable) or
        (self.candeployonunbuildableocean and not isbuildable))) then
			return result
		else
			return false
		end
	end

	return result
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("deployable", function(cmp)


cmp.quantizefn = nil
cmp.SetQuantizeFunction = SetQuantizeFunction
cmp.GetQuantizedPosition = GetQuantizedPosition
cmp.DeployAtRange = DeployAtRange

_CanDeploy = cmp.CanDeploy
cmp.CanDeploy = CanDeploy

addsetter(cmp, "deployatrange", ondeployatrange)
addsetter(cmp, "candeployonland", oncandeployonland)
addsetter(cmp, "candeployonshallowocean", oncandeployonshallowocean)
addsetter(cmp, "candeployonbuildableocean", oncandeployonbuildableocean)
addsetter(cmp, "candeployonunbuildableocean", oncandeployonunbuildableocean)

cmp.deployatrange = false
cmp.candeployonland = true
cmp.candeployonshallowocean = false
cmp.candeployonbuildableocean = false
cmp.candeployonunbuildableocean = false


end)
