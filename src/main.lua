math.randomseed( os.time() )

love.graphics.setDefaultImageFilter("nearest","nearest")

git,git_count = "missing git.lua",0
pcall( function() return require("git") end );

Gamestate = require("libs.gamestate")

states = {}
states.game = require("state_game")
states.connect = require("state_connect")

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(states.connect)
end