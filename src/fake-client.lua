local client = {}

-- Connect to the server with this command.  Only run this command once. on
-- success, it will return true. false otherwise.

function client.connect(ip,port)
  local m = {}

  client._money = 2000
  
  client.map.w = 64
  client.map.h = 64
  
  for y = 1, client.map.h do
    m[y] = {}
    for x = 1,client.map.w do
      m[y][x] = {tile=0} -- open space
    end
  end
  client.map.data = m -- PRIVATE

  client.buildings.data = { -- PRIVATE
    {name = "Command Center",cost=1000},
    {name = "Bunker",cost = 100},
    {name = "Turret",cost = 150},
    {name = "Road",cost = 20},
    {name = "Factory",cost = 200},
  }

  return true
end

-- This will inform the server that you have disconnected. This function will
-- return true on success, and false otherwise.

function client.disconnect()
  return true
end

-- This will tell you if the client is connected or not. 

function client.status()
  return "connected"
end

-- This is the update system that will update the cache.

function client.update()
  return true
end

function client.money()
  return client._money
end

function client.ready()
  return true
end

function client.loadmap()
  return 100
end

client.map = {}

-- This function will get the map data that is currently cached by the client
-- object. It is ordered by y, then x. Each value has a table which has
-- `tile` - The tile index
-- `data` - The data for the tile;
--   `owner` - the owner of the current tile
--   `type` - what the owner has made
--   `hp` - how much health the building has

function client.map.get()
  return client.map.data
end

-- This function will determine if an area is buildable.

function client.map.free(x,y)
  if client.map.data[y][x].tile == 1 then
    return true
  else
    return false
  end
end

-- This function will return the width of the map.

function client.map.width() 
  return client.map.w
end

-- This function will return the height of the map.

function client.map.height()
  return client.map.h
end

-- This function will allow you to build stuff for the current player.

function client.map.buy(type,x,y)
  if client._money >= client.buildings.data[type].cost and
      client.map.data[y] and
      client.map.data[y][x] and
      not client.map.data[y][x].owner then
    client.map.data[y][x].owner = 1
    client.map.data[y][x].tile = type
    client._money = client._money - client.buildings.data[type].cost
  end
end

-- This function will allow you to sell stuff for the current player.

function client.map.sell(x,y)
  if client.map.data[y][x].owner == 1 then
    local type = client.map.data[y][x].tile
    client._money = client._money + math.floor(client.buildings.data[type].cost/2)
    client.map.data[y][x].owner = nil
    client.map.data[y][x].tile = 0
  end
end

client.buildings = {}

-- This function will show you the availible buildings on the server.
-- The table will be an numerically indexed table.
-- each entry will have a table;
-- `name` -- the name of the item
-- `cost` -- the cost of the item

function client.buildings.get()
  return client.buildings.data
end

return client