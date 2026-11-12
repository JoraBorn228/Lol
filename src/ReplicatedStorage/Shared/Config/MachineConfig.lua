--!strict
return table.freeze({
 TickSeconds=0.1,
 MaxMachines=1200,
 Extractor=table.freeze({InputCapacity=0,OutputCapacity=100,Recipes=table.freeze({"MineIron"}),RequiresDeposit=true}),
 Smelter=table.freeze({InputCapacity=100,OutputCapacity=100,Recipes=table.freeze({"SmeltIron","SmeltCopper"})}),
 Constructor=table.freeze({InputCapacity=100,OutputCapacity=100,Recipes=table.freeze({"IronPlate","IronRod","Concrete"})}),
 Assembler=table.freeze({InputCapacity=100,OutputCapacity=100,Recipes=table.freeze({})}),
 Generator=table.freeze({InputCapacity=100,OutputCapacity=0,Recipes=table.freeze({})}),
 TestMachine=table.freeze({InputCapacity=100,OutputCapacity=100,Recipes=table.freeze({"PrototypePlate","CopperWire","Concrete"})}),
})
