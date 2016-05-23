local class 		= require("middleclass")
local RenderObject 	= require("LLBase.Renderer.RenderObject")

local rotate90 = math.rad(90)

--[[ An image that can move. Inheritrs from RenderObject ]]
local MovingObject = class('MovingObject', RenderObject)

function MovingObject:initialize(renderImage)
		-- Call parents constructor
		RenderObject.initialize(self, renderImage)

		-- Movement speed
		self.speed = 0

		-- Drawing scale
		self.scale = { x = 1, y = 1 }

		-- Offsets for drawing at the center
		local width,height = renderImage:getDimensions()
		self.spec = {
			w = width,
			h = height,
			offX = width * 0.5,
			offY = height * 0.5
		}

		-- Our forwards.
		self.heading = 0 -- In Radians
end

function MovingObject:setImage(image)
	-- Offsets for drawing at the center
	local width,height = image:getDimensions()
	self.spec = {
		w = width,
		h = height,
		offX = width * 0.5,
		offY = height * 0.5
	}
	self.image = image
end

function MovingObject:drawDebug()
	if(self.debug == true) then
		love.graphics.circle("line", self.x, self.y, 15)
	end
end

function MovingObject:setHeading(x,y)
	-- Converts a foward vector to radians. The vector mush be normalized!!!
	self.heading = math.atan2(y, x)
end

function MovingObject:update(dt)
	RenderObject.update(self, dt)
	
	-- Move towards the forwards vector at the given speed.
	local fwdVector = {
		x = math.cos(self.heading),
		y = math.sin(self.heading)
	}
	-- Update the position with deltas. Remember the physics from shcool?
	self.x = self.x + (fwdVector.x * self.speed * dt)
	self.y = self.y + (fwdVector.y * self.speed * dt)
end

function MovingObject:draw()
	if(self.renderFlag == true) then
		-- Completely overrides parent's implementation
		love.graphics.draw(self.image, self.x, self.y, self.heading + rotate90, self.scale.x, self.scale.y, self.spec.offX, self.spec.offY)
	end
	self:drawDebug()
end


--[[
	Rerturns the (distance^2) to a coordinate (x,y)

	@param x The x coordinate
	@param y The y coordinate

	@returns The distance squared
]]
function MovingObject:distSqToPosition(x,y)
	-- Get a vector from us to the target (distVector)
	local distX = x - self.x
	local distY = y - self.y
	local squaredDistance = (distX * distX) + (distY * distY) -- Good 'ol Pythagoras
	return squaredDistance
end

--[[ 
	Checks if we are inside the given circle ({x,y,r})

	@returns true if collision
]]
function MovingObject:isInsideCircle(x,y,radius)
	-- ;) If a distance vector betweer our position and the circle is smaller than the radius, we are inside
	local distSq = self:distSqToPosition(x, y)
	local radiusSq = radius * radius

	if(distSq < radiusSq) then
		-- We are inside the circle
		return true
	else
		-- We are not inside the circle
	    return false
	end
end



return MovingObject
