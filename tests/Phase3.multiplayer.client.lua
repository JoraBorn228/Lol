local test = game:GetService("StudioTestService")
local okArgs, args = pcall(function() return test:GetTestArgs() end)
if not okArgs or typeof(args) ~= "table" or not args.phase3 then return end
local p=game.Players.LocalPlayer
local deadline=os.clock()+35
repeat task.wait(0.1) until #game.Players:GetPlayers()==2 or os.clock()>deadline
local players=game.Players:GetPlayers()
table.sort(players,function(a,b) return a.UserId<b.UserId end)
local index=players[1]==p and 1 or 2
if not p.Character then p.CharacterAdded:Wait() end
local remote=game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuildRequest")
task.wait(1)
remote:FireServer({action="Place",templateId="TestMachine",position=Vector3.new(index==1 and -24 or -40,2,24),turns=index-1})
local function stage(name)
	while workspace:GetAttribute("Phase3TestStage")~=name do task.wait(0.1) end
end
stage("ForeignRemove")
local folder=workspace:WaitForChild("Buildings")
local ownId
for _,o in folder:GetChildren() do
	if o:GetAttribute("OwnerUserId")==p.UserId then ownId=o:GetAttribute("BuildId")
	else remote:FireServer({action="Remove",buildId=o:GetAttribute("BuildId")}) end
end
stage("OwnRemove")
remote:FireServer({action="Remove",buildId=ownId})
