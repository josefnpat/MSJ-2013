local client = {}

client._money = 0
client._money_t = 2
client._money_t_dt = client._money_t

client._map = nil
client._map_t = 0.5
client._map_t_dt = client._map_t

function client.money()
  return client._money
end

client.map = {}
function client.map.get()
  if client._map == nil then
    return {}
  else
    return client._map
  end
end

function client.map.buy(type,x,y)
  client.sock:run("buy",{type=type,x=x,y=y})
end

client.buildings = {}

function client.buildings.get()
  return client._buildings
end


function client.update(dt)
  client._money_t_dt = client._money_t_dt + dt
  if client._money_t_dt > client._money_t then
    client._money_t_dt = 0
    client.sock:run("money","")
  end

  client._map_t_dt = client._map_t_dt + dt
  if client._map_t_dt > client._map_t then
    client._map_t_dt = 0
    if client._map == nil then
      client.sock:run("map",{full=1})
    else
      client.sock:run("map",{full=0})
    end
  end

  client.sock:update(dt)
  return true
end

return client