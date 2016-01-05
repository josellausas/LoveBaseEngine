--[[ Main.lua 

> La base de la base
by jose@josellausas.com

Todos los derechos reservadas.

]]

local imgx = 100
local imgy = 100

local blueTile = nil
local redTile  = nil

local target = nil

local ObjectFactory = require("ObjectFactory")

local ai_01 = nil
local ai_02 = nil
local ai_03 = nil
local ai_04 = nil
local ai_05 = nil





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

function love.update(dt)
	if love.keyboard.isDown("up") then
		
	end

	ObjectFactory:update(dt)
end

function love.draw()
	
	ObjectFactory:draw()
	
end

function love.mousepressed(x,y,button)
	print("mouse pressed")
	print(button)
	if button == 1 then
		imgx, imgy = x,y
		target.x = x
		target.y = y
	end
end

function love.mousereleased(x,y,button)
	if (button == '1') then
		-- Do something
	end
end

function love.keypressed(key)
	if key == 'b' then
		
		ai_01.speed = 25
		ai_02.speed = 12
		ai_03.speed = 31
		ai_04.speed = 24
		ai_05.speed = 100
	end
end

function love.keyreleased(key)
	-- The key was released
end

function love.focus(f)
	if not f then
		print("Lost focus")
	else
		print("Gained focus")
	end
end

function love.quit()
	-- Before quits runs this:
end



