require "prefabutil"

local assets =
{
  Asset("ANIM", "anim/sandbag_small.zip"),
  Asset("ANIM", "anim/sandbag.zip"),
}

local prefabs =
{
	-- "gridplacer",
	"collapse_small",
}


local function OnIsPathFindingDirty(inst)
    if inst._ispathfinding:value() then
        if inst._pfpos == nil then
            inst._pfpos = inst:GetPosition()
			TheWorld.Pathfinder:AddWall(inst._pfpos.x + 0.5, inst._pfpos.y, inst._pfpos.z + 0.5)
			TheWorld.Pathfinder:AddWall(inst._pfpos.x + 0.5, inst._pfpos.y, inst._pfpos.z - 0.5)
			TheWorld.Pathfinder:AddWall(inst._pfpos.x - 0.5, inst._pfpos.y, inst._pfpos.z + 0.5)
			TheWorld.Pathfinder:AddWall(inst._pfpos.x - 0.5, inst._pfpos.y, inst._pfpos.z - 0.5)
        end
    elseif inst._pfpos ~= nil then
		TheWorld.Pathfinder:RemoveWall(inst._pfpos.x + 0.5, inst._pfpos.y, inst._pfpos.z + 0.5)
		TheWorld.Pathfinder:RemoveWall(inst._pfpos.x + 0.5, inst._pfpos.y, inst._pfpos.z - 0.5)
		TheWorld.Pathfinder:RemoveWall(inst._pfpos.x - 0.5, inst._pfpos.y, inst._pfpos.z + 0.5)
		TheWorld.Pathfinder:RemoveWall(inst._pfpos.x - 0.5, inst._pfpos.y, inst._pfpos.z - 0.5)
        inst._pfpos = nil
    end
end

local function InitializePathFinding(inst)
    inst:ListenForEvent("onispathfindingdirty", OnIsPathFindingDirty)
    OnIsPathFindingDirty(inst)
end

local function makeobstacle(inst)
    inst.Physics:SetActive(true)
    inst._ispathfinding:set(true)
    TheWorld:PushEvent("floodblockercreated",{blocker = inst})
end

local function clearobstacle(inst)
    inst.Physics:SetActive(false)
    inst._ispathfinding:set(false)
    TheWorld:PushEvent("floodblockerremoved",{blocker = inst})
end

local anims =
{
	{ threshold = 0, anim = "rubble" },
	{ threshold = 0.4, anim = "heavy_damage" },
	{ threshold = 0.5, anim = "half" },
	{ threshold = 0.99, anim = "light_damage" },
	{ threshold = 1, anim = "full" },
}

local function resolveanimtoplay(inst, percent)
    for i, v in ipairs(anims) do
        if percent <= v.threshold then
            return v.anim
        end
    end
end

local function onhealthchange(inst, old_percent, new_percent)
    local anim_to_play = resolveanimtoplay(inst, new_percent)
	inst.AnimState:PlayAnimation(anim_to_play)
	if new_percent > 0 and old_percent <= 0 then makeobstacle(inst) end
	if old_percent > 0 and new_percent <= 0 then clearobstacle(inst) end
    -- if new_percent > 0 then
        -- if old_percent <= 0 then
            -- makeobstacle(inst)
        -- end
        -- inst.AnimState:PlayAnimation(anim_to_play.."_hit")
        -- inst.AnimState:PushAnimation(anim_to_play, false)
    -- else
        -- if old_percent > 0 then
            -- clearobstacle(inst)
        -- end
        -- inst.AnimState:PlayAnimation(anim_to_play)
    -- end
end

local function keeptargetfn()
    return false
end

local function onload(inst)
    if inst.components.health:IsDead() then
        clearobstacle(inst)
	else
		makeobstacle(inst)
    end
end

local function onremove(inst)
    inst._ispathfinding:set_local(false)
    OnIsPathFindingDirty(inst)
	if TheWorld.ismastersim and not inst.components.health:IsDead() then
		TheWorld:PushEvent("floodblockerremoved",{blocker = inst})
	end
end

local function quantizepos(pt)
	local x, y, z = TheWorld.Map:GetTileCenterPoint(pt:Get())

	if pt.x > x then
		x = x + 1
	else
		x = x - 1
	end

	if pt.z > z then
		z = z + 1
	else
		z = z - 1
	end

	return Vector3(x,y,z)
end

