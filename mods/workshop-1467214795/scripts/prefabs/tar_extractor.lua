require "prefabutil"

local assets=
{
	Asset("ANIM", "anim/tar_extractor.zip"),
	Asset("ANIM", "anim/tar_extractor_meter.zip"),	
}

local prefabs=
{
	"tar",
    "collapse_small",
}

local RESOURCE_TIME = TUNING.SEG_TIME*4
local POOP_ANIMATION_LENGTH = 70

local startTar

local function spawnTarProp(inst)
	inst.task_spawn = nil
	local tar = SpawnPrefab("tar")

 	local pt = inst:GetPosition() + Vector3(0,4.5,0)

	-- local right = TheCamera:GetRightVec()
	-- local offset = 1.3
	-- local variation = 0.2
	-- tar.Transform:SetPosition(pt.x + (right.x*offset) +(math.random()*variation),0, pt.z + (right.z*offset)+(math.random()*variation) )
	
	tar.Transform:SetPosition(pt.x + 1, 0, pt.z + 1)
	
	tar.AnimState:PlayAnimation("drop") 
	tar.AnimState:PushAnimation("idle_water",true)	
	--inst:RemoveEventCallback("animover", spawnTarProp )
	if inst.components.machine:IsOn() and not inst.components.fueled:IsEmpty() then
		startTar(inst)
		inst.AnimState:PlayAnimation("active",true)
	else
		inst.AnimState:PlayAnimation("idle", true)
	end
end

local function makeTar(inst)	
	inst.SoundEmitter:PlaySound("ia/common/tar_extractor/poop")
	inst.AnimState:PlayAnimation("poop")	
	inst.task_spawn = inst:DoTaskInTime(POOP_ANIMATION_LENGTH * FRAMES, spawnTarProp)
	inst.task_tar = nil
	--inst:ListenForEvent("animover", spawnTarProp )
end

startTar = function(inst)
	inst.task_tar = inst:DoTaskInTime(RESOURCE_TIME, makeTar )
	inst.task_tar_time = GetTime()
end

local function placeAlign(inst)
	local range = 1
	local pt = inst:GetPosition()
	local tarpits = TheSim:FindEntities(pt.x, pt.y, pt.z, range, {"tarpit"})

	if #tarpits > 0 then
		for k, v in pairs(tarpits) do
			if not v:HasTag("NOCLICK") then
				inst.Transform:SetPosition(v.Transform:GetWorldPosition())
				return true
			end
		end
	end
	return false
end

local function placeTestFn(pt, rot)
	local range = .1
	local tarpits = TheSim:FindEntities(pt.x, pt.y, pt.z, range, {"tarpit"})

	if #tarpits > 0 then
		for k, v in pairs(tarpits) do
			if not v:HasTag("NOCLICK") then
				return true, false
			end
		end
	end
	return false, false
end

local function onBuilt(inst)
	inst.SoundEmitter:PlaySound("ia/common/tar_extractor/craft")
	inst.SoundEmitter:PlaySound("ia/creatures/seacreature_movement/splash_medium")
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle",true)	

	local range = .1
	local pt = inst:GetPosition()
	local tarpits = TheSim:FindEntities(pt.x, pt.y, pt.z, range, {"tarpit"}, nil)
	for i,tarpit in ipairs(tarpits)do
		if tarpit:IsValid() and not tarpit:HasTag("NOCLICK") then
			inst.tarpit = tarpit
			tarpit:AddTag("NOCLICK")
			break
		end		
	end
	
	if not inst.tarpit then
		--This should not happen, panic!
		inst.components.workable:Destroy(inst)
	end
end

local function onRemove(inst, worker)
	if inst.tarpit then
		inst.tarpit:RemoveTag("NOCLICK")
	end
end


local function onhit(inst, worker)
	if not inst:HasTag("burnt") and not inst.task_spawn then
		inst.AnimState:PlayAnimation("hit")
		if inst.components.machine:IsOn() then 
			inst.AnimState:PushAnimation("active",true)
		else
			inst.AnimState:PushAnimation("idle", true)
		end
	end
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnAt("collapse_small", inst)
    fx:SetMaterial("metal")
	inst.SoundEmitter:KillSound("suck")
    inst:Remove()
end

local function TurnOff(inst)
	if inst.task_tar then
		inst.task_tar:Cancel()
		inst.task_tar = nil
		inst.task_tar_time = nil
	end
	inst.components.fueled:StopConsuming()
	inst.AnimState:PlayAnimation("idle", true)
	inst.SoundEmitter:KillSound("suck")
end

