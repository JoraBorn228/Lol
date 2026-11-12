--!strict
return table.freeze({
 TickSeconds=0.1,
 MaxMachines=1200,
 Extractor=table.freeze({InputCapacity=0,OutputCapacity=100,Recipes=table.freeze({}),RequiresDeposit=true}),
 Smelter=table.freeze({InputCapacity=100,OutputCapacity=100,Recipes=table.freeze({})}),
 Constructor=table.freeze({InputCapacity=100,OutputCapacity=100,Recipes=table.freeze({})}),
 Assembler=table.freeze({InputCapacity=100,OutputCapacity=100,Recipes=table.freeze({})}),
 Generator=table.freeze({InputCapacity=100,OutputCapacity=0,Recipes=table.freeze({})}),
 TestMachine=table.freeze({InputCapacity=100,OutputCapacity=100,Recipes=table.freeze({"IronPlate","CopperWire","Concrete"})}),
})
