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
 local gui=Instance.new("ScreenGui");gui.Name="InventoryHUD";gui.ResetOnSpawn=false;gui.Parent=player:WaitForChild("PlayerGui")
 local panel=Instance.new("TextLabel");panel.Size=UDim2.fromOffset(250,240);panel.Position=UDim2.new(0,12,0.3,0)
 panel.BackgroundColor3=Color3.fromRGB(25,29,34);panel.BackgroundTransparency=0.15;panel.TextColor3=Color3.new(1,1,1)
 panel.TextSize=18;panel.TextXAlignment=Enum.TextXAlignment.Left;panel.TextYAlignment=Enum.TextYAlignment.Top;panel.Visible=false;panel.Parent=gui
 local ids={};for id in Catalog do table.insert(ids,id) end;table.sort(ids)
 local function render()
  local rows={"Инвентарь · I — закрыть"}
  for _,id in ids do table.insert(rows,Catalog[id].Name..": "..tostring(inventory:GetAttribute(id) or 0)) end
  panel.Text=table.concat(rows,"\n")
 end
 inventory.AttributeChanged:Connect(render);render()
 CAS:BindAction("IndustriaInventory",function(_,state)
  if UIS:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
  if state==Enum.UserInputState.Begin then panel.Visible=not panel.Visible end
  return Enum.ContextActionResult.Sink
 end,true,Enum.KeyCode.I)
 CAS:SetTitle("IndustriaInventory","Инвентарь")
end
return Controller
