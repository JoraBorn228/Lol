--!strict
return table.freeze({
 TickSeconds=0.1,
 MaxMachines=1200,
 TestMachine=table.freeze({InputCapacity=100,OutputCapacity=100,Recipes=table.freeze({"IronPlate","CopperWire","Concrete"})}),
})
