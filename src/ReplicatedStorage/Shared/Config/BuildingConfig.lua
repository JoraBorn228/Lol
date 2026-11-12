--!strict
local GameConfig = require(script.Parent.GameConfig)
return table.freeze({
	GridSize = GameConfig.Building.GridSize,
	RotationStep = GameConfig.Building.RotationStep,
	MaxDistance = 64,
	RequestInterval = 0.15,
	MaxBuildingsPerPlayer = 200,
	GroundY = 0,
	MapHalfSize = 128,
	CollisionInset = 0.05,
	PreviewTransparency = 0.55,
	ValidColor = Color3.fromRGB(75, 210, 120),
	InvalidColor = Color3.fromRGB(240, 80, 80),
})
