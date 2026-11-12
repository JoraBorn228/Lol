local test = game:GetService("StudioTestService")
local okArgs, args = pcall(function() return test:GetTestArgs() end)
if not okArgs or typeof(args) ~= "table" or not args.phase3 then return end
local function waitFor(predicate, message)
	local deadline = os.clock() + 35
	repeat if predicate() then return end; task.wait(0.1) until os.clock() > deadline
	error(message)
end
local ok, result = xpcall(function()
	waitFor(function() return #game.Players:GetPlayers() == 2 end, "Two players did not join")
	waitFor(function() local f=workspace:FindFirstChild("Buildings"); return f and #f:GetChildren()==2 end, "Two placements did not replicate to server")
	local objects=workspace.Buildings:GetChildren()
	assert(objects[1]:GetAttribute("OwnerUserId") ~= objects[2]:GetAttribute("OwnerUserId"), "Owners identical")
	assert(objects[1]:GetAttribute("BuildId") ~= objects[2]:GetAttribute("BuildId"), "IDs identical")
	workspace:SetAttribute("Phase3TestStage", "ForeignRemove")
	task.wait(2)
	assert(#workspace.Buildings:GetChildren()==2, "Foreign removal succeeded")
	workspace:SetAttribute("Phase3TestStage", "OwnRemove")
	waitFor(function() return #workspace.Buildings:GetChildren()==0 end, "Own removals failed")
	for _,p in game.Players:GetPlayers() do assert(p:GetAttribute("ConstructionUnits")==20,"Refund mismatch") end
	return {passed=true,realClients=2,ownership=true,replication=true,refunds=true}
end, debug.traceback)
test:EndTest(ok and result or {passed=false,error=tostring(result)})
