--!strict
-- Temporary construction-only balance; replace adapter with InventoryService in Phase 4.
local Budget = {}
local balances: {[Player]: number} = {}
local function publish(player: Player)
	player:SetAttribute("ConstructionUnits", balances[player])
end
function Budget.get(player: Player): number
	if balances[player] == nil then balances[player] = 20; publish(player) end
	return balances[player]
end
function Budget.spend(player: Player, amount: number): boolean
	if Budget.get(player) < amount then return false end
	balances[player] -= amount
	publish(player)
	return true
end
function Budget.refund(player: Player, amount: number)
	balances[player] = Budget.get(player) + amount
	publish(player)
end
function Budget.remove(player: Player) balances[player] = nil end
return Budget
