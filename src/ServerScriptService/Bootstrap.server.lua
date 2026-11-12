--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Logger = require(ReplicatedStorage.Shared.Util.Logger)
local NetworkService = require(script.Parent.Services.NetworkService)
local PlayerService = require(script.Parent.Services.PlayerService)
local ok, problem = xpcall(function()
	PlayerService.start()
	NetworkService.init()
end, debug.traceback)
if not ok then
	Logger.warn("Server", tostring(problem))
	error("INDUSTRIA startup failed")
end
Logger.info("Server", "Bootstrap online.")
