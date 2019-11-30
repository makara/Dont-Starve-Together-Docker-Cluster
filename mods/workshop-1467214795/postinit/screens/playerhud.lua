local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

local ContainerWidget = require("widgets/containerwidget")
local PoisonOver = require("widgets/poisonover")
local BoatOver = require "widgets/boatover"

IAENV.AddClassPostConstruct("screens/playerhud", function(cmp)

local _CreateOverlays = cmp.CreateOverlays
function cmp:CreateOverlays(owner)
    _CreateOverlays(self, owner)

    self.poisonover = self.overlayroot:AddChild(PoisonOver(owner))
    self.boatover = self.overlayroot:AddChild(BoatOver(owner))
end

function cmp:GetOpenContainerWidgets()
    return self.controls.containers
end

function cmp:OpenBoat(boat, sailing)
    if boat then
        local boatwidget = nil
        if sailing then
            self.controls.inv.boatwidget = self.controls.inv.root:AddChild(ContainerWidget(self.owner))
            boatwidget = self.controls.inv.boatwidget
            boatwidget:SetScale(1)
            boatwidget.scalewithinventory = false
            boatwidget:MoveToBack()
            self.controls.inv:Rebuild()
        else
            boatwidget = self.controls.containerroot:AddChild(ContainerWidget(self.owner))
        end

        boatwidget:Open(boat, self.owner, not sailing)

        for k,v in pairs(self.controls.containers) do
            if v.container then
                if v.parent == boatwidget.parent or k == boat then
                    v:Close()
                end
            else
                self.controls.containers[k] = nil
            end
        end
        
        self.controls.containers[boat] = boatwidget
    end
end

end)