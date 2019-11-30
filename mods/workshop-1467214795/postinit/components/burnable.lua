local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _SpawnFX
local function SpawnFX(self, ...)
    if self.nofx then
        return
    end
    return _SpawnFX(self, ...)
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("burnable", function(cmp)


_SpawnFX = cmp.SpawnFX
cmp.SpawnFX = SpawnFX


end)
