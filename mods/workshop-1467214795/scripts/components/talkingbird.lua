local TalkingBird = Class(function(self, inst)
    self.inst = inst
    self.time_to_convo = 10

    self.inst:ListenForEvent("ondropped", function() self:OnDropped() end)
    self.inst:ListenForEvent("onputininventory", function(owner) self:OnPutInInventory(owner) end)

    local dt = 5 + math.random()
    self.inst:DoPeriodicTask(dt, function() self:OnUpdate(dt) end)
    self.warnlevel = 0
end)


function TalkingBird:OnDropped()
    self:Say(STRINGS.TALKINGBIRD.on_dropped)
    if self._owner then
        if self._onembark then
            self.inst:RemoveEventCallback("embarkboat", self._onembark, self._owner)
        end
        if self._ondisembark then
            self.inst:RemoveEventCallback("disembarkboat", self._ondisembark, self._owner)
        end
    end
    self._onembark = nil
    self._ondisembark = nil
    self._owner = nil
end

function TalkingBird:OnPutInInventory(owner)
    self._owner = owner
    if self._owner then
        self._onembark = function() self:OnEmbarked() end
        self._ondisembark = function() self:OnDisembarked() end
        self.inst:ListenForEvent("embarkboat", self._onembark, self._owner)
        self.inst:ListenForEvent("disembarkboat", self._ondisembark, self._owner)
    end
end

function TalkingBird:OnEmbarked()
    local grand_owner = self.inst.components.inventoryitem:GetGrandOwner()
    local owner = self.inst.components.inventoryitem.owner
    if (grand_owner and grand_owner:HasTag("player")) or (owner and owner:HasTag("player")) then
        self:Say(STRINGS.TALKINGBIRD.on_mounted)
    end
end

function TalkingBird:OnDisembarked()
    local grand_owner = self.inst.components.inventoryitem:GetGrandOwner()
    local owner = self.inst.components.inventoryitem.owner
    if (grand_owner and grand_owner:HasTag("player")) or (owner and owner:HasTag("player")) then
        self:Say(STRINGS.TALKINGBIRD.on_dismounted)
    end
end

function TalkingBird:OnUpdate(dt)
    self.time_to_convo = self.time_to_convo - dt
    if self.time_to_convo <= 0 then
        self:MakeConversation()
    end
end

function TalkingBird:Say(list, sound_override)
    self.sound_override = sound_override
    self.inst.components.talker:Say(list[math.random(#list)])
    self.time_to_convo = math.random(60, 120)
end


function TalkingBird:MakeConversation()
    if self.inst.components.freezable and self.inst.components.freezable:IsFrozen() then
        return
    end

    local grand_owner = self.inst.components.inventoryitem:GetGrandOwner()
    local owner = self.inst.components.inventoryitem.owner

    local quiplist = nil
    if owner and owner:HasTag("player") then
        if self.inst.components.equippable and self.inst.components.equippable:IsEquipped() then
            --currently equipped
        else
            --in player inventory
            quiplist = STRINGS.TALKINGBIRD.in_inventory
        end
    elseif owner == nil then
        --on the ground
        quiplist = STRINGS.TALKINGBIRD.on_ground
    elseif grand_owner and grand_owner ~= owner and grand_owner:HasTag("player") then
        --in a backpack
        quiplist = STRINGS.TALKINGBIRD.in_container
    elseif owner and owner.components.container then
        --in a container
        quiplist = STRINGS.TALKINGBIRD.in_container
    else
        --owned by someone else
        quiplist = STRINGS.TALKINGBIRD.other_owner
    end

    if quiplist then
        self:Say(quiplist)
    end
end

return TalkingBird
