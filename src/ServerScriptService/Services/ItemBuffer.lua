--!strict
local Catalog=require(game:GetService("ReplicatedStorage").Shared.Config.ItemCatalog)
local Buffer={}
function Buffer.new(capacity) return {capacity=capacity,items={}} end
function Buffer.total(buffer)
 local n=0;for _,amount in buffer.items do n+=amount end;return n
end
function Buffer.canApply(buffer,delta)
 local total=Buffer.total(buffer)
 for id,amount in delta do
  if not Catalog[id] or typeof(amount)~="number" or amount~=amount or math.abs(amount)>1000 or amount%1~=0 then return false end
  if (buffer.items[id] or 0)+amount<0 then return false end
  total+=amount
 end
 return total<=buffer.capacity
end
function Buffer.apply(buffer,delta)
 if not Buffer.canApply(buffer,delta) then return false end
 for id,amount in delta do buffer.items[id]=(buffer.items[id] or 0)+amount end
 return true
end
return Buffer
