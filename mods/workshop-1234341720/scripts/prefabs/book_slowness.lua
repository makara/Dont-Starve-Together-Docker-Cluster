local assets =
{
    Asset("ANIM", "anim/book_slowness.zip"),
	Asset("ATLAS", "images/inventoryimages/book_slowness.xml"),
    Asset("IMAGE", "images/inventoryimages/book_slowness.tex"),
}


local function slowspell(inst, target)
	if target:HasTag("monster") or target:HasTag("hound") or target:HasTag("largecreature") or target:HasTag("epic") or target:HasTag("smallcreature") or target:HasTag("animal") then
		local speed_run = target.components.locomotor:GetRunSpeed()
		local speed_walk = target.components.locomotor:GetWalkSpeed()
		target.components.locomotor.runspeed =(speed_run*0.5)
		target.components.locomotor.walkspeed =(speed_walk*0.5)
		local x, y, z = target.Transform:GetWorldPosition() 
		local spell = SpawnPrefab("deer_ice_charge")
		spell.Transform:SetPosition(x, y+3, z)
		spell:DoTaskInTime(1, spell.KillFX)
	end
end

local function removeslow(inst, target)
	if target:HasTag("monster") or target:HasTag("hound") or target:HasTag("largecreature") or target:HasTag("epic") or target:HasTag("smallcreature") or target:HasTag("animal") then
		local speed_run = target.components.locomotor:GetRunSpeed()
		local speed_walk = target.components.locomotor:GetWalkSpeed()
		target.components.locomotor.runspeed =(speed_run*2)
		target.components.locomotor.walkspeed =(speed_walk*2)
		local x, y, z = target.Transform:GetWorldPosition() 
		local spell = SpawnPrefab("deer_fire_charge")
		spell.Transform:SetPosition(x, y+3, z)
		spell:DoTaskInTime(1, spell.KillFX)
	end
end

local book_defs = {
    {
        name = "book_slowness",
        uses = 8,
        fn = function(inst, reader)
			local pt = reader:GetPosition()
            local spawning = 1 -- how many times function is going to loop
            reader.components.sanity:DoDelta(-15)
			reader.components.hunger:DoDelta(-15)
			reader.components.talker:Say("Slow-motion!")
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
						local ents = TheSim:FindEntities(x, y, z, 16)
						for k, v in pairs(ents) do
							slowspell(inst, v)
						end
						Sleep(12)
						for k, v in pairs(ents) do
							removeslow(inst, v)
						end
					end	
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

        inst.AnimState:SetBank("book_slowness")
        inst.AnimState:SetBuild("book_slowness")
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
		inst.components.inventoryitem.imagename = "book_slowness"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/book_slowness.xml"
		
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

local book_slowness = {}
for i, v in ipairs(book_defs) do
    table.insert(book_slowness, MakeBook(v))
end
book_defs = nil
return unpack(book_slowness)
