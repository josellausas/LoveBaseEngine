--[[ ObjectFactory.lua ]]

local AIBehaviors = require("LLBase.AIBehaviors")
local UpdateFuncs = require("LLBase.LLUpdateFuncs")
local RenderFuncs = require("LLBase.LLRenderFuncs")


--[[  RenderObject
	The most basic render object.
	Note: This is not offset to the center.
	This is used for things that do not move.
	And are usually aligned to a grid. 
	If you need to center postion or move, use MovingObject
]]
local RenderObject = 
{
	-- Constructor
	new = function(self, renderImage)
		local renderObjInstance = 
		{	
			x = 100,				-- X position 
			y = 100,				-- Y position
			lifeTime = 0,			-- # of seconds it's been alive
			image 	= renderImage,	-- The image rendered
			draw 	= RenderFuncs.basic,	-- The drawFunc
			update 	= UpdateFuncs.lifetime,	-- The updateFunc
		}
		return renderObjInstance
	end,	
}


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





--[[ A Moving object that seems to be intelligent ]]
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


--[[ The main interface. Is in charge of creating and managing all objects. Needs to be updated and drawn. ]]
local ObjectFactory = 
{
	--[[ Stores all the objects created with this Factory. 
	This can be used for memory clean ups.]]
	allObjects = {},

	--[[ Creates a new Artificial Intelligence actor that has a target. ]]
	newAI = function(self, img, posX, posY, target)
		local inst = IntelligentObject:new(img,target)
		inst.x = posX
		inst.y = posY

		table.insert(self.allObjects, inst)
		return inst
	end,

	--[[ Creates a new static render object. These objects are aligned to the top-left (0,0) ]]
	newStatic = function(self, img, posX, posY)
		local inst = RenderObject:new(img)
		inst.x = posX
		inst.y = posY
		table.insert(self.allObjects, inst)
		return inst
	end,

	--[[ Creates a RenderObject that has the heading and speed properties. (it moves)]]
	new = function(self, img, posX, posY)
		local instance = MovingObject:new(img)
		instance.x = posX
		instance.y = posY

		table.insert(self.allObjects, instance)
		return instance
	end,

	--[[ Updates all RenderObjects ]]
	update = function(self, dt)
		for k,v in pairs(self.allObjects) do
			v:update(dt)
		end
	end,

	--[[ Draws all RenderObjects ]]
	draw = function(self)
		for k,v in pairs(self.allObjects) do
			v:draw()
		end
	end,

}

return ObjectFactory