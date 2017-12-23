local strlist = {
  ["Friendly"] = "友好",
  ["Epic"] = "巨大",
  ["Small"] = "小型",
  ["Large"] = "大型",
  ["Trappable"] = "可捕获",
  ["Monster"] = "怪物",
  ["Insect"] = "昆虫",
  ["Bird"] = "鸟类",
  ["Animal"] = "动物",
}

AddClassPostConstruct("widgets/progressbar", function(self)
    if self.SetSubLabel then
      local function NewSetSubLabel(owner, text)
        local str = text
        if type(text) == "string" then
          for k,v in pairs(strlist) do
            str = _G.string.gsub(str, k, v)
          end
        end
        self.sublabel:SetString(str)
      end
      self.SetSubLabel = NewSetSubLabel
    end
  end)
