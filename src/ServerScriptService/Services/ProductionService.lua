--!strict
local RunService=game:GetService("RunService")
local Config=require(game:GetService("ReplicatedStorage").Shared.Config.MachineConfig)
local Engine=require(script.Parent.ProductionEngine)
local Service={}
local machines={}
local started=false
function Service.register(object,state)
 machines[object]=state
end
function Service.unregister(object) machines[object]=nil end
function Service.start()
 if started then return end;started=true
 local accumulator=0
 RunService.Heartbeat:Connect(function(dt)
  accumulator+=dt
  if accumulator<Config.TickSeconds then return end
  local elapsed=math.min(accumulator,1);accumulator=0
  local count=0
  for object,state in machines do
   if not object.Parent then machines[object]=nil;continue end
   count+=1
   if count>Config.MaxMachines then break end
   Engine.step(state,elapsed)
   object:SetAttribute("ProductionStatus",state.status)
   object:SetAttribute("ProductionProgress",state.progress)
   object:SetAttribute("RecipeId",state.recipeId)
   object:SetAttribute("InputTotal",require(script.Parent.ItemBuffer).total(state.input))
   object:SetAttribute("OutputTotal",require(script.Parent.ItemBuffer).total(state.output))
  end
 end)
end
return Service
