local client = {}

require "json"
require "socket"

client.default = {}
client.default.ip,client.default.port = "localhost",19870

client.ping = 1/24

client.debug = false

-- Connect to the server with this command.  Only run this command once. on
-- success, it will return true. false otherwise.

function client.connect(ip,port)
  if not ip then ip = client.default.ip end
  if not port then port = client.defualt.port end
  if client.debug then print("socket.connect start") end
  local sock,error = socket.connect(ip,port)
  if client.debug then print("socket.connect stop") end
  if sock then
    sock:settimeout(0.01)
    client.id = math.random(1,99999999)
    client.sock = sock
  else
    client.sock = nil
    return false,error
  end
  client.ping_dt = 0
  return true
end

-- This will inform the server that you have disconnected. This function will
-- return true on success, and false otherwise.

function client.disconnect()
  client.sock = nil
end

-- This will tell you if the client is connected or not.

function client.status()
  if client.sock then
    return "connected"
  end
end

-- This is the update system that will update the cache.

function client.update(dt)
  if client.sock then
    client.ping_dt = client.ping_dt + dt
    if client.ping_dt > client.ping then
      client.ping_dt = 0
      
      local op = {}
      
      if not client.map.data then
        table.insert(op,{func="map_full"})
      end
      
      if client.debug then print("client.sock:send start") end
      client.sock:send(json.encode({id=client.id,op=op}).."\n")
      if client.debug then print("client.sock:send stop") end
      if client.debug then print("client.sock:receive start") end
      local line,error = client.sock:receive()
      if client.debug then print("client.sock:receive stop") end
      if error then
        return false,error
      else
        if client.debug then print("response:"..line) end
        if pcall(function() json.decode(line) end) then
          local data = json.decode(line)
          for i,v in pairs(data) do
            
          end
        end
        return true
      end
    else
      return true
    end
  else
    return false,"no sock"
  end
end

function client.money()
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
  if client.map.data then
    return client.map.data
  else
    return {}
  end
end

-- This function will determine if an area is buildable.

function client.map.free(x,y)
end

-- This function will return the width of the map.

function client.map.width() 
end

-- This function will return the height of the map.

function client.map.height()
end

-- This function will allow you to build stuff for the current player.

function client.map.buy(type,x,y)
end

-- This function will allow you to sell stuff for the current player.

function client.map.sell(x,y)
end

client.buildings = {}

-- This function will show you the availible buildings on the server.
-- The table will be an numerically indexed table.
-- each entry will have a table;
-- `name` -- the name of the item
-- `cost` -- the cost of the item

function client.buildings.get()
end

return client