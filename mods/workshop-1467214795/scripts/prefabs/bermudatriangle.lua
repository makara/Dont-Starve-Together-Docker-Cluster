require "stategraphs/SGbermudatriangle"

local assets=
{
	Asset("ANIM", "anim/bermudatriangle.zip"),
	Asset("ANIM", "anim/teleporter_worm.zip"),
	Asset("ANIM", "anim/teleporter_worm_build.zip"),
    Asset("SOUND", "sound/common.fsb"),
}


local function GetStatus(inst)
	if inst.sg.currentstate.name ~= "idle" then
		return "OPEN"
	end
end

local function OnActivate(inst, doer, target)
	if doer:HasTag("player") then
        --ProfileStatsSet("wormhole_used", true)
		-- doer.components.health:SetInvincible(true)
		-- if TUNING.DO_SEA_DAMAGE_TO_BOAT and (doer.components.sailor and doer.components.sailor.boat and doer.components.sailor.boat.components.boathealth) then
			-- doer.components.sailor.boat.components.boathealth:SetInvincible(true)
		-- end
		-- doer.components.playercontroller:Enable(false)
		
		if inst.components.teleporter.targetTeleporter ~= nil then
			DeleteCloseEntsWithTag("WORM_DANGER", inst.components.teleporter.targetTeleporter, 15)
		end
		
        if doer.components.talker ~= nil then
            doer.components.talker:ShutUp()
        end
        if doer.components.sanity ~= nil then
            doer.components.sanity:DoDelta(-TUNING.SANITY_MED)
        end

		-- TheLocalPlayer.HUD:Hide()
		-- --TheFrontEnd:SetFadeLevel(1)
        -- TheCamera:SetTarget(inst)
		-- TheFrontEnd:Fade(false, 0.5)
		-- doer:DoTaskInTime(2, function()
            -- TheCamera:SetTarget(target)
            -- TheCamera:Snap()
			-- TheFrontEnd:Fade(true, 0.5)
			-- TheLocalPlayer.HUD:Show()
			-- --doer.sg:GoToState("wakeup")
			-- if doer.components.sanity then
				-- doer.components.sanity:DoDelta(-TUNING.SANITY_MED)
			-- end
		-- end)
		-- doer:DoTaskInTime(3.5, function()
			-- TheCamera:SetTarget(TheLocalPlayer)
			-- doer:PushEvent("bermudatriangleexit")
			-- doer.components.health:SetInvincible(false)
			-- if TUNING.DO_SEA_DAMAGE_TO_BOAT and (doer.components.sailor and doer.components.sailor.boat and doer.components.sailor.boat.components.boathealth) then
				-- doer.components.sailor.boat.components.boathealth:SetInvincible(false)
			-- end
			-- doer.components.playercontroller:Enable(true)
		-- end)
		--doer.SoundEmitter:PlaySound("ia/common/bermuda/travel", "wormhole_travel")
	elseif doer.SoundEmitter then
		-- inst.SoundEmitter:PlaySound("ia/common/bermuda/spark", "wormhole_swallow")
	end
end

local function OnDoneTeleporting(inst, obj)
    if inst.closetask ~= nil then
        inst.closetask:Cancel()
    end
    inst.closetask = inst:DoTaskInTime(1.5, function()
        if not (inst.components.teleporter:IsBusy() or
                inst.components.playerprox:IsPlayerClose()) then
            inst.sg:GoToState("closing")
        end
    end)
    -- inst.SoundEmitter:PlaySound("ia/common/bermuda/spark")

    if obj ~= nil and obj:HasTag("player") then
        obj:DoTaskInTime(1, obj.PushEvent, "bermudatriangleexit") -- for wisecracker
    end
end

local function OnActivateByOther(inst, source, doer)
    if not inst.sg:HasStateTag("open") then
        inst.sg:GoToState("opening")
    end
end

local function onnear(inst)
    if inst.components.teleporter:IsActive() and not inst.sg:HasStateTag("open") then
        inst.sg:GoToState("opening")
    end
end

local function onfar(inst)
    if not inst.components.teleporter:IsBusy() and inst.sg:HasStateTag("open") then
        inst.sg:GoToState("closing")
    end
end

local function onaccept(inst, giver, item)
    inst.components.inventory:DropItem(item)
    inst.components.teleporter:Activate(item)
end

local function StartTravelSound(inst, doer)
    -- inst.SoundEmitter:PlaySound("ia/common/bermuda/spark")
    -- doer:PushEvent("wormholetravel", WORMHOLETYPE.BERMUDA) --Event for playing local travel sound
	--TODO we should really use a custom event for this
	--or use the stategraph to hack it in?
		--doer.SoundEmitter:PlaySound("ia/common/bermuda/travel", "wormhole_travel")
end

local function fn(Sim)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("bermudatriangle.tex")
   
    inst.AnimState:SetBank("bermudatriangle")
    inst.AnimState:SetBuild("bermudatriangle")
    inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    
	local s = 1.3
	inst.Transform:SetScale(s,s,s)

    --trader, alltrader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")
    inst:AddTag("alltrader")

    inst:AddTag("antlion_sinkhole_blocker")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	
	inst:SetStateGraph("SGbermudatriangle")
    
    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(4,5)
    inst.components.playerprox.onnear = onnear
    inst.components.playerprox.onfar = onfar

	inst:AddComponent("teleporter")
	inst.components.teleporter.onActivate = OnActivate
    inst.components.teleporter.onActivateByOther = OnActivateByOther
	inst.components.teleporter.offset = 0
	
    inst:ListenForEvent("starttravelsound", StartTravelSound) -- triggered by player stategraph
    inst:ListenForEvent("doneteleporting", OnDoneTeleporting)

	inst:AddComponent("inventory")

	inst:AddComponent("trader")
    inst.components.trader.acceptnontradable = true
    inst.components.trader.onaccept = onaccept
    inst.components.trader.deleteitemonaccept = false
	
	--print("Bermuda Spawned!")

    return inst
end

return Prefab( "bermudatriangle", fn, assets) 
