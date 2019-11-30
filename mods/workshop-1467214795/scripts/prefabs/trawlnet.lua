local MakeVisualBoatEquip = require("prefabs/visualboatequip")

local net_assets=
{
    Asset("ANIM", "anim/swap_trawlnet.zip"),
    Asset("ANIM", "anim/swap_trawlnet_half.zip"),
    Asset("ANIM", "anim/swap_trawlnet_full.zip"),
}

local dropped_assets=
{
    Asset("ANIM", "anim/swap_trawlnet.zip"),
    -- Asset("ANIM", "anim/ui_chest_3x2.zip"),
}

local chance =
{
    verylow = 1,
    low = 2,
    medium = 4,
    high = 8,
}

local loot =
{
    shallow =
    {
     
        {"roe", chance.medium},

        {"seaweed", chance.high},
        {"mussel", chance.medium},
        {"lobster", chance.low},
        {"jellyfish", chance.low},
        {"fish", chance.medium},
        {"coral", chance.medium},
        {"messagebottleempty", chance.medium},
        {"fish_med", chance.low},
        {"rocks", chance.high},
    },


    medium =
    {
        {"roe", chance.medium},

        {"seaweed", chance.high},
        {"mussel", chance.high},
        {"lobster", chance.low},
        {"jellyfish", chance.medium},
        {"fish", chance.high},
        {"coral", chance.high},
        {"fish_med", chance.medium},
        {"messagebottleempty", chance.medium},
        {"boneshard", chance.medium},
        {"spoiled_fish", chance.medium},
        {"dubloon", chance.low},
        {"goldnugget", chance.low},
        {"telescope", chance.verylow},
        {"firestaff", chance.verylow},
        {"icestaff", chance.verylow},
        {"panflute", chance.verylow},
        {"trinket_ia_16", chance.low},
        {"trinket_ia_17", chance.medium},
        {"trinket_ia_18", chance.verylow},
    },

    deep =
    {
        {"roe", chance.low},

        {"seaweed", chance.high},
        {"mussel", chance.high},
        {"lobster", chance.low},
        {"jellyfish", chance.high},
        {"fish", chance.high},
        {"coral", chance.high},
        {"fish_med", chance.high},
        {"messagebottleempty", chance.medium},
        {"boneshard", chance.medium},
        {"spoiled_fish", chance.medium},
        {"dubloon", chance.medium},
        {"goldnugget", chance.medium},
        {"telescope", chance.low},
        {"firestaff", chance.low},
        {"icestaff", chance.low},
        {"panflute", chance.low},
        {"redgem", chance.low},
        {"bluegem", chance.low},
        {"purplegem", chance.low},
        {"goldenshovel", chance.low},
        {"goldenaxe", chance.low},
        {"razor", chance.low},
        {"spear", chance.low},
        {"compass", chance.low},
        {"amulet", chance.verylow},
        {"trinket_ia_16", chance.low},
        {"trinket_ia_17", chance.low},
        {"trinket_ia_18", chance.verylow},
        {"trident", chance.verylow},
    }
}

