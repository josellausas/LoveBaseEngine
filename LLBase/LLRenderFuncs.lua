
-- Offsets the rotation so it looks good.
local rotate90 = math.rad(90)

--[[Draws static things, no scale, no offsets, etc.]]
local draw_basic = function(self)
	love.graphics.draw(self.image, self.x, self.y)
end



--[[ Draws the thing in the center, scaled and rotated in the correct direction ]]
local draw_advanced = function(self)
	love.graphics.draw(self.image, self.x, self.y, self.heading + rotate90, self.scale.x, self.scale.y, self.spec.offX, self.spec.offY)
end

local p = {}
p.basic = draw_basic
p.advanced = draw_advanced
return p
