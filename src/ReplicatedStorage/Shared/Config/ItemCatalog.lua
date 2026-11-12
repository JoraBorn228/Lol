--!strict
local Catalog = {}
Catalog.ConstructionUnit = table.freeze({Name="Стройматериалы", Color=Color3.fromRGB(225,180,100)})
for _,id in {"IronOre","CopperOre","Limestone","Coal"} do
 Catalog[id]=require(script.Parent.Items[id])
end
return table.freeze(Catalog)
