local assets =
{
    Asset("ANIM", "anim/book_light.zip"),
	Asset("ATLAS", "images/inventoryimages/book_light.xml"),
    Asset("IMAGE", "images/inventoryimages/book_light.tex"),
}

local function kill_sound(inst)
    inst.SoundEmitter:KillSound("staff_star_loop")
end

local function kill_light(spell)
    spell.AnimState:PlayAnimation("disappear")
    spell:ListenForEvent("animover", kill_sound)
    spell:DoTaskInTime(1, spell.Remove) --originally 0.6, padded for network
end

local prefabs =
{
    "light",
    "sleepbomb_burst", 
}

local book_defs =
{
    {
        name = "book_light",
        uses = 15,
        fn = function(inst, reader)
            local pt = reader:GetPosition()
            local spawning = 1 -- how many times function is going to loop

            reader.components.sanity:DoDelta(-30)
			reader.components.hunger:DoDelta(-30)
			reader.components.talker:Say("Light of Justice!")
            reader:StartThread(function()
				for k = 1, spawning do
					local x, y, z = reader.Transform:GetWorldPosition()
					local spell = SpawnPrefab("stafflight")
					spell.Transform:SetPosition(x, y+12, z)
					spell:DoTaskInTime(120, kill_light)
					local spell2 = SpawnPrefab("deer_fire_flakes")
					spell2.Transform:SetPosition(x, y-1, z)
					spell2:DoTaskInTime(121, spell2.KillFX)
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

        inst.AnimState:SetBank("book_light")
        inst.AnimState:SetBuild("book_light")
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
		inst.components.inventoryitem.imagename = "book_light"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/book_light.xml"

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

local book_light = {}
for i, v in ipairs(book_defs) do
    table.insert(book_light, MakeBook(v))
end
book_defs = nil
return unpack(book_light)
