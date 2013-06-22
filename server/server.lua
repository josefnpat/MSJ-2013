#!/usr/bin/lua5.1

require "json"
require "socket"

jellyserver = require('jelly-server')
ops = require('ops')

server = jellyserver.new(19870,ops)

servercache = {}
servercache.user = {}
servercache.user.data = {}
servercache.user.publicid = 1
function servercache.user.init(clientid)
  if not servercache.user.data[clientid] then
    servercache.user.data[clientid] = {}
    servercache.user.data[clientid].money = 2000
    servercache.user.data[clientid].publicid = "X"..servercache.user.publicid
    servercache.user.publicid = servercache.user.publicid + 1
  end
end

servercache.buildings = {}
servercache.buildings.data = {
  {name = "Command Center",cost="0"}, 
  {name = "Bunker",cost = "10"}, 
  {name = "Turret",cost = "15"},
  {name = "Road",cost = "2"}, 
  {name = "Factory",cost = "20"},
}

servercache.map = {}
servercache.map.x = 64
servercache.map.y = 64
servercache.map.data = {}

for y = 1,servercache.map.y do
  servercache.map.data[y] = {}
  for x = 1,servercache.map.x do
    -- TODO: have this data load from the collision layer from src/maps/map.tmx
    servercache.map.data[y][x] = {tile=0} -- open space
    if math.random(1,10) == 1 then
      servercache.map.data[y][x].tile = math.random(1,#servercache.buildings.data)
      servercache.map.data[y][x].owner = math.random(1,10)
    end
  end
end

while 1 do
  server:update()
end
