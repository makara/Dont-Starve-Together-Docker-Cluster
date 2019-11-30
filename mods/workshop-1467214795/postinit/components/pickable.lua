local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function picked(inst, data)
	if data and data.loot and data.loot.components.visualvariant then
		data.loot.components.visualvariant:CopyOf(data.plant or inst)
	end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("pickable", function(cmp)


cmp.inst:ListenForEvent("picked", picked)


end)
