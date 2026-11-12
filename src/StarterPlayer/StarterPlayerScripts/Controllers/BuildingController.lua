--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Config = require(ReplicatedStorage.Shared.Config.BuildingConfig)
local Grid = require(ReplicatedStorage.Shared.Util.GridUtils)
local Catalog = require(ReplicatedStorage.Shared.Config.BuildCatalog)
local Controller = {}
local active = false
local started = false
local turns = 0
local preview: BasePart? = nil
local candidate: CFrame? = nil
local valid = false
local selected = "TestMachine"
local status: TextLabel? = nil
function Controller.start()
	if started then return end
	started = true
end
return Controller
