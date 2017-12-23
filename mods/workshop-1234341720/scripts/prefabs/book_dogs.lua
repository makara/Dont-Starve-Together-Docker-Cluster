local assets =
{
    Asset("ANIM", "anim/book_dogs.zip"),
	Asset("ATLAS", "images/inventoryimages/book_dogs.xml"),
    Asset("IMAGE", "images/inventoryimages/book_dogs.tex"),
}

local prefabs =
{
    "hound",
    "hound1",
    "hound2",
    "sleepbomb_burst", 
}

local book_defs =
{
    {
        name = "book_dogs",
        uses = 4,
        fn = function(inst, reader)
            local pt = reader:GetPosition()
            local spawning = 2 -- how many times function is going to loop
			
            reader.components.sanity:DoDelta(-50)
			reader.components.talker:Say("Hounds of Death!")
            reader:StartThread(function()
                for k = 1, spawning do
                    local theta = math.random() * 2 * PI
                    local radius = math.random(8,13)

                    local result_offset = FindValidPositionByFan(theta, radius, 3, function(offset)
                        local pos = pt + offset
                        return TheWorld.Map:IsPassableAtPoint(pos:Get()) and not
							TheWorld.GroundCreep:OnCreep(pos:Get()) and
							#TheSim:FindEntities(pos.x, 0, pos.z, 1, nil, { "INLIMBO", "FX" }) <= 0
                            and TheWorld.Map:IsDeployPointClear(pos, nil, 1)
                    end)

                    if result_offset ~= nil then
                        local x, z = pt.x + result_offset.x, pt.z + result_offset.z
                        local hound = SpawnPrefab("hound") 
                        hound.Transform:SetPosition(x, 0, z)
                        hound.sg:GoToState("attack_pre")
                        local hound1 = SpawnPrefab("firehound") 
                        hound1.Transform:SetPosition(x+2, 0, z+1)
                        hound1.sg:GoToState("attack_pre")
                        local hound2 = SpawnPrefab("icehound") 
                        hound2.Transform:SetPosition(x-2, 0, z+1)
                        hound2.sg:GoToState("attack_pre")
                        SpawnPrefab("sleepbomb_burst").Transform:SetPosition(x, 0, z)
						SpawnPrefab("sleepbomb_burst").Transform:SetPosition(x+2, 0, z+1)
						SpawnPrefab("sleepbomb_burst").Transform:SetPosition(x-2, 0, z+1)
                        ShakeAllCameras(CAMERASHAKE.FULL, .25, .04, .4, reader, 40)
                    end
					Sleep(1.5)
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

        inst.AnimState:SetBank("book_dogs")
        inst.AnimState:SetBuild("book_dogs")
        inst.AnimState:PlayAnimation("idle")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        -----------------------------------

        inst:AddComponent("inspectable")
		inst:AddComponent("book")
        inst.components.book.onread = def.fn
		
		
        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = "book_dogs"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/book_dogs.xml"
		inst.fxcolour = {1/255, 30/255, 250/255}
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

local book_dogs = {}
for i, v in ipairs(book_defs) do
    table.insert(book_dogs, MakeBook(v))
end
book_defs = nil
return unpack(book_dogs)
