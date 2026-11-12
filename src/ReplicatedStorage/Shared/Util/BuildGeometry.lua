--!strict
local Config = require(script.Parent.Parent.Config.BuildingConfig)
local Geometry = {}
function Geometry.inBounds(cf: CFrame, size: Vector3): boolean
	local halfX = math.abs(cf.RightVector.X) * size.X / 2 + math.abs(cf.LookVector.X) * size.Z / 2
	local halfZ = math.abs(cf.RightVector.Z) * size.X / 2 + math.abs(cf.LookVector.Z) * size.Z / 2
	return math.abs(cf.X) + halfX <= Config.MapHalfSize and math.abs(cf.Z) + halfZ <= Config.MapHalfSize
end
function Geometry.isClear(cf: CFrame, size: Vector3): boolean
	local map = workspace:FindFirstChild("Map")
	local ground = map and map:FindFirstChild("Baseplate")
	if not ground then return false end
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { ground }
	local inset = Vector3.one * Config.CollisionInset
	return #workspace:GetPartBoundsInBox(cf, size - inset, params) == 0
end
return table.freeze(Geometry)
