--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared = ReplicatedStorage:WaitForChild("Shared", 10)
assert(shared, "Shared startup folder missing")
local Config = require(shared.Config.GameConfig)
local Logger = require(shared.Util.Logger)
local RemoteConfig = require(shared.Config.RemoteConfig)
local remotes = ReplicatedStorage:WaitForChild(RemoteConfig.FolderName, Config.StartupTimeoutSeconds)
assert(remotes, "Server startup timed out: Remotes missing")
local deadline = os.clock() + Config.StartupTimeoutSeconds
while remotes:GetAttribute("ServerReady") ~= true and os.clock() < deadline do
	task.wait()
end
assert(remotes:GetAttribute("ServerReady") == true, "Server readiness timed out")
Logger.info("Client", "Bootstrap online.")
local controllers = script.Parent:WaitForChild("Controllers", Config.StartupTimeoutSeconds)
assert(controllers, "Client controllers missing")
local building = controllers:WaitForChild("BuildingController", Config.StartupTimeoutSeconds)
assert(building, "Building controller missing")
require(building).start()
local inventory=controllers:WaitForChild("InventoryController",Config.StartupTimeoutSeconds)
assert(inventory,"Inventory controller missing")
require(inventory).start()
local machine=controllers:WaitForChild("MachineController",Config.StartupTimeoutSeconds)
assert(machine,"Machine controller missing")
require(machine).start()
