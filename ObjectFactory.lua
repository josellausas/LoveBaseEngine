--[[ ObjectFactory.lua ]]

local rotate90 = math.rad(90)

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
		movingInstance.heading = 0

		movingInstance.setHeading = function(self, x, y)
			--[[Returns the forward vector in radians]]
			self.heading = math.atan2(y, x)
		end

		-- Knows how to update itself
		movingInstance.update = function(self, dt)
			self.x = self.x + (self.vx * dt)
			self.y = self.y + (self.vy * dt)
			self.lifeTime = self.lifeTime + dt
		end

		movingInstance.draw = function(self)
			-- Centered rotation
			local width,height = self.image:getDimensions()
			love.graphics.draw(self.image, self.x, self.y, self.heading + rotate90, 1, 1, width * 0.5, height * 0.5)
		end

		-- Para arriba:
		movingInstance:setHeading(0, -1)
		print("Heading: " .. movingInstance.heading)

		return movingInstance
	end
}

local IntelligentObject = 
{
	new = function(self, renderImage, target)
		local ai = MovingObject:new(renderImage)

		ai.target = target

		ai.setTarget = function(self, target)
			self.target = target
		end

		ai.lookAt = function(self, coord)
			--[[Look at behavior]]

			-- Get the targets pos
			local targetX = coord.x
			local targetY = coord.y
			-- Get a vector from us to the target (distVector)
			local distX = targetX - self.x
			local distY = targetY - self.y
			local fwd = {
				x = distX,
				y = distY
			}
			-- Normalize to set the heading vector.
			local length = math.sqrt((distX ^ 2) + (distY ^ 2))
			if(length > 0) then
				fwd.x = distX / length
				fwd.y = distY / length
			end

			self:setHeading(fwd.x, fwd.y)
		end

		ai.update = function(self, dt)
			-- Do the parent behavior
			self.x = self.x + (self.vx * dt)
			self.y = self.y + (self.vy * dt)
			self.lifeTime = self.lifeTime + dt

			if(self.target == nil) then
				
			else
				self:lookAt(self.target)
			end
		end


		--[[ai.draw = function(self, dt)
			TODO: Implement this with forward looking
		end]]
		return ai
	end,
}

local ObjectFactory = 
{
	allObjects = {},
	newAI = function(self, img, posX, posY, target)
		local inst = IntelligentObject:new(img,target)
		inst.x = posX
		inst.y = posY

		table.insert(self.allObjects, inst)
		return inst
	end,
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