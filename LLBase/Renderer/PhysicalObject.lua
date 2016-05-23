local class 		= require 'middleclass'
local MovingObject 	= require 'LLBase.Renderer.RenderObject'

local PhysicalObject = class('PhysicalObject', MovingObject)

function PhysicalObject:initialize(image, shape)
	MovingObject.initialize(self, image)

	self.phyObj = {}
	self.phyObj.shape = shape
end

return PhysicalObject
