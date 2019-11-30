local function onvolume(self, volume)
    if volume > 0 then
        self.inst:AddTag("breederharvest")
    else
        self.inst:RemoveTag("breederharvest")
    end
end

local function onseeded(self, seeded)
    if not seeded then
        self.inst:AddTag("canbeseeded")
    else
        self.inst:RemoveTag("canbeseeded")
    end
end

local Breeder = Class(function(self, inst)
    self.inst = inst

    --V2C: Recommended to explicitly add tag to prefab pristine state
    self.inst:AddTag("breeder")

    self.crops = {}
    self.volume = 0
    self.max_volume = 4
    self.seeded = false
    self.harvestable = false
    self.level = 1
    self.croppoints = {}
    self.growrate = 1

    self.haspredators = true

    self.luretime = TUNING.SEG_TIME * 5
    self.cycle_min = TUNING.SEG_TIME * 6
    self.cycle_max = TUNING.SEG_TIME * 10
end,
nil,
{
    seeded = onseeded,
    volume = onvolume,
})

function Breeder:IsEmpty()
    return self.volume == 0
end

function Breeder:OnSave()
    local data = {
        harvestable = self.harvestable,
        volume = self.volume,
        seeded = self.seeded,
        product = self.product,
        harvested = self.harvested,
    }

    if self.BreedTask then     
        data.breedtasktime = GetTaskRemaining(self.BreedTask)     
    end

    if self.luretask then
        data.luretasktime = GetTaskRemaining(self.luretask) 
    end

    return data
end    

function Breeder:OnLoad(data, newents)    
	self.volume = data.volume
    self.seeded = data.seeded
    self.harvestable = data.harvestable
    self.product = data.product   
    self.harvested= data.harvested

    if data.breedtasktime then        
        self.BreedTask = self.inst:DoTaskInTime(data.breedtasktime, function() self:CheckVolume() end)
    end

    if data.luretasktime then
        self.LureTask = self.inst:DoTaskInTime(data.luretask, function() self:CheckLure() end)
    end

    self.inst:DoTaskInTime(0, function() self.inst:PushEvent("vischange") end )
end

function Breeder:CheckSeeded()
    if self.volume < 1 and not self.harvestable then        
        self:StopBreeding()
    end 
    self.inst:PushEvent("vischange")
end

function Breeder:UpdateVolume(delta)
    self.volume = math.min(math.max(self.volume + delta, 0), self.max_volume)
    self:CheckSeeded()
end

local function SpawnPredatorPrefab(inst)
    local prefab = "crocodog"

    local x, y, z = inst.Transform:GetWorldPosition()
    local tile, tileinfo = inst:GetCurrentTileType(x, y, z)

    --TODO more tile properties?
    if tile == GROUND.OCEAN_DEEP or tile == GROUND.OCEAN_MEDIUM then
        if math.random() < 0.7 then
            prefab = "swordfish"
        end
    end

    local pt = Vector3(inst.Transform:GetWorldPosition())
    local predators = TheSim:FindEntities(pt.x, pt.y, pt.z, 10, {"crocodog", "swordfish"})

    if #predators > 2 then
        return nil
    end
    return SpawnPrefab(prefab)
end

function Breeder:SummonPredator()
    if not self.haspredators then
        return
    end
    local spawn_pt = Vector3(self.inst.Transform:GetWorldPosition())

    if spawn_pt then
        local predator = self.spawnpredatorprefabfn == nil and SpawnPredatorPrefab(self.inst) or self.spawnpredatorprefabfn(self.inst)

        if predator then
            local radius = 30 
            local base = spawn_pt
            local theta = math.random() * 2 * PI
            local offset = Vector3(0,0,0)

            local player = self.inst:GetNearestPlayer(true)

            if player and self.inst:GetDistanceSqToInst(player) < radius * radius then
                offset = Vector3(radius * math.cos(theta), 0, -radius * math.sin(theta))            
                base = Vector3(player.Transform:GetWorldPosition())
                predator.Physics:Teleport((base + offset):Get())
                predator.components.combat:SuggestTarget(player)
            else
                predator.Physics:Teleport(base:Get())
            end
        end
    end
end

function Breeder:CheckLure()
    if self.volume > 0 then
        if math.random() * 120 / math.pow(self.volume, 1.5) <= 1 then
            self:SummonPredator()
        end
    end
    self.LureTask = self.inst:DoTaskInTime(self.luretime, function() self:CheckLure() end)
end

function Breeder:CheckVolume()
    if self.seeded then
        self:UpdateVolume(1)
        self.inst:PushEvent("vischange")

        local time = math.random(self.cycle_min, self.cycle_max)

        self.BreedTask = self.inst:DoTaskInTime(time, function() self:CheckVolume() end)
    end
end

function Breeder:Seed(item)
    if not item.components.seedable then
        return false
    end
    
    self:Reset()
    
    local prefab = nil
    if item.components.seedable.product and type(item.components.seedable.product) == "function" then
		prefab = item.components.seedable.product(item)
    else
		prefab = item.components.seedable.product or item.prefab
	end

    self.product = prefab

    self.seeded = true

    local time = math.random(self.cycle_min, self.cycle_max)

    self.BreedTask = self.inst:DoTaskInTime(time, function() self:CheckVolume() end)

    self.LureTask = self.inst:DoTaskInTime(self.luretime, function() self:CheckLure() end)

    if self.onseedfn then
		self.onseedfn(self.inst, item)
    end

    self.inst:PushEvent("vischange")

	item:Remove()    
	
    return true
end

function Breeder:Harvest(harvester)
    if self.onharvestfn then
        self.onharvestfn(self.inst, harvester)
    end

    self.harvestable = false
    self.harvested = true
    if harvester and harvester.components.inventory then
        local product = SpawnPrefab(self.product)
        harvester.components.inventory:GiveItem(product)
    elseif harvester and harvester.components.lootdropper then
        harvester.components.lootdropper:SpawnLootPrefab(self.product)
    end
    self:UpdateVolume(-1)   

    return true
end

function Breeder:GetDebugString()
    return "seeded: ".. tostring(self.seeded) .." harvestable: ".. tostring(self.harvestable) .." volume: ".. tostring(self.volume)
end

function Breeder:Reset()
    self.harvested = false
    self.seeded = false
    self.harvestable = false
    self.volume = 0   
    self.product = nil 
    self.inst:PushEvent("vischange")

    if self.LureTask then
        self.LureTask:Cancel()
        self.LureTask = nil
    end
end

function Breeder:StopBreeding()
    self:Reset()
    if self.BreedTask then
        self.BreedTask:Cancel()
        self.BreedTask = nil
    end
end

return Breeder
