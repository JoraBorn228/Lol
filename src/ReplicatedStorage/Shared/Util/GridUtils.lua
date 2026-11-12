--!strict
local Grid = {}
function Grid.isFinite(value: any): boolean
	return typeof(value) == "number" and value == value and math.abs(value) < math.huge
end
function Grid.isPosition(value: any): boolean
	return typeof(value) == "Vector3" and Grid.isFinite(value.X) and Grid.isFinite(value.Y) and Grid.isFinite(value.Z)
end
function Grid.rotation(turns: number): CFrame
	return CFrame.Angles(0, (turns % 4) * math.pi / 2, 0)
end
function Grid.snap(value: number, step: number): number
	return math.floor(value / step + 0.5) * step
end
function Grid.snapPosition(position: Vector3, step: number, height: number): Vector3
	return Vector3.new(Grid.snap(position.X, step), height, Grid.snap(position.Z, step))
end
function Grid.isAligned(value: number, step: number): boolean
	return math.abs(value - Grid.snap(value, step)) < 0.001
end
return table.freeze(Grid)
