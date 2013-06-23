local ops = {}

-- MONEY

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

-- MAP

ops.map = {}
ops.map.server = function(clientid,data)
  ret = {}
  if servercache.map.data[data.y] and 
      servercache.map.data[data.y][data.x] then
    ret.x = data.x
    ret.y = data.y
    ret.v = servercache.map.data[data.y][data.x]
  end
  return ret
end
ops.map.client = function(data)
  client._map[data.y][data.x] = data.v
end
ops.map.validate = function(data)
  if data.x and data.y then
    return true
  end
end

-- MAP QUEUE

ops.mapq = {}
ops.mapq.server = function(clientid,data)
  servercache.user.init(clientid)
  ret = {}
  for i,v in pairs(ops.mapq.queue) do
    if servercache.user.data[clientid].last_mapq_update <= v.t then
      table.insert(ret,v)
    end
  end
  servercache.user.data[clientid].last_mapq_update = socket.gettime()
  return ret
end
ops.mapq.client = function(data)
  for i,v in pairs(data) do
    client._map[v.y][v.x] = v.data
  end
end
ops.mapq.validate = function(data)
  return true -- no args
end

ops.mapq.queue = {}
ops.mapq.newItem = function(x,y)
  local data = servercache.map.data[y][x]
  table.insert(ops.mapq.queue,{x=x,y=y,data=data,t=socket.gettime()})
end

-- BUILDINGS

ops.buildings = {}
ops.buildings.server = function(clientid,data)
  return servercache.buildings.data
end
ops.buildings.client = function(data)
  client._buildings = data
end
ops.buildings.validate = function(data)
  return true
end

-- BUY

ops.buy = {}
ops.buy.server = function(clientid,data)
  servercache.user.init(clientid)
  if servercache.map.data[data.y] and -- valid y
      servercache.map.data[data.y][data.x] and -- valid x
      servercache.buildings.data[data.type] and -- valid building type
      servercache.user.data[clientid].money >= servercache.buildings.data[data.type].cost and --  enough money
      not servercache.map.data[data.y][data.x].owner then -- not owned by anyone
    servercache.user.data[clientid].money = servercache.user.data[clientid].money - servercache.buildings.data[data.type].cost
    servercache.map.data[data.y][data.x].owner = servercache.user.data[clientid].publicid
    servercache.map.data[data.y][data.x].tile = data.type
    ops.mapq.newItem(data.x,data.y)
    return "success"
  else
    return "fail"
  end
end
ops.buy.client = function(data)
end
ops.buy.validate = function(data)
  if data.x and data.y and data.type then
    return true
  end
end

return ops
