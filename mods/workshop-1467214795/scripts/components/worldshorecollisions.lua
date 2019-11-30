
--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------

--[[
local function MakeShoreObstaclePhysics(inst, rad, height)
    local phys = inst.entity:AddPhysics()
    phys:SetMass(0)
    phys:SetCollisionGroup(COLLISION.SHORE)
    phys:ClearCollisionMask()
    --this might need to get updated.
    phys:CollidesWith(COLLISION.CHARACTERS)
    phys:CollidesWith(COLLISION.FLYERS)
    phys:CollidesWith(COLLISION.GIANTS)
    phys:SetCapsule(rad, height or 2)

end

local function CreateShoreWall()
    local inst = CreateEntity()

    inst.persists = false
    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")

    inst.entity:AddTransform()

    inst.Transform:SetEightFaced()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("wall")
    inst.AnimState:SetBuild("wall_ruins")
    --inst.AnimState:PlayAnimation("broken")
    inst.AnimState:PlayAnimation("half")
    --"half" for when the wall is active

    inst.entity:SetPristine()

    return inst
end

local function SpawnShoreCollisionAt(self, x, z)
    if self.walllist[x][z] == nil then
        local shorewall = CreateShoreWall()
        shorewall.Transform:SetPosition(x, 0, z)
        self.walllist[x][z] = shorewall
    end
end

local function RemoveShoreCollisionAt(self, x, z)
    if self.walllist[x][z] ~= nil then
         self.walllist[x][z]:Remove()
         self.walllist[x][z] = nil
    end
end
--]]

local function AddPathfinderWallAt(self, x, z)
    if self.pathwalllist[x][z] == nil then
        TheWorld.Pathfinder:AddWall(x, 0, z)
        --self.walllist[x][z] = CreateShoreWall()
        --self.walllist[x][z].Transform:SetPosition(x, 0, z)
        self.pathwalllist[x][z] = 1
    else
        self.pathwalllist[x][z] = self.pathwalllist[x][z] + 1
    end
end

local function RemovePathfinderWallAt(self, x, z)
    if self.pathwalllist[x][z] ~= nil then
        if self.pathwalllist[x][z] == 1 then
            TheWorld.Pathfinder:RemoveWall(x, 0, z)
            --self.walllist[x][z]:Remove()
            --self.walllist[x][z] = nil
            self.pathwalllist[x][z] = nil
        else
            self.pathwalllist[x][z] = self.pathwalllist[x][z] - 1
        end
    end
end

local function MakeVerticalShoreWall(self, x, z1, z2)
    --this check will return false if the shore walls already exist at that point,
    --we cant check x, z though because thats a intersection wall between 4 different shoreline collisions.
    if self.pathwalllist[x][z2] == nil then
        for i = 0, 3, 1 do
            AddPathfinderWallAt(self, x + i, z1)
            AddPathfinderWallAt(self, x + i, z2)
        end
    end
end

local function RemoveVerticalShoreWall(self, x, z1, z2)
    if self.pathwalllist[x][z2] ~= nil then
        for i = 0, 3, 1 do
            RemovePathfinderWallAt(self, x + i, z1)
            RemovePathfinderWallAt(self, x + i, z2)
        end
    end
end

local function MakeHorizontalShoreWall(self, x1, x2, z)
    if self.pathwalllist[x2][z] == nil then
        for i = 0, 3, 1 do
            AddPathfinderWallAt(self, x1, z + i)
            AddPathfinderWallAt(self, x2, z + i)
        end
    end
end

local function RemoveHorizontalShoreWall(self, x1, x2, z)
    if self.pathwalllist[x2][z] == nil then
        for i = 0, 3, 1 do
            RemovePathfinderWallAt(self, x1, z + i)
            RemovePathfinderWallAt(self, x2, z + i)
        end
    end
end


local function MakeShoreCorner(self, x, z1, z2)
    if self.pathwalllist[x][z2] == nil then
        for i = 0, 0.5, 0.5 do
            AddPathfinderWallAt(self, x + i, z1)
            AddPathfinderWallAt(self, x + i, z2)
        end
    end
end

local function RemoveShoreCorner(self, x, z1, z2)
    if self.pathwalllist[x][z2] ~= nil then
        for i = 0, 0.5, 0.5 do
            RemovePathfinderWallAt(self, x + i, z1)
            RemovePathfinderWallAt(self, x + i, z2)
        end
    end
end

