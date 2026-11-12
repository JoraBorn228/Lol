--!strict
local Recipes=require(game:GetService("ReplicatedStorage").Shared.Config.RecipeConfig)
local Buffer=require(script.Parent.ItemBuffer)
local Engine={}
function Engine.step(state,dt)
 if typeof(dt)~="number" or dt~=dt or dt<0 or dt==math.huge then return end
 if not state.enabled then state.status="Disabled";return end
 local recipe=Recipes[state.recipeId]
 if not recipe then state.status="NoRecipe";return end
 for id,amount in recipe.Inputs do
  if (state.input.items[id] or 0)<amount then state.status="WaitingInputs";return end
 end
end
return Engine
