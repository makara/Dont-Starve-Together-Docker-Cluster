require "brains/doydoybrain"
require "stategraphs/SGdoydoy"

local assets_baby =
{
	Asset("ANIM", "anim/doydoy.zip"),
	Asset("ANIM", "anim/doydoy_baby.zip"),
	Asset("ANIM", "anim/doydoy_baby_build.zip"),
	Asset("ANIM", "anim/doydoy_teen_build.zip"),
}

local assets =
{
	Asset("ANIM", "anim/doydoy.zip"),
	Asset("ANIM", "anim/doydoy_adult_build.zip"),
}

local prefabs_baby =
{
	"doydoyfeather",
	"drumstick",
}

local prefabs =
{
	"doydoyfeather",
	"drumstick",
	"doydoy_mate_fx",
}

local babyloot = {"smallmeat","doydoyfeather"}
local teenloot = {"drumstick","doydoyfeather","doydoyfeather"}
local adultloot = {'meat', 'drumstick', 'drumstick', 'doydoyfeather', 'doydoyfeather'}

local babyfoodprefs = {"SEEDS"}
local teenfoodprefs = {"SEEDS", "VEGGIE"}
local adultfoodprefs = {"MEAT", "VEGGIE", "SEEDS", "ELEMENTAL", "WOOD"}

local babysounds = 
{
	eat_pre = "ia/creatures/doydoy/baby/eat_pre",
	swallow = "ia/creatures/doydoy/teen/swallow", --SW bug: baby has no swallow sound
	hatch = "ia/creatures/doydoy/baby/hatch",
	death = "ia/creatures/doydoy/baby/death",
	jump = "ia/creatures/doydoy/baby/jump",
	peck = "ia/creatures/doydoy/teen/peck",
}

local teensounds = 
{
	idle = "ia/creatures/doydoy/teen/idle",
	eat_pre = "ia/creatures/doydoy/teen/eat_pre",
	swallow = "ia/creatures/doydoy/teen/swallow",
	hatch = "ia/creatures/doydoy/teen/hatch",
	death = "ia/creatures/doydoy/teen/death",
	jump = "ia/creatures/doydoy/baby/jump",
	peck = "ia/creatures/doydoy/teen/peck",
}

local function TrackInSpawner(inst)
	if TheWorld.components.doydoyspawner then
		TheWorld.components.doydoyspawner:StartTracking(inst)
	end
end

local function StopTrackingInSpawner(inst)
	if TheWorld.components.doydoyspawner then
		TheWorld.components.doydoyspawner:StopTracking(inst)
	end
end

local function SetBaby(inst)
	inst:AddTag("baby")
	inst:RemoveTag("teen")

	inst.AnimState:SetBank("doydoy_baby")
	inst.AnimState:SetBuild("doydoy_baby_build")
	inst.AnimState:PlayAnimation("idle", true)

	inst.sounds = babysounds
	inst.components.combat:SetHurtSound("ia/creatures/doydoy/baby/hit")

	inst.Transform:SetScale(1, 1, 1)

	inst.components.health:SetMaxHealth(TUNING.DOYDOY_BABY_HEALTH)
	inst.components.locomotor.walkspeed = TUNING.DOYDOY_BABY_WALK_SPEED
	inst.components.locomotor.runspeed = TUNING.DOYDOY_BABY_WALK_SPEED
	inst.components.lootdropper:SetLoot(babyloot)
	inst.components.eater.foodprefs = babyfoodprefs

	inst.components.inventoryitem:ChangeImageName("doydoy_baby")

	inst.components.named:SetName(STRINGS.NAMES.DOYDOYBABY)
end

local function SetTeen(inst)
	inst:AddTag("teen")
	inst:RemoveTag("baby")

	inst.AnimState:SetBank("doydoy")
	inst.AnimState:SetBuild("doydoy_teen_build")
	inst.AnimState:PlayAnimation("idle", true)

	inst.sounds = teensounds
	inst.components.combat:SetHurtSound("ia/creatures/doydoy/hit")

	local scale = TUNING.DOYDOY_TEEN_SCALE
	inst.Transform:SetScale(scale, scale, scale)

	inst.components.health:SetMaxHealth(TUNING.DOYDOY_TEEN_HEALTH)
	inst.components.locomotor.walkspeed = TUNING.DOYDOY_TEEN_WALK_SPEED
	inst.components.locomotor.runspeed = TUNING.DOYDOY_TEEN_WALK_SPEED
	inst.components.lootdropper:SetLoot(teenloot)
	inst.components.eater.foodprefs = teenfoodprefs

	inst.components.inventoryitem:ChangeImageName("doydoy_teen")

	inst.components.named:SetName(STRINGS.NAMES.DOYDOYTEEN)
end

local function SetFullyGrown(inst)
	inst.needtogrowup = true
end

local function GetBabyGrowTime()
	return TUNING.DOYDOY_BABY_GROW_TIME
end

local function GetTeenGrowTime()
	return TUNING.DOYDOY_TEEN_GROW_TIME
end

local growth_stages =
{
	{name="baby", time = GetBabyGrowTime, fn = SetBaby},
	{name="teen", time = GetTeenGrowTime, fn = SetTeen},
	{name="grown", time = GetTeenGrowTime, fn = SetFullyGrown},
}

local function OnEntitySleep(inst)
	if inst.shouldGoAway then
		inst:Remove()
	end
end

local function OnEntityWake(inst)
	inst:ClearBufferedAction()
	--TODO this massive hack is done very improperly
	-- what about the inventory?
	if inst.needtogrowup then
		local grown = SpawnPrefab("doydoy")
		grown.Transform:SetPosition(inst.Transform:GetWorldPosition() )
		grown.Transform:SetRotation(inst.Transform:GetRotation() )
		
		inst:Remove()
	end
