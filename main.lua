--[[ Main.lua 

> La base de la base
by jose@josellausas.com

Todos los derechos reservadas.

]]
local lovebird 		= require("lovebird")
local gameSettings  = require("game_settings")
local LlauGame 	    = require("Game")

require("mobdebug").start()

-- Window width
local function getWidth()
	return love.graphics.getWidth()
end

-- Window height
local function getHeight()
	return love.graphics.getHeight()
end


function love.load()
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(120,120,120)

	LlauGame:init(gameSettings)
end


	
function love.update(dt)
	LlauGame:update(dt)
	lovebird.update()
end

function love.draw()
	LlauGame:draw()
end


function love.mousepressed(x,y,button)
	
end

function love.mousereleased(x,y,button)
	if (button == '1') then
		-- Do something
	end
end



function love.keypressed(key)
	
	
end

function love.keyreleased(key)
	if key == 'z' then
		LlauGame:zoomOut()
	end

	if key == 'a' then
		LlauGame:zoomIn()
	end
end

function love.focus(f)
	if not f then
		print("Lost focus")
	else
		print("Gained focus")
		print("Window dimensions = { " .. getWidth() .. " , " .. getHeight() .. " } ")
	end
end

function love.quit()
	-- Before quits runs this:
end



