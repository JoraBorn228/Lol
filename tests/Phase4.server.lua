local Inventory=require(game.ServerScriptService.Services.InventoryService)
-- Folder provides the replicated attribute surface without creating a real Player.
local actor=Instance.new("Folder")
local checks=0
local function check(v,msg) assert(v,msg);checks+=1 end
local ok,err=xpcall(function()
 check(Inventory.snapshot(actor).IronOre==10,"Starter ore")
 check(Inventory.add(actor,"IronOre",3),"Add")
 check(Inventory.has(actor,"IronOre",13),"Has")
 check(Inventory.remove(actor,"IronOre",13),"Remove exact")
 check(not Inventory.remove(actor,"IronOre",1),"No negative stock")
 check(not Inventory.add(actor,"Coal",0/0),"Reject NaN")
 check(not Inventory.add(actor,"Coal",math.huge),"Reject infinity")
 check(not Inventory.add(actor,"Coal",0.5),"Reject fractions")
 check(not Inventory.add(actor,"Unknown",1),"Reject unknown")
 check(not Inventory.remove(actor,"Coal",-5),"Reject negative removal")
 local before=Inventory.snapshot(actor).Coal
 check(not Inventory.transact(actor,{Coal=-999,CopperOre=5}),"Reject whole failed batch")
 check(Inventory.snapshot(actor).Coal==before and Inventory.snapshot(actor).CopperOre==10,"No partial mutation")
 check(not Inventory.add(actor,"Coal",1000),"Capacity check")
 local snapshot=Inventory.snapshot(actor);snapshot.Coal=999
 check(Inventory.snapshot(actor).Coal==before,"Snapshot isolated")
 local budget=require(game.ServerScriptService.Services.ConstructionBudget)
 check(budget.spend(actor,1),"Construction debit")
 check(Inventory.snapshot(actor).ConstructionUnit==19,"Single authority")
 check(budget.refund(actor,1),"Construction refund")
 check(Inventory.snapshot(actor).ConstructionUnit==20,"Exact refund")
end,debug.traceback)
actor:Destroy()
assert(ok,err)
return {passed=checks}
