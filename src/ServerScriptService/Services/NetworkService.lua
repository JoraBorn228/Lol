--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteConfig = require(ReplicatedStorage.Shared.Config.RemoteConfig)
local NetworkService = {}
function NetworkService.init()
	local folder = ReplicatedStorage:FindFirstChild(RemoteConfig.FolderName)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = RemoteConfig.FolderName
		folder.Parent = ReplicatedStorage
	end
	assert(folder:IsA("Folder"), "Remotes must be a Folder")
	local event = folder:FindFirstChild(RemoteConfig.ServerReady)
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = RemoteConfig.ServerReady
		event.Parent = folder
	end
	assert(event:IsA("RemoteEvent"), "ServerReady must be a RemoteEvent")
	-- Persistent readiness avoids missed one-shot events when a client joins late.
	folder:SetAttribute("ServerReady", true)
end
return NetworkService
