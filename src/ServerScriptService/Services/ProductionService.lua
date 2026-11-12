--!strict
local RunService=game:GetService("RunService")
local Config=require(game:GetService("ReplicatedStorage").Shared.Config.MachineConfig)
local Engine=require(script.Parent.ProductionEngine)
local Buffer=require(script.Parent.ItemBuffer)
local HttpService=game:GetService("HttpService")
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
   if state.lastVisualStatus~=state.status then
    state.lastVisualStatus=state.status
    local lamp=object:FindFirstChild("StatusLamp")
    if lamp and lamp:IsA("BasePart") then
     lamp.Color=state.status=="Working" and Color3.fromRGB(70,220,110) or state.status=="OutputFull" and Color3.fromRGB(240,180,50) or Color3.fromRGB(140,145,150)
     lamp.Material=state.status=="Working" and Enum.Material.Neon or Enum.Material.SmoothPlastic
    end
    local sign=object:FindFirstChild("MachineStatus")
    local label=sign and sign:FindFirstChild("Label")
    local names={Working="Работает",WaitingInputs="Нет сырья",OutputFull="Выход заполнен",Disabled="Пауза",Completed="Цикл завершён",NoDeposit="Нет месторождения",Exhausted="Исчерпано",PowerPending="Энергетика — Phase 8",NoRecipe="Нет рецепта"}
    if label then label.Text=(object:GetAttribute("TemplateId") or object.Name).."\n"..(names[state.status] or state.status) end
   end
   object:SetAttribute("ProductionStatus",state.status)
   object:SetAttribute("ProductionProgress",state.progress)
   object:SetAttribute("RecipeId",state.recipeId)
   object:SetAttribute("InputTotal",Buffer.total(state.input))
   object:SetAttribute("OutputTotal",Buffer.total(state.output))
   object:SetAttribute("InputItems",HttpService:JSONEncode(state.input.items))
   object:SetAttribute("OutputItems",HttpService:JSONEncode(state.output.items))
  end
 end)
end
return Service
