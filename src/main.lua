Gamestate = require "gameState.gamestate"

states = {}
game = require("game")


function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(game)

end