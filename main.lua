--------------------------------
-- La base de la base
--
-- @author jose@josellausas.com
-- @copyright Zunware 2016
--------------------------------
local lovebird 		= require("lovebird")
local gameSettings  = require("game_settings") -- The settings used for the game
local LlauGame 	    = require("Game")

require("mobdebug").start()

local busted = require("busted")

-------------------------------------------------------
-- The windows width
--
-- @return number The width in pixels
-------------------------------------------------------
local function getWidth()
	return love.graphics.getWidth()
end

-------------------------------------------------------
-- The window's height
--
-- @return number The height in pixels
-------------------------------------------------------
local function getHeight()
	return love.graphics.getHeight()
end

-------------------------------------------------------
-- Loads the game
-------------------------------------------------------
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

	-- Setup the Love window
	love.window.setMode(0, 0, options)
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(120,120,120)

	-- Initializes the Llau Game
	LlauGame:init(gameSettings)
end


----------------------------------------------------
-- Updates the system
--
-- @param dt Delta time
----------------------------------------------------
function love.update(dt)
	LlauGame:update(dt)
	lovebird.update()
end


----------------------------------------------------
-- Draws the scene
----------------------------------------------------
function love.draw()
	LlauGame:draw()
end


----------------------------------------------------
-- Handles mouse presses
--
-- @param x **(Number)** The x coordinate
-- @param y **(Number)** The y coordinate
-- @param button **(Button)** the button pressed
----------------------------------------------------
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

----------------------------------------
-- Handles heyboard input
--
-- @param key The key that was pressed
----------------------------------------
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

----------------------------------------
-- Handles the focus event
----------------------------------------
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



