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
	-- Constructor
	new = function(self, renderImage)
		local renderObjInstance = 
		{
			x = 100,
			y = 100,
			lifeTime = 0,
			image = renderImage,
			draw = function(self)
				love.graphics.draw(self.image, self.x, self.y)
			end
		}
		return renderObjInstance
	end,
}

local MovingObject = 
{
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

		-- Knows how to update itself
		movingInstance.update = function(self, dt)
			self.x = self.x + (self.vx * dt)
			self.y = self.y + (self.vy * dt)
			self.lifeTime = self.lifeTime + dt
		end

		return movingInstance
	end
}

local ObjectFactory = 
{
	allObjects = {},
	new = function(self, img, posX, posY)
		local instance = MovingObject:new(img)
		instance.x = posX
		instance.y = posY

		table.insert(self.allObjects, instance)
		return instance
	end,
	update = function(self, dt)
		for k,v in pairs(self.allObjects) do
			v:update(dt)
		end
	end,
	draw = function(self)
		for k,v in pairs(self.allObjects) do
			v:draw()
		end
	end,

}



function love.load()
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(255,255,255)

	-- Load the images here
	blueTile = love.graphics.newImage("art/tileBlue_04.png")
	redTile = love.graphics.newImage("art/tileRed_04.png")
	playerShip = love.graphics.newImage("art/playerShip3_blue.png")


	ObjectFactory:new(playerShip, 100, 500)
	ObjectFactory:new(playerShip, 200, 500)
	ObjectFactory:new(playerShip, 300, 500)
	ObjectFactory:new(playerShip, 400, 500)
	ObjectFactory:new(playerShip, 500, 500)




end

function love.update(dt)
	if love.keyboard.isDown("up") then
		num = num + 100 * dt -- 100 hz
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



