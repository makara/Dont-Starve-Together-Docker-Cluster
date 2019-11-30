local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddPrefabPostInit("mandrake", function(inst)
	
	
	inst.Physics:CollidesWith(COLLISION.WAVES)
	
	
end)
