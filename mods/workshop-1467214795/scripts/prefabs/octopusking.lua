local assets=
{
	Asset("ANIM", "anim/octopus.zip"),
	-- Asset("MINIMAP_IMAGE", "octopus"),
}


local prefabs = 
{
	"dubloon",
	"octopuschest",
	"seaweed",
	"seashell",
	"coral",
	"shark_fin",
	"blubber",
	"sail_palmleaf",
	"sail_cloth",
	"trawlnet",
	"seatrap",
	--"telescope",
	"boat_lantern",
	"piratehat",
	"boatcannon",
}

-- only accept 1 trinket per day and pull up a chest that has multiple  dubloons + items (that we set per trinket)
-- only accept 1 seafood meal per day and pull up a chest with 1 dubloon + rando cheap items that come from a loot list
-- only accept 1 seafood crockpot meal per day and pull up a chest that has 1 dubloon + items (that we set per dish)

local function StartTrading(inst)
	if not inst.components.trader.enabled then
		inst.components.trader:Enable()
		inst.AnimState:PlayAnimation("sleep_pst")
		inst.AnimState:PushAnimation("idle", true)

        inst:RemoveEventCallback("animover", inst.sleepfn)
        inst.sleepfn = nil
	end
end

local function FinishedTrading(inst)
	inst.components.trader:Disable()
	inst.AnimState:PlayAnimation("sleep_pre")

	if inst.sleepfn then
		inst:RemoveEventCallback("animover", inst.sleepfn)
        inst.sleepfn = nil
	end
	
	inst.sleepfn = function(inst)
		inst.AnimState:PlayAnimation("sleep_loop")
		inst.SoundEmitter:PlaySound("ia/creatures/octopus_king/sleep")
	end
    
    inst:ListenForEvent("animover", inst.sleepfn)
end

