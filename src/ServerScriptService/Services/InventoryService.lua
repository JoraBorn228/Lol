--!strict
local Players=game:GetService("Players")
local Shared=game:GetService("ReplicatedStorage").Shared
local Catalog=require(Shared.Config.ItemCatalog)
local Config=require(Shared.Config.ItemConfig)
local Inventory={}
local states={}
local started=false
local function publish(player)
 local folder=player:FindFirstChild("Inventory")
 if not folder then folder=Instance.new("Folder");folder.Name="Inventory";folder.Parent=player end
 for id in Catalog do folder:SetAttribute(id,states[player][id] or 0) end
 player:SetAttribute("ConstructionUnits",states[player].ConstructionUnit or 0)
end
function Inventory.ensure(player)
 if states[player] then return end
 local items={}
 for id in Catalog do items[id]=Config.StarterItems[id] or 0 end
 states[player]=items
 publish(player)
end
function Inventory.snapshot(player)
 Inventory.ensure(player)
 return table.clone(states[player])
end
function Inventory.start()
 if started then return end
 started=true
 Players.PlayerAdded:Connect(Inventory.ensure)
 Players.PlayerRemoving:Connect(function(player) states[player]=nil end)
 for _,player in Players:GetPlayers() do Inventory.ensure(player) end
end
function Inventory.transact(player, delta)
 if typeof(delta)~="table" then return false,"Некорректная операция" end
 Inventory.ensure(player)
 local nextState=table.clone(states[player])
 for id,amount in delta do
  if typeof(id)~="string" or not Catalog[id] or typeof(amount)~="number" or amount~=amount or math.abs(amount)>Config.MaxTransaction or amount%1~=0 then return false,"Некорректный ресурс или количество" end
  local value=(nextState[id] or 0)+amount
  if value<0 then return false,"Недостаточно ресурсов" end
  nextState[id]=value
 end
 local total=0
 for _,amount in nextState do total+=amount end
 if total>Config.Capacity then return false,"Инвентарь заполнен" end
 states[player]=nextState
 publish(player)
 return true,"Готово"
end
function Inventory.add(player,id,amount)
 if typeof(amount)~="number" or amount<=0 then return false,"Некорректное количество" end
 if typeof(id)~="string" then return false,"Некорректный ресурс" end
 return Inventory.transact(player,{[id]=amount})
end
return Inventory
