local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _fall_exit
local function fall_exit(inst, ...)
    if IsOnWater(inst) then
        SpawnAt("splash_water_sink", inst)
        inst:Remove()
    end
    if _fall_exit then _fall_exit(inst, ...) end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddStategraphPostInit("frog", function(sg)


if TheWorld.ismastersim then
	_fall_exit = sg.states["fall"].onexit
	sg.states["fall"].onexit = fall_exit
end


end)
