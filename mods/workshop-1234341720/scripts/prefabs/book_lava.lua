local assets =
{
    Asset("ANIM", "anim/book_lava.zip"),
	Asset("ATLAS", "images/inventoryimages/book_lava.xml"),
    Asset("IMAGE", "images/inventoryimages/book_lava.tex"),
}

local FLAMES = 0.9999

local function fireSpell(inst, target)
	if target:HasTag("monster") or target:HasTag("hound") or target:HasTag("largecreature") or target:HasTag("epic") or target:HasTag("smallcreature") or target:HasTag("animal") then
		if target ~= nil and target.components.burnable ~= nil and math.random() < FLAMES * target.components.burnable.flammability then	
			target.components.burnable:Ignite(nil, target)
		end
		if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
			target.components.sleeper:WakeUp()
		end
		if target.components.burnable ~= nil and not target.components.burnable:IsBurning() then
			if target.components.freezable ~= nil and target.components.freezable:IsFrozen() then
				target.components.freezable:Unfreeze()
			end
		end
		if target.components.burnable ~= nil then
			if target.components.burnable:IsSmoldering() then
				target.components.burnable:Ignite(nil, target)
			end
		end
	end
end

local function damagedeal(inst, target)
	if target:HasTag("monster") or target:HasTag("hound") or target:HasTag("largecreature") or target:HasTag("epic") or target:HasTag("smallcreature") or target:HasTag("animal") then
		if target ~= nil and target.components.burnable ~= nil then	
			target.components.health:DoDelta(-5)
		end
	end
end

local prefabs =
{
}

local book_defs =
{
    {
        name = "book_lava",
        uses = 10,
        fn = function(inst, reader)
            local pt = reader:GetPosition()
            local spawning = 6 -- how many times function is going to loop
			local lavafield = 1 -- how many fire star is going to loop
            reader.components.sanity:DoDelta(-15)
			reader.components.hunger:DoDelta(-10)
			reader.components.talker:Say("Inferno!")
            reader:StartThread(function()
				for k = 1, lavafield do
					local x, y, z = reader.Transform:GetWorldPosition()
					local ents = TheSim:FindEntities(x, y, z, 14)
					local spell5 = SpawnPrefab("deer_fire_charge")
					spell5.Transform:SetPosition(x, y+3, z)
					spell5:DoTaskInTime(6, spell5.KillFX)
					for k, v in pairs(ents) do
						fireSpell(inst, v)
					end
				end
                for k = 1, spawning do
                    local theta = math.random() * 2 * PI
                    local radius = math.random(7, 10)
                    local result_offset = FindValidPositionByFan(theta, radius, 1, function(offset)
                        local pos = pt + offset
                        return TheWorld.Map:IsPassableAtPoint(pos:Get()) and not
							TheWorld.GroundCreep:OnCreep(pos:Get()) and
							#TheSim:FindEntities(pos.x, 0, pos.z, 1, nil, { "INLIMBO", "FX" }) <= 0
                            and TheWorld.Map:IsDeployPointClear(pos, nil, 1)
                    end)

                    if result_offset ~= nil then
                        local x, z = pt.x + result_offset.x, pt.z + result_offset.z
						local spell2 = SpawnPrefab("deer_fire_circle")
						spell2.Transform:SetPosition(x, 0, z)
						spell2:DoTaskInTime(16, spell2.KillFX)
						local spell3 = SpawnPrefab("deer_fire_burst")
						spell3.Transform:SetPosition(x, 0, z)
						spell3:DoTaskInTime(16, spell3.KillFX)
						local spell4 = SpawnPrefab("deer_fire_flakes")
						spell4.Transform:SetPosition(x, 0, z)
						spell4:DoTaskInTime(16, spell4.KillFX)
						local x, y, z = reader.Transform:GetWorldPosition()
						local creatures = TheSim:FindEntities(x, y, z, 14)
						for k, v in pairs(creatures) do
							damagedeal(inst, v)
						end
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

        inst.AnimState:SetBank("book_lava")
        inst.AnimState:SetBuild("book_lava")
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
		inst.components.inventoryitem.imagename = "book_lava"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/book_lava.xml"
		
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

local book_lava = {}
for i, v in ipairs(book_defs) do
    table.insert(book_lava, MakeBook(v))
end
book_defs = nil
return unpack(book_lava)
