--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config.BuildingConfig)
local Catalog = require(ReplicatedStorage.Shared.Config.BuildCatalog)
local Grid = require(ReplicatedStorage.Shared.Util.GridUtils)
local Geometry = require(ReplicatedStorage.Shared.Util.BuildGeometry)
local BuildService = {}
local lastRequest: {[Player]: number} = {}
local started = false
local function validate(player: Player, request: any): (boolean, string, CFrame?)
	if typeof(request) ~= "table" or request.action ~= "Place" then return false, "Некорректный запрос" end
	if typeof(request.templateId) ~= "string" or not Catalog[request.templateId] then return false, "Неизвестный объект" end
	if not Grid.isPosition(request.position) or not Grid.isFinite(request.turns) or request.turns % 1 ~= 0 or request.turns < 0 or request.turns > 3 then return false, "Некорректные координаты" end
	local item = Catalog[request.templateId]
	local pos = request.position
	if not Grid.isAligned(pos.X, Config.GridSize) or not Grid.isAligned(pos.Z, Config.GridSize) or math.abs(pos.Y - Config.GroundY - item.Size.Y / 2) > 0.001 then return false, "Требуется сетка" end
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid or humanoid.Health <= 0 or (root.Position - pos).Magnitude > Config.MaxDistance then return false, "Слишком далеко" end
	local cf = CFrame.new(pos) * Grid.rotation(request.turns)
	if not Geometry.inBounds(cf, item.Size) or not Geometry.isClear(cf, item.Size) then return false, "Место занято или вне карты" end
	return true, "Проверено", cf
end
function BuildService.handle(player: Player, request: any): (boolean, string)
	local now = os.clock()
	if now - (lastRequest[player] or -math.huge) < Config.RequestInterval then return false, "Слишком часто" end
	lastRequest[player] = now
	local ok, reason, cf = validate(player, request)
	if not ok or not cf then return false, reason end
	local folder = workspace:FindFirstChild("Buildings")
	if not folder then folder = Instance.new("Folder"); folder.Name = "Buildings"; folder.Parent = workspace end
	local count = 0
	for _, object in folder:GetChildren() do
		if object:GetAttribute("OwnerUserId") == player.UserId then count += 1 end
	end
	if count >= Config.MaxBuildingsPerPlayer then return false, "Лимит построек" end
	local object = ReplicatedStorage.Assets[Catalog[request.templateId].TemplateName]:Clone()
	object.CFrame = cf
	object.Anchored = true
	object:SetAttribute("OwnerUserId", player.UserId)
	object:SetAttribute("TemplateId", request.templateId)
	object.Parent = folder
	return true, "Построено"
end
function BuildService.start()
	if started then return end
	started = true
	ReplicatedStorage.Remotes.BuildRequest.OnServerEvent:Connect(function(player, request)
		local ok, reason = BuildService.handle(player, request)
		ReplicatedStorage.Remotes.BuildResult:FireClient(player, ok, reason)
	end)
	Players.PlayerRemoving:Connect(function(player) lastRequest[player] = nil end)
end
return BuildService