local hurricaneloot =
{
    shallow =
    {

        {"roe", chance.medium},

        {"seaweed", chance.high},
        {"mussel", chance.medium},
        {"lobster", chance.medium},
        {"jellyfish", chance.medium},
        {"fish", chance.high},
        {"coral", chance.high},
        {"messagebottleempty", chance.high},
        {"fish_med", chance.medium},
        {"rocks", chance.high},
        {"dubloon", chance.low},
        {"trinket_ia_16", chance.low},
        {"trinket_ia_17", chance.low},
    },


    medium =
    {
         {"roe", chance.medium},

        {"seaweed", chance.high},
        {"mussel", chance.high},
        {"lobster", chance.medium},
        {"jellyfish", chance.high},
        {"fish", chance.high},
        {"coral", chance.high},
        {"fish_med", chance.high},
        {"messagebottleempty", chance.high},
        {"boneshard", chance.high},
        {"spoiled_fish", chance.high},
        {"dubloon", chance.medium},
        {"goldnugget", chance.medium},
        {"telescope", chance.low},
        {"firestaff", chance.low},
        {"icestaff", chance.low},
        {"panflute", chance.low},
        {"trinket_ia_16", chance.low},
        {"trinket_ia_17", chance.low},
        {"trinket_ia_18", chance.verylow},
        {"trident", chance.verylow},
    },


    deep =
    {
        {"roe", chance.low},

        {"seaweed", chance.high},
        {"mussel", chance.high},
        {"lobster", chance.low},
        {"jellyfish", chance.high},
        {"fish", chance.high},
        {"coral", chance.high},
        {"fish_med", chance.high},
        {"messagebottleempty", chance.high},
        {"boneshard", chance.high},
        {"spoiled_fish", chance.high},
        {"dubloon", chance.medium},
        {"goldnugget", chance.medium},
        {"telescope", chance.medium},
        {"firestaff", chance.low},
        {"icestaff", chance.medium},
        {"panflute", chance.medium},
        {"redgem", chance.medium},
        {"bluegem", chance.medium},
        {"purplegem", chance.medium},
        {"goldenshovel", chance.medium},
        {"goldenaxe", chance.medium},
        {"razor", chance.medium},
        {"spear", chance.medium},
        {"compass", chance.medium},
        {"amulet", chance.verylow},
        {"trinket_ia_16", chance.medium},
        {"trinket_ia_17", chance.medium},
        {"trinket_ia_18", chance.verylow},
        {"trident", chance.low},
    }
}

local dryloot =
{
    shallow =
    {
        {"seaweed", chance.high},
        {"mussel", chance.high},
        {"lobster", chance.medium},
        {"jellyfish", chance.medium},
        {"fish", chance.high},
        {"coral", chance.high},
        {"messagebottleempty", chance.high},
        {"fish_med", chance.medium},
        {"rocks", chance.high},
        {"dubloon", chance.low},
        {"obsidian", chance.high},
    },


    medium =
    {
        {"seaweed", chance.high},
        {"mussel", chance.high},
        {"lobster", chance.medium},
        {"jellyfish", chance.high},
        {"fish", chance.high},
        {"coral", chance.high},
        {"fish_med", chance.high},
        {"messagebottleempty", chance.high},
        {"boneshard", chance.high},
        {"spoiled_fish", chance.high},
        {"dubloon", chance.medium},
        {"goldnugget", chance.medium},
        {"telescope", chance.low},
        {"firestaff", chance.medium},
        {"icestaff", chance.low},
        {"panflute", chance.low},
        {"obsidian", chance.medium},
        {"trinket_ia_16", chance.low},
        {"trinket_ia_17", chance.low},
        {"trinket_ia_18", chance.verylow},
        {"trident", chance.verylow},
    },


    deep =
    {
        {"seaweed", chance.high},
        {"mussel", chance.high},
        {"lobster", chance.low},
        {"jellyfish", chance.high},
        {"fish", chance.high},
        {"coral", chance.high},
        {"fish_med", chance.high},
        {"messagebottleempty", chance.high},
        {"boneshard", chance.high},
        {"spoiled_fish", chance.high},
        {"dubloon", chance.medium},
        {"goldnugget", chance.medium},
        {"telescope", chance.medium},
        {"firestaff", chance.medium},
        {"icestaff", chance.low},
        {"panflute", chance.medium},
        {"redgem", chance.medium},
        {"bluegem", chance.medium},
        {"purplegem", chance.medium},
        {"goldenshovel", chance.medium},
        {"goldenaxe", chance.medium},
        {"razor", chance.medium},
        {"spear", chance.medium},
        {"compass", chance.medium},
        {"amulet", chance.verylow},
        {"obsidian", chance.medium},
        {"trinket_ia_16", chance.low},
        {"trinket_ia_17", chance.low},
        {"trinket_ia_18", chance.verylow},
        {"trident", chance.low},
    }
}

local uniqueItems =
{
    "trinket_ia_16",
    "trinket_ia_17",
    "trinket_ia_18",
    "trident",
}

