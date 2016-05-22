--[[
	RenderObject.lua
	================

	A basic render object for Love
]]
local class 	   = require("middleclass")

-- Toggles Debug Mode
local renderDebug = true

-- Define the render object
local RenderObject = class('RenderObject')

function RenderObject:drawDebug()
	if(self.debug == true) then
		love.graphics.circle("line", self.x, self.y, 15)
	end
end

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
end

function RenderObject:draw()
	love.graphics.draw(self.image, self.x, self.y)
	-- Draw a debug image
	self:drawDebug()
end

function RenderObject:update(dt)
	self.lifeTime = self.lifeTime + dt
end

return RenderObject
