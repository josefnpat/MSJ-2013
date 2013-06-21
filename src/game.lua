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

function game:init()
  local AdvTiledLoader = require("AdvTiledLoader.Loader")
  commandCenter_tile = require("tileFiles.commandCenter_tile")
  defensive_tile = require("tileFiles.defensive_tile")
  offensive_tile = require("tileFiles.offensive_tile")
  road_tile = require("tileFiles.road_tile")

  selection_tile = love.graphics.newImage("selection.png")
  
  AdvTiledLoader.path = "maps/"
  map = AdvTiledLoader.load("map.tmx")
  map:setDrawRange(window.x,window.y,window.w,window.h)  
  camera:setScale(0.5,0.5)
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
  
  mouseLoc.x, mouseLoc.y = love.mouse.getPosition( ) 
  selection.x =  math.ceil((mouseLoc.x * camera.sx + (camera.x)) / map.tileWidth)
  selection.y =  math.ceil((mouseLoc.y * camera.sy + (camera.y)) / map.tileHeight)
  
end

return game