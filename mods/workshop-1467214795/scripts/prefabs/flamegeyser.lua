local assets=
{
  Asset("ANIM", "anim/geyser.zip"),
  Asset("MINIMAP_IMAGE", "geyser"),
}


local function StartBurning(inst)
  inst.Light:Enable(true)

  inst.components.geyserfx:Ignite()
  inst:AddTag("fire")
end

local function OnIgnite(inst)
  StartBurning(inst)
end

local function OnBurn(inst)
  inst.components.fueled:StartConsuming()
  inst.components.propagator:StartSpreading()
  inst.components.geyserfx:SetPercent(inst.components.fueled:GetPercent())
  inst:AddComponent("cooker")
end

local function SetIgniteTimer(inst)
  inst:DoTaskInTime(GetRandomWithVariance(TUNING.FLAMEGEYSER_REIGNITE_TIME, TUNING.FLAMEGEYSER_REIGNITE_TIME_VARIANCE), function()
      if not inst:HasTag("flooded") then
        inst.components.fueled:SetPercent(1.0)
        OnIgnite(inst)
      end 
    end)
end

local function OnErupt(inst)
  StartBurning(inst)
  inst.components.fueled:SetPercent(1.0)
  OnBurn(inst)
  ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, 0.75, inst, 15)
end

local function OnExtinguish(inst, setTimer)
  inst.AnimState:ClearBloomEffectHandle()
  inst.components.fueled:StopConsuming()
  inst.components.propagator:StopSpreading()
  inst.components.geyserfx:Extinguish()
  if inst.components.cooker then 
    inst:RemoveComponent("cooker")
  end 
  if setTimer ~= false then 
    SetIgniteTimer(inst)
  end
  inst:RemoveTag("fire")
end

local function OnIdle(inst)
  inst.AnimState:PlayAnimation("idle_dormant", true)
  inst.Light:Enable(false)
  inst:StopUpdatingComponent(inst.components.geyserfx)
end

local function onSection(section, oldsection, inst)
	if section == 0 then
		OnExtinguish(inst)
	else
		local damagerange = {2,2,2,2}
		local ranges = {2,2,2,4}
		local output = {4,10,20,40}
		inst.components.propagator.damagerange = damagerange[section]
		inst.components.propagator.propagaterange = ranges[section]
		inst.components.propagator.heatoutput = output[section]
	end
end

local function onFuelUpdate(inst)
	if not inst.components.fueled:IsEmpty() then
		inst.components.geyserfx:SetPercent(inst.components.fueled:GetPercent())
	end
end

local function OnLoad(inst, data)
  if not inst.components.fueled:IsEmpty() then
    OnIgnite(inst)
  else
    SetIgniteTimer(inst)
  end
end

local heats = { 70, 85, 100, 115 }
local function GetHeatFn(inst)
  return 100 --heats[inst.components.geyserfx.level] or 20
end

local function onStartFlooded(inst)
  inst.components.fueled:SetPercent(0)
  OnExtinguish(inst, false)
end


local function onStopFlooded(inst)
  SetIgniteTimer(inst)
end 

local function fn()
  local inst = CreateEntity()
  local trans = inst.entity:AddTransform()
  inst.entity:AddAnimState()
  local light = inst.entity:AddLight()
  local sound = inst.entity:AddSoundEmitter()
  local minimap = inst.entity:AddMiniMapEntity()
  inst.entity:AddNetwork()

  MakeObstaclePhysics(inst, 2.05)
  inst.Physics:SetCollides(false)

  minimap:SetIcon("geyser.tex")
  inst.AnimState:SetBank("geyser")
  inst.AnimState:SetBuild("geyser")
  inst.AnimState:PlayAnimation("idle_dormant", true)
  inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

  inst.Light:EnableClientModulation(true)

	inst:AddComponent("floodable")
	inst.components.floodable:SetFX(nil,.1) --init update faster

	inst:DoTaskInTime(1, function()
		inst.components.floodable:SetFX(nil,10) --now update normal again
	end)

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  inst:AddComponent("inspectable")
  inst:AddComponent("heater")
  inst.components.heater.heatfn = GetHeatFn

  inst:AddComponent("fueled")
  inst.components.fueled.maxfuel = TUNING.FLAMEGEYSER_FUEL_MAX
  inst.components.fueled.accepting = false
  inst:AddComponent("propagator")
  inst.components.propagator.damagerange = 2
  inst.components.propagator.damages = true

  inst.components.fueled:SetSections(4)
  inst.components.fueled.rate = 1
  inst.components.fueled.period = 1

  inst.components.fueled:SetUpdateFn( onFuelUpdate)
  inst.components.fueled:SetSectionCallback( onSection )

  inst.components.fueled:InitializeFuelLevel(TUNING.FLAMEGEYSER_FUEL_START)

	inst.components.floodable.onStartFlooded = onStartFlooded
	inst.components.floodable.onStopFlooded = onStopFlooded

  inst:AddComponent("geyserfx")
  inst.components.geyserfx.usedayparamforsound = true
  inst.components.geyserfx.lightsound = "ia/common/flamegeyser_open"
  --inst.components.geyserfx.extinguishsound = "ia/common/flamegeyser_out"
  inst.components.geyserfx.pre =
  {
    {percent=1.0, anim="active_pre", radius=0, intensity=.8, falloff=.33, colour = {255/255,187/255,187/255}, soundintensity=.1},
    {percent=1.0-(24/42), sound="ia/common/flamegeyser_lp", radius=1, intensity=.8, falloff=.33, colour = {255/255,187/255,187/255}, soundintensity=1},
    {percent=0.0, sound="ia/common/flamegeyser_lp", radius=3.5, intensity=.8, falloff=.33, colour = {255/255,187/255,187/255}, soundintensity=1},
  }
  inst.components.geyserfx.levels =
  {
    {percent=1.0, anim="active_loop", sound="ia/common/flamegeyser_lp", radius=3.5, intensity=.8, falloff=.33, colour = {255/255,187/255,187/255}, soundintensity=1},
  }
  inst.components.geyserfx.pst =
  {
    {percent=1.0, anim="active_pst", sound="ia/common/flamegeyser_lp", radius=3.5, intensity=.8, falloff=.33, colour = {255/255,187/255,187/255}, soundintensity=1},
    {percent=1.0-(61/96), sound="ia/common/flamegeyser_out", radius=0, intensity=.8, falloff=.33, colour = {255/255,187/255,187/255}, soundintensity=.1},
  }


  if not inst.components.fueled:IsEmpty() then
    OnIgnite(inst)
  end

  inst.OnIgnite = OnIgnite
  inst.OnErupt = OnErupt
  inst.OnBurn = OnBurn
  inst.OnIdle = OnIdle

  return inst
end

return Prefab( "flamegeyser", fn, assets)