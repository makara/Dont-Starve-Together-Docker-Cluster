local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

local function fn(inst)


local tile = TheWorld.Map:GetTileAtPoint(inst:GetPosition():Get())
if tile < GROUND.OCEAN_START or tile > GROUND.OCEAN_END then

    inst.AnimState:SetOceanBlendParams(0)
	
end


end

IAENV.AddPrefabPostInit("float_fx_front", fn)
IAENV.AddPrefabPostInit("float_fx_back", fn)