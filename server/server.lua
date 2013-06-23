#!/usr/bin/lua5.1

require "json"
require "socket"

jellyserver = require('jelly-server')
ops = require('ops')

server = jellyserver.new(19870,ops)

map_export = require("map_export")

for i,v in pairs(map_export.layers) do
  if v.name == "collision" then
    map_collision = {}
    local tx,ty = 1,1
    map_collision[ty] = {}
    for j,w in pairs(v.data) do
      if w == 7 then
        map_collision[ty][tx] = true
      else
        map_collision[ty][tx] = false      
      end
      tx = tx + 1
      if tx > 64 then
        tx = 1
        ty = ty + 1
        map_collision[ty] = {}
      end
    end
    break
  end
end

servercache = {}
servercache.user = {}
servercache.user.data = {}
servercache.user.publicid = 1
function servercache.user.init(clientid)
  if not servercache.user.data[clientid] then
    servercache.user.data[clientid] = {}
    servercache.user.data[clientid].money = 100100
    servercache.user.data[clientid].publicid = servercache.user.publicid
    servercache.user.publicid = servercache.user.publicid + 1
    servercache.user.data[clientid].last_mapq_update = socket.gettime()
  end
end

servercache.buildings = {}
servercache.buildings.data = {
  {name="Command Center",cost=100000,hp=100},
  {name="Bunker",cost=100,hp=50}, 
  {name="Turret",cost=600,hp=10},
  {name="Road",cost=20,hp=3}, 
  {name="Factory",cost=400,hp=15},
}

servercache.map = {}
servercache.map.x = 64
servercache.map.y = 64
servercache.map.data = {}

for y = 1,servercache.map.y do
  servercache.map.data[y] = {}
  for x = 1,servercache.map.x do
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
        servercache.user.data[clientid].money = servercache.user.data[clientid].money + 10
      elseif w.tile == 5 then
        local clientid = find_clientid(w.owner)
        servercache.user.data[clientid].money = servercache.user.data[clientid].money + 3
      end
      
    end
  end
end

ticks.checkuser = {}
ticks.checkuser.t = 10
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

ticks.attack = {}
ticks.attack.t = 1
ticks.attack.dt = 0
ticks.attack.run = function()
  for y,v in pairs(servercache.map.data) do
    for x,w in pairs(v) do
    
      if w.tile == 3 then
      
        for i,v in pairs({{x+1,y},{x-1,y},{x,y+1},{x,y-1}}) do
          attack(v[1],v[2],w.owner)
          ops.mapq.newItem(v[1],v[2])
        end
        
      end
      
    end
  end  
end

function attack(x,y,owner)
  if servercache.map.data[y] and
      servercache.map.data[y][x] and
      servercache.map.data[y][x].owner and
      servercache.map.data[y][x].owner ~= owner then
    servercache.map.data[y][x].hp = servercache.map.data[y][x].hp - 1
    if servercache.map.data[y][x].hp <= 0 then
      servercache.map.data[y][x].tile = 0
      servercache.map.data[y][x].owner = nil
    end
  end
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
