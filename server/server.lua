#!/usr/bin/lua5.1

local json = require("json")

local socket = require("socket")
local server = assert(socket.bind("*", 19870))
local ip, port = server:getsockname()

update = require("update")

print("Server hosted on port " .. port)

debug = false
debug_cycles = 0
debug_cycles_max = 100

local clients = {}

while 1 do
  if debug then
    debug_cycles = debug_cycles + 1
    if debug_cycles > debug_cycles_max then
      debug_cycles = 0
      print("Performed "..debug_cycles_max)
    end
  end
  
  server:settimeout(0.01)
  local client,error = server:accept()
  if client then
    client:settimeout(0.01)
    table.insert(clients,client)
    print("User connected [client count:"..#clients.."]")
  else
    if debug then print("accept error:"..error) end
  end
  
  if debug then
    print("clients:")
    for clienti,client in ipairs(clients) do
      print(clienti,client)
    end
  end
  
  for clienti,client in ipairs(clients) do
    if debug then print(clienti.." client:receive start") end
    local line,error = client:receive()
    if debug then print(clienti.." client:receive stop") end
    if error then
      if error == "closed" then
        client:close()
        table.remove(clients,clienti)
        print("User disconnected [client count:"..#clients.."]")
      end
      if debug then print("receive error:"..error) end
    else
      if pcall(function() json.decode(line) end) then
        local data = json.decode(line)

        if debug then print("update start") end
        local response = "{}"
        if update then response = json.encode(update.run(client,data)) end
        if debug then print("update stop") end
        if debug then print(clienti.." client:send start") end
        client:send(response.."\n")
        if debug then print(clienti.." client:send stop") end
        if debug then print("receive:"..line) end
      else
        if debug then print("json.decode() failed") end
      end
    end
    
  end
  
end

