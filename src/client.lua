local client = {}

client._money = 0
client._money_t = 0.5
client._money_t_dt = client._money_t

client._map = {}

client._loadmap = {}
client._loadmap.t = 1/24
client._loadmap.dt = 0
client._loadmap.x = 1
client._loadmap.y = 1
client._loadmap.multiplex = 64

client._mapq = {}
client._mapq_t = 1/24
client._mapq_t_dt = 0

for y = 1,64 do
  client._map[y] = {}
  for x = 1,64 do
    client._map[y][x] = {tile=0}
  end
end

function client.money()
  return client._money
end

function client.closed()
  return client.sock._closed
end

client.map = {}
function client.map.get()
  return client._map
end

function client.map.buy(type,x,y)
  client.sock:run("buy",{type=type,x=x,y=y})
end

function client.map.sell(x,y)
  client.sock:run("sell",{x=x,y=y})
end

client.buildings = {}

function client.buildings.get()
  return client._buildings
end

function client.ready()
  return client._loadmap.done
end

function client.loadmap()
  return math.floor((client._loadmap.x-1 + (client._loadmap.y-1)*64)/(64^2)*100)
end

function client.update(dt)
  client._money_t_dt = client._money_t_dt + dt
  if client._money_t_dt > client._money_t then
    client._money_t_dt = 0
    client.sock:run("money","")
  end

  client._mapq_t_dt = client._mapq_t_dt + dt
  if client._mapq_t_dt > client._mapq_t then
    client._mapq_t_dt = 0
    client.sock:run("mapq","")
  end  

  if not client._loadmap.done then
    client._loadmap.dt = client._loadmap.dt + dt
    if client._loadmap.dt > client._loadmap.t then
      client._loadmap.dt = 0
      
      for i = 1,client._loadmap.multiplex do
        if client._loadmap.done then
          break
        end
        client.sock:run("map",{x=client._loadmap.x,y=client._loadmap.y})
        client._loadmap.x = client._loadmap.x + 1
        if client._loadmap.x > 64 then
          client._loadmap.x = 1
          client._loadmap.y = client._loadmap.y + 1
          if client._loadmap.y > 64 then
            client._loadmap.done = true
          end
        end
        
      end
      
    end
  end
  client.sock:update(dt)
  return true
end

return client