local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddPrefabPostInit("chester", function(inst)
	
	
	inst.Physics:CollidesWith(COLLISION.WAVES)
	
	
end)