local function gettrawlbuild(inst)
	if not inst.components.inventory then return "swap_trawlnet" end
    local fullness = inst.components.inventory:NumItems()/inst.components.inventory.maxslots
    if fullness <= 0.33 then
        return "swap_trawlnet"
    elseif fullness <= 0.66 then
        return "swap_trawlnet_half"
    else
        return "swap_trawlnet_full"
    end
end

local function ontrawlpickup(inst, numitems, pickup)
    local owner = inst.components.inventoryitem.owner
    local sailor = nil

    if owner and owner.components.sailable then
        sailor = owner.components.sailable.sailor
        if inst.visual then
            inst.visual.AnimState:SetBuild(gettrawlbuild(inst))
        end
        if sailor then
            sailor:PushEvent("trawlitem")
            inst.trawlitem:set_local(true)
            inst.trawlitem:set(true)
        end
    end

    inst.SoundEmitter:PlaySound("ia/common/trawl_net/collect")
end


local function updatespeedmult(inst)
    local fullpenalty = TUNING.TRAWLING_SPEED_MULT
    local penalty = fullpenalty * (inst.components.inventory:NumItems()/TUNING.TRAWLNET_MAX_ITEMS)

    local owner = inst.components.inventoryitem.owner
    if owner and owner.components.sailable then
        local sailor = owner.components.sailable.sailor
        if sailor then
            sailor.components.locomotor:SetExternalSpeedMultiplier(inst, "TRAWL", 1 - penalty)
        end
    end
end

local function pickupitem(inst,pickup)
    if pickup then
        print("Trawl net caught a...", pickup.prefab)
        local num = inst.components.inventory:NumItems()
        inst.components.inventory:GiveItem(pickup, num + 1)
        ontrawlpickup(inst, num + 1, pickup)

        if inst.components.inventory:IsFull() then
            local owner = inst.components.inventoryitem.owner
            if owner then
                if owner.components.sailable and owner.components.sailable.sailor then
                    owner.components.sailable.sailor:PushEvent("trawl_full")
                end
                owner.components.container:DropItem(inst)
            end
        else
            updatespeedmult(inst)
        end
    end
end

local specialCasePrefab =
{
    ["seaweed_planted"] = function(inst,net)
        if inst and inst.components.pickable then
            if inst.components.pickable.canbepicked
            and inst.components.pickable.caninteractwith then
                pickupitem(net, SpawnPrefab(inst.components.pickable.product))
            end            
            inst:Remove()
            return SpawnPrefab("seaweed_stalk")            
        end
    end,
    ["jellyfish_planted"] = function(inst)
        inst:Remove()
        return SpawnPrefab("jellyfish")
    end,
    ["mussel_farm"] = function(inst,net)
        if inst then     
            if inst.growthstage <= 0 then                              
                inst:Remove()
                return SpawnPrefab(inst.components.pickable.product)  
            end
        end
    end,
    ["sunkenprefab"] = function(inst)
		local record = inst.components.sunkenprefabinfo:GetSunkenPrefab()
		if not record or not record.prefab then record = {prefab = ""} end --prevent crash from missing record
        local sunken = SpawnSaveRecord(record)
		if sunken and sunken:IsValid() then --might be nil if the thing is a prefab from a no-longer-enabled mod
			sunken:LongUpdate(inst.components.sunkenprefabinfo:GetTimeSubmerged() or 0)
		end
        inst:Remove()
        return sunken and sunken:IsValid() and sunken
    end,
    ["lobster"] = function(inst)
        return inst
    end,
}

local function isItemUnique(item)
    for i = 1, #uniqueItems do
        if uniqueItems[i] == item then
            return true
        end
    end
    return false
end

local function hasUniqueItem(inst)
    for k,v in pairs(inst.components.inventory.itemslots) do
        for i = 1, #uniqueItems do
            if uniqueItems[i] == v then
                return true
            end
        end
    end

    return false
end

