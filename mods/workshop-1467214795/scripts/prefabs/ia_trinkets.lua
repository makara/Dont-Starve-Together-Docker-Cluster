
local oldPickRandomTrinket = PickRandomTrinket
function PickRandomTrinket()
	if math.random() < 11 / (NUM_TRINKETS + 11) then
		return "trinket_ia_".. math.random(13,23)
	else
		return oldPickRandomTrinket()
	end
end

local assets =
{
    Asset("ANIM", "anim/trinkets_ia.zip"),
}

local TRADEFOR =
{
    -- [1] = {"rewardprefab"},
}

local function MakeTrinket(num, prefix, tuning)
    local prefabs = TRADEFOR[num]

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("trinkets_ia")
        inst.AnimState:SetBuild("trinkets_ia")
        inst.AnimState:PlayAnimation(tostring(num))

        inst:AddTag("molebait")
        inst:AddTag("cattoy")

		MakeInventoryFloatable(inst)
		inst.components.floater:UpdateAnimations(tostring(num).."_water", tostring(num))

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("appeasement")
        inst.components.appeasement.appeasementvalue = TUNING.APPEASEMENT_LARGE

        inst:AddComponent("inspectable")
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        MakeInvItemIA(inst)
        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = TUNING.GOLD_VALUES[tuning][num] or 3
        inst.components.tradable.dubloonvalue = TUNING.DUBLOON_VALUES[tuning][num] or 3
        inst.components.tradable.tradefor = TRADEFOR[num]
        
		-- if num >= HALLOWEDNIGHTS_TINKET_START and num <= HALLOWEDNIGHTS_TINKET_END then
	        -- if IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) then
				-- inst.components.tradable.halloweencandyvalue = 5
			-- end
		-- end
		inst.components.tradable.rocktribute = math.ceil(inst.components.tradable.goldvalue / 3)

        MakeHauntableLaunchAndSmash(inst)

        inst:AddComponent("bait")

        return inst
    end

    return Prefab(prefix .. tostring(num), fn, assets, prefabs)
end

local ret = {}
for k = 13, 23 do
    table.insert(ret, MakeTrinket(k, "trinket_ia_", "IA_TRINKETS"))
end
for k = 1, 5 do
    table.insert(ret, MakeTrinket(k, "sunken_boat_trinket_", "SUNKEN_BOAT_TRINKETS"))
end

return unpack(ret)
