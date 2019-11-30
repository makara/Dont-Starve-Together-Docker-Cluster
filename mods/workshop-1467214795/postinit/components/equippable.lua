local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function onboatequipslot(self, boatequipslot)
    self.inst.replica.equippable:SetBoatEquipSlot(boatequipslot)
end

local function ontoggled(self, toggled)
    if toggled then
        self.inst:AddTag("toggled")
    else
        self.inst:RemoveTag("toggled")
    end
end

local function ontogglable(self, togglable)
    if togglable then
        self.inst:AddTag("togglable")
    else
        self.inst:RemoveTag("togglable")
    end
end

local function IsPoisonBlocker(self)
    return self.poisonblocker or false
end

local function IsPoisonGasBlocker(self)
    return self.poisongasblocker or false
end

local function ToggleOn(self)
    self.toggled = true 
    if self.toggledonfn then 
        self.toggledonfn(self.inst)
    end 
end

local function ToggleOff(self)
    self.toggled = false 
    if self.toggledofffn then 
        self.toggledofffn(self.inst)
    end 
end  

local function IsToggledOn(self)
    return self.toggled 
end 

local function OnSave(self)
    local data = {}
    data.togglable = self.togglable
    data.toggled = self.toggled
    return data
end   


local function LoadPostPass(self, ents, data)
    if data and data.togglable then 
        self.togglable = data.togglable
        self.toggled = data.toggled
        if self.toggledon then 
            self:ToggleOn()
        else
            self:ToggleOff()
        end 

    end 
end   

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("equippable", function(cmp)


addsetter(cmp, "boatequipslot", onboatequipslot)
addsetter(cmp, "toggled", ontoggled)
addsetter(cmp, "togglable", ontogglable)

cmp.boatequipslot = nil
cmp.toggled = false
cmp.togglable = false
cmp.toggledonfn = nil 
cmp.toggledofffn = nil 

cmp.IsPoisonBlocker = IsPoisonBlocker 
cmp.IsPoisonGasBlocker = IsPoisonGasBlocker 
cmp.ToggleOn = ToggleOn 
cmp.ToggleOff = ToggleOff 
cmp.IsToggledOn = IsToggledOn 
cmp.OnSave = OnSave 
cmp.LoadPostPass = LoadPostPass 


end)
