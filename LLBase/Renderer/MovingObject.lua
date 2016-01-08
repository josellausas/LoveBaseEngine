local UpdateFuncs  = require("LLBase.LLUpdateFuncs")
local RenderFuncs  = require("LLBase.LLRenderFuncs")
local RenderObject = require("LLBase.Renderer.RenderObject")

--[[ An image that can move]]
local MovingObject = 
{
	new = function(self, renderImage)
		-- Inherits from a render object
		local inst = RenderObject:new(renderImage)

		-- Movement speed
		inst.speed = 0

		-- Drawing scale
		inst.scale = { x = 1, y = 1 }

		-- Offsets for drawing at the center
		local width,height = renderImage:getDimensions()
		inst.spec = {
			w = width,
			h = height,
			offX = width * 0.5,
			offY = height * 0.5
		}

		-- Our forwards.
		inst.heading = 0 -- In Radians
		

		inst.setHeading = function(self, x, y)
			-- Converts a foward vector to radians. The vector mush be normalized!!!
			self.heading = math.atan2(y, x)
		end

		-- Polymorphysm :)
		inst.update = function(self, dt)
			UpdateFuncs.lifeTime(self, dt)
			UpdateFuncs.movement(self, dt)
		end

		-- Completely overrides parent's implementation
		inst.draw = function(self)
			RenderFuncs.advanced(self)
		end

		return inst
	end
}

return MovingObject
