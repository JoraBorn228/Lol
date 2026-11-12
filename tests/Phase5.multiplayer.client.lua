local test=game:GetService("StudioTestService")
local okArgs,args=pcall(function() return test:GetTestArgs() end)
if not okArgs or typeof(args)~="table" or not args.phase5 then return end
local p=game.Players.LocalPlayer
local deadline=os.clock()+35
repeat task.wait(0.1) until #game.Players:GetPlayers()==2 or os.clock()>deadline
local players=game.Players:GetPlayers();table.sort(players,function(a,b)return a.UserId<b.UserId end)
local index=players[1]==p and 1 or 2
if not p.Character then p.CharacterAdded:Wait() end
local r=game.ReplicatedStorage:WaitForChild("Remotes")
local machine=r:WaitForChild("MachineRequest")
task.wait(1)
r.BuildRequest:FireServer({action="Place",templateId="TestMachine",position=Vector3.new(index==1 and -12 or 12,2,0),turns=0})
local function stage(name)
 local limit=os.clock()+40
 repeat if workspace:GetAttribute("Phase5Stage")==name then return end;task.wait(0.1) until os.clock()>limit
 error("Stage timeout: "..name)
end
stage("Foreign")
local own,other
for _,o in workspace.Buildings:GetChildren() do if o:GetAttribute("OwnerUserId")==p.UserId then own=o else other=o end end
assert(own and other,"Replicated machines missing")
machine:FireServer({action="Deposit",buildId=other:GetAttribute("BuildId")})
r.BuildRequest:FireServer({action="Remove",buildId=other:GetAttribute("BuildId")})
task.wait(0.4)
-- Test-only acknowledgement is sent through a separate harness RemoteEvent.
game.ReplicatedStorage.Phase5TestAck:FireServer()
stage("Deposit")
machine:FireServer({action="Deposit",buildId=own:GetAttribute("BuildId")})
stage("Collect")
machine:FireServer({action="Collect",buildId=own:GetAttribute("BuildId")})
stage("DuplicateCollect")
task.wait(0.2);machine:FireServer({action="Collect",buildId=own:GetAttribute("BuildId")})
stage("Remove")
r.BuildRequest:FireServer({action="Remove",buildId=own:GetAttribute("BuildId")})
