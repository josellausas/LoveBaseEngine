--[[ Main.lua 

> La base de la base
by jose@josellausas.com

Todos los derechos reservadas.

]]

local imgx = 100
local imgy = 100

local blueTile = nil
local redTile = nil

function love.load()
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(255,255,255)

	-- Load the images here
	blueTile = love.graphics.newImage("art/tileBlue_04.png")
	redTile = love.graphics.newImage("art/tileRed_04.png")
	playerShip = love.graphics.newImage("art/playerShip3_blue.png")
end

function love.update(dt)
	if love.keyboard.isDown("up") then
		num = num + 100 * dt -- 100 hz
	end
end

function love.draw()
	-- Color setting is global.
	love.graphics.setColor(0,0,0)
	love.graphics.print("Hello World", 400, 400)

	love.graphics.setColor(255,255,255)
	love.graphics.draw(blueTile, imgx, imgy)
	love.graphics.draw(redTile, 250,100)
	love.graphics.draw(playerShip, playerX, playerY)

	
end

function love.mousepressed(x,y,button)
	print("mouse pressed")
	print(button)
	if button == 1 then
		imgx, imgy = x,y
	end
end

function love.mousereleased(x,y,button)
	if (button == '1') then
		-- Do something
	end
end

function love.keypressed(key)
	if key == 'b' then
		-- the b key was pressed
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



