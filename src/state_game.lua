require "libs.camera"
local game = {}

window = {}
window.padding = 32
window.x = 0
window.y = 0
window.w = love.graphics.getWidth()
window.h = love.graphics.getHeight()
selection = {}
selection.x = 0
selection.y = 0
mouseLoc = {}
mouseLoc.x = 0
mouseLoc.y = 0
cameraMove = 500
scale = 0.5
mouseScroll = 1/10
AdvTiledLoader = require("libs.AdvTiledLoader.Loader")

function game:init()
  selection_tile = love.graphics.newImage("assets/images/selection.png")  
  AdvTiledLoader.path = "maps/"
  map = AdvTiledLoader.load("map.tmx")
  camera:setScale(scale,scale)
end

function game:draw()
  camera:set()
  map:draw()
  love.graphics.draw(selection_tile,
    math.floor( (selection.x-1) * map.tileWidth),
    math.floor( (selection.y-1) * map.tileHeight)
  )
  -- DEBUG EXAMPLE
  for y,v in pairs(client.map.get()) do
    for x,w in pairs(v) do
      if w.tile ~= 0 then
        love.graphics.rectangle("line",x*32,y*32,32,32)
        love.graphics.print(w.tile .. "-" .. w.owner,x*32,y*32)
      end
    end
  end
  camera:unset()
  love.graphics.print("Money: " .. client.money() .. "\n" ..
    "Camera X: " .. camera.x .. ", Tile X: " .. selection.x .. ", Mouse X: " .. mouseLoc.x .. "\n" .. 
    "Camera Y: " .. camera.y .. ", Tile Y: " .. selection.y .. ", Mouse Y: " .. mouseLoc.y, 32, 32)
end

function game:update(dt)

  client.update(dt)

  love.graphics.setCaption(love.timer.getFPS())

  local cam_move_by_key = false
  if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    camera.x = camera.x + cameraMove*dt
    cam_move_by_key = true    
  end
  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
    camera.x = camera.x - cameraMove*dt
    cam_move_by_key = true    
  end
  if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
    camera.y = camera.y - cameraMove*dt
    cam_move_by_key = true    
  end
  if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
    camera.y = camera.y + cameraMove*dt
    cam_move_by_key = true    
  end

  if not cam_move_by_key then
    mx,my = love.mouse.getPosition()
    if mx < love.graphics.getWidth()*mouseScroll then
      camera.x = camera.x - cameraMove*dt
    elseif mx > love.graphics.getWidth()*(1-mouseScroll) then
      camera.x = camera.x + cameraMove*dt
    end
    if my < love.graphics.getHeight()*mouseScroll then
      camera.y = camera.y - cameraMove*dt
    elseif my > love.graphics.getHeight()*(1-mouseScroll) then
      camera.y = camera.y + cameraMove*dt
    end
  end
  
  if camera.x < 0 then
    camera.x = 0
  end
  if camera.y < 0 then
    camera.y = 0
  end
  local max_camera_x = map.tileWidth  * map.width  - love.graphics.getWidth() *scale
  local max_camera_y = map.tileHeight * map.height - love.graphics.getHeight()*scale
  if camera.x > max_camera_x then
    camera.x = max_camera_x
  end  
  if camera.y > max_camera_y then
    camera.y = max_camera_y
  end  
  map.offsetX = camera.x
  map.offsetY = camera.y

  map:setDrawRange(window.x+map.offsetX,window.y+map.offsetY,window.w*scale,window.h*scale)
  
  mouseLoc.x, mouseLoc.y = love.mouse.getPosition( ) 
  selection.x =  math.ceil((mouseLoc.x * camera.sx + (camera.x)) / map.tileWidth)
  selection.y =  math.ceil((mouseLoc.y * camera.sy + (camera.y)) / map.tileHeight)
  
end

function game.mousepressed(x,y,button)
  client.map.buy(1,selection.x,selection.y)
end

return game