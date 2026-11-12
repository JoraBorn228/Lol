--!strict
local Recipes=require(game:GetService("ReplicatedStorage").Shared.Config.RecipeConfig)
local Buffer=require(script.Parent.ItemBuffer)
local Engine={}
function Engine.step(state,dt)
 if typeof(dt)~="number" or dt~=dt or dt<0 or dt==math.huge then return end
 if not state.enabled then state.status="Disabled";return end
 local recipe=Recipes[state.recipeId]
 if not recipe then state.status="NoRecipe";return end
 local extractionAmount=0
 if state.requiresDeposit then
  local node=state.resourceNode
  if not node or not node.Parent then state.status="NoDeposit";return end
  for _,amount in recipe.Outputs do extractionAmount+=amount end
  if (node:GetAttribute("Remaining") or 0)<extractionAmount then state.status="Exhausted";return end
 end
 for id,amount in recipe.Inputs do
  if (state.input.items[id] or 0)<amount then state.status="WaitingInputs";return end
 end
 if not Buffer.canApply(state.output,recipe.Outputs) then state.status="OutputFull";return end
 state.status="Working"
 state.progress=math.min(recipe.Duration,state.progress+dt)
 if state.progress<recipe.Duration then return end
 -- Commit a whole cycle synchronously; input remains available until completion.
 if not Buffer.canApply(state.output,recipe.Outputs) then state.status="OutputFull";return end
 local delta={};for id,amount in recipe.Inputs do delta[id]=-amount end
 if state.requiresDeposit then state.resourceNode:SetAttribute("Remaining",state.resourceNode:GetAttribute("Remaining")-extractionAmount) end
 assert(Buffer.apply(state.input,delta),"Recipe input invariant failed")
 assert(Buffer.apply(state.output,recipe.Outputs),"Recipe output invariant failed")
 state.progress=0
 state.status="Completed"
end
return Engine
