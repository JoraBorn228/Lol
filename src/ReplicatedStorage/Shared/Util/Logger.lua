--!strict
local Config = require(script.Parent.Parent.Config.GameConfig)
local Logger = {}
function Logger.info(scope: string, message: string)
	print(string.format("[INDUSTRIA][%s] %s", scope, message))
end
function Logger.debug(scope: string, message: string)
	if Config.DebugLogging then Logger.info(scope, message) end
end
function Logger.warn(scope: string, message: string)
	warn(string.format("[INDUSTRIA][%s] %s", scope, message))
end
return table.freeze(Logger)
