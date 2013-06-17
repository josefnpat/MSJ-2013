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
    client:settimeout(0.01)
    table.insert(clients,client)
  else
    print("accept error:"..error)
  end
  
  for clienti,client in ipairs(clients) do
  
    local line,error = client:receive()
    if error then
      table.remove(clients,clienti)
      print("receive error:"..error)
    else
      if pcall(function() json.decode(line) end) then
        data = json.decode(line)
        client:send(json.encode({test="Hello world."}).."\n")
        print("receive:"..line)
      else
        print("json.decode() failed")
      end
    end
    
  end
  
end

