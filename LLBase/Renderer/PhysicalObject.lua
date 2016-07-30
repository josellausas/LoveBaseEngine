---------------------------------------------------------------
-- Physical Object base class
--
-- @author jose@josellausas.com
-- @module PhysicalObject
---------------------------------------------------------------
local class 		= require 'middleclass'
local MovingObject 	= require 'LLBase.Renderer.RenderObject'
local PhysicalObject = class('PhysicalObject', MovingObject)

---------------------------------------------------------------
-- Initializes a pysical object
--
-- @param image **(Image)** The image avatar
-- @param shape **(Table)** The collision shape
---------------------------------------------------------------
function PhysicalObject:initialize(image, shape)
	MovingObject.initialize(self, image)

	self.phyObj = {}
	self.phyObj.shape = shape
end

return PhysicalObject
