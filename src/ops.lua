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
