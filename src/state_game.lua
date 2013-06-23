require("libs.camera")
colorgen = require("colorgen")

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
  
  bld = {}
  bld.img = love.graphics.newImage("maps/buildings.png")
  bld.img_color = love.graphics.newImage("maps/buildings_color.png")
  
  bld.quads = {}
  for i = 1,5 do
    bld.quads[i] = love.graphics.newQuad( (i-1)*32,0,32,64,256,256)
  end
  
end

function game:draw()
  love.graphics.setFont(fonts.ui)
  camera:set()
  map:draw()
  love.graphics.draw(selection_tile,
    math.floor( (selection.x-1) * map.tileWidth),
    math.floor( (selection.y-1) * map.tileHeight)
  )

  local buildings = client.buildings.get()
  for y,v in pairs(client.map.get()) do
    for x,w in pairs(v) do
      if w.tile ~= 0 then
        if w.owner then
          love.graphics.setColor(255,255,255)
          love.graphics.drawq(bld.img,bld.quads[w.tile],(x-1)*32,(y-2)*32)
          love.graphics.setColor( colorgen.get(w.owner) )
          love.graphics.drawq(bld.img_color,bld.quads[w.tile],(x-1)*32,(y-2)*32)
          if buildings then
            local percent = w.hp/buildings[w.tile].hp
            if percent < 1 then
              love.graphics.setColor(0,255,0)
              love.graphics.rectangle("fill",(x-1)*32,(y-1)*32,32*percent,4)
              love.graphics.setColor(0,0,0)
              love.graphics.rectangle("line",(x-1)*32,(y-1)*32,32*percent,4)
            end
          end
        end
        love.graphics.setColor(255,255,255)
      end
    end
  end

  camera:unset()
  
  love.graphics.print( "$" .. client.money(),32,32)

  if client.closed() then
    love.graphics.setColor(0,0,0,127)
    love.graphics.rectangle("fill",0,32,love.graphics.getWidth(),32)
    love.graphics.setColor(255,255,255)
    love.graphics.printf("You have been disconnected.",0,32,love.graphics.getWidth(),"center")
  end
      
  local boff = 128
  love.graphics.setColor(0,0,0,127)
  love.graphics.rectangle("fill",0,boff-32,350,64*5+64)
  if client.buildings.get() then
    for i,v in pairs(client.buildings.get()) do
      if client.money() < v.cost then
        love.graphics.setColor(255,0,0)
      elseif game.current_selected_building == i then
        love.graphics.setColor(0,255,0)
      else
        love.graphics.setColor(255,255,255)
      end
      love.graphics.drawq(bld.img,bld.quads[i],32,boff+64*(i-1))
      love.graphics.printf(v.name .. "\n$"..v.cost,96,boff+64*(i-1),350-64-64,"left")
      love.graphics.printf("\n"..i,96,boff+64*(i-1),350-64-64,"right")
    end
  end
  love.graphics.setColor(255,255,255)
  
end

function game:update(dt)

  client.update(dt)

  love.graphics.setCaption(game_name .. " " .. love.timer.getFPS())

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

game.current_selected_building = 1

function game:keypressed(key)
  if key == "1" then
    game.current_selected_building = 1  
  elseif key == "2" then
    game.current_selected_building = 2
  elseif key == "3" then
    game.current_selected_building = 3
  elseif key == "4" then
    game.current_selected_building = 4
  elseif key == "5" then
    game.current_selected_building = 5  
  end
end

function game:mousepressed(x,y,button)
  if button == "l" then
    client.map.buy(game.current_selected_building,selection.x,selection.y)
  elseif button == "r" then
    client.map.sell(selection.x,selection.y)
  end
end

return game