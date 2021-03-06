local ops = {}

-- TIME TO LIVE

ops.timetolive = {}
ops.timetolive.server = function(clientid,data)
  return time_to_live
end
ops.timetolive.client = function(data)
  client._time_to_live = data
end
ops.timetolive.validate = function(data)
  return true -- no args to parse
end

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
  if #ops.mapq.queue > 128 then
    table.remove(ops.mapq.queue,1)
  end
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
      map_collision[data.y][data.x] == false and
      servercache.user.data[clientid].money >= servercache.buildings.data[data.type].cost and --  enough money
      (data.type == 1 or ops.buy.checkneighbors(data.x,data.y,clientid)) and -- ensure neighbors unless CC
      not servercache.map.data[data.y][data.x].owner then -- not owned by anyone
    servercache.user.data[clientid].money = servercache.user.data[clientid].money - servercache.buildings.data[data.type].cost
    servercache.map.data[data.y][data.x].owner = servercache.user.data[clientid].publicid
    servercache.map.data[data.y][data.x].tile = data.type
    servercache.map.data[data.y][data.x].hp = servercache.buildings.data[data.type].hp
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

ops.buy.checkneighbors = function(x,y,clientid)
  local owner = servercache.user.data[clientid].publicid
  for i,v in pairs({{x+1,y},{x-1,y},{x,y+1},{x,y-1}}) do
    if servercache.map.data[v[2]] and
        servercache.map.data[v[2]][v[1]] and
        servercache.map.data[v[2]][v[1]].owner and
        servercache.map.data[v[2]][v[1]].owner == owner and
        (servercache.map.data[v[2]][v[1]].tile == 1 or servercache.map.data[v[2]][v[1]].tile == 4) then
      return true
    end
  end
end

-- SELL

ops.sell = {}
ops.sell.server = function(clientid,data)
  servercache.user.init(clientid)
  if servercache.map.data[data.y] and -- valid y
      servercache.map.data[data.y][data.x] and -- valid x
      servercache.map.data[data.y][data.x].tile ~= 1 and
      servercache.map.data[data.y][data.x].owner == servercache.user.data[clientid].publicid then -- client owns it
    
    servercache.user.data[clientid].money = servercache.user.data[clientid].money + 
      math.floor(servercache.buildings.data[ servercache.map.data[data.y][data.x].tile ].cost/2)
    
    servercache.map.data[data.y][data.x].owner = nil
    servercache.map.data[data.y][data.x].tile = 0    
    ops.mapq.newItem(data.x,data.y)
    return "success"
  else
    return "fail"
  end
end
ops.sell.client = function(data)
end
ops.sell.validate = function(data)
  if data.x and data.y then
    return true
  end
end

return ops
