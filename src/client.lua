local client = {}

client._money = 0
client._money_t = 2
client._money_t_dt = client._money_t

client._map = {}
client._map_t = 1
client._map_t_dt = client._map_t

function client.money()
  return client._money
end

client.map = {}
function client.map.get()
  return client._map
end

function client.map.buy(type,x,y)
  client.sock:run("buy",{type=type,x=x,y=y})
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
    client.sock:run("map","")
  end

  client.sock:update(dt)
  return true
end

return client