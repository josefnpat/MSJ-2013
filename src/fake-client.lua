local client = {}

-- Connect to the server with this command.  Only run this command once. on
-- success, it will return true. false otherwise.

function client.connect(ip,port)
  local m = {}
  
  client.map.w = 64
  client.map.h = 64
  
  for y = 1, client.map.h do
    m[y] = {}
    for x = 1,client.map.w do
      if math.random(1,10) == 1 then
        m[y][x] = {tile=math.random(1,5),owner=math.random(1,10)} -- obstruction
      else
        m[y][x] = {tile=0} -- open space
      end
    end
  end
  client.map.data = m -- PRIVATE

  client.buildings.data = { -- PRIVATE
    {name = "Command Center",cost="0"},
    {name = "Bunker",cost = "10"},
    {name = "Turret",cost = "15"},
    {name = "Road",cost = "2"},
    {name = "Factory",cost = "20"},
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
  print("BUY",type,x,y)
  if client.map.data[y][x].data then
    return false,"There is already data there."
  else
    local data = {}
    data.owner = 1
    data.type = type
    data.hp = 100
    client.map.data[y][x].data = data
    return true
  end
end

-- This function will allow you to sell stuff for the current player.

function client.map.sell(x,y)
  print("SELL")
  if client.map.data[y][x].data then
    client.map.data[y][x].data = nil
  else
    return false,"There isn't any data there."
  end
  return true
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