local function SpawnShoreCollisionForTile(self, x, y)
    local middle = GetTileInfo(self.map:GetTile(x, y))
    if middle and middle.type ~= TILE_TYPE.WATER then
        local leftup,   up,     rightup   = GetTileInfo(self.map:GetTile(x - 1, y - 1)), GetTileInfo(self.map:GetTile(x - 1, y)), GetTileInfo(self.map:GetTile(x - 1, y + 1))
        local left,             right     = GetTileInfo(self.map:GetTile(x, y - 1)),                                              GetTileInfo(self.map:GetTile(x, y + 1))
        local leftdown, down,   rightdown = GetTileInfo(self.map:GetTile(x + 1, y - 1)), GetTileInfo(self.map:GetTile(x + 1, y)), GetTileInfo(self.map:GetTile(x + 1, y + 1))
        local xstart, zstart = (self.tilestartx + (x * TILE_SCALE)), (self.tilestartz + (y * TILE_SCALE))
        if up and up.type == TILE_TYPE.WATER then
            MakeHorizontalShoreWall(self, xstart - 1.5, xstart - 1, zstart - 1.5)
        end
        if down and down.type == TILE_TYPE.WATER then
            MakeHorizontalShoreWall(self, xstart + 1.5, xstart + 1, zstart - 1.5)
        end
        if left and left.type == TILE_TYPE.WATER then
            MakeVerticalShoreWall(self, xstart - 1.5, zstart - 1.5, zstart - 1)
        end
        if right and right.type == TILE_TYPE.WATER then
            MakeVerticalShoreWall(self, xstart - 1.5, zstart + 1.5, zstart + 1)
        end
        if leftup and leftup.type == TILE_TYPE.WATER and not (up and up.type == TILE_TYPE.WATER) and not (left and left.type == TILE_TYPE.WATER) then
            MakeShoreCorner(self, xstart - 1.5, zstart - 1.5, zstart - 1)
        end
        if rightup and rightup.type == TILE_TYPE.WATER and not (up and up.type == TILE_TYPE.WATER) and not (right and right.type == TILE_TYPE.WATER) then
            MakeShoreCorner(self, xstart - 1.5, zstart + 1.5, zstart + 1)
        end
        if leftdown and leftdown.type == TILE_TYPE.WATER and not (down and down.type == TILE_TYPE.WATER) and not (left and left.type == TILE_TYPE.WATER) then
            MakeShoreCorner(self, xstart + 1, zstart - 1.5, zstart - 1)
        end
        if rightdown and rightdown.type == TILE_TYPE.WATER and not (down and down.type == TILE_TYPE.WATER) and not (right and right.type == TILE_TYPE.WATER) then
            MakeShoreCorner(self, xstart + 1, zstart + 1.5, zstart + 1)
        end
    end
end

local function RemoveShoreCollisionForTile(self, x, y)
    local xstart, zstart = (self.tilestartx + (x * TILE_SCALE)), (self.tilestartz + (y * TILE_SCALE))
    for k, v in pairs(self.pathwalllist) do
        if k > xstart - 2 and k < xstart + 2 then
            for k1, v1 in pairs(v) do
                if k1 > zstart - 2 and k1 < zstart + 2 then
                    if self.pathwalllist[k][k1] ~= nil then
                        self.pathwalllist[k][k1] = 1
                        RemovePathfinderWallAt(self, k, k1)
                    end
                end
            end
        end
    end

    --[[RemoveHorizontalShoreWall(self, xstart - 1.5, xstart - 1, zstart - 1.5)
    RemoveHorizontalShoreWall(self, xstart + 1.5, xstart + 1, zstart - 1.5)
    RemoveVerticalShoreWall(self, xstart - 1.5, zstart - 1.5, zstart - 1)
    RemoveVerticalShoreWall(self, xstart - 1.5, zstart + 1.5, zstart + 1)
    RemoveShoreCorner(self, xstart - 1.5, zstart - 1.5, zstart - 1)
    RemoveShoreCorner(self, xstart - 1.5, zstart + 1.5, zstart + 1)
    RemoveShoreCorner(self, xstart + 1, zstart - 1.5, zstart - 1)
    RemoveShoreCorner(self, xstart + 1, zstart + 1.5, zstart + 1)]]
end

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

local WorldShoreCollisions = Class(function(self, inst)
    self.inst = inst
    --simple metatable that prevents me from constantly having to do if walllist[x][y] == nil then wallist[x][y] = {} end
    --[[self.walllist = setmetatable({}, {__index = function(t, k)
        rawset(t, k, {})
        return rawget(t, k)
    end})]]
    self.pathwalllist = setmetatable({}, {__index = function(t, k)
        rawset(t, k, {})
        return rawget(t, k)
    end})
end)
  
--------------------------------------------------------------------------
--[[ Functions ]]
--------------------------------------------------------------------------

function WorldShoreCollisions:OnPostInit()
    self.map = self.inst.Map
    self.w, self.h = self.map:GetSize()
    self.tilestartx, self.tilestartz = -((self.w * TILE_SCALE) / 2), -((self.h * TILE_SCALE) / 2)
    self:SpawnCollisions()
end

function WorldShoreCollisions:SpawnCollisions()
    --we start at 0, 0 and do the right and down tiles, which when you iterate through all the tiles covers all shore borders.
    for i = 0, self.w, 1 do
        for j = 0, self.h, 1 do
            SpawnShoreCollisionForTile(self, i, j)
        end
    end
end

--this is called whenever a mod/item/whatever changes a tile from shore to land and vice versa.
function WorldShoreCollisions:UpdateTileCollisions(tilex, tiley)
    --hey i know this is stupid, but it works.
    RemoveShoreCollisionForTile(self, tilex - 1, tiley - 1)
    RemoveShoreCollisionForTile(self, tilex, tiley - 1)
    RemoveShoreCollisionForTile(self, tilex + 1, tiley - 1)
    RemoveShoreCollisionForTile(self, tilex - 1, tiley)
    RemoveShoreCollisionForTile(self, tilex, tiley)
    RemoveShoreCollisionForTile(self, tilex + 1, tiley)
    RemoveShoreCollisionForTile(self, tilex - 1, tiley + 1)
    RemoveShoreCollisionForTile(self, tilex, tiley + 1)
    RemoveShoreCollisionForTile(self, tilex + 1, tiley + 1)

    SpawnShoreCollisionForTile(self, tilex - 1, tiley - 1)
    SpawnShoreCollisionForTile(self, tilex, tiley - 1)
    SpawnShoreCollisionForTile(self, tilex + 1, tiley - 1)
    SpawnShoreCollisionForTile(self, tilex - 1, tiley)
    SpawnShoreCollisionForTile(self, tilex, tiley)
    SpawnShoreCollisionForTile(self, tilex + 1, tiley)
    SpawnShoreCollisionForTile(self, tilex - 1, tiley + 1)
    SpawnShoreCollisionForTile(self, tilex, tiley + 1)
    SpawnShoreCollisionForTile(self, tilex + 1, tiley + 1)
end

return WorldShoreCollisions
