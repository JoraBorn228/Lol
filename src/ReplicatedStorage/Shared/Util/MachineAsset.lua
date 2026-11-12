--!strict
local Asset={}
function Asset.pivot(root: BasePart,cf: CFrame)
 local previous=root.CFrame
 local parts={}
 for _,part in root:GetDescendants() do if part:IsA("BasePart") then parts[part]=previous:ToObjectSpace(part.CFrame) end end
 root.CFrame=cf
 for part,offset in parts do part.CFrame=cf*offset end
end
function Asset.preview(root: BasePart)
 for _,part in {root,table.unpack(root:GetDescendants())} do
  if part:IsA("BasePart") then part.Anchored=true;part.CanCollide=false;part.CanQuery=false;part.CanTouch=false;part.Transparency=0.55 end
 end
end
function Asset.addPorts(root: BasePart)
 local y=-root.Size.Y/2+1
 for name,cf in {InputPort=CFrame.new(0,y,-root.Size.Z/2),OutputPort=CFrame.new(0,y,root.Size.Z/2)*CFrame.Angles(0,math.pi,0),PowerPort=CFrame.new(root.Size.X/2,y,0)*CFrame.Angles(0,-math.pi/2,0)} do
  if not root:FindFirstChild(name) then local port=Instance.new("Attachment");port.Name=name;port.CFrame=cf;port.Parent=root end
 end
end
return Asset
