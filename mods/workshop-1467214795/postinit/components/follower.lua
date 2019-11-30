local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _SetLeader
local function SetLeader(self, inst)
  self.previousleader = self.leader
  _SetLeader(self, inst)
end

local function HibernateLeader(self, hibernate)
  if hibernate == false then

    self.leader = self.hibernatedleader
    self.hibernatedleader = nil

    if self.leader and (self.leader:HasTag("player") or self.leader:HasTag("follower_leash")) then 
      self:StartLeashing()
    end
  elseif self.hibernatedleader ~= nil then
    print("!!ERROR: Leader Already Hibernated")
  elseif hibernate then
    self.hibernatedleader = self.leader
    self.leader = nil
    self:StopLeashing()
  end
end

local function SetFollowExitDestinations(self, exit_list)
  self.exit_destinations = exit_list
end

local function CanFollowLeaderThroughExit(self, exit_destination)
  local canFollow = false
  for k,v in ipairs(self.exit_destinations) do
    if v == exit_destination then
      canFollow = true
    end
  end
  return canFollow
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("follower", function(cmp)


cmp.previousleader = nil
cmp.hibernatedleader = nil
cmp.exit_destinations = { EXIT_DESTINATION.LAND }

_SetLeader = cmp.SetLeader
cmp.SetLeader = SetLeader

cmp.HibernateLeader = HibernateLeader
cmp.SetFollowExitDestinations = SetFollowExitDestinations
cmp.CanFollowLeaderThroughExit = CanFollowLeaderThroughExit


end)
