math.randomseed( os.time() )

game_name = "Temp Game Name"

love.graphics.setCaption(game_name)

love.graphics.setDefaultImageFilter("nearest","nearest")

git,git_count = "missing git.lua",0
pcall( function() return require("git") end );

Gamestate = require("libs.gamestate")

states = {}
states.intro = require("state_intro")
states.game = require("state_game")
states.connect = require("state_connect")

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(states.intro)
end