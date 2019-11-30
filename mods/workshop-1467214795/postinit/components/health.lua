local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function DoPoisonDamage(self, amount, doer)
  if not self.invincible and self.vulnerabletopoisondamage and self.poison_damage_scale > 0 then
    if amount > 0 then
      self:DoDelta(-amount*self.poison_damage_scale, false, "poison")
    end
  end
end

local function Drown(self)
	local rescueitem = nil --the thing that tells us not to drown this person
	local handled = false --something handles things for us (indication to break loops!)
	
	if self.cantdrown then
		--Werebeaver
		rescueitem = self.inst
		if type(self.cantdrown) == "function" then
			handled = self.cantdrown(self.inst)
		end
	end
	if not handled and self.inst.components.leader and self.inst.components.leader:CountFollowers() > 0 then
		--Ballphins
		for item,_ in pairs(self.inst.components.leader.followers) do
			if (item.components.follower.preventdrowningtest
			and item.components.follower.preventdrowningtest(item, self.inst))
			or (not item.components.follower.preventdrowningtest
			and item.components.follower.preventdrowning) then
				rescueitem = rescueitem or item
				if type(item.components.follower.preventdrowning) == "function" and not handled then
					handled = item.components.follower.preventdrowning(item, self.inst)
					rescueitem = item
					break
				end
			end
		end
	end
	if not handled and self.inst.components.inventory then
		--Life Jacket
		for slot, item in pairs(self.inst.components.inventory.equipslots) do
			if (item.components.equippable.preventdrowningtest
			and item.components.equippable.preventdrowningtest(item, self.inst))
			or (not item.components.equippable.preventdrowningtest
			and item.components.equippable.preventdrowning) then
				rescueitem = rescueitem or item
				if type(item.components.equippable.preventdrowning) == "function" and not handled then
					handled = item.components.equippable.preventdrowning(item, self.inst)
					rescueitem = item
					break
				end
			end
		end
	end
	
	if rescueitem then
		if not handled then
			self.inst:PushEvent("drown_fake", {rescueitem = rescueitem}) --The stategraph knows what to do from here
		end
		return false
	elseif CHEATS_ENABLED and self.inst.components.sailor then
		local boat = SpawnPrefab("boat_row")
		boat.Transform:SetPosition(self.inst:GetPosition():Get())
		self.inst.components.sailor:Embark(boat)
	else
		self.inst.components.health:DoDelta(-self.inst.components.health.currenthealth, false, "drowning", false, nil, true)
		return true
	end
end

local function DryDrown(self)
    --THIS IS NOT FUNCTIONAL YET -Z
    local rescueitem = nil --the thing that tells us not to drown this person
    local handled = false --something handles things for us (indication to break loops!)
    
    if self.cantdrown then
        --Werebeaver
        rescueitem = self.inst
        if type(self.cantdrown) == "function" then
            handled = self.cantdrown(self.inst)
        end
    end
    if not handled and self.inst.components.leader and self.inst.components.leader:CountFollowers() > 0 then
        --Ballphins
        for item,_ in pairs(self.inst.components.leader.followers) do
            if (item.components.follower.preventdrowningtest
            and item.components.follower.preventdrowningtest(item, self.inst))
            or (not item.components.follower.preventdrowningtest
            and item.components.follower.preventdrowning) then
                rescueitem = rescueitem or item
                if type(item.components.follower.preventdrowning) == "function" and not handled then
                    handled = item.components.follower.preventdrowning(item, self.inst)
                    rescueitem = item
                    break
                end
            end
        end
    end
    if not handled and self.inst.components.inventory then
        --Life Jacket
        for slot, item in pairs(self.inst.components.inventory.equipslots) do
            if (item.components.equippable.preventdrowningtest
            and item.components.equippable.preventdrowningtest(item, self.inst))
            or (not item.components.equippable.preventdrowningtest
            and item.components.equippable.preventdrowning) then
                rescueitem = rescueitem or item
                if type(item.components.equippable.preventdrowning) == "function" and not handled then
                    handled = item.components.equippable.preventdrowning(item, self.inst)
                    rescueitem = item
                    break
                end
            end
        end
    end
    
    if rescueitem then
        if not handled then
            self.inst:PushEvent("drown_fake", {rescueitem = rescueitem}) --The stategraph knows what to do from here
        end
        return false
    else
        self.inst.components.health:DoDelta(-self.inst.components.health.currenthealth, false, "drowning", false, nil, true)
        return true
    end
end


----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("health", function(cmp)


cmp.vulnerabletopoisondamage = true
cmp.poison_damage_scale = 1

cmp.DoPoisonDamage = DoPoisonDamage
cmp.Drown = Drown
cmp.DryDrown = DryDrown


end)
