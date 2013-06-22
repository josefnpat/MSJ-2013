ops = require('ops')
local connect = {}

connect.msg = ""
connect.msgt = 1
connect.msgt_dt = 0

function connect:draw()
  love.graphics.print("Connect to:\n"..
        "1) fake-client (aka single player)\n"..
        "2) localhost\n"..
        "3) asswb.com\n\n"..connect.msg,32,32)
end

function connect:keypressed(key)
  local connect_valid = false
  if key == "1" then
    client = require("fake-client")
    connect_valid = true
  elseif key == "2" or key == "3" then
    require('libs/json')
    require('socket')
    jellyclient = require('libs.jelly-client')
    local ip = "localhost"
    if key == "3" then
      ip = "asswb.com"
    end
    client,error = jellyclient.new(ip,19870,ops)
    if error then
      connect.msg = error
      connect.msgt_dt = 0
    else
      connect_valid = true
    end
  end
  if connect_valid then
    Gamestate.switch(states.game)
  end
end

function connect:update(dt)
  if connect.msg then
    connect.msgt_dt = connect.msgt_dt + dt
    if connect.msgt_dt > connect.msgt then
      connect.msgt_dt = 0
      connect.msg = ""
    end
  end
end

return connect