local function TurnOn(inst)
	startTar(inst)
	inst.components.fueled:StartConsuming()
	inst.AnimState:PlayAnimation("active", true)
	inst.SoundEmitter:PlaySound("ia/common/tar_extractor/active_LP", "suck")  
end

local function CanInteract(inst)	
	return not inst.components.fueled:IsEmpty()
end

local function OnFuelSectionChange(new, old, inst)
    if inst._fuellevel ~= new then
        inst._fuellevel = new
		inst.AnimState:OverrideSymbol("swap_meter", "tar_extractor_meter", tostring(new))
    end
end

local function OnFuelEmpty(inst)
	inst.components.machine:TurnOff()
end

local function ontakefuelfn(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
	--Turn machine on?
end

local function getstatus(inst, viewer)
	if inst.components.machine.ison then
		if inst.components.fueled
		and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= .25 then
			return "LOWFUEL"
		else
			return "ON"
		end
	else
		return "OFF"
	end
end

local function OnSave(inst, data)
    if inst:HasTag("burnt")
	or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end 

	if inst.task_spawn then
		data.task_spawn = true
    elseif inst.task_tar then
		data.task_tar_time = RESOURCE_TIME - (GetTime() - inst.task_tar_time)
    end
	
	if inst.tarpit then
		data.tarpit = inst.tarpit.GUID
		return {tarpit = inst.tarpit.GUID}
	end
end

local function OnLoad(inst, data)
	if data and data.burnt and inst.components.burnable and inst.components.burnable.onburnt then
        inst.components.burnable.onburnt(inst)
    end

    inst:DoTaskInTime(0, function()
	    if data.task_spawn then
			makeTar(inst)
		elseif data.task_tar_time then
	    	if inst.task_tar then
	    		inst.task_tar:Cancel()
	    		inst.task_tar = nil
	    	end
			inst.task_tar = inst:DoTaskInTime(data.task_tar_time, makeTar )
			inst.task_tar_time = GetTime()    	
	    end
	end)
end

local function OnLoadPostPass(inst, newents, data)
    if data and data.tarpit then
		local tarpit = newents[data.tarpit]
		if tarpit then
			inst.tarpit = tarpit.entity
			inst.tarpit:AddTag("NOCLICK")
			return
		end
    end
	--This should not happen, panic!
	inst.components.workable:Destroy(inst)
end

local function OnSpawn(inst)
    if inst and not inst.tarpit then
		print("Please do not spawn Tar Extractors using the debug console. Consider using c_mat(\"tar_extractor\") to get the crafting materials, and spawn a tar_pool where you want to place the extractor.")
		--This should not happen, panic!
		inst.components.workable:Destroy(inst)
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, .4)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetPriority( 5 )
	minimap:SetIcon( "tar_extractor.tex" )
    
	inst.AnimState:SetBank("tar_extractor")
	inst.AnimState:SetBuild("tar_extractor")
	inst.AnimState:PlayAnimation("idle",true)

	inst.AnimState:OverrideSymbol("swap_meter", "tar_extractor_meter", 10)
	
	inst:AddTag("structure")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
   
	inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)		


	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOn
	inst.components.machine.turnofffn = TurnOff
	inst.components.machine.caninteractfn = CanInteract
	inst.components.machine.cooldowntime = 0.5

	inst:AddComponent("fueled")
	inst.components.fueled:SetDepletedFn(OnFuelEmpty)
    inst.components.fueled:SetTakeFuelFn(ontakefuelfn)
	inst.components.fueled.accepting = true
	inst.components.fueled:SetSections(10)
	inst.components.fueled:SetSectionCallback(OnFuelSectionChange)
	inst.components.fueled:InitializeFuelLevel(TUNING.TAR_EXTRACTOR_MAX_FUEL_TIME)
	inst.components.fueled.bonusmult = 5
	inst.components.fueled.secondaryfueltype = FUELTYPE.CHEMICAL

	--MakeLargeBurnable(inst, nil, nil, true)
	--MakeLargePropagator(inst)
	
	MakeSnowCovered(inst)
	
	inst.OnSave = OnSave 
    inst.OnLoad = OnLoad
    inst.OnLoadPostPass = OnLoadPostPass
	inst.OnRemoveEntity = onRemove
	inst:ListenForEvent( "onbuilt", onBuilt)
	inst:DoTaskInTime(0, OnSpawn)
	
	return inst
end

local function placerfn(inst)
	inst.components.placer.onupdatetransform = placeAlign
	-- inst.components.placer.testfn = placeTestFn
end

return Prefab( "tar_extractor", fn, assets, prefabs ),
MakePlacer( "tar_extractor_placer", "tar_extractor", "tar_extractor", "idle", nil, nil, nil, nil, nil, nil, placerfn)
