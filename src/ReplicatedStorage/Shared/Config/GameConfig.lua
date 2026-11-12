--!strict
return table.freeze({
	Name = "PROJECT: INDUSTRIA",
	Version = "0.1.0-dev",
	ProtocolVersion = 1,
	StartupTimeoutSeconds = 10,
	DebugLogging = true,
	Building = table.freeze({ GridSize = 4, RotationStep = 90 }),
	Multiplayer = table.freeze({ TargetPlayers = 6 }),
})
