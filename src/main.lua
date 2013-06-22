math.randomseed( os.time() )

love.graphics.setDefaultImageFilter("nearest","nearest")

git,git_count = "missing git.lua",0
pcall( function() return require("git") end );

Gamestate = require("libs.gamestate")

states = {}
states.game = require("game_state")

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(states.game)
end