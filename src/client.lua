local client = {}

client._money = 0
client._money_t = 1
client._money_t_dt = client._money_t

function client.money()
  return client._money
end

function client.update(dt)
  client._money_t_dt = client._money_t_dt + dt
  if client._money_t_dt > client._money_t then
    client._money_t_dt = 0
    client.sock:run("money","")
  end
  client.sock:update(dt)
  return true
end

return client