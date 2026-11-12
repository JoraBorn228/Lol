--!strict
-- Compatibility adapter; InventoryService is the only resource authority.
local Inventory=require(script.Parent.InventoryService)
local Budget={}
function Budget.get(player) return Inventory.snapshot(player).ConstructionUnit or 0 end
function Budget.spend(player,amount) return Inventory.remove(player,"ConstructionUnit",amount) end
function Budget.refund(player,amount) return Inventory.add(player,"ConstructionUnit",amount) end
function Budget.remove(_player) end
return Budget
