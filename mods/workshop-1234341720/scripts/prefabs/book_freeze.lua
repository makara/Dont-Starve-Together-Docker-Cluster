local assets =
{
    Asset("ANIM", "anim/book_freeze.zip"),
	Asset("ATLAS", "images/inventoryimages/book_freeze.xml"),
    Asset("IMAGE", "images/inventoryimages/book_freeze.tex"),
}

local function freezeSpell(inst, target)
    if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end
    if target.components.burnable ~= nil then
        if target.components.burnable:IsBurning() then
            target.components.burnable:Extinguish()
        elseif target.components.burnable:IsSmoldering() then
            target.components.burnable:SmotherSmolder()
        end
    end
    if target.components.freezable ~= nil then
        target.components.freezable:AddColdness(3)
        target.components.freezable:SpawnShatterFX()
    end
end

local prefabs =
{
}

local book_defs =
{
    {
        name = "book_freeze",
        uses = 10,
        fn = function(inst, reader)
            local pt = reader:GetPosition()
            local spawning = 6 -- how many times function is going to loop
			local freezefield = 1 -- how many times spawn shatter FX + freeze star is going to loop
            reader.components.sanity:DoDelta(-15)
			reader.components.hunger:DoDelta(-10)
			reader.components.talker:Say("Ice Age!")
            reader:StartThread(function()
				for k = 1, freezefield do
					local x, y, z = reader.Transform:GetWorldPosition()
					local ents = TheSim:FindEntities(x, y, z, 12, {"freezable"})
					local spell5 = SpawnPrefab("deer_ice_charge")
					spell5.Transform:SetPosition(x, y+3, z)
					spell5:DoTaskInTime(5, spell5.KillFX)
					for k, v in pairs(ents) do
						freezeSpell(inst, v)
					end
				end
                for k = 1, spawning do
                    local theta = math.random() * 2 * PI
                    local radius = math.random(7, 11)

                    local result_offset = FindValidPositionByFan(theta, radius, 1, function(offset)
                        local pos = pt + offset
                        return TheWorld.Map:IsPassableAtPoint(pos:Get()) and not
							TheWorld.GroundCreep:OnCreep(pos:Get()) and
							#TheSim:FindEntities(pos.x, 0, pos.z, 1, nil, { "INLIMBO", "FX" }) <= 0
                            and TheWorld.Map:IsDeployPointClear(pos, nil, 1)
                    end)

                    if result_offset ~= nil then
                        local x, z = pt.x + result_offset.x, pt.z + result_offset.z
						local spell2 = SpawnPrefab("deer_ice_circle")
						spell2.Transform:SetPosition(x, 0, z)
						spell2:DoTaskInTime(24, spell2.KillFX)
						local spell3 = SpawnPrefab("deer_ice_burst")
						spell3.Transform:SetPosition(x, 0, z)
						spell3:DoTaskInTime(24, spell3.KillFX)
						local spell4 = SpawnPrefab("deer_ice_flakes")
						spell4.Transform:SetPosition(x, 0, z)
						spell4:DoTaskInTime(24, spell4.KillFX)
                    end
					Sleep(0.5)
                end
            end)
            return true
        end,
    },
}

local function MakeBook(def)

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("book_freeze")
        inst.AnimState:SetBuild("book_freeze")
        inst.AnimState:PlayAnimation("idle")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        -----------------------------------
		inst.fxcolour = {1, 145/255, 0}
        inst:AddComponent("inspectable")
        inst:AddComponent("book")

        inst.components.book.onread = def.fn

        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = "book_freeze"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/book_freeze.xml"
		
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(def.uses)
        inst.components.finiteuses:SetUses(def.uses)
        inst.components.finiteuses:SetOnFinished(inst.Remove)

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL

        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)
        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(def.name, fn, assets, prefabs)
end

local book_freeze = {}
for i, v in ipairs(book_defs) do
    table.insert(book_freeze, MakeBook(v))
end
book_defs = nil
return unpack(book_freeze)
