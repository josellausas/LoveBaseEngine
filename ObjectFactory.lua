--[[ ObjectFactory.lua ]]

local rotate90 = math.rad(90)


--[[ FUNC TABLES??? ]]
local update_lifeTime = function(self, dt)
	self.lifeTime = self.lifeTime + dt
end

local update_movement = function(self, dt)
	-- Move towards the forwards vector at the given speed.
	local fwdVector = {
		x = math.cos(self.heading),
		y = math.sin(self.heading)
	}

	self.x = self.x + (fwdVector.x * self.speed * dt)
	self.y = self.y + (fwdVector.y * dt * self.speed)
end

local update_intelligence = function(self, dt)
	-- Just looks at the objective for now
	if not (self.target == nil) then
		self:lookAt(self.target)
	end
end

local draw_basic = function(self)
	love.graphics.draw(self.image, self.x, self.y)
end

local draw_advanced = function(self)
	love.graphics.draw(self.image, self.x, self.y, self.heading + rotate90, self.scale.x, self.scale.y, self.spec.offX, self.spec.offY)
end



--[[  RenderObject

	The most basic render object.
	Note: This is not offset to the center.
	This is used for things that do not move.
	And are usually aligned to a grid. 
	If you need to center postion or move, use MovingObject
]]
local RenderObject = 
{
	-- Constructor
	new = function(self, renderImage)
		local renderObjInstance = 
		{
			x = 100,
			y = 100,
			lifeTime = 0,
			image 	= renderImage,
			draw 	= draw_basic,
			update 	= update_func,
		}
		return renderObjInstance
	end,	
}


local MovingObject = 
{
	new = function(self, renderImage)
		-- Inheritance :)
		local movingInstance = RenderObject:new(renderImage)
		
		-- Centered rotation
		local width,height = renderImage:getDimensions()

		-- Add extra things here:
		movingInstance.speed = 0
		movingInstance.spec = {
			w = width,
			h = height,
			offX = width * 0.5,
			offY = height * 0.5
		}

		movingInstance.scale = {
			x = 1,
			y = 1,
		}

		-- Fwd vector
		movingInstance.heading = 0
		movingInstance.setHeading = function(self, x, y)
			--[[Returns the forward vector in radians]]
			self.heading = math.atan2(y, x)
		end


	
		-- Polymorphysm :)
		movingInstance.update = function(self, dt)
			update_lifeTime(self, dt)
			update_movement(self, dt)
		end

		-- Completely overrides parent's implementation
		movingInstance.draw = function(self)
			draw_advanced(self)
		end

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

		-- Polymorphism
		ai.update = function(self, dt)
			-- Call the parents update
			update_lifeTime(self, dt)
			update_movement(self, dt)
			update_intelligence(self, dt)
		end

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

	newStatic = function(self, img, posX, posY)
		local inst = RenderObject:new(img)
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