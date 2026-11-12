--!strict
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Config=require(ReplicatedStorage.Shared.Config.MachineConfig)
local State=require(script.Parent.MachineState)
local Buffer=require(script.Parent.ItemBuffer)
local Production=require(script.Parent.ProductionService)
local Inventory=require(script.Parent.InventoryService)
local Service={}
local states={}
local started=false
function Service.attach(object)
 local config=Config[object:GetAttribute("TemplateId")]
 if not config or states[object] then return end
 states[object]=State.new(config)
 local prompt=Instance.new("ProximityPrompt");prompt.Name="MachinePrompt";prompt.ActionText="Управлять";prompt.ObjectText="Производство";prompt.MaxActivationDistance=16;prompt.RequiresLineOfSight=true;prompt.Parent=object
 Production.register(object,states[object])
end
function Service.get(object) return states[object] end
function Service.refundForRemoval(player,object,cost)
 local delta={ConstructionUnit=cost}
 local state=states[object]
 if state then
  for _,buffer in {state.input,state.output} do
   for id,amount in buffer.items do delta[id]=(delta[id] or 0)+amount end
  end
 end
 return Inventory.transact(player,delta)
end
function Service.start()
 if started then return end;started=true
 local folder=workspace:FindFirstChild("Buildings")
 if not folder then folder=Instance.new("Folder");folder.Name="Buildings";folder.Parent=workspace end
 folder.ChildAdded:Connect(Service.attach)
 folder.ChildRemoved:Connect(function(object) Production.unregister(object);states[object]=nil end)
 for _,object in folder:GetChildren() do Service.attach(object) end
 Production.start()
end
return Service
