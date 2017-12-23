_G.ChinesePlus.RenameAction("DESTINATION","選擇目的地")
if _G.TheNet:GetIsServer() then
  local FT_Points = {
    "homesign"
  }

  for k, v in pairs(FT_Points) do
    AddPrefabPostInit(v,function(inst)
        if _G.TheWorld.ismastersim and inst and inst.components and inst.components.fasttravel and inst.components.fasttravel.SelectDestination then
          inst.components.fasttravel.SelectDestination = nil
          local default_dist_cost = 32
          local max_sanity_cost = 15
          local min_hunger_cost = 5
          local sanity_cost_ratio = 20/75
          local find_dist = (max_sanity_cost / sanity_cost_ratio - min_hunger_cost) * default_dist_cost
          local ownershiptag = 'uid_private'
          local traveltag = 'FastTravelling'
          local FTSignTag = 'fast_travel'

          local function IsNearDanger(inst)
            local hounded = _G.TheWorld.components.hounded
            if hounded ~= nil and (hounded:GetWarning() or hounded:GetAttacking()) then
              return true
            end
            local burnable = inst.components.burnable
            if burnable ~= nil and (burnable:IsBurning() or burnable:IsSmoldering()) then
              return true
            end
            if inst:HasTag("spiderwhisperer") then
              return _G.FindEntity(inst, 10,
                function(target)
                  return (target.components.combat ~= nil and target.components.combat.target == inst)
                  or (not (target:HasTag("player") or target:HasTag("spider"))
                    and (target:HasTag("monster") or target:HasTag("pig")))
                end,
                nil, nil, { "monster", "pig", "_combat" }) ~= nil
            end
            return _G.FindEntity(inst, 10,
              function(target)
                return (target.components.combat ~= nil and target.components.combat.target == inst)
                or (target:HasTag("monster") and not target:HasTag("player"))
              end,
              nil, nil, { "monster", "_combat" }) ~= nil
          end

          function inst.components.fasttravel:SelectDestination(traveller)
            if traveller == nil then return end
            self:ListDestination(traveller)
            local comment = self.inst.components.talker
            local talk = traveller.components.talker

            if self.ownership and self.inst:HasTag(ownershiptag) and traveller.userid ~= nil and not self.inst:HasTag('uid_'..traveller.userid) then
              if comment then comment:Say("私人財產！")
              elseif talk then talk:Say("這是私有財產。") end
              return
            elseif self.totalsites < 1 then
              if comment then comment:Say("沒有可用的目的地。")
              elseif talk then talk:Say("無處可去！") end
              return
            end

            -- Restart travel tasks
            traveller:RemoveTag(traveltag)
            if traveller.untraveltask ~= nil then
              traveller.untraveltask:Cancel()
              traveller.untraveltask = nil
            end
            if self.traveltask ~= nil then
              self.traveltask:Cancel()
              self.traveltask = nil
            end
            if self.traveltask1 ~= nil then
              self.traveltask1:Cancel()
              self.traveltask1 = nil
            end
            if self.traveltask2 ~= nil then
              self.traveltask2:Cancel()
              self.traveltask2 = nil
            end
            if self.traveltask3 ~= nil then
              self.traveltask3:Cancel()
              self.traveltask3 = nil
            end
            if self.traveltask4 ~= nil then
              self.traveltask4:Cancel()
              self.traveltask4 = nil
            end
            if self.traveltask5 ~= nil then
              self.traveltask5:Cancel()
              self.traveltask5 = nil
            end

            -- Select next site
            if self.currentplayer ~= nil and self.currentplayer == traveller then
              self.site = self.site + 1
              if self.site > self.totalsites then self.site = 1 end
            end
            self.currentplayer = traveller
            local destination = self.destinations[self.site]
            if destination == nil then return end

            -- If next site is self, try next next site
            if destination == self.inst then
              self.site = self.site + 1
              if self.site > self.totalsites then self.site = 1 end
              destination = self.destinations[self.site]
              if destination == self.inst then
                return
              end
            end

            -- Site information
            local desc = destination and destination.components.writeable and destination.components.writeable:GetText()
            local description = desc and string.format('"%s"', desc) or "未知目的地"
            local information = ""
            local cost_hunger = min_hunger_cost
            local cost_sanity = 0
            local xi,yi,zi = self.inst.Transform:GetWorldPosition()
            local xf,yf,zf = destination.Transform:GetWorldPosition()
            local dist = math.sqrt((xi-xf)^2 + (zi-zf)^2)

            if destination and destination.components.fasttravel then
              traveller:AddTag(traveltag)
              traveller.untraveltask = traveller:DoTaskInTime(15, function() traveller:RemoveTag(traveltag) end)
              cost_hunger = cost_hunger + math.ceil(dist / self.dist_cost)
              cost_sanity = cost_hunger * sanity_cost_ratio
              if _G.TheWorld.state.season == "winter" then
                cost_sanity = cost_sanity * 1.25
              elseif _G.TheWorld.state.season == "summer" then
                cost_sanity = cost_sanity * 0.75
              end

              information = "目的地: "..description.." ("..string.format("%.0f", self.site).."/"..string.format("%.0f", self.totalsites)..")".."\n".."飢餓損耗： "..string.format("%.0f", cost_hunger).."\n".."精神損耗："..string.format("%.1f", cost_sanity)
              if comment then
                comment:Say(string.format(information),3)
              elseif talk then
                talk:Say(string.format(information),3)
              end

              self.traveltask = self.inst:DoTaskInTime(8, function()
                  local travellers = _G.TheSim:FindEntities(xi, yi, zi, 5, {traveltag,"player"},{"playerghost"})

                  for k, who in pairs(travellers) do
                    if destination == nil or not destination:IsValid() then
                      if comment then comment:Say("目標已經不能到達。")
                      elseif talk then talk:Say("目標已經不能到達。") end
                    elseif who == nil or (who.components.health and who.components.health:IsDead()) then
                      if comment then comment:Say("我們不傳送屍體。") end
                    elseif IsNearDanger(who) then
                      if talk then talk:Say("這時候旅行是不安全。")
                      elseif comment then comment:Say("這時候旅行是不安全的") end
                    elseif destination.components.fasttravel.ownership and destination:HasTag(ownershiptag) and who.userid ~= nil and not destination:HasTag('uid_'..who.userid) then
                      if comment then comment:Say("私人目的地。禁止遊客。")
                      elseif talk then talk:Say("目的地是私人的。") end
                    elseif who.components.hunger and who.components.hunger.current >= cost_hunger and who.components.sanity and who.components.sanity.current >= cost_sanity then
                      who.components.hunger:DoDelta(-cost_hunger)
                      who.components.sanity:DoDelta(-cost_sanity)
                      if who.Physics ~= nil then
                        who.Physics:Teleport(xf-1, 0, zf)
                      else
                        who.Transform:SetPosition(xf-1, 0, zf)
                      end

                      -- follow
                      if who.components.leader and who.components.leader.followers then
                        for kf,vf in pairs(who.components.leader.followers) do
                          if kf.Physics ~= nil then
                            kf.Physics:Teleport(xf+1, 0, zf)
                          else
                            kf.Transform:SetPosition(xf+1, 0, zf)
                          end
                        end
                      end

                      local inventory = who.components.inventory
                      if inventory then
                        for ki, vi in pairs(inventory.itemslots) do
                          if vi.components.leader and vi.components.leader.followers then
                            for kif,vif in pairs(vi.components.leader.followers) do
                              if kif.Physics ~= nil then
                                kif.Physics:Teleport(xf, 0, zf+1)
                              else
                                kif.Transform:SetPosition(xf, 0, zf+1)
                              end
                            end
                          end
                        end
                      end

                      local container = inventory:GetOverflowContainer()
                      if container then
                        for kb, vb in pairs(container.slots) do
                          if vb.components.leader and vb.components.leader.followers then
                            for kbf,vbf in pairs(vb.components.leader.followers) do
                              if kbf.Physics ~= nil then
                                kbf.Physics:Teleport(xf, 0, zf-1)
                              else
                                kbf.Transform:SetPosition(xf, 0, zf-1)
                              end
                            end
                          end
                        end
                      end
                      -- /follow

                      traveller:RemoveTag(traveltag)
                      if traveller.untraveltask ~= nil then
                        traveller.untraveltask:Cancel()
                        traveller.untraveltask = nil
                      end
                    else
                      if talk then talk:Say("我不會做這個。")
                      elseif comment then comment:Say("你不會做這個。") end
                    end
                  end
                end)

              self.traveltask5 = self.inst:DoTaskInTime(3, function() comment:Say("5 秒後開始傳送。")
              end)
            self.traveltask4 = self.inst:DoTaskInTime(4, function() comment:Say("請靠近這裡，否則視為放棄傳送！")
              self.inst.SoundEmitter:PlaySound("dontstarve/HUD/craft_down") end)
            self.traveltask3 = self.inst:DoTaskInTime(5, function() comment:Say("3 秒後開始傳送。")
              self.inst.SoundEmitter:PlaySound("dontstarve/HUD/craft_down") end)
            self.traveltask2 = self.inst:DoTaskInTime(6, function() comment:Say("2 秒後開始傳送。")
              self.inst.SoundEmitter:PlaySound("dontstarve/HUD/craft_down") end)
            self.traveltask1 = self.inst:DoTaskInTime(7, function() comment:Say("1 秒後開始傳送。",1)
              self.inst.SoundEmitter:PlaySound("dontstarve/HUD/craft_down") end)

          elseif comment then
            comment:Say("目的地不可到達！")
          elseif talk then
            talk:Say("目的地不可到達！")
          end

        end

      end
    end)
  end

end
