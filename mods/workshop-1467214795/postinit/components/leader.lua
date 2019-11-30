local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function HibernateFollower(self, follower, hibernate)
  if follower.components.follower then
    follower.components.follower:HibernateLeader(hibernate)
  end
end 

local function HibernateLandFollowers(self, hibernate)
  for k,v in pairs(self.followers) do
    if not k:CanOnWater() then
      self:HibernateFollower(k, hibernate)
    end
  end
end 

local function HibernateWaterFollowers(self, hibernate)
  for k,v in pairs(self.followers) do
    if not CanOnLand(k) then
      self:HibernateFollower(k, hibernate)
    end
  end
end 
----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("leader", function(cmp)


cmp.HibernateFollower = HibernateFollower
cmp.HibernateLandFollowers = HibernateLandFollowers
cmp.HibernateWaterFollowers = HibernateWaterFollowers


end)
