local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _GetInventoryLists
local function GetInventoryLists(self, same_container_only)
    same_container_only = false
    local lists = _GetInventoryLists(self, same_container_only)
    if not same_container_only then
        local firstcontainer = self.owner.HUD:GetFirstOpenContainerWidget()
        if firstcontainer then
            if firstcontainer.boatEquip then
                table.insert(lists, firstcontainer.boatEquip)
            end
        end
        local containers = self.owner.HUD:GetOpenContainerWidgets() 
        if containers then 
            for k,v in pairs(containers) do
                if v and v ~= firstcontainer then
                    table.insert(lists, v.inv)
                    if v.boatEquip then 
                        table.insert(lists, v.boatEquip)
                    end 
                end 
            end     
        end 
    end
    return lists
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddClassPostConstruct("widgets/inventorybar", function(widget)


_GetInventoryLists = widget.GetInventoryLists
widget.GetInventoryLists = GetInventoryLists


end)
