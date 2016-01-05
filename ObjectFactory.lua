--[[ ObjectFactory.lua ]]

-- Offsets the rotation so it looks good.
local rotate90 = math.rad(90)


--[[ Updates the lifetime of an object ]]
local update_lifeTime = function(self, dt)
	self.lifeTime = self.lifeTime + dt
end



--[[Moves the object in the direction it is facing]]
local update_movement = function(self, dt)
	-- Move towards the forwards vector at the given speed.
	local fwdVector = {
		x = math.cos(self.heading),
		y = math.sin(self.heading)
	}
	-- Update the position with deltas.
	self.x = self.x + (fwdVector.x * self.speed * dt)
	self.y = self.y + (fwdVector.y * dt * self.speed)
end



--[[Looks at the target if he have one.]]
local update_intelligence = function(self, dt)
	-- Just looks at the objective for now
	if not (self.target == nil) then
		self:lookAt(self.target)
	end
end



--[[Draws static things, no scale, no offsets, etc.]]
local draw_basic = function(self)
	love.graphics.draw(self.image, self.x, self.y)
end



--[[ Draws the thing in the center, scaled and rotated in the correct direction ]]
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


--[[ An image that can move]]
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

--[[ A Moving object that seems to be intelligent ]]
local IntelligentObject = 
{
	-- Our constructor method.
	new = function(self, renderImage, target)
		-- The new instance we are creating
		local ai = MovingObject:new(renderImage)
		-- Sets our target
		ai.target = target

		--[[ Sets the heading in the direciton of the target ]]
		ai.lookAt = function(self, coord)
			-- Get the targets position.
			local targetX = coord.x
			local targetY = coord.y
			-- Get a vector from us to the target (distVector)
			local distX = targetX - self.x
			local distY = targetY - self.y
			-- Figure out our forward vector (has to be normalized)
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
			-- Sets the heading to our forward vector.
			self:setHeading(fwd.x, fwd.y)
		end

		-- Polymorphism
		ai.update = function(self, dt)
			update_lifeTime(self, dt)
			update_movement(self, dt)
			update_intelligence(self, dt)
		end

		return ai
	end,
}


--[[ The main interface. Is in charge of creating and managing all objects. Needs to be updated and drawn. ]]
local ObjectFactory = 
{
	--[[ Stores all the objects created with this Factory. 
	This can be used for memory clean ups.]]
	allObjects = {},

	--[[ Creates a new Artificial Intelligence actor that has a target. ]]
	newAI = function(self, img, posX, posY, target)
		local inst = IntelligentObject:new(img,target)
		inst.x = posX
		inst.y = posY

		table.insert(self.allObjects, inst)
		return inst
	end,

	--[[ Creates a new static render object. These objects are aligned to the top-left (0,0) ]]
	newStatic = function(self, img, posX, posY)
		local inst = RenderObject:new(img)
		inst.x = posX
		inst.y = posY
		table.insert(self.allObjects, inst)
		return inst
	end,

	--[[ Creates a RenderObject that has the heading and speed properties. (it moves)]]
	new = function(self, img, posX, posY)
		local instance = MovingObject:new(img)
		instance.x = posX
		instance.y = posY

		table.insert(self.allObjects, instance)
		return instance
	end,

	--[[ Updates all RenderObjects ]]
	update = function(self, dt)
		for k,v in pairs(self.allObjects) do
			v:update(dt)
		end
	end,

	--[[ Draws all RenderObjects ]]
	draw = function(self)
		for k,v in pairs(self.allObjects) do
			v:draw()
		end
	end,

}

return ObjectFactory