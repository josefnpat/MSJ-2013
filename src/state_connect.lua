ops = require('ops')
local connect = {}

function connect:init()
  connect.bg = love.graphics.newImage("assets/bg.png")
  fonts = {}
  fonts.title = love.graphics.newFont("assets/gimmie_danger.ttf",64)
  fonts.ui = love.graphics.newFont("assets/iceland_regular.ttf",32)
  music=love.audio.newSource("assets/house.mp3")
  music:setLooping(true)
  love.audio.play(music)
end

connect.msg = ""
connect.msgt = 1
connect.msgt_dt = 0

function connect:draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(connect.bg,0,0,0,2/3,2/3)
  love.graphics.setFont(fonts.title)
  love.graphics.printf(game_name,0,0,love.graphics.getWidth(),"center")
  love.graphics.setFont(fonts.ui)    
  if client and client.loading then
    connect.msg = "Synchronizing map ... "..client.loadmap().."%\n"
    connect.msgt_dt = 0
  end
  love.graphics.print("Press any key to connect to asswb.com server.\n"..
        connect.msg.."\n",256,512)
end

function connect:keypressed(key)
  local connect_valid = false
  if key == "d" then
    client = require("fake-client")
    client.connect()
    connect_valid = true
  elseif not client then
    require('libs/json')
    require('socket')
    client = require('client')
    jellyclient = require('libs.jelly-client')
    local ip = "localhost"
    if key ~= "l" then
      ip = "asswb.com"
    end
    client.sock,error = jellyclient.new(ip,19870,ops)
    if error then
      connect.msg = error
      connect.msgt_dt = 0
      client = nil
    else
      connect_valid = true
      client.sock:run("buildings","")
    end
  end
  if connect_valid then
    client.loading = true
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
  if client and client.loading then
    client.update(dt)
    if client.ready() then
      Gamestate.switch(states.game)      
    end
  end
end

return connect