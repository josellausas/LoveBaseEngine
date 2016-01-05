--[[ Main.lua 

> La base de la base
by jose@josellausas.com

Todos los derechos reservadas.

]]

local imgx = 100
local imgy = 100

local blueTile = nil
local redTile = nil

local RenderObject = 
{
	-- The items
	allItems = {},
	-- Constructor
	new = function(self, renderImage)
		local renderObjInstance = 
		{
			x = 100,
			y = 100,
			image = renderImage
		}
		
		-- Keep track of the things
		table.insert(self.allItems, renderObjInstance)
		
		return renderObjInstance
	end,

	draw = function(self)
		for i,v in pairs(self.allItems) do
			--todo
			love.graphics.draw(v.image, v.x, v.y)
		end
	end
}

local MovingObject = 
{
	allItems = {},
	new = function(self, renderImage)
		
		-- Inheritance :)
		local movingInstance = RenderObject:new(renderImage)
		
		-- Add extra things here:
		movingInstance.vx = 0
		movingInstance.vy = -25

		-- Fwd vector
		movingInstance.fwd = {
			x = 0,
			y = 1
		}

		table.insert(self.allItems, movingInstance)

		return movingInstance
	end,
	update = function(self, dt)
		for k,v in pairs(self.allItems) do
			deltaX = v.vx * dt
			deltaY = v.vy * dt

			v.x = v.x + deltaX
			v.y = v.y + deltaY
		end
	end
}


function love.load()
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(255,255,255)

	-- Load the images here
	blueTile = love.graphics.newImage("art/tileBlue_04.png")
	redTile = love.graphics.newImage("art/tileRed_04.png")
	playerShip = love.graphics.newImage("art/playerShip3_blue.png")


	MovingObject:new(playerShip)


end

function love.update(dt)
	if love.keyboard.isDown("up") then
		num = num + 100 * dt -- 100 hz
	end

	MovingObject:update(dt)
end

function love.draw()
	

	RenderObject:draw()
	
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



