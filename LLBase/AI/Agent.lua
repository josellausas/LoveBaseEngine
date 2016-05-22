--[[ 
		Agent.lua
		=========

		About
		-----
		Abstracts an inteligent agent for AI 
]]
local class 		= require "middleclass"
local MovingObject  = require("LLBase.Renderer.MovingObject")	-- Base moving object
local AIBehaviors   = require("LLBase.AI.Behaviors")				-- State Machines

local IntelligentObject = class('IntelligentObject', MovingObject) --The Object inherits from a Moving Object 

local renderDebug   = false
local debugTextSize = 5

--[[ 
	Cretaes a new instance of an intelligent object.
]]
function IntelligentObject:initialize(renderImage, target)
	MovingObject.initialize(self, renderImage) -- Parent's constructor

	-- Give the object some properties
	self.target = target
	self.currentBehavior = AIBehaviors.noBehavior
end

function IntelligentObject:changeState(state)
	-- Perform a change of state
	local oldBehavior = self.currentBehavior.onExit(self) -- Exit last behavior
	state.onEnter(self)									  -- Enter new behavior
	self.currentBehavior = state 
end

function IntelligentObject:chill()
	self.target = nil
	self:changeState(AIBehaviors.noBehavior)
end

--[[ Change to seek behavior. Follow the target ]]
function IntelligentObject:seek(target)
	self.target = target
	self:changeState(AIBehaviors.seekBehavior)
end
	
function IntelligentObject:lookAt(coord)
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

function IntelligentObject:update(dt)
	MovingObject.update(self, dt)
	self.currentBehavior.onUpdate(self,dt)
end

--[[ Returns the distance squared to given target ]]
function IntelligentObject:distSqToTarget()
	if not (self.target == nil) then
		-- Get a vector from us to the target (distVector)
		local distX = self.target.x - self.x
		local distY = self.target.y- self.y

		return (distX^2 + distY^2)
	else
		-- Use a large number
		return 9999999999
	end
end

function IntelligentObject:draw()
	MovingObject.draw(self)

	if(renderDebug == true) then
		local textToPrint = ""
		if( self.target == nil) then
			textToPrint = "Chill"
		else
		    textToPrint = "" .. self:distSqToTarget()
		end
		love.graphics.print(textToPrint,self.x,self.y,0,debugTextSize,debugTextSize,0,0,0,0)
	end

end

-- Return the Intelligent Object Factory
return IntelligentObject
