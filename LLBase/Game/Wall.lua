--[[Wall]]
local class = require 'middleclass'

local Wall = class('Wall')

function Wall:initialize(width, height)
	self.x = 0
	self.y = 0
	self.width  = width
	self.height = height
end

function Wall:update(dt)

end

function Wall:draw()

end

return Wall
