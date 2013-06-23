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
    servercache.user.data[clientid].publicid = servercache.user.publicid
    servercache.user.publicid = servercache.user.publicid + 1
    servercache.user.data[clientid].last_mapq_update = socket.gettime()
  end
end

servercache.buildings = {}
servercache.buildings.data = {
  {name="Command Center",cost=1000,hp=100},
  {name="Bunker",cost=100,hp=50}, 
  {name="Turret",cost=150,hp=25},
  {name="Road",cost=20,hp=10}, 
  {name="Factory",cost=200,hp=15},
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
  end
end

servercache.map.changeset = {}

ticks = {}
ticks.money = {}
ticks.money.t = 1
ticks.money.dt = 0
ticks.money.run = function()
  for y,v in pairs(servercache.map.data) do
    for x,w in pairs(v) do
    
      if w.tile == 1 then
        local clientid = find_clientid(w.owner)
        servercache.user.data[clientid].money = servercache.user.data[clientid].money + 5
      elseif w.tile == 5 then
        local clientid = find_clientid(w.owner)
        servercache.user.data[clientid].money = servercache.user.data[clientid].money + 7
      end
      
    end
  end
end

ticks.checkuser = {}
ticks.checkuser.t = 1
ticks.checkuser.dt = 0
ticks.checkuser.run = function()
  for clientid,v in pairs(servercache.user.data) do
    if socket.gettime() - servercache.user.data[clientid].last_mapq_update > 1 
        and not servercache.user.data[clientid]._remove then
      servercache.user.data[clientid]._remove = true
      for y,v in pairs(servercache.map.data) do
        for x,w in pairs(v) do
          if w.owner == servercache.user.data[clientid].publicid then
            w.owner = nil
            w.tile = 0
            ops.mapq.newItem(x,y)
          end
        end
      end
      
    end
  end
  --[[ TODO: This doesn't actually remove the player for some reason.
  for i,v in pairs(servercache.user.data) do
    if v._remove then
      table.remove(servercache.user.data,i)
    end
  end
  --]]
end

function find_clientid(publicid)
  local clientid
  for i,v in pairs(servercache.user.data) do
    if publicid == v.publicid then
      clientid = i
      break
    end
  end
  return clientid
end

time = socket.gettime()
while 1 do
  last_time = time
  time = socket.gettime()
  dt = time - last_time
  
  server:update()
  
  for i,v in pairs(ticks) do
    v.dt = v.dt + dt
    if v.dt > v.t then
      v.dt = v.dt - v.t
      v.run()
    end
  end
    
end
