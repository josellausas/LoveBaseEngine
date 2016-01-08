local UpdateFuncs  = require("LLBase.LLUpdateFuncs")
local RenderFuncs  = require("LLBase.LLRenderFuncs")
local MovingObject = require("LLBase.Renderer.MovingObject")
local AIBehaviors  = require("LLBase.AI.Behaviors")

local IntelligentObject = 
{
	-- Our constructor method.
	new = function(self, renderImage, target)
		-- Inherits from a moving object
		local ai = MovingObject:new(renderImage)
		
		-- Tracks a moving target
		ai.target = target
		ai.currentBehavior = AIBehaviors.noBehavior

		ai.changeState = function(self, state)
			local oldBehavior = self.currentBehavior.onExit(self)
			state.onEnter(self)

			-- Set this as the current behavir
			self.currentBehavior = state
		end

		ai.chill = function(self)
			self.target = nil
			self:changeState(AIBehaviors.noBehavior)
		end
		

		ai.seek = function(self, target)
			self.target = target
			self:changeState(AIBehaviors.seekBehavior)
		end

		-- Sets the heading towards the given coordinate
		ai.lookAt = function(self, coord)
			-- Get the targets position.
			local targetX = coord.x
			local targetY = coord.y
			
			-- Get a vector from us to the target (distVector)
			local distX = targetX - self.x
			local distY = targetY - self.y
			
			-- Figure out our forward vector (has to be normalized)
			local fwd = {
				x = distX,
				y = distY
			}
			
			-- Normalize to set the heading vector.
			local length = math.sqrt((distX ^ 2) + (distY ^ 2))
			
			if(length > 0) then
				fwd.x = distX / length
				fwd.y = distY / length
			end
			
			-- Sets the heading to our forward vector.
			self:setHeading(fwd.x, fwd.y)
		end

		-- Polymorphism
		ai.update = function(self, dt)
			UpdateFuncs.lifeTime(self, dt)
			UpdateFuncs.movement(self, dt)
			UpdateFuncs.intelligence(self, dt)
		end

		ai.distSqToTarget = function(self)
			if not (self.target == nil) then
				-- Get a vector from us to the target (distVector)
				local distX = self.target.x - self.x
				local distY = self.target.y- self.y

				return (distX^2 + distY^2)
			else
				return 99999
			end
		end

		return ai
	end,
}

return IntelligentObject
