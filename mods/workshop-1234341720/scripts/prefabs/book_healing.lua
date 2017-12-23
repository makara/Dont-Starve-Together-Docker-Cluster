local assets =
{
    Asset("ANIM", "anim/book_healing.zip"),
	Asset("ATLAS", "images/inventoryimages/book_healing.xml"),
    Asset("IMAGE", "images/inventoryimages/book_healing.tex"),
}


local function healspell(inst, target)
    if target.components.freezable ~= nil then
		target.components.health:DoDelta(5)
    end
    if target.components.burnable ~= nil then
        if target.components.burnable:IsBurning() then
            target.components.burnable:Extinguish()
        elseif target.components.burnable:IsSmoldering() then
            target.components.burnable:SmotherSmolder()
        end
    end
	local x, y, z = target.Transform:GetWorldPosition() 
	local spell = SpawnPrefab("deer_ice_flakes")
	spell.Transform:SetPosition(x, y, z)
	spell:DoTaskInTime(1, spell.KillFX)
	SpawnPrefab("sleepbomb_burst").Transform:SetPosition(x, y, z)
end

local book_defs = {
    {
        name = "book_healing",
        uses = 10,
        fn = function(inst, reader)
			local pt = reader:GetPosition()
            local spawning = 8 -- how many times function is going to loop
            reader.components.sanity:DoDelta(-15)
			reader.components.hunger:DoDelta(-15)
			reader.components.talker:Say("Healing Spell!")
			
            reader:StartThread(function()
                for k = 1, spawning do
                    local theta = math.random() * 2 * PI
                    local radius = 14
					
					local result2_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
                        local pos = pt + offset
                        return TheWorld.Map:IsPassableAtPoint(pos:Get()) and not
							TheWorld.GroundCreep:OnCreep(pos:Get()) and
							#TheSim:FindEntities(pos.x, 0, pos.z, 1, nil, { "INLIMBO", "FX" }) <= 0
                            and TheWorld.Map:IsDeployPointClear(pos, nil, 1)
                    end)
                    if result2_offset ~= nil then
                        local x, y, z = reader.Transform:GetWorldPosition()  
						local ents = TheSim:FindEntities(x, y, z, 14, {"player"})
						for k, v in pairs(ents) do
							healspell(inst, v)
						end
					end
					Sleep(1)	
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

        inst.AnimState:SetBank("book_healing")
        inst.AnimState:SetBuild("book_healing")
        inst.AnimState:PlayAnimation("idle")

        inst.entity:SetPristine()

		if not TheNet:GetIsMasterSimulation() then
            return inst
		end

        -----------------------------------
		inst.fxcolour = {1, 145/255, 0}
        inst:AddComponent("inspectable")

        inst:AddComponent("book")
        inst.components.book.onread = def.fn
		
        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = "book_healing"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/book_healing.xml"
		
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

local book_healing = {}
for i, v in ipairs(book_defs) do
    table.insert(book_healing, MakeBook(v))
end
book_defs = nil
return unpack(book_healing)
