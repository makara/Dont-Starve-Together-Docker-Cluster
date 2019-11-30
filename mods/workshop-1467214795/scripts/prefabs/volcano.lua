local BigPopupDialogScreen = require "screens/bigpopupdialog"

local assets =
{
	Asset("ANIM", "anim/volcano.zip"),
}


local function OnSummer(inst, issummer, instant)
    if issummer then
        inst.sg:GoToState(instant and "active" or "dormant_pst")
    else
        inst.sg:GoToState(instant and "dormant" or "active_pst")
    end
end

local function OnWake(inst)
    inst.SoundEmitter:PlaySound("ia/common/volcano/volcano_external_amb", "volcano")
    local state = 1.0
    if inst.sg and inst.sg.currentstate == "dormant" then
        state = 0.0
    end
    inst.SoundEmitter:SetParameter("volcano", "volcano_state", state)
end

local function OnSleep(inst)
    inst.SoundEmitter:KillSound("volcano")
end


-- local maxmod = 70
-- local distToFinish = 10 * 10 --Distance to volcano where you reach max zoom
-- local distToStart = 65 * 65 --Distance from the volcano where you start to zoom

local function CalcCameraDistMod(camera, mod, data)
	local dist = data.inst:GetDistanceSqToPoint(camera.currentpos)
	-- if dist < distToStart then --is in range
	if dist < 4225 then
		mod = mod +
			-- (  dist < distToFinish and maxmod --peak
			(  dist < 100 and 70
			-- or maxmod * (1 - (dist - distToFinish) / (distToStart - distToFinish))  ) --Lerp
			or 70 * (1 - (dist - 100) / 4125)  )
	end
	return mod
end

local function OnRemoveEntity_camera(inst)
	if TheCamera then
		for k, v in pairs(TheCamera.envdistancemods) do
			if v.inst == inst then
				table.remove(TheCamera.envdistancemods, k)
				return
			end
		end
	end
end


local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()

	inst.entity:AddAnimState()
    inst.AnimState:SetBuild("volcano")
    inst.AnimState:SetBank("volcano")
    inst.AnimState:PlayAnimation("dormant_idle", true)

	--use "globalmapiconunderfog" prefab to avoid issue #188 ?
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("volcano.tex")
	
    inst.entity:AddLight()
    inst.Light:SetFalloff(0.4)
    inst.Light:SetIntensity(.7)
    inst.Light:SetRadius(10)
    inst.Light:SetColour(249/255, 130/255, 117/255)
    inst.Light:Enable(true)

    inst.entity:AddPhysics()
 	inst.Physics:SetMass(0)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	inst.Physics:CollidesWith(COLLISION.WAVES)
    inst.Physics:SetCapsule(40, 5)
	
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst:AddTag("theVolcano") -- for rainbow jellyfish
	
    inst.entity:SetPristine()

	if not TheNet:IsDedicated() then
		if TheCamera and TheCamera.envdistancemods then
			table.insert(TheCamera.envdistancemods, {fn = CalcCameraDistMod, inst = inst})
			inst.OnRemoveEntity = OnRemoveEntity_camera
		else
			print(inst,"PANIC! no camera!")
		end
	end

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	
    -- inst:AddComponent("waveobstacle")
	
	--TODO let players climb the volcano
    -- inst:AddComponent("worldmigrator")

    -- inst:AddComponent("activatable")
    -- inst.components.activatable.OnActivate = OnActivate
    -- inst.components.activatable.inactive = true
    -- inst.components.activatable.getverb =  function()
		-- return STRINGS.ACTIONS.ACTIVATE.CLIMB
	-- end
    -- inst.components.activatable.quickaction = true

    -- inst.OnLoadPostPass = function(inst, ents, data)
    	-- GetWorld().components.volcanomanager:AddVolcano(inst)
	-- end

    -- inst.OnRemoveEntity = function(inst)
    	-- GetWorld().components.volcanomanager:RemoveVolcano(inst)
	-- end

	--TODO handle those elsehow (worldstate probably won't work)
    -- inst:ListenForEvent("OnVolcanoEruptionBegin", function (it)
        -- if inst and inst.sg then
            -- inst.sg:GoToState("erupt")
        -- end
        -- -- print(">>>OnVolcanoEruptionBegin", inst)
    -- end, GetWorld())

    -- inst:ListenForEvent("OnVolcanoEruptionEnd", function (it)
        -- if inst and inst.sg then
            -- inst.sg:GoToState("rumble")
        -- end
        -- -- print(">>>OnVolcanoEruptionEnd", inst)
    -- end, GetWorld())

    -- inst:ListenForEvent("OnVolcanoWarningQuake", function (it)
        -- if inst and inst.sg then
            -- inst.sg:GoToState("rumble")
        -- end
        -- -- print(">>>OnVolcanoEruptionEnd", inst)
    -- end, GetWorld())

    inst:SetStateGraph("SGvolcano")

    OnSummer(inst, TheWorld.state.issummer, true)
    inst:WatchWorldState("issummer", OnSummer)

    inst.OnEntityWake = OnWake
    inst.OnEntitySleep = OnSleep

	return inst
end

return Prefab( "volcano", fn, assets)
