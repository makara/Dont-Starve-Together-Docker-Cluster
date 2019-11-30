local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _hop_exit
local function hop_exit(inst, ...)
    if inst.updateWater then
        inst:updateWater()
    end
    if _hop_exit then _hop_exit(inst, ...) end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddStategraphPostInit("bird", function(sg)


_hop_exit = sg.states["hop"].onexit
sg.states["hop"].onexit = hop_exit


end)
