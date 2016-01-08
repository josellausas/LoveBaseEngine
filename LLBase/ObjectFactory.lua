--[[ ObjectFactory.lua ]]
local AIBehaviors 		= require("LLBase.AI.Behaviors")
local UpdateFuncs 		= require("LLBase.LLUpdateFuncs")
local RenderFuncs 		= require("LLBase.LLRenderFuncs")
local MovingObject 		= require("LLBase.Renderer.MovingObject")
local IntelligentObject = require("LLBase.AI.Agent")

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
