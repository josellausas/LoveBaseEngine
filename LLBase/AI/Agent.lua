--[[ 
		Agent.lua
		=========

		About
		-----
		Abstracts an inteligent agent for AI 
]]
local class = require "middleclass"
local MovingObject = require("LLBase.Renderer.MovingObject")	-- Base moving object
local AIBehaviors  = require("LLBase.AI.Behaviors")				-- State Machines

--[[ The Object ]]
local IntelligentObject = 
{
	cretedInstances = {},

	--[[ 
		new() 
		=====

		Cretaes a new instance of an intelligent object.
	]]
	new = function(self, renderImage, target)

		-- Inherit from a moving object
		local ai = MovingObject:new(renderImage)				-- Crete the instance
		
		-- Set the member variables
		ai.target = target 										-- The target
		ai.currentBehavior = AIBehaviors.noBehavior 			-- Default behavior

		--[[ changeState() ]]
		ai.changeState = function(self, state)
			-- Perform a change of state
			local oldBehavior = self.currentBehavior.onExit(self) -- Exit last behavior
			state.onEnter(self)									  -- Enter new behavior
			self.currentBehavior = state 						  -- Set this as the current behavir
		end

		--[[ Change to chill behavior ]]
		ai.chill = function(self)
			self.target = nil
			self:changeState(AIBehaviors.noBehavior)
		end
		
		--[[ Change to seek behavior. Follow the target ]]
		ai.seek = function(self, target)
			self.target = target
			self:changeState(AIBehaviors.seekBehavior)
		end


		--[[ lookAt() ]]
		--[[ Sets the heading towards the given coordinate ]]
		ai.lookAt = function(self, coord)
			-- Get the targets position.
			local targetX = coord.x
			local targetY = coord.y
			
			-- Get a vector from us to the target (distVector)
			local distX = targetX - self.x
			local distY = targetY - self.y
			
			-- Figure out our forward vector (has to be normalized)
			local fwd = {x = distX,y = distY}
			
			-- Normalize to set the heading vector.
			local length = math.sqrt((distX ^ 2) + (distY ^ 2))
			
			if(length > 0) then
				fwd.x = distX / length
				fwd.y = distY / length
			end
			
			-- Sets the heading to our forward vector.
			self:setHeading(fwd.x, fwd.y)
		end

		--[[ update() ]]
		-- Polymorphism
		ai.update = function(self, dt)
			MovingObject.update(self, dt)
			self.currentBehavior.onUpdate(self,dt)
		end

		--[[ Returns the distance squared to given target ]]
		ai.distSqToTarget = function(self)
			if not (self.target == nil) then
				-- Get a vector from us to the target (distVector)
				local distX = self.target.x - self.x
				local distY = self.target.y- self.y

				return (distX^2 + distY^2)
			else
				-- Use a large number
				return 99999
			end
		end

		-- Add instance tracking
		table.insert(self.cretedInstances, instances)
		print("AI count: " .. #self.cretedInstances)

		-- Return the created instance
		return ai
	end,
}

-- Return the Intelligent Object Factory
return IntelligentObject
