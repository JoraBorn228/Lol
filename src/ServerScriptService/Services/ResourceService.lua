--!strict
local Config=require(game:GetService("ReplicatedStorage").Shared.Config.ResourceConfig)
local Service={}
function Service.start()
 local map=workspace:WaitForChild("Map")
 if map:FindFirstChild("ResourceNodes") then return end
 local folder=Instance.new("Folder");folder.Name="ResourceNodes";folder.Parent=map
 for i,pos in Config.IronNodes do
  local node=Instance.new("Part");node.Name="IronNode"..i;node.Size=Vector3.new(8,0.5,8);node.Position=pos;node.Anchored=true;node.CanCollide=false;node.CanQuery=false;node.CanTouch=false;node.Color=Color3.fromRGB(165,90,55)
  node:SetAttribute("ResourceId","IronOre");node:SetAttribute("Remaining",Config.InitialAmount);node:SetAttribute("NodeId",node.Name)
  local gui=Instance.new("BillboardGui");gui.Size=UDim2.fromOffset(200,32);gui.StudsOffset=Vector3.new(0,3,0);gui.AlwaysOnTop=true;gui.Parent=node
  local label=Instance.new("TextLabel");label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=0.3;label.TextColor3=Color3.new(1,1,1);label.TextSize=16;label.Parent=gui
  local function update() label.Text="Железо: "..tostring(node:GetAttribute("Remaining")) end
  node:GetAttributeChangedSignal("Remaining"):Connect(update);update()
  node.Parent=folder
 end
end
function Service.findAt(position)
 local map=workspace:FindFirstChild("Map");local folder=map and map:FindFirstChild("ResourceNodes")
 if not folder then return nil end
 for _,node in folder:GetChildren() do
  if node:GetAttribute("ResourceId")=="IronOre" and Vector2.new(position.X-node.Position.X,position.Z-node.Position.Z).Magnitude<=Config.BindRadius then return node end
 end
 return nil
end
return Service
