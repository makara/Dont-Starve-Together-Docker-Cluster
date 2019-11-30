local AutoFixer = Class(function(self, inst)
    self.inst = inst

    --V2C: Recommended to explicitly add tag to prefab pristine state
    inst:AddTag("autofixer")

    self.users = {}
    self.locked = false

    self.onremoveuser = function(user) self:TurnOff(user) end
end)

function AutoFixer:OnRemoveFromEntity()
    self.inst:RemoveTag("autofixer")
    for i, user in ipairs(self.users) do
        self.inst:RemoveEventCallback("onremove", self.onremoveuser, user)
        if self.stopfixing then
            self.stopfixing(self.inst, user)
        end        
    end
    self.users = nil
end

AutoFixer.OnRemoveEntity = AutoFixer.OnRemoveFromEntity

function AutoFixer:OnSave()
    return {locked = self.locked}
end

function AutoFixer:OnLoad(data)
    if data then
        self.locked = data.locked
    end
end

function AutoFixer:SetAutoFixUserTestFn(fn)
    self.autofixusertest = fn
end

function AutoFixer:SetCanTurnOnFn(fn)
    self.canturnon = fn
end

function AutoFixer:SetOnTurnOnFn(fn)
    self.onturnon = fn
end

function AutoFixer:SetOnTurnOffFn(fn)
    self.onturnoff = fn
end

function AutoFixer:SetStartFixingFn(fn)
    self.startfixing = fn
end

function AutoFixer:SetStopFixingFn(fn)
    self.stopfixing = fn
end

function AutoFixer:CanAutoFixUser(user)
    return not self.locked and (self.autofixusertest == nil or self.autofixusertest(self.inst, user))
end

function AutoFixer:TurnOn(user) 
    if not self.locked and (self.canturnon == nil or self.canturnon(self.inst)) then
        local _usercount = #self.users
        if not table.contains(self.users, user) then
            table.insert(self.users, user)
            self.inst:ListenForEvent("onremove", self.onremoveuser, user)
            if self.startfixing then
                self.startfixing(self.inst, user)
            end
        end
        if self.onturnon and _usercount == 0 and #self.users >= 1 then
            self.onturnon(self.inst)
        end
    end
end

function AutoFixer:TurnOff(user)
    if user == nil then
        local users = {}
        for i, v in ipairs(self.users) do
            users[i] = v
        end
        for i, v in ipairs(users) do
            self:TurnOff(v)
        end
        return
    end
    local _usercount = #self.users
    if table.contains(self.users, user) then
        table.removearrayvalue(self.users, user)
        self.inst:RemoveEventCallback("onremove", self.onremoveuser, user)
        if self.stopfixing then
            self.stopfixing(self.inst, user)
        end
    end
    if self.onturnoff and _usercount > 0 and #self.users <= 0 then
        self.onturnoff(self.inst)
    end
end

function AutoFixer:IsOn()
    return #self.users > 0
end

return AutoFixer