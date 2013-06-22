servercache = {}
servercache.user = {}
servercache.user.data = {}
servercache.user.publicid = 1
function servercache.user.init(clientid)
  if not servercache.user.data[clientid] then
    servercache.user.data[clientid] = {}
    servercache.user.data[clientid].money = 2000
    servercache.user.data[clientid].publicid = "X"..servercache.user.publicid
    servercache.user.publicid = servercache.user.publicid + 1
  end
end

servercache.map = {}
servercache.map.x = 64
servercache.map.y = 64
servercache.map.data = {}

for y = 1,servercache.map.y do
  servercache.map.data[y] = {}
  for x = 1,servercache.map.x do
    -- TODO: have this data load from the collision layer from src/maps/map.tmx
    servercache.map.data[y][x] = {c=0} -- open space
  end
end

servercache.buildings = {}
servercache.buildings.data = {
  {name = "Command Center",cost="0"}, 
  {name = "Bunker",cost = "10"}, 
  {name = "Turret",cost = "15"},
  {name = "Road",cost = "2"}, 
  {name = "Factory",cost = "20"},
}

local ops = {}

ops.money = {}
ops.money.server = function(clientid,data)
  servercache.user.init(clientid)
  return servercache.user.data[clientid].money
end
ops.money.client = function(data)
  client._money = data
end
ops.money.validate = function(data)
  return true -- no args to parse
end

ops.map = {}
ops.map.server = function(clientid,data)
  return servercache.map.data
end
ops.map.client = function(data)
  client._map = data
end
ops.map.validate = function(data)
  return true -- no args to parse
end

ops.buy = {}
ops.buy.server = function(clientid,data)
  print("buy:server")
  servercache.user.init(clientid)
  print("user init done")
  if servercache.map.data[data.y] and -- valid y
     servercache.map.data[data.y][data.x] and -- valid x
     servercache.buildings.data[data.type] then -- valid building type
     print("selection valid")
    if servercache.user.data[clientid].money >= servercache.buildings.data[data.type].cost then
      print("enough money")
      servercache.user.data[clientid].money = servercache.user.data[clientid].money - servercache.buildings.data[data.type].cost
      servercache.map.data[data.y][data.x].owner = servercache.user.data[clientid].publicid
      servercache.map.data[data.y][data.x].tile = data.type
    end
  end
  return "OK"
end
ops.buy.client = function(data)
  print("buy:client")
  print(data)
end


ops.buy.validate = function(data)
  print("buy:validate")
  if data.x and data.y and data.type then
    return true
  end
end

return ops
