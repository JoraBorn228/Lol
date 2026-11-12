--!strict
return table.freeze({
 IronRod=table.freeze({Name="Железный стержень",Duration=2,Inputs=table.freeze({IronIngot=1}),Outputs=table.freeze({IronRod=1})}),
 SmeltIron=table.freeze({Name="Железный слиток",Duration=2,Inputs=table.freeze({IronOre=2}),Outputs=table.freeze({IronIngot=1})}),
 SmeltCopper=table.freeze({Name="Медный слиток",Duration=2,Inputs=table.freeze({CopperOre=2}),Outputs=table.freeze({CopperIngot=1})}),
 MineIron=table.freeze({Name="Добыча железа",Duration=2,Inputs=table.freeze({}),Outputs=table.freeze({IronOre=1})}),
 PrototypePlate=table.freeze({Name="Прототип: пластина",Duration=2,Inputs=table.freeze({IronOre=2}),Outputs=table.freeze({IronPlate=1})}),
 IronPlate=table.freeze({Name="Железная пластина",Duration=2,Inputs=table.freeze({IronIngot=1}),Outputs=table.freeze({IronPlate=1})}),
 CopperWire=table.freeze({Name="Медный провод",Duration=2,Inputs=table.freeze({CopperIngot=1}),Outputs=table.freeze({CopperWire=2})}),
 Concrete=table.freeze({Name="Бетон",Duration=3,Inputs=table.freeze({Limestone=3}),Outputs=table.freeze({Concrete=1})}),
})
