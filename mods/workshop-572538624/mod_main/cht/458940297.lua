STRINGS.DFV_HUNGER = "飽食度"
STRINGS.DFV_HEALTH = "生命值"
STRINGS.DFV_SANITY = "精神值"
STRINGS.DFV_PERISHSOON = "它馬上就腐爛了"
STRINGS.DFV_PERISHIN = "它快要腐爛了"
STRINGS.DFV_SPOILSOON = "它馬上就壞了"
STRINGS.DFV_SPOILIN = "它快要壞了"
STRINGS.DFV_STALESOON = "它馬上就不新鮮了"
STRINGS.DFV_STALEIN = "它快要不新鮮了"
STRINGS.DFV_SPOILDAY = "天"
STRINGS.DFV_REMAININGBURNTIME = "剩餘燃燒時間："
STRINGS.DFV_TIMETILLMORNING = "燃燒到早晨的時間："

if not _G.TheNet:GetIsServer() then return end

AddPlayerPostInit(function(inst)
    if inst and inst.components and inst.components.itemvalues and inst.components.itemvalues.On_ItemValue_Changed then
      inst.components.itemvalues.On_ItemValue_Changed = nil
      function inst.components.itemvalues:On_ItemValue_Changed(player, item, keydown, ctrlkeydown, DFV_FUELEDSET, show_damage, show_uses, show_temp, show_insul, show_acond, show_adef, show_atype)
        self.item = item
        if keydown and self.item.components.cookable ~= nil then
          local campfire = self:SpawnPrefabAsServerAndRemoveFromWorld("campfire")
          self.item = self.item.components.cookable:Cook(campfire, player)
          self.string = "\n" .. "如果做熟"
        else
          self.string = ""
        end
        local actionpicker = player.components.playeractionpicker
        local realfood = nil

        local actions = actionpicker:GetInventoryActions(self.item)
        if #actions > 0 then
          for k,v in pairs(actions) do
            if v.action == _G.ACTIONS.EAT or v.action == _G.ACTIONS.HEAL then
              realfood = true
              break
            end
          end
        end

        if realfood and self.item.components.edible and not ctrlkeydown then
          if player.components.eater and player.components.eater.monsterimmune then
            if self.item.components.edible.hungervalue < 0 and player.components.eater:DoFoodEffects(self.item) or self.item.components.edible.hungervalue > 0 then
              self.hungervalue = math.floor(self.item.components.edible:GetHunger(player) * 10 + 0.5) / 10
            end
            if self.item.components.edible.healthvalue < 0 and player.components.eater:DoFoodEffects(self.item) or self.item.components.edible.healthvalue > 0 then
              self.healthvalue = math.floor(self.item.components.edible:GetHealth(player) * 10 + 0.5) / 10
            end
            if self.item.components.edible.sanityvalue < 0 and player.components.eater:DoFoodEffects(self.item) or self.item.components.edible.sanityvalue > 0 then
              self.sanityvalue = math.floor(self.item.components.edible:GetSanity(player) * 10 + 0.5) / 10
            end
          else
            self.hungervalue = math.floor(self.item.components.edible:GetHunger(player) * 10 + 0.5) / 10
            self.healthvalue = math.floor(self.item.components.edible:GetHealth(player) * 10 + 0.5) / 10
            self.sanityvalue = math.floor(self.item.components.edible:GetSanity(player) * 10 + 0.5) / 10
          end

        elseif self.item.components.healer and realfood then
          self.healthvalue = math.floor(self.item.components.healer.health * 10 + 0.5) / 10
        else
          self.hungervalue = 0
          self.healthvalue = 0
          self.sanityvalue = 0
        end

        if STRINGS.DFV_MIN then
          if self.hungervalue ~= 0 or self.healthvalue ~= 0 or self.sanityvalue ~= 0 then
            self.string = self.string .. "\n"
          end

          if self.hungervalue ~= 0 then
            self.string = self.string .. "\153" .. " " .. self.hungervalue .. " "
          end
          if self.healthvalue ~= 0 then
            self.string = self.string .. "\151" .. " " .. self.healthvalue .. " "
          end
          if self.sanityvalue ~= 0 then
            self.string = self.string .. "\152" .. " " .. self.sanityvalue .. " "
          end
        else
          if self.hungervalue ~= 0 then
            self.string = self.string.."\n" .. STRINGS.DFV_HUNGER .. " " .. self.hungervalue
          end
          if self.healthvalue ~= 0 then
            self.string = self.string.."\n" .. STRINGS.DFV_HEALTH .. " " .. self.healthvalue
          end
          if self.sanityvalue ~= 0 then
            self.string = self.string.."\n" .. STRINGS.DFV_SANITY .. " " .. self.sanityvalue
          end

        end

        if self.item.components.perishable and realfood and ctrlkeydown then
          local owner = item.components.inventoryitem and item.components.inventoryitem.owner
          local modifier = 1

          if owner then
            if owner:HasTag("fridge") then
              if item:HasTag("frozen") then
                modifier = _G.TUNING.PERISH_COLD_FROZEN_MULT
              else
                modifier = _G.TUNING.PERISH_FRIDGE_MULT
              end
            elseif owner:HasTag("spoiler") then
              modifier = _G.TUNING.PERISH_GROUND_MULT
            end
          else
            modifier = _G.TUNING.PERISH_GROUND_MULT
          end

          if self.item.components.perishable.frozenfiremult then
            modifier = modifier * _G.TUNING.PERISH_FROZEN_FIRE_MULT
          end

          modifier = modifier * _G.TUNING.PERISH_GLOBAL_MULT

          if modifier ~= 0 then

            if item.components.cookable and keydown then
              self.perishremainingtime = math.floor((self.item.components.perishable.perishremainingtime / _G.TUNING.TOTAL_DAY_TIME / modifier)* 10 + 0.5) / 10
              self.staleremainingtime = math.floor((self.item.components.perishable.perishremainingtime/ _G.TUNING.TOTAL_DAY_TIME / modifier - 0.5 * self.item.components.perishable.perishtime/ _G.TUNING.TOTAL_DAY_TIME / modifier )* 10 + 0.5) / 10
              self.spoilremainingtime = math.floor((self.item.components.perishable.perishremainingtime/ _G.TUNING.TOTAL_DAY_TIME / modifier - 0.2 * self.item.components.perishable.perishtime/ _G.TUNING.TOTAL_DAY_TIME / modifier )* 10 + 0.5) / 10
            else
              self.perishremainingtime = math.floor((item.components.perishable.perishremainingtime / _G.TUNING.TOTAL_DAY_TIME / modifier)* 10 + 0.5) / 10
              self.staleremainingtime = math.floor((item.components.perishable.perishremainingtime/ _G.TUNING.TOTAL_DAY_TIME / modifier - 0.5 * item.components.perishable.perishtime/ _G.TUNING.TOTAL_DAY_TIME / modifier )* 10 + 0.5) / 10
              self.spoilremainingtime = math.floor((item.components.perishable.perishremainingtime/ _G.TUNING.TOTAL_DAY_TIME / modifier - 0.2 * item.components.perishable.perishtime/ _G.TUNING.TOTAL_DAY_TIME / modifier )* 10 + 0.5) / 10
            end

            if self.perishremainingtime < 0.1 then
              self.string = self.string.."\n" .. STRINGS.DFV_PERISHSOON
            elseif STRINGS.DFV_LANG ~= "RU" then
              self.string = self.string.."\n" .. STRINGS.DFV_PERISHIN .. " 剩 " .. self.perishremainingtime .. " " .. STRINGS.DFV_SPOILDAY
            else
              self.string = self.string.."\n" .. STRINGS.DFV_PERISHIN .. " " .. self.perishremainingtime .. " "
            end
            if STRINGS.DFV_LANG == "RU" then
              local plural_days = {"день", "дня", "дней"}
              local plural_type = function(n)
                if n%10==1 and n%100~=11 then
                  return 1
                elseif n%10>=2 and n%10<=4 and (n%100<10 or n%100>=20) then
                  return 2
                else
                  return 3
                end
              end
              self.string = self.string .. plural_days[plural_type(math.modf(self.perishremainingtime))]
            else
              if self.perishremainingtime >1 then
                if STRINGS.DFV_LANG == "GR" then
                  self.string = self.string .. "en"
                elseif STRINGS.DFV_LANG == "IT" then
                  self.string = self.string .. "i"
                else
                  self.string = self.string .. ""
                end
              elseif self.perishremainingtime >= 0.1 and STRINGS.DFV_LANG == "IT" then
                self.string = self.string .. "o"
              end
            end
            local prep_foods = _G.require("preparedfoods")
            if prep_foods[item.prefab] ~= nil and prep_foods[item.prefab].temperatureduration ~= nil then
              self.string = self.string .. " / t "
              if prep_foods[item.prefab].temperature < 0 then
                self.string = self.string .. "-"
              else
                self.string = self.string .. "+"
              end
              self.string = self.string .. prep_foods[item.prefab].temperatureduration
            elseif item.prefab == "ice" and item.components.edible.temperatureduration ~= nil then
              self.string = self.string .. " / t "
              if item.components.edible.temperaturedelta < 0 then
                self.string = self.string .. "-"
              else
                self.string = self.string .. "+"
              end
              self.string = self.string .. item.components.edible.temperatureduration
            end

            if self.spoilremainingtime < 0 then
            elseif self.spoilremainingtime < 0.1 then
              self.string = self.string.."\n" .. STRINGS.DFV_SPOILSOON
            elseif STRINGS.DFV_LANG ~= "RU" then
              self.string = self.string.."\n" .. STRINGS.DFV_SPOILIN .. " 剩 " .. self.spoilremainingtime .. " " .. STRINGS.DFV_SPOILDAY
            else
              self.string = self.string.."\n" .. STRINGS.DFV_SPOILIN .. " " .. self.spoilremainingtime .. " "
            end
            if STRINGS.DFV_LANG == "RU" then
              local plural_days = {"день", "дня", "дней"}
              local plural_type = function(n)
                if n%10==1 and n%100~=11 then
                  return 1
                elseif n%10>=2 and n%10<=4 and (n%100<10 or n%100>=20) then
                  return 2
                else
                  return 3
                end
              end
              self.string = self.string .. plural_days[plural_type(math.modf(self.spoilremainingtime))]
            else
              if self.spoilremainingtime > 1 then
                if STRINGS.DFV_LANG == "GR" then
                  self.string = self.string .. "en"
                elseif STRINGS.DFV_LANG == "IT" then
                  self.string = self.string .. "i"
                else
                  self.string = self.string .. ""
                end
              elseif self.spoilremainingtime >= 0.1 and STRINGS.DFV_LANG == "IT" then
                self.string = self.string .. "o"
              end
            end

            if self.staleremainingtime < 0 then
            elseif self.staleremainingtime < 0.1 then
              self.string = self.string.."\n" .. STRINGS.DFV_STALESOON
            elseif STRINGS.DFV_LANG ~= "RU" then
              self.string = self.string.."\n" .. STRINGS.DFV_STALEIN .. " 剩 " .. self.staleremainingtime .. " " .. STRINGS.DFV_SPOILDAY
            else
              self.string = self.string.."\n" .. STRINGS.DFV_STALEIN .. " " .. self.staleremainingtime .. " "
            end
            if STRINGS.DFV_LANG == "RU" then
              local plural_days = {"день", "дня", "дней"}
              local plural_type = function(n)
                if n%10==1 and n%100~=11 then
                  return 1
                elseif n%10>=2 and n%10<=4 and (n%100<10 or n%100>=20) then
                  return 2
                else
                  return 3
                end
              end
              self.string = self.string .. plural_days[plural_type(math.modf(self.staleremainingtime))]
            else
              if self.staleremainingtime ~= 1.0 then
                if STRINGS.DFV_LANG == "GR" then
                  self.string = self.string .. "en"
                elseif STRINGS.DFV_LANG == "IT" then
                  self.string = self.string .. "i"
                else
                  self.string = self.string .. ""
                end
              elseif self.staleremainingtime >= 1 and STRINGS.DFV_LANG == "IT" then
                self.string = self.string .. "o"
              end
            end

          else
            self.string = self.string .. "\n"
            local prep_foods = _G.require("preparedfoods")
            if prep_foods[item.prefab] ~= nil and prep_foods[item.prefab].temperatureduration ~= nil then
              self.string = self.string .. "t "
              if prep_foods[item.prefab].temperature < 0 then
                self.string = self.string .. "-"
              else
                self.string = self.string .. "+"
              end
              self.string = self.string .. prep_foods[item.prefab].temperatureduration
            elseif item.prefab == "ice" and item.components.edible.temperatureduration ~= nil then
              self.string = self.string .. "t "
              if item.components.edible.temperaturedelta < 0 then
                self.string = self.string .. "-"
              else
                self.string = self.string .. "+"
              end
              self.string = self.string .. item.components.edible.temperatureduration
            end
          end
        end

        if item.components.weapon ~= nil and (show_damage or keydown) then
          self.string = self.string .. "\n" .. "攻擊力: " .. item.components.weapon.damage
        end
        if item.components.finiteuses ~= nil and (show_uses or keydown) then
          self.string = self.string .. "\n" .. "使用次數: " .. item.components.finiteuses:GetUses()
        end
        if item.components.temperature ~= nil and (show_temp or keydown) then
          self.string = self.string .. "\n" .. math.floor(item.components.temperature.current*10)/10 .. "\176C"
        end
        if item.components.fueled ~= nil then
          if item.name == "Thermal Stone" then
            self.string = self.string .. "\n" .. item.components.fueled:GetPercent() * _G.TUNING.HEATROCK_NUMUSES .. " 耐久"
          else
            if DFV_FUELEDSET == "both" or DFV_FUELEDSET == "default" then
              local minutes_left = math.floor((item.components.fueled.currentfuel / item.components.fueled.rate) / 60)
              local seconds_left = math.floor(item.components.fueled.currentfuel - minutes_left * 60)
              local zero = ""
              if seconds_left < 10 then
                zero = "0"
              end
              self.string = self.string .. "\n" .. minutes_left .. ":" .. zero .. seconds_left
            end
            if DFV_FUELEDSET == "both" or DFV_FUELEDSET == "seg" then
              local total_segments = math.floor(((item.components.fueled.currentfuel / item.components.fueled.rate) / (_G.TUNING.TOTAL_DAY_TIME / 16))*10)/10
              if total_segments > 16 then
                local days = math.floor(total_segments/16)
                local segments = math.floor((total_segments - days*16)*10)/10
                self.string = self.string .. "\n" .. days .. " 天 ".. segments .. " 段"
              else
                self.string = self.string .. "\n" .. total_segments .. " 段"
              end
            end
          end
        end
        if item.components.armor ~= nil then
          if item.components.armor.condition ~= nil and (show_acond or keydown) then
            self.string = self.string .. "\n" .. "防具耐久: " .. math.floor(item.components.armor.condition)
          end
          if item.components.armor.tags ~= nil and (show_atype or keydown) then
            for k,v in pairs(item.components.armor.tags) do
              self.string = self.string .. "\n" .. "保護 " .. v .. " 傷害"
            end
          end
          if show_adef then
            self.string = self.string .. "\n" .. "傷害吸收: " .. item.components.armor.absorb_percent * 100 .. "%"
          end
        end
        if item.components.insulator ~= nil and (show_insul or keydown) then
          self.string = self.string .. "\n" .. math.floor(item.components.insulator.insulation) .. " 隔熱時間"
        end

        self.string = self.string .."\n\n" .. " "
        self.string_dirty:set(self.string)
        self.itemupdate:push()

      end

    end
  end)

