update = {}

update.map = {}

update.map.w = math.random(8,16)
update.map.h = math.random(8,16)
update.map.data = {}

for y = 1,update.map.h do
  update.map.data[y] = {}
  for x = 1,update.map.w do
    if x == 1 or y == 1 or x == update.map.w or y == update.map.h then
      update.map.data[y][x] = {tile=2} -- obstruction
    else
      update.map.data[y][x] = {tile=1} -- open space
    end
  end
end

function update.run(client,data)
  if data.id then -- if user id
    if data.op then -- render operations
      local rets = {}
      for opi,opv in pairs(data.op) do
        if opv.func and update.op[opv.func] then
          local ret = update.op[opv.func](client,opv.arg)
          if ret then
            table.insert(rets,ret)
          else
            table.insert(rets,{})
          end
        end
      end
      return rets
    else -- no ops to render
      return {}
    end
  else -- hey, I need a user id.
    return {}
  end
end

update.op = {}

update.op.map_full = function(client,arg)
  return update.map.data
end

update.op.map_update = function(client,arg)

end

update.op.buy = function(client,arg)

end

update.op.sell = function(client,arg)

end

update.op.buildings_full = function(client,arg)

end
  
return update