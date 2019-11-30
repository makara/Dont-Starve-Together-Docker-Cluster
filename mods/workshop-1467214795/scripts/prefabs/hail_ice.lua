local assets =
{
    Asset("ANIM", "anim/ice_hail.zip"),
}

local names = { "f1","f2","f3" }

local function onsave(inst, data)
    data.anim = inst.animname
end

local function onload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname)
    end
end

local function onperish(inst)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil then
        local stacksize = inst.components.stackable:StackSize()
        if owner.components.moisture ~= nil then
            owner.components.moisture:DoDelta(2 * stacksize)
        elseif owner.components.inventoryitem ~= nil then
            owner.components.inventoryitem:AddMoisture(4 * stacksize)
        end
        inst:Remove()
    else
        inst.components.inventoryitem.canbepickedup = false
        inst.AnimState:PlayAnimation("melt")
        inst:ListenForEvent("animover", inst.Remove)
    end
end

local function onfiremelt(inst)
    inst.components.perishable.frozenfiremult = true
end

local function onstopfiremelt(inst)
    inst.components.perishable.frozenfiremult = false
end

--TODO imrpove this function
local function playfallsound(inst)
    local ice_fall_sound =
    {
        [GROUND.BEACH] = "ia/common/ice_fall/beach",
        [GROUND.JUNGLE] = "ia/common/ice_fall/jungle",
        [GROUND.TIDALMARSH] = "ia/common/ice_fall/marsh",
        [GROUND.MAGMAFIELD] = "ia/common/ice_fall/rocks",
        [GROUND.MEADOW] = "ia/common/ice_fall/grass",
        [GROUND.VOLCANO] = "ia/common/ice_fall/rocks",
        [GROUND.ASH] = "ia/common/ice_fall/rocks",
    }
	
    local tile = inst:GetCurrentTileType()
    if ice_fall_sound[tile] ~= nil then
        inst.SoundEmitter:PlaySound(ice_fall_sound[tile])
    end
end

local function onhitground_hail(inst, onwater)
    if not onwater then
        playfallsound(inst)
    else
		inst.persists = false --let the default behaviour handle this
        -- inst:Remove()
    end
end

local function onlanded_hail(inst)
    if IsOnWater(inst) then
		inst.persists = false --let the default behaviour handle this --TODO verify this works in R08_ROT_TURNOFTIDES
        -- inst:Remove()
    else
        playfallsound(inst)
    end
end

local function onlanded_haildrop(inst)
    if not IsOnWater(inst) then --TODO should be a land check
        if math.random() < TUNING.HURRICANE_HAIL_BREAK_CHANCE then
            inst.components.inventoryitem.canbepickedup = false
            inst.AnimState:PlayAnimation("break")
            inst:ListenForEvent("animover", function(inst) inst:Remove() end)
        else
			inst.components.inventoryitem.canbepickedup = true
			inst.persists = true
            -- inst.components.blowinwind:Start()
            inst:RemoveEventCallback("on_landed", onlanded_haildrop)
            -- ChangeToInventoryPhysics(inst)
            --inst.Physics:SetCollisionCallback(nil)
        end
    end
end

local function hail_startfalling(inst, x, y, z)
    -- inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    -- inst.Physics:ClearCollisionMask()
    -- inst.Physics:CollidesWith(COLLISION.GROUND)
    -- inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    -- inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	-- inst.Physics:CollidesWith(COLLISION.WAVES)
    --inst.Physics:SetCollisionCallback(function(inst, other)
    --  if other and other.components.health and other.Physics:GetCollisionGroup() == COLLISION.CHARACTERS then
    --      other.components.health:DoDelta(-TUNING.HURRICANE_HAIL_DAMAGE, false, "hail")
    --  end
    --end)
    inst.Physics:Teleport(x, 35, z)
	inst:ListenForEvent("on_landed", onlanded_haildrop)
    -- inst.components.blowinwind:Stop()
	inst.components.inventoryitem:SetLanded(false, true)
	inst.components.inventoryitem.canbepickedup = false
	inst.persists = false
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ice_hail")
    inst.AnimState:SetBuild("ice_hail")

    inst:AddTag("frozen")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.MEDIUM, TUNING.WINDBLOWN_SCALE_MAX.MEDIUM)

    inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname)

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY/8
    inst.components.edible.degrades_with_spoilage = false
    inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_BRIEF * 1.5

    inst:AddComponent("smotherer")

    inst:ListenForEvent("firemelt", onfiremelt)
    inst:ListenForEvent("stopfiremelt", onstopfiremelt)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(onperish)

    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    MakeInvItemIA(inst)
    inst.components.inventoryitem:SetOnPickupFn(onstopfiremelt)
	inst.components.inventoryitem:SetSinks(true)
	inst.nosunkenprefab = true

    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = MATERIALS.ICE
    inst.components.repairer.perishrepairpercent = .05

    -- inst:AddComponent("bait")
    -- inst:AddTag("molebait")

	inst:ListenForEvent("on_landed", onlanded_hail)

    inst.StartFalling = hail_startfalling
	
    inst.OnSave = onsave 
    inst.OnLoad = onload 

    MakeHauntableLaunchAndSmash(inst)

    return inst
end

return Prefab( "hail_ice", fn, assets)