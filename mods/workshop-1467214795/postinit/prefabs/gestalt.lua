local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

IAENV.AddPrefabPostInit("gestalt", function(inst)


inst:AddTag("amphibious")

if TheWorld.ismastersim then
end


end)