local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _DoSpawnChild
local function DoSpawnChild(self, target, prefab, radius, ...)
    if self.inst.prefab == "spiderden" and (prefab == "spider_warrior" or self.childname == "spider_warrior") and IsInIAClimate(self.inst) then
        local _childname = rawget(self, "childname")
        self.childname = "tropical_spider_warrior"
        local child = _DoSpawnChild(self, target, "tropical_spider_warrior", radius, ...)
        self.childname = _childname
        return child
    end
    return _DoSpawnChild(self, target, prefab, radius, ...)
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("childspawner", function(cmp)


_DoSpawnChild = cmp.DoSpawnChild
cmp.DoSpawnChild = DoSpawnChild


end)
