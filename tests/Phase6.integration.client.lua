-- Run in isolated Phase6 Client Play; moves its test character between machines.
local p=game.Players.LocalPlayer
local r=game.ReplicatedStorage.Remotes
local function waitFor(predicate,message,seconds)
 local deadline=os.clock()+(seconds or 20)
 repeat if predicate() then return end;task.wait(0.1) until os.clock()>deadline
 error(message)
end
local function moveNear(object)
 p.Character:PivotTo(CFrame.new(object.Position+Vector3.new(0,4,10)))
 task.wait(0.5)
end
local function request(object,action)
 r.MachineRequest:FireServer({action=action,buildId=object:GetAttribute("BuildId")})
 task.wait(0.25)
end
local specs={
 {"Extractor",Vector3.new(32,4,16)},
 {"Smelter",Vector3.new(16,4,16)},
 {"Constructor",Vector3.new(0,3,16)},
 {"Assembler",Vector3.new(-16,4,16)},
 {"Generator",Vector3.new(-32,3,-16)},
}
local objects={}
for _,spec in specs do
 r.BuildRequest:FireServer({action="Place",templateId=spec[1],position=spec[2],turns=0})
 waitFor(function()
  for _,object in workspace.Buildings:GetChildren() do if object:GetAttribute("TemplateId")==spec[1] and object:GetAttribute("OwnerUserId")==p.UserId then objects[spec[1]]=object;return true end end
  return false
 end,"Placement failed: "..spec[1],5)
 task.wait(0.2)
end
local extractor=objects.Extractor
waitFor(function() return (extractor:GetAttribute("OutputTotal") or 0)>=2 end,"Mining stalled")
moveNear(extractor);request(extractor,"Collect")
waitFor(function() return p.Inventory:GetAttribute("IronOre")>=12 end,"Ore collection failed")
local smelter=objects.Smelter
moveNear(smelter)
for _=1,6 do request(smelter,"Deposit") end
waitFor(function() return (smelter:GetAttribute("OutputTotal") or 0)==6 end,"Six ingots not smelted")
request(smelter,"Collect")
waitFor(function() return p.Inventory:GetAttribute("IronIngot")==6 end,"Ingot collection failed")
local constructor=objects.Constructor
moveNear(constructor)
for _=1,4 do request(constructor,"Deposit") end
waitFor(function() return (constructor:GetAttribute("OutputTotal") or 0)==4 end,"Four plates not produced")
request(constructor,"Collect");request(constructor,"NextRecipe")
waitFor(function() return constructor:GetAttribute("RecipeId")=="IronRod" end,"Rod recipe switch failed")
request(constructor,"Deposit");request(constructor,"Deposit")
waitFor(function() return (constructor:GetAttribute("OutputTotal") or 0)==2 end,"Two rods not produced")
request(constructor,"Collect")
waitFor(function() return p.Inventory:GetAttribute("IronPlate")==4 and p.Inventory:GetAttribute("IronRod")==2 end,"Constructor yield mismatch")
local assembler=objects.Assembler
moveNear(assembler);request(assembler,"Deposit")
waitFor(function() return (assembler:GetAttribute("OutputTotal") or 0)==1 end,"Assembly stalled")
request(assembler,"Collect")
waitFor(function() return p.Inventory:GetAttribute("ReinforcedPlate")==1 end,"Reinforced plate missing")
assert(p.Inventory:GetAttribute("IronIngot")==0 and p.Inventory:GetAttribute("IronPlate")==0 and p.Inventory:GetAttribute("IronRod")==0,"Intermediate resources not consumed exactly")
assert(objects.Generator:GetAttribute("ProductionStatus")=="PowerPending","Generator incorrectly produces power")
return {passed=true,modelsPlaced=5,reinforcedPlate=1,chain="mine -> smelt -> construct -> assemble",generator="PowerPending"}
