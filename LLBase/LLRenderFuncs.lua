-- Offsets the rotation so it looks good.
local rotate90 = math.rad(90)

--[[
	Draws a debug image for the position
]]
local function drawDebug(self)
	if(self.debug == true) then
		love.graphics.circle("line", self.x, self.y, 15)
	end
end

--[[Draws static things, no scale, no offsets, etc.]]
local draw_basic = function(self)
	love.graphics.draw(self.image, self.x, self.y)
	-- Draw a debug image
	drawDebug(self)
end


--[[ Draws the thing in the center, scaled and rotated in the correct direction ]]
local draw_advanced = function(self)
	love.graphics.draw(self.image, self.x, self.y, self.heading + rotate90, self.scale.x, self.scale.y, self.spec.offX, self.spec.offY)
	drawDebug(self)
end


--[[ Build the package ]]
local p = {}
p.basic 	= draw_basic
p.advanced 	= draw_advanced
return p
