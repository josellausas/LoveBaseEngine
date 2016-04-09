--[[ Main.lua 

> La base de la base
by jose@josellausas.com

Todos los derechos reservadas.

]]
local lovebird 		= require("lovebird")
local gameSettings  = require("game_settings")
local LlauGame 	    = require("Game")

require("mobdebug").start()

local busted = require("busted")

-- Window width
local function getWidth()
	return love.graphics.getWidth()
end

-- Window height
local function getHeight()
	return love.graphics.getHeight()
end


function love.load()
	-- Grab the max size of the screen
	local options = {
		fullscreen = false, 
		vsync = false, 
		msaa = 0, 
		resizable = true, 
		borderless=false, 
		centered = true, 
		display = 1
	}
	love.window.setMode(0, 0, options)
	--[[
	local screen_width  = love.graphics.getWidth()
	local screen_height = love.graphics.getHeight()
	-- Offset for window things
	love.window.setMode(screen_width, screen_height, options)
	]]

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

local sound = nil

local function playSFX(nameID)
	if(sound == nil) then
		sound = love.audio.newSource("art/Sound/fall.wav", "static")
	end

	sound:play()
end

function love.keyreleased(key)
	if key == 'z' then
		LlauGame:zoomOut()

		-- Play a sound
		playSFX("hey")

		success = love.window.showMessageBox( "Hola", "que hace", "info",  false)
	end

	if key == 'a' then
		LlauGame:zoomIn()
	end

	if key=='space' then
		LlauGame:centerCamPlayer()
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



