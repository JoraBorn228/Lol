--!strict
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Config=require(ReplicatedStorage.Shared.Config.MachineConfig)
local State=require(script.Parent.MachineState)
local Buffer=require(script.Parent.ItemBuffer)
local Production=require(script.Parent.ProductionService)
local Inventory=require(script.Parent.InventoryService)
local Recipes=require(ReplicatedStorage.Shared.Config.RecipeConfig)
local Players=game:GetService("Players")
local Service={}
local states={}
local started=false
local lastRequest={}
function Service.attach(object)
 local config=Config[object:GetAttribute("TemplateId")]
 if not config or states[object] then return end
 states[object]=State.new(config)
 local prompt=Instance.new("ProximityPrompt");prompt.Name="MachinePrompt";prompt.ActionText="Управлять";prompt.ObjectText="Производство";prompt.MaxActivationDistance=16;prompt.RequiresLineOfSight=true;prompt.Parent=object
 Production.register(object,states[object])
end
function Service.get(object) return states[object] end
function Service.handle(player,request)
 if typeof(request)~="table" or typeof(request.buildId)~="string" or #request.buildId>64 or typeof(request.action)~="string" then return false,"Некорректный запрос" end
 local now=os.clock()
 if now-(lastRequest[player] or -math.huge)<0.15 then return false,"Слишком часто" end
 lastRequest[player]=now
 local object,state
 for candidate,s in states do
  if candidate:GetAttribute("BuildId")==request.buildId then object=candidate;state=s;break end
 end
 if not object or not object.Parent then return false,"Машина не найдена" end
 if object:GetAttribute("OwnerUserId")~=player.UserId then return false,"Чужая машина" end
 local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
 local humanoid=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
 if not root or not humanoid or humanoid.Health<=0 or (root.Position-object.Position).Magnitude>20 then return false,"Подойдите ближе" end
 local recipe=Recipes[state.recipeId]
 if request.action=="Deposit" then
  if not Buffer.canApply(state.input,recipe.Inputs) then return false,"Вход заполнен" end
  local delta={};for id,amount in recipe.Inputs do delta[id]=-amount end
  local ok,reason=Inventory.transact(player,delta)
  if not ok then return false,reason end
  assert(Buffer.apply(state.input,recipe.Inputs),"Input transfer invariant")
  return true,"Сырьё загружено"
 elseif request.action=="Collect" then
  if Buffer.total(state.output)==0 then return false,"Выход пуст" end
  local ok,reason=Inventory.transact(player,table.clone(state.output.items))
  if not ok then return false,reason end
  table.clear(state.output.items)
  return true,"Продукция получена"
 elseif request.action=="Toggle" then
  state.enabled=not state.enabled;return true,state.enabled and "Включено" or "Остановлено"
 elseif request.action=="NextRecipe" then
  if state.progress>0 or Buffer.total(state.input)>0 or Buffer.total(state.output)>0 then return false,"Сначала опустошите машину" end
  local list=Config[object:GetAttribute("TemplateId")].Recipes
  local index=table.find(list,state.recipeId) or 1
  state.recipeId=list[index%#list+1];return true,"Рецепт изменён"
 end
 return false,"Неизвестная операция"
end
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
 ReplicatedStorage.Remotes.MachineRequest.OnServerEvent:Connect(function(player,request)
  local ok,reason=Service.handle(player,request)
  ReplicatedStorage.Remotes.MachineResult:FireClient(player,ok,reason)
 end)
 Players.PlayerRemoving:Connect(function(player) lastRequest[player]=nil end)
end
return Service
