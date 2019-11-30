local prefabs = {
	"jellyfish_planted",
}

local function onspawned(inst, child)
	local pos = child:GetPosition()
	local offset = FindWaterOffset(pos, 2*math.pi*math.random(), 30*math.random(), 4)
	if offset then
		child.Transform:SetPosition((offset + pos):Get())
	end
	SpawnAt("splash_water_drop", child)
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
    --[[Non-networked entity]]

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "jellyfish_planted"
    inst.components.childspawner.spawnoffscreen = true
    inst.components.childspawner:SetRegenPeriod(60)
    inst.components.childspawner:SetSpawnPeriod(.1)
    inst.components.childspawner:SetMaxChildren(5)
    inst.components.childspawner:SetSpawnedFn(onspawned)
	inst.components.childspawner:StartSpawning()

    return inst
end

return Prefab( "jellyfish_spawner", fn, nil, prefabs)
