--!strict
local Catalog = {}
Catalog.ConstructionUnit = table.freeze({Name="Стройматериалы", Color=Color3.fromRGB(225,180,100)})
for _,id in {"IronOre","CopperOre","Limestone","Coal"} do
 Catalog[id]=require(script.Parent.Items[id])
end
Catalog.IronPlate=table.freeze({Name="Железная пластина",Color=Color3.fromRGB(170,180,195)})
Catalog.CopperWire=table.freeze({Name="Медный провод",Color=Color3.fromRGB(220,145,75)})
Catalog.Concrete=table.freeze({Name="Бетон",Color=Color3.fromRGB(170,170,160)})
return table.freeze(Catalog)
