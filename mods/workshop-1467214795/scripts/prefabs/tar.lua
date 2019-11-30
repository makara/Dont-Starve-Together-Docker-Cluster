local itemassets =
{
	Asset("ANIM", "anim/tar.zip"),
}
local assets =
{
	Asset("ANIM", "anim/tar_trap.zip"),
}

local itemprefabs=
{
	"tar_trap",
}

local function onRemove(inst)
	for i,slowedinst in pairs( inst.slowed_objects ) do
		i.slowing_objects[inst] = nil      
	end
end

local function updateslowdowners(inst)

	local x,y,z = inst.Transform:GetWorldPosition() 
	local slowdowns = TheSim:FindEntities(x,y,z, 1.5, {"locomotor"})
	local tempSlowedObjects = {}

	for i=#slowdowns,1,-1 do
		if not slowdowns[i].sg or not slowdowns[i].sg:HasStateTag("moving") then
			table.remove(slowdowns,i)
		end            
	end

	if #slowdowns > 0 then
		if not next(inst.slowed_objects) then
			inst.components.fueled:StartConsuming()
		end
	elseif next(inst.slowed_objects) then
		inst.components.fueled:StopConsuming()
	end

	for i,slowinst in ipairs(slowdowns)do
		if not slowinst.slowing_objects then
			slowinst.slowing_objects  = {}
		end

		slowinst.slowing_objects[inst] = true                    

		tempSlowedObjects[slowinst] = true
	end

	for i,slowedinst in pairs( inst.slowed_objects ) do
		if not tempSlowedObjects[i] then
			i.slowing_objects[inst] = nil
		end       
	end

	inst.slowed_objects = tempSlowedObjects

	--I increased the delay from 2 to 5 frames, because muh performance. -M
	inst:DoTaskInTime(5/30, updateslowdowners)
end

local function updateAnim(inst,section)
	if section == 1 then
		inst.AnimState:PlayAnimation("idle_25")
	elseif section == 2 then
		inst.AnimState:PlayAnimation("idle_50")
	elseif section == 3 then
		inst.AnimState:PlayAnimation("idle_75")                
	elseif section == 4 then
		inst.AnimState:PlayAnimation("idle_full")                
	end
end

local function ontakefuelfn(inst)
	-- inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
	updateAnim(inst,inst.components.fueled:GetCurrentSection())
end

local function sectionfn(section, oldsection, inst)
	if section == 0 then
		--when we burn out
		if inst.components.burnable then
			inst.components.burnable:Extinguish()
		end
	else
		updateAnim(inst, section)
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)

	inst.AnimState:SetLayer( LAYER_BACKGROUND )
	inst.AnimState:SetSortOrder( 3 )
   
	inst.AnimState:SetBank("tar_trap")
	inst.AnimState:SetBuild("tar_trap")

	inst.AnimState:PlayAnimation("idle_full")
	
	-- inst:AddTag("tar_trap") --unused
	-- inst:AddTag("locomotor_slowdown") --unused

	inst.slowed_objects = {}
	inst:DoTaskInTime(1/30, updateslowdowners)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	MakeLargeBurnable(inst, TUNING.SMALL_BURNTIME)
	MakeLargePropagator(inst)

	inst.slowdowners = {}

	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.TAR
	inst.components.fueled.accepting = true
	inst.components.fueled.ontakefuelfn = ontakefuelfn
	inst.components.fueled:SetSections(4)
	inst.components.fueled:InitializeFuelLevel(TUNING.TAR_TRAP_TIME/2)
	inst.components.fueled:SetDepletedFn(inst.Remove)
	inst.components.fueled:SetSectionCallback(sectionfn)

	inst.OnRemoveEntity = onRemove

	return inst
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

local function oncannotbuild(inst)
	inst:Hide()
	for i, v in ipairs(inst.components.placer.linked) do
		v:Hide()
	end
end

local function placerpostinitfn(inst)
	inst.components.placer.onupdatetransform = quantizeplacer
	inst.components.placer.oncannotbuild = oncannotbuild
end

local function ondeploy(inst, pt, deployer)
	--[[
	local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 0.2, {"tar_trap"}) -- or we could include a flag to the search?
	for i, ent in ipairs(ents) do
		ent:Remove()
	end
	]]
	local wall = SpawnPrefab("tar_trap") 

	if wall then
		pt = quantizepos(pt)
		wall.AnimState:PlayAnimation("place")
		wall.AnimState:PushAnimation("idle_full")
		wall.Physics:Teleport(pt.x, pt.y, pt.z)

		inst.components.stackable:Get():Remove()

		wall.SoundEmitter:PlaySound("dontstarve/common/poop_splat")
	end
end

local function itemfn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("tar")
	inst.AnimState:SetBuild("tar")

	inst.AnimState:PlayAnimation("idle")

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.LIGHT, TUNING.WINDBLOWN_SCALE_MAX.LIGHT)

	MakeInvItemIA(inst)
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("tradable")

	inst:AddComponent("inspectable")

	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	inst.components.fuel.secondaryfueltype = FUELTYPE.TAR
	
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	MakeSmallPropagator(inst)

	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = ondeploy
	inst.components.deployable:SetDeploySpacing(0)
	-- inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)
	-- inst.components.deployable.deploydistance = 2

	return inst
end

return Prefab( "tar", itemfn, itemassets, itemprefabs),
	Prefab("tar_trap", fn, assets),
	MakePlacer("tar_placer",  "tar_trap", "tar_trap", "idle_full", false, false, false, 1, nil, nil, placerpostinitfn)
