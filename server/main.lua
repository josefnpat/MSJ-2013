-- SERVER TEST CLIENT

client = require("client")

function love.load()
  local success,error = client.connect("localhost","1337")
  if success then
    print("Connected successfully")
  else
    print("Connection failed:" .. error)
  end
end

function love.update(dt)
  local success,error = client.update(dt)
  if not success then
    print("Failed to update:"..error)
  end
end

function love.mousepressed(x,y,button)
  rx,ry = math.floor(x/32)+1,math.floor(y/32)+1
  print(rx,ry)
  if button == "l" then
    if client.map.free(rx,ry) then
      local success,error = client.map.buy(1,rx,ry)
      if not success then
        print(error)
      end
    end
  elseif button == "r" then
    local success,error = client.map.sell(rx,ry)
    if not success then
      print(error)
    end
  end
end

function love.draw()
  local map = client.map.get()
  
  for yi,yv in pairs(map) do
    for xi,xv in pairs(yv) do
    
      if client.map.free(xi,yi) then
        love.graphics.setColor(255,255,255)
      else
        love.graphics.setColor(255,0,0)      
      end
      
      if xv.data then
        love.graphics.rectangle("fill",(xi-1)*32,(yi-1)*32,31,31)
      else
        love.graphics.rectangle("line",(xi-1)*32,(yi-1)*32,31,31)
      end
    end
  end
  
  love.graphics.setColor(255,255,255)
  
end