local function getLootList(inst)
    local loottable = loot
    if TheWorld.state.iswinter then
        loottable = hurricaneloot
    elseif TheWorld.state.issummer then
        loottable = dryloot
    end

    local owner = inst.components.inventoryitem.owner
    local pos = owner:GetPosition() or inst:GetPosition()
    if owner and owner.components.sailable and owner.components.sailable.sailor then
        pos = owner.components.sailable.sailor:GetPosition()
    end
	
    local tile = GROUND.OCEAN_SHALLOW
    tile = TheWorld.Map:GetTileAtPoint(pos:Get())
    if tile == GROUND.OCEAN_MEDIUM then
        return loottable.medium
    elseif tile == GROUND.OCEAN_DEEP then
        return loottable.deep
    else
        return loottable.shallow
    end
end

local function selectLoot(inst)
    local total = 0
    local lootList = getLootList(inst)

    for i = 1, #lootList do
        total = total + lootList[i][2]
    end

    local choice = math.random(0,total)
    total = 0
    for i = 1, #lootList do
        total = total + lootList[i][2]
        if choice <= total then
            local loot = lootList[i][1]

            --Check if the player has already found one of these
            if isItemUnique(loot) and hasUniqueItem(inst) then
                --If so, pick a different item to give
                loot = selectLoot(inst)
                --NOTE - Possible infinite loop here if only possible loot is unique items.
            end

            return loot
        end
    end
end

local function droploot(inst, owner)
    local chest = SpawnPrefab("trawlnetdropped")
    local pt = inst:GetPosition()

    chest:DoDetach()

    chest.Transform:SetPosition(pt.x, pt.y, pt.z)

    local slotnum = 1
    for k,v in pairs(inst.components.inventory.itemslots) do
        chest.components.container:GiveItem(v, slotnum)
        slotnum = slotnum + 1
    end

    if owner and owner.components.sailable and owner.components.sailable.sailor then
        local sailor = owner.components.sailable.sailor
        local angle = sailor.Transform:GetRotation()
        local dist = -3
        local offset = Vector3(dist * math.cos(angle*DEGREES), 0, -dist*math.sin(angle*DEGREES))
        local chestpos = sailor:GetPosition() + offset        
        chest.Transform:SetPosition(chestpos:Get())
        chest:FacePoint(pt:Get())
    end
end

local function generateLoot(inst)
    return SpawnPrefab(selectLoot(inst))
end

local function stoptrawling(inst)
    inst.trawling = false
    if inst.trawltask then
        inst.trawltask:Cancel()
    end
end

local function isBehind(inst, tar)
    local pt = inst:GetPosition()
    local hp = tar:GetPosition()

    local heading_angle = -(inst.Transform:GetRotation())
    local dir = Vector3(math.cos(heading_angle*DEGREES),0, math.sin(heading_angle*DEGREES))

    local offset = (hp - pt):GetNormalized()     
    local dot = offset:Dot(dir)

    local dist = pt:Dist(hp)

    return dot <= 0 and dist >= 1
end

local function updateTrawling(inst)
    if not inst.trawling then
        return
    end

    local owner = inst.components.inventoryitem.owner
    local sailor = nil

    if owner and owner.components.sailable then
        sailor = owner.components.sailable.sailor
    end

    if not sailor then
        print("NO SAILOR IN TRAWLNET?! SOMETHING WENT WRONG!")
        stoptrawling(inst)
        return
    end

    local pickup = nil
    local pos = inst:GetPosition()
    local displacement = pos - inst.lastPos
    inst.distanceCounter = inst.distanceCounter + displacement:Length()

    if inst.distanceCounter > TUNING.TRAWLNET_ITEM_DISTANCE then
        pickup = generateLoot(inst)
        inst.distanceCounter = 0
    end

    inst.lastPos = pos

    if not pickup then
        local range = 2
        pickup = FindEntity(sailor, range, function(item)
            return isBehind(sailor, item)
                and ((item.components.inventoryitem and not item.components.inventoryitem:IsHeld()
				and item.components.inventoryitem.cangoincontainer)
                and item.components.floater
                or specialCasePrefab[item.prefab] ~= nil) end, nil, {"trap", "FX", "NOCLICK", "player"})
    end

	-- I have no idea why FindEntity can detect the NOCLICK sunkenprefab in SW -M
    if not pickup then
        local range = 2
        pickup = FindEntity(sailor, range, function(item)
				return isBehind(sailor, item)
			end, {"sunkenprefab"})
    end
	
    if pickup and specialCasePrefab[pickup.prefab] then
        pickup = specialCasePrefab[pickup.prefab](pickup,inst)
    end

    if pickup then
        pickupitem(inst,pickup)
    end