end

local function OnInventory(inst)
	inst:ClearBufferedAction()
	inst:AddTag("mating")
end

local function OnDropped(inst)
	inst.components.sleeper:GoToSleep()
	inst:AddTag("mating")
end

local function OnMate(inst, partner)
	
end

local function commonpristinefn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddLightWatcher() --solely for cave sleeping
	inst.entity:AddNetwork()
	inst.entity:AddDynamicShadow()
    
	inst.DynamicShadow:SetSize(1.5, 0.8)
	
	inst.Transform:SetFourFaced()
	
	MakeCharacterPhysics(inst, 50, .5)

	inst.AnimState:SetBank("doydoy")
	inst.AnimState:SetBuild("doydoy_adult_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("doydoy")
	inst:AddTag("companion")
	inst:AddTag("nosteal")
	--nosteal is not exactly SW-accurate, but I don't *want* to find out why SW Primeapes do not steal Doydoys. -M
	
	MakeFeedableSmallLivestockPristine(inst)
	
	return inst
end

local function commonmasterfn(inst)
	MakeInvItemIA(inst)
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem.longpickup = true
	inst.components.inventoryitem:SetSinks(true)

	inst:AddComponent("appeasement")
    inst.components.appeasement.appeasementvalue = TUNING.APPEASEMENT_LARGE
	
	inst:AddComponent("health")
	-- inst:AddComponent("sizetweener")
	inst:AddComponent("sleeper")

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")

	inst:AddComponent("inventory")
	-- inst:AddComponent("entitytracker")
	
	inst:AddComponent("eater")
	-- inst.components.eater:SetCanEatTestFn(CanEatFn) --TODO cannot eat "doydoyegg" (tag)

	inst:ListenForEvent("entitysleep", OnEntitySleep)
	inst:ListenForEvent("entitywake", OnEntityWake)

    MakePoisonableCharacter(inst)
	MakeSmallBurnableCharacter(inst, "swap_fire")
	MakeSmallFreezableCharacter(inst, "mossling_body")

	inst:AddComponent("locomotor")

	inst:AddComponent("combat")
	
	TrackInSpawner(inst)
	inst:ListenForEvent("onremove", StopTrackingInSpawner)

	inst:ListenForEvent("gotosleep", function(inst) inst.components.inventoryitem.canbepickedup = true end)
    inst:ListenForEvent("onwakeup", function(inst) 
    	inst.components.inventoryitem.canbepickedup = false
    	inst:RemoveTag("mating")
    end)

    inst:ListenForEvent("death", function(inst, data) 
    	--If the doydoy is held drop items.
		local owner = inst.components.inventoryitem:GetGrandOwner()

		if inst.components.lootdropper and owner then
			local loots = inst.components.lootdropper:GenerateLoot()
			inst:Remove()
			for k, v in pairs(loots) do
				local loot = SpawnPrefab(v)
				owner.components.inventory:GiveItem(loot)
			end
		end
	end)
	
	MakeFeedableSmallLivestock(inst, TUNING.TOTAL_DAY_TIME, OnInventory, OnDropped)

	return inst
end

local function babyfn(Sim)
	local inst = commonpristinefn(Sim)

	inst.AnimState:SetBank("doydoy_baby")
	inst.AnimState:SetBuild("doydoy_baby_build")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("baby")

	inst.sounds = babysounds
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	commonmasterfn(inst)
	
	inst.components.combat:SetHurtSound("ia/creatures/doydoy/baby/hit")
	inst:AddComponent("named")
	
	inst.components.health:SetMaxHealth(TUNING.DOYDOY_BABY_HEALTH)
	inst.components.locomotor.walkspeed = TUNING.DOYDOY_BABY_WALK_SPEED
	inst.components.locomotor.runspeed = TUNING.DOYDOY_BABY_WALK_SPEED
	inst.components.lootdropper:SetLoot(babyloot)

	inst.components.inventoryitem:ChangeImageName("doydoy_baby")

	inst.components.eater.foodprefs = babyfoodprefs

	inst:SetStateGraph("SGdoydoybaby")
	local brain = require("brains/doydoybrain")
	inst:SetBrain(brain)

	inst:AddComponent("growable")
	inst.components.growable.stages = growth_stages
	-- inst.components.growable.growonly = true
	inst.components.growable:SetStage(1)
	inst.components.growable.growoffscreen = true
	inst.components.growable:StartGrowing()

	return inst
end

local function adultfn(Sim)
	local inst = commonpristinefn(Sim)

	inst.AnimState:SetBank("doydoy")
	inst.AnimState:SetBuild("doydoy_adult_build")
	inst.AnimState:PlayAnimation("idle", true)

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	commonmasterfn(inst)
	
	inst:AddComponent("mateable")
	inst.components.mateable:SetOnMateCallback(OnMate)
	
	inst.components.combat:SetHurtSound("ia/creatures/doydoy/hit")

	inst.components.health:SetMaxHealth(TUNING.DOYDOY_HEALTH)
	inst.components.locomotor.walkspeed = TUNING.DOYDOY_WALK_SPEED
	inst.components.lootdropper:SetLoot(adultloot)

	inst.components.eater.foodprefs = adultfoodprefs
	
	inst:SetStateGraph("SGdoydoy")
	local brain = require("brains/doydoybrain")
	inst:SetBrain(brain)

	return inst
end

return  Prefab("common/monsters/doydoybaby", babyfn, assets_baby, prefabs_baby),
		Prefab("common/monsters/doydoy", adultfn, assets, prefabs)