local function quantizeplacer(inst)
	inst.Transform:SetPosition(quantizepos(inst:GetPosition()):Get())
end

local function placerpostinitfn(inst)
	inst.components.placer.onupdatetransform = quantizeplacer
end

local function ondeploy(inst, pt, deployer)
	local wall = SpawnPrefab("sandbagsmall") 

	if wall then
		pt = quantizepos(pt)

		wall.Physics:SetCollides(false)
		wall.Physics:Teleport(pt.x, pt.y, pt.z) 
		wall.Physics:SetCollides(true)
		inst.components.stackable:Get():Remove()

		wall.SoundEmitter:PlaySound("ia/common/sandbag")

		makeobstacle(wall)
	end
end


local function onhammered(inst, worker)
	local max_loots = 2
	local num_loots = math.max(1, math.floor(max_loots*inst.components.health:GetPercent()))
	for k = 1, num_loots do
		inst.components.lootdropper:SpawnLootPrefab("sand")
	end

	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	-- fx:SetMaterial(data.material)

	inst:Remove()
end

local function onhit(inst)
	inst.SoundEmitter:PlaySound("ia/common/sandbag")		

	local healthpercent = inst.components.health:GetPercent()
	local anim_to_play = resolveanimtoplay(inst, healthpercent)
	inst.AnimState:PushAnimation(anim_to_play)
	-- if healthpercent > 0 then
		-- local anim_to_play = resolveanimtoplay(inst, healthpercent)
		-- inst.AnimState:PlayAnimation(anim_to_play.."_hit")
		-- inst.AnimState:PushAnimation(anim_to_play, false)
	-- end
end

local function onrepaired(inst)
	inst.SoundEmitter:PlaySound("ia/common/sandbag")		
	makeobstacle(inst)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetEightFaced()

	MakeObstaclePhysics(inst, 1)
	inst.Physics:SetDontRemoveOnSleep(true)

    inst:SetDeployExtraSpacing(2) --only works against builder, not against deployables

	inst:AddTag("floodblocker")
	inst:AddTag("sandbag")
	inst:AddTag("wall")
	inst:AddTag("noauradamage")
	inst:AddTag("nointerpolate")

	inst.AnimState:SetBank("sandbag_small")
	inst.AnimState:SetBuild("sandbag_small")
	inst.AnimState:PlayAnimation("full", false)

	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	-- makeobstacle(inst) --TODO don't have position yet!
	inst:DoTaskInTime(0, makeobstacle)
	--Delay this because makeobstacle sets pathfinding on by default
	--but we don't to handle it until after our position is set
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("repairable")
	inst.components.repairable.repairmaterial = MATERIALS.SANDBAGSMALL
	inst.components.repairable.onrepaired = onrepaired

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.SANDBAG_HEALTH)
	inst.components.health.currenthealth = TUNING.SANDBAG_HEALTH
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = true
	inst.components.health.canheal = false
	--apparently not burnable -M
	inst.components.health.fire_damage_scale = 0

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	MakeHauntableWork(inst)

	inst.OnLoad = onload

	return inst      
end

local function itemfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst:AddTag("wallbuilder")

	inst.AnimState:SetBank("sandbag")
	inst.AnimState:SetBuild("sandbag")
	inst.AnimState:PlayAnimation("idle")

	-- MakeInventoryFloatable(inst)
	-- inst.components.floater:UpdateAnimations("idle_water", "idle")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
	return inst
	end

	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = MATERIALS.SANDBAGSMALL
	inst.components.repairer.healthrepairvalue = TUNING.SANDBAG_HEALTH / 2

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst:AddComponent("inspectable")
	MakeInvItemIA(inst)
		inst.components.inventoryitem:SetSinks(true)

	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = ondeploy
	inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)
	-- inst.components.deployable.min_spacing = 0	
	-- inst.components.deployable.placer = "sandbagsmall_placer"
	-- inst.components.deployable:SetQuantizeFunction(quantizepos)
	-- inst.components.deployable.deploydistance = 2

	MakeHauntableLaunch(inst)

	return inst
end

return Prefab( "sandbagsmall", fn, assets, prefabs ),
Prefab( "sandbagsmall_item", itemfn, assets, prefabs ), 
MakePlacer("sandbagsmall_item_placer",  "sandbag_small", "sandbag_small", "full", false, false, false, 1.0, nil, "eight", placerpostinitfn) 
