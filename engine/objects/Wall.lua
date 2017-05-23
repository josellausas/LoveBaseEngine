--[[Wall]]
local class = require 'middleclass'
local PhysicalObject = require "engine.objects.abstract.PhysicalObject"

local Wall = class('Wall', PhysicalObject)

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
