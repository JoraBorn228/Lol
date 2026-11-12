--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared = ReplicatedStorage:WaitForChild("Shared", 10)
assert(shared, "Shared startup folder missing")
local Config = require(shared.Config.GameConfig)
local Logger = require(shared.Util.Logger)
local RemoteConfig = require(shared.Config.RemoteConfig)
local remotes = ReplicatedStorage:WaitForChild(RemoteConfig.FolderName, Config.StartupTimeoutSeconds)
assert(remotes, "Server startup timed out: Remotes missing")
assert(remotes:GetAttribute("ServerReady") == true, "Server readiness missing")
Logger.info("Client", "Bootstrap online.")
