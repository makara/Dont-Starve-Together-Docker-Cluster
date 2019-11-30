local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local stagename = {
	"short",
	"normal",
	"tall",
	"old",
}

local function OnGustAnimDone(inst)
	if inst:HasTag("stump") or inst:HasTag("burnt") then
		inst:RemoveEventCallback("animover", OnGustAnimDone)
		return
	end
	if inst.components.blowinwindgust and inst.components.blowinwindgust:IsGusting() then
		local anim = math.random(1,2)
		inst.AnimState:PlayAnimation("blown_loop_".. stagename[inst.components.growable.stage] ..tostring(anim), false)
		inst.SoundEmitter:PlaySound("ia/common/wind_tree_creak") --I won't bother with the spot emitters -M
	else
		inst:DoTaskInTime(math.random()/2, function(inst)
			inst:RemoveEventCallback("animover", OnGustAnimDone)
			inst.AnimState:PlayAnimation("blown_pst_" .. stagename[inst.components.growable.stage], false)
			inst.AnimState:PushAnimation(math.random() > .5 and inst.anims.sway1 or inst.anims.sway2, true)
		end)
	end
end

local function OnGustStart(inst, windspeed)
	if inst:HasTag("stump") or inst:HasTag("burnt") then
		return
	end
	inst:DoTaskInTime(math.random()/2, function(inst)
		-- if inst.spotemitter == nil then
			-- AddToNearSpotEmitter(inst, "treeherd", "tree_creak_emitter", TUNING.TREE_CREAK_RANGE)
		-- end
		inst.AnimState:PlayAnimation("blown_pre_" .. stagename[inst.components.growable.stage], false)
		inst.SoundEmitter:PlaySound("ia/common/wind_tree_creak")
		inst:ListenForEvent("animover", OnGustAnimDone)
	end)
end

local function OnGustFall(inst)
	inst.components.workable:Destroy(inst)
end

local function postinitfn(inst)


if TheWorld.ismastersim then
	if not inst:HasTag("burnt") and not inst:HasTag("stump") then

        inst:AddComponent("blowinwindgust")
        inst.components.blowinwindgust:SetWindSpeedThreshold(TUNING.EVERGREEN_WINDBLOWN_SPEED)
        inst.components.blowinwindgust:SetDestroyChance(TUNING.EVERGREEN_WINDBLOWN_FALL_CHANCE)
        inst.components.blowinwindgust:SetGustStartFn(OnGustStart)
        inst.components.blowinwindgust:SetDestroyFn(OnGustFall)
        inst.components.blowinwindgust:Start()
		
	end
end


end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPrefabPostInit("evergreen", postinitfn)
IAENV.AddPrefabPostInit("evergreen_sparse", postinitfn)
IAENV.AddPrefabPostInit("deciduoustree", postinitfn)
