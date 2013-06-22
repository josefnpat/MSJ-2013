math.randomseed( os.time() )

love.graphics.setDefaultImageFilter("nearest","nearest")

git,git_count = "missing git.lua",0
pcall( function() return require("git") end );

Gamestate = require("libs.gamestate")

states = {}
game = require("game")

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(game)
end