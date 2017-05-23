---------------------------------------------------------------
-- A basic render object for Love
--
-- @author jose@zunware.com
-- @module RenderObject
---------------------------------------------------------------
local class = require("middleclass")

-- Toggles Debug Mode
local renderDebug = false

-- Define the render object
local RenderObject = class('RenderObject')

---------------------------------------------------------------
-- Draws the object in debug mode
---------------------------------------------------------------
function RenderObject:drawDebug()
	if(self.debug == true) then
		love.graphics.circle("line", self.x, self.y, 15)
	end
end

---------------------------------------------------------------
-- Initializes a RenderObject
--
-- @param renderImage **(Image)** The image avatar
---------------------------------------------------------------
function RenderObject:initialize(renderImage)
	-- Catch bad parameters
	if(renderImage == nil) then
		print ("Cannot build with an empty image")
		return nil
	end

	-- The member variables
	self.x 			= 100				-- X position
	self.y 			= 100				-- Y position
	self.lifeTime 	= 0					-- # of seconds it's been alive
	self.image 	= renderImage			-- The image rendered

	-- Debug flag
	self.debug = renderDebug
	self.renderFlag = true
end

---------------------------------------------------------------
-- The render function
---------------------------------------------------------------
function RenderObject:draw()
	if(self.renderFlag) then
		love.graphics.draw(self.image, self.x, self.y)
	end
	-- Draw a debug image
	self:drawDebug()
end

---------------------------------------------------------------
-- Heartbeat function
--
-- @number dt Delta Time slice
---------------------------------------------------------------
function RenderObject:update(dt)
	self.lifeTime = self.lifeTime + dt
end


return RenderObject
