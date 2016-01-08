--[[ Main.lua 

> La base de la base
by jose@josellausas.com

Todos los derechos reservadas.

]]

local ObjectFactory = require("ObjectFactory")
local lovebird 		= require("lovebird")
local camera 		= require("LLCamera")

local cameraSpeed = 800
local camScale = 2


require("mobdebug").start()


local blueTile 	= nil
local redTile  	= nil
local target 	= nil
local ai_01 	= nil
local ai_02 	= nil
local ai_03 	= nil
local ai_04 	= nil
local ai_05 	= nil

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

	-- Load the images here
	blueTile   = love.graphics.newImage("art/tileBlue_04.png")
	redTile    = love.graphics.newImage("art/tileRed_04.png")
	playerShip = love.graphics.newImage("art/playerShip3_blue.png")

	target = ObjectFactory:new(redTile, 200, 200)

	ai_01 = ObjectFactory:newAI(playerShip, 100, 500, target)
	ai_02 = ObjectFactory:newAI(playerShip, 200, 500, target)
	ai_03 = ObjectFactory:newAI(playerShip, 300, 500, target)
	ai_04 = ObjectFactory:newAI(playerShip, 400, 500, target)
	ai_05 = ObjectFactory:newAI(playerShip, 500, 500, target)

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
	-- Update the world
	ObjectFactory:update(dt)
	

	local camDx, camDy = getCameraDeltas(dt)
	print(camDx .. " - " .. camDy)
	camera:move(camDx, camDy)

end

function love.draw()
	camera:set()
	ObjectFactory:draw()
	camera:unset()
end

function love.mousepressed(x,y,button)
	print("mouse pressed")
	print(button)
	if button == 1 then
		local relX, relY = camera:mousePosition(x,y)
		target.x = relX
		target.y = relY
	end
end

function love.mousereleased(x,y,button)
	if (button == '1') then
		-- Do something
	end
end



function love.keypressed(key)
	if key == 'b' then
		-- Makes them moove at diferent speeds
		ai_01.speed = 60
		ai_02.speed = 500
		ai_03.speed = 300
		ai_04.speed = 200
		ai_05.speed = 120
	end

	
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



