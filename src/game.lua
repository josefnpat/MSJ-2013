require "camera"
local game = {}

function game:init()
  local AdvTiledLoader = require("AdvTiledLoader.Loader")
  commandCenter_tile = require("tileFiles.commandCenter_tile")
  defensive_tile = require("tileFiles.defensive_tile")
  offensive_tile = require("tileFiles.offensive_tile")
  road_tile = require("tileFiles.road_tile")

  AdvTiledLoader.path = "maps/"
  map = AdvTiledLoader.load("map.tmx")
  map:setDrawRange(mapX, mapY, map.width * map.tileWidth, map.height * map.tileHeight)
  
  cameraMove = 2 * 4.3
end

function game:draw()
  camera:set()
    
  map:draw()

  camera:unset()
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
end

return game