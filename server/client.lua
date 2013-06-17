local client = {}

-- Connect to the server with this command.  Only run this command once. on
-- success, it will return true. false otherwise.

function client.connect(ip,port)
end

-- This will inform the server that you have disconnected. This function will
-- return true on success, and false otherwise.

function client.disconnect()
end

function client.update()
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