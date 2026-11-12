--!strict
local Catalog={
	TestMachine = table.freeze({
		DisplayName = "Тестовый блок",
		TemplateName = "TestMachine",
		Size = Vector3.new(4, 4, 8),
		Cost = 1,
	}),
}
for id,entry in {Extractor={"Добытчик",8,8,8,2},Smelter={"Плавильня",8,8,8,2},Constructor={"Конструктор",8,6,8,2},Assembler={"Сборщик",12,8,8,3},Generator={"Генератор",8,6,12,3}} do
 Catalog[id]=table.freeze({DisplayName=entry[1],TemplateName=id,Size=Vector3.new(entry[2],entry[3],entry[4]),Cost=entry[5]})
end
return table.freeze(Catalog)
