--!strict
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local Prompts=game:GetService("ProximityPromptService")
local HttpService=game:GetService("HttpService")
local Catalog=require(RS.Shared.Config.ItemCatalog)
local Recipes=require(RS.Shared.Config.RecipeConfig)
local Controller={}
local started=false
function Controller.start()
 if started then return end;started=true
 local player=Players.LocalPlayer
 local gui=Instance.new("ScreenGui");gui.Name="MachineHUD";gui.ResetOnSpawn=false;gui.Parent=player:WaitForChild("PlayerGui")
 local frame=Instance.new("Frame");frame.Size=UDim2.new(0.42,0,0,330);frame.Position=UDim2.new(0.56,0,0.3,0);frame.BackgroundColor3=Color3.fromRGB(25,29,34);frame.Visible=false;frame.Parent=gui
 local label=Instance.new("TextLabel");label.Size=UDim2.new(1,0,0,165);label.BackgroundTransparency=1;label.TextColor3=Color3.new(1,1,1);label.TextSize=16;label.TextWrapped=true;label.Parent=frame
 local selected=nil
 local feedback=""
 local function send(action)
  if selected then RS.Remotes.MachineRequest:FireServer({action=action,buildId=selected:GetAttribute("BuildId")}) end
 end
 for i,entry in {{"Deposit","Загрузить цикл"},{"Collect","Забрать всё"},{"NextRecipe","Другой рецепт"},{"Toggle","Пуск / пауза"},{"Close","Закрыть"}} do
  local button=Instance.new("TextButton");button.Size=UDim2.new(1,-16,0,28);button.Position=UDim2.new(0,8,0,165+(i-1)*31);button.Text=entry[2];button.TextSize=16;button.Parent=frame
  button.Activated:Connect(function() if entry[1]=="Close" then selected=nil;frame.Visible=false else send(entry[1]) end end)
 end
 local function contents(json)
  local ok,items=pcall(function() return HttpService:JSONDecode(json or "{}") end)
  if not ok then return "—" end
  local rows={};for id,amount in items do if amount>0 then table.insert(rows,(Catalog[id] and Catalog[id].Name or id).." ×"..amount) end end
  table.sort(rows);return #rows>0 and table.concat(rows,", ") or "пусто"
 end
 Prompts.PromptTriggered:Connect(function(prompt)
  if prompt.Name~="MachinePrompt" then return end
  selected=prompt.Parent;feedback="";frame.Visible=true
 end)
 RS.Remotes.MachineResult.OnClientEvent:Connect(function(_,reason) feedback=tostring(reason) end)
 local elapsed=0
 RunService.Heartbeat:Connect(function(dt)
  elapsed+=dt;if elapsed<0.2 then return end;elapsed=0
  if not selected then return end
  local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
  if not selected.Parent or not root or (root.Position-selected.Position).Magnitude>20 then selected=nil;frame.Visible=false;return end
  local recipe=Recipes[selected:GetAttribute("RecipeId")]
  local progress=selected:GetAttribute("ProductionProgress") or 0
  local percent=recipe and math.floor(progress/recipe.Duration*100) or 0
  local status=selected:GetAttribute("ProductionStatus") or "Загрузка"
  local names={Working="Работает",WaitingInputs="Нет сырья",OutputFull="Выход заполнен",Disabled="Пауза",Completed="Цикл завершён",NoDeposit="Нет месторождения",Exhausted="Месторождение исчерпано",PowerPending="Энергетика — Phase 8",NoRecipe="Нет рецепта"}
  label.Text=(recipe and recipe.Name or "Машина").." · "..percent.."%\n"..(names[status] or status).."\nВход: "..contents(selected:GetAttribute("InputItems")).."\nВыход: "..contents(selected:GetAttribute("OutputItems")).."\n"..feedback
 end)
end
return Controller