end

local function starttrawling(inst)
    inst.trawling = true
    inst.lastPos = inst:GetPosition()
    inst.trawltask = inst:DoPeriodicTask(FRAMES * 5, updateTrawling)
    inst.SoundEmitter:PlaySound("ia/common/trawl_net/attach")
end

local function embarked(boat, data)
    local item = boat.components.container:GetItemInBoatSlot(BOATEQUIPSLOTS.BOAT_SAIL)
    starttrawling(item)
    updatespeedmult(item)
end

local function disembarked(boat, data)
    local item = boat.components.container:GetItemInBoatSlot(BOATEQUIPSLOTS.BOAT_SAIL)
    stoptrawling(item)

    if data.sailor.components.locomotor then
        data.sailor.components.locomotor:RemoveExternalSpeedMultiplier(item, "TRAWL")
    end
end

local function onequip(inst, owner)
    if owner.components.boatvisualmanager then
        owner.components.boatvisualmanager:SpawnBoatEquipVisuals(inst, "trawlnet")
    end
    inst.components.inventoryitem.cangoincontainer = false
    inst:ListenForEvent("embarked", embarked, owner)
    inst:ListenForEvent("disembarked", disembarked, owner)
    updatespeedmult(inst)
	starttrawling(inst)
end

local function onunequip(inst, owner)	
    if owner.components.boatvisualmanager then
        owner.components.boatvisualmanager:RemoveBoatEquipVisuals(inst)
    end
    if owner.components.sailable and owner.components.sailable.sailor then	
        if owner.components.sailable.sailor.components.locomotor then
            owner.components.sailable.sailor.components.locomotor:RemoveExternalSpeedMultiplier(inst, "TRAWL")
        end
    end

    inst:RemoveEventCallback("embarked", embarked, owner)
    inst:RemoveEventCallback("disembarked", disembarked, owner)
    stoptrawling(inst)
	--Only do the following if this entity is not in the process of getting removed already (fixes issue #246 - Duplication Bug)
	if Ents[inst.GUID] then
		droploot(inst, owner)
		inst:DoTaskInTime(2*FRAMES, inst.Remove)
	end
end

local loots = {}

local function net(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

    inst.AnimState:SetBank("trawlnet")
    inst.AnimState:SetBuild("swap_trawlnet")
    inst.AnimState:PlayAnimation("idle")
	
    MakeInventoryPhysics(inst)

    inst:AddTag("trawlnet")
    inst:AddTag("show_invspace")

    inst.trawlitem = net_bool(inst.GUID, "trawlitem", not TheWorld.ismastersim and "trawlitem" or nil)

    if not TheWorld.ismastersim then
        inst:ListenForEvent("trawlitem", function(inst)
            TheLocalPlayer:PushEvent("trawlitem")
        end)
    end

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
    inst:AddComponent("inspectable")

    MakeInvItemIA(inst)

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("inventory")
    inst.components.inventory.maxslots = TUNING.TRAWLNET_MAX_ITEMS

	inst:AddComponent("equippable")
    inst.components.equippable.boatequipslot = BOATEQUIPSLOTS.BOAT_SAIL
    inst.components.equippable.equipslot = nil
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst.currentLoot = {}
    inst.uniqueItemsFound = {}
    inst.distanceCounter = 0
    inst.trawltask = nil
    inst.rowsound = "ia/common/trawl_net/move_LP"
    updatespeedmult(inst)

    return inst
end


local function sink(inst, instant)
    if not instant then
        inst.AnimState:PlayAnimation("sink_pst")
        inst:ListenForEvent("animover", function()
            inst.components.container:DropEverything()            
            inst:Remove()
        end)
    else
        -- this is to catch the nets that for some reason dont have the right timer save data. 
        inst.components.container:DropEverything()
        inst:Remove()
    end
end

local function getsinkstate(inst)
    if inst.components.timer:TimerExists("sink") then
        return "sink"
    elseif inst.components.timer:TimerExists("startsink") then
        return "full"
    end
    return "sink"
end

local function startsink(inst)
    inst.AnimState:PlayAnimation("full_to_sink")
    inst.components.timer:StartTimer("sink", TUNING.TRAWL_SINK_TIME * 1/3)
    inst.AnimState:PushAnimation("idle_"..getsinkstate(inst), true)
end


local function dodetach(inst)
    inst.components.timer:StartTimer("startsink", TUNING.TRAWL_SINK_TIME * 2/3)
    inst.AnimState:PlayAnimation("detach")
    inst.AnimState:PushAnimation("idle_"..getsinkstate(inst), true)
    inst.SoundEmitter:PlaySound("ia/common/trawl_net/detach")
end

local function onopen(inst)
    inst.AnimState:PlayAnimation("interact_"..getsinkstate(inst))
    inst.AnimState:PushAnimation("idle_"..getsinkstate(inst), true)
    inst.SoundEmitter:PlaySound("ia/common/trawl_net/open")
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("interact_"..getsinkstate(inst))
    inst.AnimState:PushAnimation("idle_"..getsinkstate(inst), true)
    inst.SoundEmitter:PlaySound("ia/common/trawl_net/close")
end

local function ontimerdone(inst, data)
    if data.name == "startsink" then
        startsink(inst)
    end

    if data.name == "sink" then
        sink(inst)
    end
    --These are sticking around some times.. maybe the timer name is being lost somehow? This will catch that?
    if data.name ~= "sink" and data.name ~= "startsink" then
        sink(inst)
    end
end


local function getstatusfn(inst, viewer)
    local sinkstate = getsinkstate(inst)
    local timeleft = (inst.components.timer and inst.components.timer:GetTimeLeft("startsink")) or TUNING.TRAWL_SINK_TIME
    if sinkstate == "sink" then
        return "SOON"
    elseif sinkstate == "full" and timeleft <= (TUNING.TRAWL_SINK_TIME * 0.66) * 0.5 then
        return "SOONISH"
    else
        return "GENERIC"
    end
end

local function onloadtimer(inst)
    if not inst.components.timer:TimerExists("sink") and not inst.components.timer:TimerExists("startsink") then
        print("TRAWL NET HAD NO TIMERS AND WAS FORCE SUNK")
        sink(inst, true)
    end
end

local function onload(inst, data)
    inst.AnimState:PlayAnimation("idle_"..getsinkstate(inst), true)    
end

local function dropped_net()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

    inst.Transform:SetTwoFaced()

    inst:AddTag("structure")
    inst:AddTag("chest")

    inst.AnimState:SetBank("trawlnet")
    inst.AnimState:SetBuild("swap_trawlnet")
    inst.AnimState:PlayAnimation("idle_full", true)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    MakeInventoryPhysics(inst)

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatusfn

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("trawlnetdropped")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", ontimerdone)
    inst.onloadtimer = onloadtimer

    inst.DoDetach = dodetach

    -- this task is here because sometimes the savedata on the timer is empty.. so no timers are reloaded.
    -- when that happens, the nets sit around forever. 
    inst:DoTaskInTime(0,function() onloadtimer(inst) end)

    inst.OnLoad = onload

    return inst
end

function trawlnet_visual_common(inst)
    inst.AnimState:SetBank("sail_visual")
    inst.AnimState:SetBuild("swap_trawlnet")
    inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:SetSortWorldOffset(0, -0.05, 0) --below the boat
end

return Prefab("trawlnet", net, net_assets),
    MakeVisualBoatEquip("trawlnet", net_assets, nil, trawlnet_visual_common),
	Prefab("trawlnetdropped", dropped_net, dropped_assets)
	