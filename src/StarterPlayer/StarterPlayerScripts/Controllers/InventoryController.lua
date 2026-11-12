--!strict
local Players=game:GetService("Players")
local CAS=game:GetService("ContextActionService")
local UIS=game:GetService("UserInputService")
local Catalog=require(game:GetService("ReplicatedStorage").Shared.Config.ItemCatalog)
local Controller={}
local started=false
function Controller.start()
 if started then return end
 started=true
 local player=Players.LocalPlayer
 local inventory=player:WaitForChild("Inventory",10)
 assert(inventory,"Inventory replication timed out")
 local gui=Instance.new("ScreenGui");gui.Name="InventoryHUD";gui.ResetOnSpawn=false;gui.DisplayOrder=20;gui.Parent=player:WaitForChild("PlayerGui")
 local panel=Instance.new("TextLabel");panel.Size=UDim2.fromOffset(250,240);panel.Position=UDim2.new(0,12,0.3,0)
 panel.BackgroundColor3=Color3.fromRGB(25,29,34);panel.BackgroundTransparency=0.15;panel.TextColor3=Color3.new(1,1,1)
 panel.Name="InventoryPanel";panel.TextSize=18;panel.TextXAlignment=Enum.TextXAlignment.Left;panel.TextYAlignment=Enum.TextYAlignment.Top;panel.Visible=false;panel.Parent=gui
 local function toggle() panel.Visible=not panel.Visible end
 local open=Instance.new("TextButton");open.Name="InventoryToggle";open.Size=UDim2.fromOffset(200,40);open.Position=UDim2.new(0,12,1,-56)
 open.BackgroundColor3=Color3.fromRGB(40,48,58);open.TextColor3=Color3.new(1,1,1);open.TextSize=18;open.Text="Инвентарь [I]";open.Parent=gui
 open.Activated:Connect(toggle)
 local close=Instance.new("TextButton");close.Name="Close";close.Size=UDim2.fromOffset(28,28);close.Position=UDim2.new(1,-28,0,0);close.Text="×";close.Parent=panel
 close.Activated:Connect(function() panel.Visible=false end)
 local ids={};for id in Catalog do table.insert(ids,id) end;table.sort(ids)
 local function render()
  local rows={"Инвентарь · I — закрыть"}
  for _,id in ids do table.insert(rows,Catalog[id].Name..": "..tostring(inventory:GetAttribute(id) or 0)) end
  panel.Text=table.concat(rows,"\n")
 end
 inventory.AttributeChanged:Connect(render);render()
 CAS:BindActionAtPriority("IndustriaInventory",function(_,state)
  if UIS:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
  if state==Enum.UserInputState.Begin then toggle() end
  return Enum.ContextActionResult.Sink
 end,false,Enum.ContextActionPriority.High.Value+1,Enum.KeyCode.I)
 CAS:SetTitle("IndustriaInventory","Инвентарь")
end
return Controller
