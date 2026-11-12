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
return Inventory
