require "camera"
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
function game:init()
  local AdvTiledLoader = require("AdvTiledLoader.Loader")

  selection_tile = love.graphics.newImage("assets/images/selection.png")
  
  AdvTiledLoader.path = "maps/"
  map = AdvTiledLoader.load("map1.tmx")
  camera:setScale(scale,scale)
end

function game:draw()
  camera:set()
  map:draw()
  love.graphics.draw(selection_tile,
    math.floor( (selection.x-1) * map.tileWidth),
    math.floor( (selection.y-1) * map.tileHeight)
  )
  camera:unset()
  love.graphics.print("Tile X: " .. selection.x .. ", Mouse X: " .. mouseLoc.x, 20, 10)
  love.graphics.print("Tile Y: " .. selection.y .. ", Mouse Y: " .. mouseLoc.y, 20, 30)
end

function game:update(dt)

  love.graphics.setCaption(love.timer.getFPS())

  if love.keyboard.isDown("d") then
    camera.x = camera.x + cameraMove*dt
  end
  if love.keyboard.isDown("a") then
    camera.x = camera.x - cameraMove*dt
  end
  if love.keyboard.isDown("w") then
    camera.y = camera.y - cameraMove*dt
  end
  if love.keyboard.isDown("s") then
    camera.y = camera.y + cameraMove*dt
  end
  
  map.offsetX = camera.x
  map.offsetY = camera.y

  map:setDrawRange(window.x+map.offsetX,window.y+map.offsetY,window.w*scale,window.h*scale)
  
  mouseLoc.x, mouseLoc.y = love.mouse.getPosition( ) 
  selection.x =  math.ceil((mouseLoc.x * camera.sx + (camera.x)) / map.tileWidth)
  selection.y =  math.ceil((mouseLoc.y * camera.sy + (camera.y)) / map.tileHeight)
  
end

return game