--!strict
local Catalog = {}
Catalog.ConstructionUnit = table.freeze({Name="Стройматериалы", Color=Color3.fromRGB(225,180,100)})
for _,id in {"IronOre","CopperOre","Limestone","Coal"} do
 Catalog[id]=require(script.Parent.Items[id])
end
Catalog.IronPlate=table.freeze({Name="Железная пластина",Color=Color3.fromRGB(170,180,195)})
Catalog.CopperWire=table.freeze({Name="Медный провод",Color=Color3.fromRGB(220,145,75)})
Catalog.Concrete=table.freeze({Name="Бетон",Color=Color3.fromRGB(170,170,160)})
Catalog.IronIngot=table.freeze({Name="Железный слиток",Color=Color3.fromRGB(155,165,180)})
Catalog.CopperIngot=table.freeze({Name="Медный слиток",Color=Color3.fromRGB(215,125,70)})
Catalog.IronRod=table.freeze({Name="Железный стержень",Color=Color3.fromRGB(150,160,175)})
return table.freeze(Catalog)
