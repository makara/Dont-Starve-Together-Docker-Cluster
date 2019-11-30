local assets=
{
  Asset("ANIM", "anim/coconut_cannon.zip"),
}

local prefabs = 
{
  "small_puff_light",
  "coconut_chunks",
  "bombsplash",
}

local function onhit(inst) --, thrower, target)
	local pos = inst:GetPosition()
	local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 1.5)

	for k,v in pairs(ents) do
	  if v.components.combat and v ~= inst and v.prefab ~= "leif_palm" then
		v.components.combat:GetAttacked(inst.thrower, TUNING.PALMTREEGUARD_COCONUT_DAMAGE)
	  end
	end

	if IsOnWater(inst) then
	  SpawnAt("bombsplash", pos)
	  inst.SoundEmitter:PlaySound("ia/common/cannonball_impact")
	  inst.SoundEmitter:PlaySound("ia/creatures/seacreature_movement/splash_large")
	else
	  SpawnAt("small_puff_light", pos)
	  if math.random() < 0.05 then
		SpawnAt("coconut", pos)
	  else
		SpawnAt("coconut_chunks", pos)
	  end
	end

	inst:Remove()
end

local function trackheight(inst)
	if inst:GetPosition().y < 0.3 then
		onhit(inst)
	end
end

local function onthrown(inst, thrower, pt, time_to_target)
	inst.Physics:SetFriction(.2)
	inst.Transform:SetFourFaced()
	inst:FacePoint(pt:Get())
	inst.AnimState:PlayAnimation("throw", true)

	local shadow = SpawnPrefab("warningshadow")
	shadow.Transform:SetPosition(pt:Get())
	shadow:shrink(time_to_target, 1.75, 0.5)
	
	inst.thrower = thrower
	inst.TrackHeight = inst:DoPeriodicTask(.1, trackheight)
end

local function onremove(inst)
	if inst.TrackHeight then
		inst.TrackHeight:Cancel()
		inst.TrackHeight = nil
	end
end

local function fn()
  local inst = CreateEntity()
  local trans = inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddSoundEmitter()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst.AnimState:SetBank("coconut_cannon")
  inst.AnimState:SetBuild("coconut_cannon")
  inst.AnimState:PlayAnimation("throw", true)

  inst:AddTag("thrown")
  inst:AddTag("projectile")

  inst.persists = false
  
  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

	inst:AddComponent("throwable")
	inst.components.throwable.onthrown = onthrown
	inst.components.throwable.random_angle = 0
	inst.components.throwable.max_y = 50
	inst.components.throwable.yOffset = 3
	
	inst.OnRemoveEntity = onremove
	
    -- inst:AddComponent("complexprojectile")
    -- inst.components.complexprojectile:SetHorizontalSpeed(10)
    -- -- inst.components.complexprojectile:SetGravity(-35)
    -- inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 3, 0))
    -- inst.components.complexprojectile:SetOnLaunch(onthrown)
    -- inst.components.complexprojectile:SetOnHit(onhit)

  return inst
end

return Prefab("treeguard_coconut", fn, assets, prefabs)