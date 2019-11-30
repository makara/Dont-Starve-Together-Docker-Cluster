local assets = {
}

local prefabs = 
{
  "swordfish",
}

local function fn()
  local inst = CreateEntity()
  inst.entity:AddTransform()
  inst.entity:AddNetwork()

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  inst:AddComponent( "childspawner" )
  inst.components.childspawner:SetRegenPeriod(60)
  inst.components.childspawner:SetSpawnPeriod(55)
  inst.components.childspawner:SetMaxChildren(1)
  inst.components.childspawner.childname = "swordfish"
  inst.components.childspawner.spawnoffscreen = true

  inst.components.childspawner:StartSpawning()

  return inst
end

return Prefab( "swordfish_spawner", fn, assets, prefabs) 