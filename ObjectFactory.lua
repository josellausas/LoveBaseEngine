--[[ ObjectFactory.lua ]]

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

return ObjectFactory