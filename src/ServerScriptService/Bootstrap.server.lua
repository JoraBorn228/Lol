--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Logger = require(ReplicatedStorage.Shared.Util.Logger)
local NetworkService = require(script.Parent.Services.NetworkService)
local PlayerService = require(script.Parent.Services.PlayerService)
local BuildService = require(script.Parent.Services.BuildService)
local InventoryService = require(script.Parent.Services.InventoryService)
local MachineService = require(script.Parent.Services.MachineService)
local ResourceService=require(script.Parent.Services.ResourceService)
local ok, problem = xpcall(function()
	PlayerService.start()
	InventoryService.start()
	NetworkService.init()
	ResourceService.start()
	MachineService.start()
	BuildService.start()
end, debug.traceback)
if not ok then
	Logger.warn("Server", tostring(problem))
	error("INDUSTRIA startup failed")
end
Logger.info("Server", "Bootstrap online.")
