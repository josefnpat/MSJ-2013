#!/usr/bin/lua5.1

local json = require("json")

local socket = require("socket")
local server = assert(socket.bind("*", 1337))
local ip, port = server:getsockname()

print("Server hosted on port " .. port)

debug_cycles = 0
debug_cycles_max = 100

local clients = {}

while 1 do
  debug_cycles = debug_cycles + 1
  if debug_cycles > debug_cycles_max then
    debug_cycles = 0
    print("Performed "..debug_cycles_max)
  end
  
  server:settimeout(0.01)
  local client,error = server:accept()
  if client then
    client:settimeout(0.01)
    table.insert(clients,client)
  else
    --print("accept error:"..error)
  end
  
  print("clients:")
  for clienti,client in ipairs(clients) do
    print(clienti,client)
  end
  
  for clienti,client in ipairs(clients) do
    print(clienti.." client:receive start")
    local line,error = client:receive()
    print(clienti.." client:receive stop")
    if error then
      if error == "closed" then
        client:close()
        table.remove(clients,clienti)
      end
      print("receive error:"..error)
    else
      if pcall(function() json.decode(line) end) then
        data = json.decode(line)
        print(clienti.." client:send start")
        client:send(json.encode({test="Hello world."}).."\n")
        print(clienti.." client:send stop")
        print("receive:"..line)
      else
        print("json.decode() failed")
      end
    end
    
  end
  
end

