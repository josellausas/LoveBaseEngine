--[[ Main.lua 

> La base de la base
by jose@josellausas.com

Todos los derechos reservadas.

]]
local lovebird 		= require("lovebird")
local camera 		= require("LLBase.LLCamera")
local gameSettings  = require("game_settings")
local LlauGame 	    = require("Game")

-- Defaults fro the camera
local cameraSpeed 	= 800
local camScale 		= 2


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
	love.graphics.setBackgroundColor(255,255,255)

	LlauGame:init(gameSettings)
end


local function getCameraDeltas(dt)

	local moveAmount = dt * cameraSpeed

	local deltaX = 0
	local deltaY = 0

	if love.keyboard.isDown("left") then
		deltaX = -moveAmount
	elseif love.keyboard.isDown("right")then
		deltaX = moveAmount
	end

	if love.keyboard.isDown("up") then
		deltaY = -moveAmount
	elseif love.keyboard.isDown("down")then
		deltaY = moveAmount
	end

	return deltaX, deltaY
end

	
function love.update(dt)
	
	lovebird.update()
	
	LlauGame:update(dt)
	
	local camDx, camDy = getCameraDeltas(dt)
	print(camDx .. " - " .. camDy)
	camera:move(camDx, camDy)

end

function love.draw()
	camera:set()
	
	LlauGame:draw()
	
	camera:unset()
end

function love.mousepressed(x,y,button)
	print("mouse pressed")
	print(button)
	if button == 1 then
		local relX, relY = camera:mousePosition(x,y)
		
		print(relX .. " - " ..relY)

	end
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
		camScale = camScale * 2
		camera:setScale(camScale,camScale)
	end

	if key == 'a' then
		camScale = camScale / 2
		camera:setScale(camScale,camScale)
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



