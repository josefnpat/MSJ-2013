#!/usr/bin/lua5.1

local json = require("json")

local socket = require("socket")
local server = assert(socket.bind("*", 1337))
local ip, port = server:getsockname()

print("Server hosted on port " .. port)

local clients = {}

while 1 do
  local client,error = server:accept()
  if client then
    client:settimeout(0.001)
    table.insert(clients,client)
  else
    print(error)
  end
  
  for _,client in ipairs(clients) do
  
    local line,error = client:receive()
    if error then
      print(error)
    else
      if pcall(function() json.decode(line) end) then
        data = json.decode(line)
        client:send(json.encode(payload).."\n")
        time_end = socket.gettime()
        print("receive:"..line.." ["..(time_end-time_start).."s]")
      else
        print("json.decode() failed")
      end
    end
    
  end
  
  -- TODO ADD CLEANUP OF CLIENTS
  
end

