require "camera"
local game = {}

selection = {}
selection.x = 0
selection.y = 0
mouseLoc = {}
mouseLoc.x = 0
mouseLoc.y = 0

function game:init()
  local AdvTiledLoader = require("AdvTiledLoader.Loader")
  commandCenter_tile = require("tileFiles.commandCenter_tile")
  defensive_tile = require("tileFiles.defensive_tile")
  offensive_tile = require("tileFiles.offensive_tile")
  road_tile = require("tileFiles.road_tile")

  selection_tile = love.graphics.newImage("selection.png")
  
  AdvTiledLoader.path = "maps/"
  map = AdvTiledLoader.load("map.tmx")
  map:setDrawRange(mapX, mapY, map.width * map.tileWidth, map.height * map.tileHeight)
  
  cameraMove = 2 * 4.3
end

function game:draw()
  camera:set()
  map:draw()
  love.graphics.draw(selection_tile, math.floor(selection.x * map.tileWidth), math.floor(selection.y * map.tileHeight))
  camera:unset()
  love.graphics.print("Tile X: " .. selection.x .. ", Mouse X: " .. mouseLoc.x, 20, 10)
  love.graphics.print("Tile Y: " .. selection.y .. ", Mouse Y: " .. mouseLoc.y, 20, 30)
end

function game:update(dt)

  if love.keyboard.isDown("d") then
    camera.x = camera.x + cameraMove
  end
  if love.keyboard.isDown("a") then
    camera.x = camera.x - cameraMove
  end
  if love.keyboard.isDown("w") then
    camera.y = camera.y - cameraMove
  end
  if love.keyboard.isDown("s") then
    camera.y = camera.y + cameraMove
  end
  
  mouseLoc.x, mouseLoc.y = love.mouse.getPosition( ) 
  selection.x =  math.ceil((mouseLoc.x * camera.sx + (camera.x - 64)) / map.tileWidth) + 1
  selection.y =  math.ceil((mouseLoc.y * camera.sy + (camera.y - 64)) / map.tileHeight) + 1
  
end

return game