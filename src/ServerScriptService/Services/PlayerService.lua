--!strict
local Players = game:GetService("Players")
local Logger = require(game:GetService("ReplicatedStorage").Shared.Util.Logger)
local PlayerService = {}
local sessions: {[number]: {userId: number, joinedAt: number}} = {}
local started = false
local function register(player: Player)
	if sessions[player.UserId] then return end
	sessions[player.UserId] = { userId = player.UserId, joinedAt = os.time() }
	player:SetAttribute("IndustriaSessionRegistered", true)
	Logger.info("Players", "Registered " .. tostring(player.UserId))
end
function PlayerService.start()
	if started then return end
	started = true
	Players.PlayerAdded:Connect(register)
	Players.PlayerRemoving:Connect(function(player)
		sessions[player.UserId] = nil
		player:SetAttribute("IndustriaSessionRegistered", nil)
		Logger.debug("Players", "Removed " .. tostring(player.UserId))
	end)
	for _, player in Players:GetPlayers() do register(player) end
end
function PlayerService.getCount(): number
	local count = 0
	for _ in sessions do count += 1 end
	return count
end
return PlayerService
