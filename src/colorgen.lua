local colorgen = {}

colorgen._colors = {}

for r = 1,0,-1 do
  for g = 1,0,-1 do
    for b = 1,0,-1 do
      local color = {255*r/2,255*g/2,255*b/2}
       table.insert(colorgen._colors,color)
    end
  end
end

function colorgen.get(id)
  local nid = ( (id - 1 ) % #colorgen._colors) + 1
  return colorgen._colors[nid]
end

return colorgen