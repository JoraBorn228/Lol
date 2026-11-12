local RS=game.ReplicatedStorage
local S=game.ServerScriptService.Services
local Recipes=require(RS.Shared.Config.RecipeConfig)
local Catalog=require(RS.Shared.Config.ItemCatalog)
local Build=require(RS.Shared.Config.BuildCatalog)
local Config=require(RS.Shared.Config.MachineConfig)
local Asset=require(RS.Shared.Util.MachineAsset)
local State=require(S.MachineState)
local Buffer=require(S.ItemBuffer)
local Engine=require(S.ProductionEngine)
local checks=0
local function check(v,message) assert(v,message);checks+=1 end
for _,id in {"Extractor","Smelter","Constructor","Assembler","Generator"} do
 local object=RS.Assets[id]:Clone()
 check(object.Size==Build[id].Size,id.." footprint")
 local offsets={}
 for _,part in object:GetDescendants() do if part:IsA("BasePart") then offsets[part]=object.CFrame:ToObjectSpace(part.CFrame) end end
 Asset.addPorts(object)
 check(object.InputPort:IsA("Attachment") and object.OutputPort:IsA("Attachment") and object.PowerPort:IsA("Attachment"),id.." ports")
 local cf=CFrame.new(40,4,-40)*CFrame.Angles(0,math.pi/2,0)
 Asset.pivot(object,cf)
 for part,offset in offsets do
  check((part.Position-(cf*offset).Position).Magnitude<0.001,id.." child pivot")
  local relative=cf:ToObjectSpace(part.CFrame)
  for x=-1,1,2 do for y=-1,1,2 do for z=-1,1,2 do
   local p=relative*Vector3.new(part.Size.X*x/2,part.Size.Y*y/2,part.Size.Z*z/2)
   check(math.abs(p.X)<=object.Size.X/2+0.01 and math.abs(p.Y)<=object.Size.Y/2+0.01 and math.abs(p.Z)<=object.Size.Z/2+0.01,id.." visual within footprint")
  end end end
 end
 Asset.preview(object)
 for part in offsets do check(not part.CanCollide and not part.CanQuery,id.." safe ghost") end
 object:Destroy()
 for _,recipeId in Config[id].Recipes do check(Recipes[recipeId]~=nil,id.." recipe exists") end
end
for id,recipe in Recipes do
 for item in recipe.Inputs do check(Catalog[item]~=nil,id.." known input") end
 for item in recipe.Outputs do check(Catalog[item]~=nil,id.." known output") end
 if next(recipe.Inputs) then
  local state=State.new(Config.TestMachine);state.recipeId=id
  check(Buffer.apply(state.input,recipe.Inputs),id.." input load")
  Engine.step(state,recipe.Duration)
  check(Buffer.total(state.input)==0,id.." consumes batch")
  for item,amount in recipe.Outputs do check(state.output.items[item]==amount,id.." exact output") end
 end
end
local node=Instance.new("Folder");node.Name="Phase6UnitNode";node.Parent=workspace;node:SetAttribute("Remaining",2)
local state=State.new(Config.Extractor);state.requiresDeposit=true;state.resourceNode=node
Buffer.apply(state.output,{IronOre=100});Engine.step(state,2)
check(node:GetAttribute("Remaining")==2 and state.status=="OutputFull","Blocked extractor preserves node")
Buffer.apply(state.output,{IronOre=-100});Engine.step(state,2)
check(node:GetAttribute("Remaining")==1 and state.output.items.IronOre==1,"First ore mined exactly")
Engine.step(state,2);Engine.step(state,2)
check(node:GetAttribute("Remaining")==0 and state.output.items.IronOre==2 and state.status=="Exhausted","No infinite extraction")
state.resourceNode=nil;Engine.step(state,2);check(state.status=="NoDeposit","Detached extractor stops")
node:Destroy()
local generator=State.new(Config.Generator);generator.kind="Generator";Engine.step(generator,100)
check(generator.status=="PowerPending" and Buffer.total(generator.output)==0,"Generator awaits Phase 8")
local Resources=require(S.ResourceService)
check(Resources.findAt(Vector3.new(32,4,16))~=nil,"Deposit lookup")
check(Resources.findAt(Vector3.new(0,4,0))==nil,"No off-node binding")
return {passed=checks,machines=5}
