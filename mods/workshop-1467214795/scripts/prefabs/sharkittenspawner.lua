local assets = {
    Asset("ANIM", "anim/sharkitten_den.zip"),
}

local prefabs = {
    "sharkitten",
    "tigershark",
}

local function ReturnChildren(inst)
    for k, child in pairs(inst.components.childspawner.childrenoutside) do
        if child.components.homeseeker then
            child.components.homeseeker:GoHome()
        end
        child:PushEvent("gohome")
    end
end

local function SummonShark(inst, player)
    --Try to spawn a shark to protect this area if it's spring.
    if inst.spawneractive then
        local tigersharker = TheWorld.components.tigersharker
		if not tigersharker then return end --in case somebody spawns this in caves

        local shark = tigersharker:SpawnShark(true, false)
        if shark then
            local spawnpt = tigersharker:GetNearbySpawnPoint(player)
            if spawnpt then
                shark.Transform:SetPosition(spawnpt:Get())
                shark.components.combat:SuggestTarget(player)
            end
        end
    end
end

local function SpawnKittens(inst, num)
    for i = 1, num do
        local kitten = SpawnPrefab("sharkitten")
        kitten.Transform:SetPosition(inst:GetPosition():Get())
        inst.components.herd:AddMember(kitten)
    end
end

local function OnIsDay(inst, isday)
	if isday and inst.spawneractive then
		inst.components.childspawner:StartSpawning()
	else
		inst.components.childspawner:StopSpawning()
		ReturnChildren(inst)
	end
end

local function ActivateSpawner(inst, onload)
    if not inst.spawneractive or onload then
        inst.spawneractive = true

		inst.components.named:SetName(STRINGS.NAMES["SHARKITTENSPAWNER_ACTIVE"])
		--Queue up an animation change for next time this is off screen
		inst.AnimState:PlayAnimation("idle_active")
		--Start task to periodically blink if there are children inside
		inst.blink_task = inst:DoPeriodicTask(math.random() * 10 + 10, function()
			if inst.components.childspawner and inst.components.childspawner.childreninside > 0 then
				inst.AnimState:PlayAnimation("blink")
				inst.AnimState:PushAnimation("idle_active")
			end
		end)

		inst:WatchWorldState("isday", OnIsDay)

		if TheWorld.state.isday then
			OnIsDay(inst, true)
		end
    end
end

local function DeactiveateSpawner(inst, onload)
    if inst.spawneractive or onload then
        inst.spawneractive = false
		
		inst.components.named:SetName(STRINGS.NAMES["SHARKITTENSPAWNER_INACTIVE"])
		--Queue up an animation change for the next time this is off screen
		inst.AnimState:PlayAnimation("idle_inactive")
		--Stop task to periodically blink if there are children inside
		if inst.blink_task then
			inst.blink_task:Cancel()
			inst.blink_task = nil
		end

		inst:StopWatchingWorldState("daytime", OnIsDay)
		inst.components.childspawner:StopSpawning()
		ReturnChildren(inst)
		
    end
end

local function OnSeasonChange(inst, season)
    if season == SEASONS.SPRING or season == SEASONS.GREEN then
        --Start the spawning.
        ActivateSpawner(inst)
    else
        --Stop
        DeactiveateSpawner(inst)
    end
end

local function getstatus(inst)
    if not inst.spawneractive then 
        return "INACTIVE"
    end
end

local function OnSave(inst, data)
    data.spawneractive = inst.spawneractive
end

local function OnLoad(inst, data)
    if data and data.spawneractive then
        ActivateSpawner(inst, true)
    else
        DeactiveateSpawner(inst, true)
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()  
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("sharkden.tex")

    inst.AnimState:SetBuild("sharkitten_den")
    inst.AnimState:SetBank("sharkittenden")
    inst.AnimState:PlayAnimation("idle_inactive")

    inst:AddTag("sharkhome")

    MakeObstaclePhysics(inst, 2)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "sharkitten"
    inst.components.childspawner:SetRegenPeriod(TUNING.SHARKITTEN_REGEN_PERIOD)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SHARKITTEN_SPAWN_PERIOD)
    inst.components.childspawner:SetMaxChildren(4)
    inst.components.childspawner:StartRegen()

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetOnPlayerNear(SummonShark)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
    inst.components.playerprox:SetDist(7.5, 10)
    inst.components.playerprox.period = 1

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("named")
    inst.components.named:SetName(STRINGS.NAMES["SHARKITTENSPAWNER_INACTIVE"])

    inst.SpawnKittens = SpawnKittens
    inst.OnLoad = OnLoad
    inst.OnSave = OnSave

    inst:WatchWorldState("season", OnSeasonChange)
    OnSeasonChange(inst, TheWorld.state.season)

    return inst
end

return Prefab("sharkittenspawner", fn, assets, prefabs)