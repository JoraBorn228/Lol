--!strict
local Buffer=require(script.Parent.ItemBuffer)
local State={}
function State.new(config)
 return {input=Buffer.new(config.InputCapacity),output=Buffer.new(config.OutputCapacity),recipeId=config.Recipes[1],progress=0,status="WaitingInputs",enabled=true}
end
return State
