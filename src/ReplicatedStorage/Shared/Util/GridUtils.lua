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
return Grid
