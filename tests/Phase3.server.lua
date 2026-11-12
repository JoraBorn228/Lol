-- Run through Studio MCP on Server in the isolated Phase3 Play session.
-- Synthetic actors test authority rules; this is not a two-client network test.
local service = require(game.ServerScriptService.Services.BuildService)
local grid = require(game.ReplicatedStorage.Shared.Util.GridUtils)
local actual = game.Players:GetPlayers()[1]
assert(actual and actual.Character, "Need one live character")
local function actor(id)
	local inventory=Instance.new("Folder")
	return { UserId=id, Character=actual.Character, attributes={}, inventory=inventory,
		FindFirstChild=function(_,name) if name=="Inventory" then return inventory end;return nil end,
		SetAttribute=function(self,key,value) self.attributes[key]=value end }
end
local a, b = actor(-801), actor(-802)
local checks = 0
local function check(value, message) assert(value, message); checks += 1 end
local function call(who, payload)
	task.wait(0.17)
	return service.handle(who, payload)
end
local position = Vector3.new(-24, 2, 24)
local function place(pos, turns)
	return { action = "Place", templateId = "TestMachine", position = pos, turns = turns or 0 }
end
local created = {}
local ok, failure = xpcall(function()
	check(grid.snap(-2.1, 4) == -4 and grid.snap(2.1, 4) == 4, "Negative/positive snapping")
	check(not grid.isFinite(0/0) and not grid.isFinite(math.huge), "Reject nonfinite numbers")
	check(call(a, place(position, 1)), "Valid placement")
	local object
	for _, candidate in workspace.Buildings:GetChildren() do
		if candidate:GetAttribute("OwnerUserId") == a.UserId then object = candidate; table.insert(created, candidate) end
	end
	check(object ~= nil, "Server object exists")
	local id = object:GetAttribute("BuildId")
	check(typeof(id) == "string" and #id > 0, "Unique ID exists")
	check(a.attributes.ConstructionUnits == 19, "Charge once")
	check(not call(a, place(position)), "Overlap rejected")
	check(not call(a, place(Vector3.new(-23,2,24))), "Off-grid rejected")
	check(not call(a, place(Vector3.new(0/0,2,24))), "NaN rejected")
	check(not call(a, place(Vector3.new(200,2,200))), "Distant placement rejected")
	check(not call(a, place(position, 4)), "Invalid rotation rejected")
	check(not call(a, {action="Place",templateId="Unknown",position=position,turns=0}), "Unknown template rejected")
	check(not call(b, {action="Remove",buildId=id}), "Foreign deletion rejected")
	check(object.Parent ~= nil, "Foreign deletion preserves object")
	check(call(a, {action="Remove",buildId=id}), "Owner deletion succeeds")
	check(a.attributes.ConstructionUnits == 20, "Exact refund")
	check(not call(a, {action="Remove",buildId=id}), "Duplicate removal rejected")
	check(a.attributes.ConstructionUnits == 20, "No duplicate refund")
	check(not service.handle(a, place(position)), "Rate limit rejects immediate request")
end, debug.traceback)
for _, object in created do if object.Parent then object:Destroy() end end
a.inventory:Destroy();b.inventory:Destroy()
assert(ok, failure)
return {passed=checks, actors=2, realClients=1, limitation="Two actual clients still required for BUILD-019"}