-- chest style
local function OnGetItemFromPlayer(inst, giver, item)
	
	local istrinket = item:HasTag("trinket") or string.sub(item.prefab, 1, 7) == "trinket" -- cache this, the item is destroyed by the time the reward is created.
	local itemprefab = string.sub(item.prefab, -8) == "_gourmet" and string.sub(item.prefab, 1, -9) or item.prefab
	local tradefor = item.components.tradable.tradefor
	inst.components.trader:Disable()

	inst.AnimState:PlayAnimation("happy")
	inst.AnimState:PushAnimation("grabchest")
	inst.AnimState:PushAnimation("idle", true)
	inst:DoTaskInTime(13*FRAMES, function(inst)	inst.SoundEmitter:PlaySound("ia/creatures/octopus_king/happy") end)
	inst:DoTaskInTime(53*FRAMES, function(inst)	inst.SoundEmitter:PlaySound("ia/creatures/octopus_king/tenticle_out_water") end)
	inst:DoTaskInTime(71*FRAMES, function(inst)	inst.SoundEmitter:PlaySound("ia/creatures/octopus_king/tenticle_in_water") end)
	inst:DoTaskInTime(78*FRAMES, function(inst)	inst.SoundEmitter:PlaySound("ia/creatures/seacreature_movement/splash_small") end)
	inst:DoTaskInTime(109*FRAMES, function(inst)

		inst.SoundEmitter:PlaySound("ia/creatures/octopus_king/tenticle_out_water")
		
		-- put things in a chest and throw that
		local angle
		local spawnangle
		local sp = math.random()*3+2
		local x, y, z = inst.Transform:GetWorldPosition()
		
		if giver ~= nil and giver:IsValid() then
			angle = (210 - math.random()*60 - giver:GetAngleToPoint(x, 0, z))*DEGREES
			spawnangle = (130 - giver:GetAngleToPoint(x, 0, z))*DEGREES
		else
			local down = TheCamera:GetDownVec()
			angle = math.atan2(down.z, down.x) + (math.random()*60-30)*DEGREES
			spawnangle = math.atan2(down.z, down.x) + -50*DEGREES
			giver = nil
		end
		
		local chest = SpawnPrefab("octopuschest")
		local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(2*math.cos(spawnangle), 2, 2*math.sin(spawnangle))
		chest.Transform:SetPosition(pt:Get())
		chest.Physics:SetVel(sp*math.cos(angle), math.random()*2+9, sp*math.sin(angle))
		if chest.components.inventoryitem then
			chest.components.inventoryitem:SetLanded(false, true)
		end
		chest.AnimState:PlayAnimation("air_loop", true)

		chest:ListenForEvent("on_landed", function()
			chest.AnimState:PlayAnimation("land")
			chest.AnimState:PushAnimation("closed", true)
		end)

		if not istrinket then
            local single = SpawnPrefab("dubloon")
            chest.components.container:GiveItem(single, nil, nil, true, false)

            if OCTOPUSKING_LOOT.chestloot[itemprefab] then
                local goodreward = SpawnPrefab(OCTOPUSKING_LOOT.chestloot[itemprefab])
                chest.components.container:GiveItem(goodreward, nil, nil, true, false)
            else
                local dubloonvalue = math.min(item.components.tradable.dubloonvalue or 0, 2)
                for i = 1, dubloonvalue do
                    local loot = SpawnPrefab(OCTOPUSKING_LOOT.randomchestloot[math.random(1, #OCTOPUSKING_LOOT.randomchestloot)])
                    chest.components.container:GiveItem(loot, nil, nil, true, false)
                end
            end
		else
			-- trinkets give out dubloons only
			for i = 1, (item.components.tradable.dubloonvalue or item.components.tradable.goldvalue * 3) do
				local loot = SpawnPrefab("dubloon")
				chest.components.container:GiveItem(loot, nil, nil, true, false)
			end
		end
		if tradefor ~= nil then
			for _, v in pairs(tradefor) do
				local item = SpawnPrefab(v)
				if item ~= nil then
					chest.components.container:GiveItem(item, nil, nil, true, false)
				end
			end
		end
	end)
	
	inst.happy = true
	if inst.endhappytask then
		inst.endhappytask:Cancel()
	end
	inst.endhappytask = inst:DoTaskInTime(5, function(inst)
		inst.happy = false
		inst.endhappytask = nil

		FinishedTrading(inst)
	end)
end

local function OnRefuseItem(inst, giver, item)
    inst.SoundEmitter:PlaySound("ia/creatures/octopus_king/reject")
    inst.AnimState:PlayAnimation("unimpressed")
    inst.AnimState:PushAnimation("idle", true)
    inst.happy = false
end

local function OnLoad(inst,data)
    if not inst.components.trader.enabled then
        FinishedTrading(inst)
    end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()
    
	inst.MiniMapEntity:SetIcon("octopus.tex")
	inst.MiniMapEntity:SetPriority(1)
	
	inst.DynamicShadow:SetSize(10, 5)
	
	MakeObstaclePhysics(inst, 2, .9)
	
	inst:AddTag("king")
	inst.AnimState:SetBank("octopus")
	inst.AnimState:SetBuild("octopus")
	inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("trader")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")

	inst:AddComponent("trader")

	inst.components.trader:SetAcceptTest(function(inst, item)
		local itemprefab = string.sub(item.prefab, -8) == "_gourmet" and string.sub(item.prefab, 1, -9) or item.prefab
		return (item.components.tradable.dubloonvalue and item.components.tradable.dubloonvalue > 0) or OCTOPUSKING_LOOT.chestloot[itemprefab] ~= nil or string.sub(itemprefab, 1, 7) == "trinket"
	end)

	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
	
	inst.OnLoad = OnLoad

    inst:WatchWorldState("startnight", function(inst)
        FinishedTrading(inst)
    end)

    inst:WatchWorldState("startday", function(inst)
        StartTrading(inst)
    end)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    inst.components.hauntable:SetOnHauntFn(function(inst, haunter)
        if inst.components.trader and inst.components.trader.enabled then
            OnRefuseItem(inst)
            return true
        end
        return false
    end)
	
	return inst
end

return Prefab( "octopusking", fn, assets, prefabs) 
