local assets =
{
    Asset("ANIM", "anim/book_summon.zip"),
	Asset("ATLAS", "images/inventoryimages/book_summon.xml"),
    Asset("IMAGE", "images/inventoryimages/book_summon.tex"),
}

local prefabs =
{
    "deerclops",
    "splash_ocean",
}

local book_defs =
{
    {
        name = "book_summon",
        uses = 1,
        fn = function(inst, reader)
            local pt = reader:GetPosition()
            local numdeerclopss = 1

            reader.components.sanity:DoDelta(-100)
			reader.components.talker:Say("Come Lord of Destruction!")
            reader:StartThread(function()
                for k = 1, numdeerclopss do
                    local theta = math.random() * 2 * PI
                    local radius = math.random(12, 16)

                    local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
                        local pos = pt + offset
                        return TheWorld.Map:IsPassableAtPoint(pos:Get()) and not
							TheWorld.GroundCreep:OnCreep(pos:Get()) and
							#TheSim:FindEntities(pos.x, 0, pos.z, 1, nil, { "INLIMBO", "FX" }) >= 0
                            and TheWorld.Map:IsDeployPointClear(pos, nil, 1)
                    end)

                    if result_offset ~= nil then
                        local x, z = pt.x + result_offset.x, pt.z + result_offset.z
						local CHANCE = 0.200
						local ENDCHANCE = 0.999
						if math.random() < CHANCE then
							local deerclops = SpawnPrefab("deerclops")
							deerclops.Transform:SetPosition(x, 0, z)
							deerclops.sg:GoToState("attack_pre")
						elseif math.random() < CHANCE then
							local moose = SpawnPrefab("moose")
							moose.Transform:SetPosition(x, 0, z)
							moose.sg:GoToState("attack_pre")
						elseif math.random() < CHANCE then
							local bearger = SpawnPrefab("bearger")
							bearger.Transform:SetPosition(x, 0, z)
							bearger.sg:GoToState("attack_pre")
						elseif math.random() < CHANCE then
							local stalker = SpawnPrefab("stalker")
							stalker.Transform:SetPosition(x, 0, z)
							stalker.sg:GoToState("attack_pre")
						elseif math.random() < CHANCE then
							local dragonfly = SpawnPrefab("dragonfly")
							dragonfly.Transform:SetPosition(x, 0, z)
							dragonfly.sg:GoToState("attack_pre")
						elseif math.random() < CHANCE then
							local klaus = SpawnPrefab("klaus")
							klaus.Transform:SetPosition(x, 0, z)
							klaus.sg:GoToState("attack_pre")
						elseif math.random() < CHANCE then
							local beequeen = SpawnPrefab("beequeen")
							beequeen.Transform:SetPosition(x, 0, z)
							beequeen.sg:GoToState("attack_pre")
						elseif math.random() < CHANCE then
							local toadstool = SpawnPrefab("toadstool")
							toadstool.Transform:SetPosition(x, 0, z)
							toadstool.sg:GoToState("attack_pre")
						elseif math.random() < ENDCHANCE then
							local boss = SpawnPrefab("deerclops")
							boss.Transform:SetPosition(x, 0, z)
							boss.sg:GoToState("attack_pre")
						end

                        SpawnPrefab("splash_ocean").Transform:SetPosition(x, 0, z)
						Sleep(.2)
						SpawnPrefab("lightning").Transform:SetPosition(x, 0, z)
						Sleep(.2)
						SpawnPrefab("lightning").Transform:SetPosition(x+4, 0, z+3)
						Sleep(.2)
						SpawnPrefab("lightning").Transform:SetPosition(x+7, 0, z-2)
						Sleep(.2)
						SpawnPrefab("lightning").Transform:SetPosition(x-5, 0, z+3)
						Sleep(.2)
						SpawnPrefab("lightning").Transform:SetPosition(x-4, 0, z-4)
                        ShakeAllCameras(CAMERASHAKE.FULL, .9, .16, .9, reader, 60)
                    end

                    Sleep(.33)
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

        inst.AnimState:SetBank("book_summon")
        inst.AnimState:SetBuild("book_summon")
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
		inst.components.inventoryitem.imagename = "book_summon"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/book_summon.xml"
		inst.fxcolour = {230/255, 1/255, 1/255}
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

local book_summon = {}
for i, v in ipairs(book_defs) do
    table.insert(book_summon, MakeBook(v))
end
book_defs = nil
return unpack(book_summon)
