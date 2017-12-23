local assets =
{
    Asset("ANIM", "anim/book_tornado.zip"),
	Asset("ATLAS", "images/inventoryimages/book_tornado.xml"),
    Asset("IMAGE", "images/inventoryimages/book_tornado.tex"),
}

local prefabs =
{
    "tornado",
    "sleepbomb_burst", 
}

local book_defs =
{
    {
        name = "book_tornado",
        uses = 7,
        fn = function(inst, reader)
            local pt = reader:GetPosition()
            local spawning = 12 -- how many times function is going to loop

            reader.components.sanity:DoDelta(-10)
			reader.components.talker:Say("Tornado!")
            reader:StartThread(function()
                for k = 1, spawning do
                    local theta = math.random() * 2 * PI
                    local radius = math.random(4, 11)

                    local result_offset = FindValidPositionByFan(theta, radius, 1, function(offset)
                        local pos = pt + offset
                        return TheWorld.Map:IsPassableAtPoint(pos:Get()) and not
							TheWorld.GroundCreep:OnCreep(pos:Get()) and
							#TheSim:FindEntities(pos.x, 0, pos.z, 1, nil, { "INLIMBO", "FX" }) <= 0
                            and TheWorld.Map:IsDeployPointClear(pos, nil, 1)
                    end)

                    if result_offset ~= nil then
                        local x, z = pt.x + result_offset.x, pt.z + result_offset.z
                        local tornado = SpawnPrefab("tornado")
						SpawnPrefab("sleepbomb_burst").Transform:SetPosition(x, 0, z)
                        tornado.Transform:SetPosition(x, 0, z)
                    end
					Sleep(0.33)
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

        inst.AnimState:SetBank("book_tornado")
        inst.AnimState:SetBuild("book_tornado")
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
		inst.components.inventoryitem.imagename = "book_tornado"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/book_tornado.xml"

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

local book_tornado = {}
for i, v in ipairs(book_defs) do
    table.insert(book_tornado, MakeBook(v))
end
book_defs = nil
return unpack(book_tornado)
