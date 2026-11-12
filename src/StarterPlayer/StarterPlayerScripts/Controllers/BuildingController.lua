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
local function setActive(value: boolean)
	active = value
	candidate = nil
	valid = false
	if preview then preview:Destroy(); preview = nil end
	if active then
		local ghost = ReplicatedStorage.Assets[Catalog[selected].TemplateName]:Clone()
		ghost.Name = "BuildingPreview"
		ghost.Anchored = true
		ghost.CanCollide = false
		ghost.CanTouch = false
		ghost.CanQuery = false
		ghost.Transparency = 1
		ghost.Parent = workspace
		preview = ghost
	end
	if status then status.Text = active and "Строительство: R — поворот · клик — поставить" or "B — строительство" end
end
function Controller.start()
	if started then return end
	started = true
	local gui = Instance.new("ScreenGui")
	gui.Name = "BuildingHUD"
	gui.ResetOnSpawn = false
	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.8, 0, 0, 72)
	label.Position = UDim2.new(0.1, 0, 0, 8)
	label.BackgroundTransparency = 0.25
	label.BackgroundColor3 = Color3.fromRGB(25, 29, 34)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextWrapped = true
	label.TextSize = 18
	label.Parent = gui
	status = label
	setActive(false)
	ContextActionService:BindAction("IndustriaBuildToggle", function(_, state)
		if state == Enum.UserInputState.Begin and not UserInputService:GetFocusedTextBox() then setActive(not active) end
		return Enum.ContextActionResult.Sink
	end, true, Enum.KeyCode.B)
	ContextActionService:SetTitle("IndustriaBuildToggle", "Строить")
end
return Controller
