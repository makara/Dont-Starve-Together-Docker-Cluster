local assets=
{
  Asset("ANIM", "anim/ox_flute.zip"),
}

local function onfinished(inst)
  inst:Remove()
end

local function OnPlayed(inst, musician, instrument)
  TheWorld:PushEvent("ms_forceprecipitation")
end

local function fn()
  local inst = CreateEntity()
  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddNetwork()

  inst:AddTag("flute")

  inst.AnimState:SetBank("ox_flute")
  inst.AnimState:SetBuild("ox_flute")
  inst.AnimState:PlayAnimation("idle")

  inst.flutebuild = "ox_flute"
  inst.flutesymbol = "ox_flute01"

  MakeInventoryPhysics(inst)

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end
  
  inst:AddComponent("inspectable")
  inst:AddComponent("instrument")
  inst.components.instrument.onplayed = OnPlayed
  inst.components.instrument.sound_noloop = "ia/common/ox_flute"    

  inst:AddComponent("tool")
  inst.components.tool:SetAction(ACTIONS.PLAY)

  inst:AddComponent("finiteuses")
  inst.components.finiteuses:SetMaxUses(TUNING.OX_FLUTE_USES)
  inst.components.finiteuses:SetUses(TUNING.OX_FLUTE_USES)
  inst.components.finiteuses:SetOnFinished( onfinished)
  inst.components.finiteuses:SetConsumption(ACTIONS.PLAY, 1)

  MakeInvItemIA(inst, "ox_flute")

  return inst
end

return Prefab( "ox_flute", fn, assets) 
