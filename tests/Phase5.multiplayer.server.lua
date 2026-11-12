local test=game:GetService("StudioTestService")
local okArgs,args=pcall(function() return test:GetTestArgs() end)
if not okArgs or typeof(args)~="table" or not args.phase5 then return end
local ack=Instance.new("RemoteEvent");ack.Name="Phase5TestAck";ack.Parent=game.ReplicatedStorage
ack.OnServerEvent:Connect(function(player) player:SetAttribute("Phase5ForeignChecked",true) end)
local function waitFor(predicate,message)
 local deadline=os.clock()+40
 repeat if predicate() then return end;task.wait(0.1) until os.clock()>deadline
 error(message)
end
local function everyPlayer(predicate)
 local players=game.Players:GetPlayers();if #players~=2 then return false end
 for _,p in players do if not predicate(p) then return false end end;return true
end
local ok,result=xpcall(function()
 waitFor(function() return #game.Players:GetPlayers()==2 end,"Players timeout")
 waitFor(function() return #workspace.Buildings:GetChildren()==2 end,"Placement timeout")
 workspace:SetAttribute("Phase5Stage","Foreign")
 waitFor(function() return everyPlayer(function(p) return p:GetAttribute("Phase5ForeignChecked")==true end) end,"Foreign request timeout")
 assert(#workspace.Buildings:GetChildren()==2,"Foreign demolition succeeded")
 for _,p in game.Players:GetPlayers() do assert(p.Inventory:GetAttribute("IronOre")==10,"Foreign deposit debited inventory") end
 workspace:SetAttribute("Phase5Stage","Deposit")
 waitFor(function()
  local objects=workspace.Buildings:GetChildren();if #objects~=2 then return false end
  for _,o in objects do if o:GetAttribute("OutputTotal")~=1 then return false end end;return true
 end,"Production output timeout")
 workspace:SetAttribute("Phase5Stage","Collect")
 waitFor(function() return everyPlayer(function(p) return p.Inventory:GetAttribute("IronPlate")==1 end) end,"Collection timeout")
 for _,p in game.Players:GetPlayers() do assert(p.Inventory:GetAttribute("IronOre")==8,"Input debit mismatch") end
 workspace:SetAttribute("Phase5Stage","DuplicateCollect")
 task.wait(1)
 for _,p in game.Players:GetPlayers() do assert(p.Inventory:GetAttribute("IronPlate")==1,"Duplicate output mint") end
 workspace:SetAttribute("Phase5Stage","Remove")
 waitFor(function() return #workspace.Buildings:GetChildren()==0 end,"Removal timeout")
 for _,p in game.Players:GetPlayers() do assert(p.Inventory:GetAttribute("ConstructionUnit")==20,"Construction refund mismatch") end
 return {passed=true,clients=2,inventory=true,production=true,ownership=true,duplicateCollect=true,refund=true}
end,debug.traceback)
test:EndTest(ok and result or {passed=false,error=tostring(result)})
