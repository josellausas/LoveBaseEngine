--[[
 
 ObjectFactory.lua 
 =================

 Creates the game objects and gives them properties.
 The main interface. Is in charge of creating and managing all objects. Needs to be updated and drawn.
]]


local AIBehaviors 		= require("LLBase.AI.Behaviors")
local MovingObject 		= require("LLBase.Renderer.MovingObject")
local IntelligentObject = require("LLBase.AI.Agent")
local Turret 			=  require("LLBase.AI.Turret")
local Player = require("LLBase.Game.Player")

local playerCount = 0


local ObjectFactory = 
{
	--Stores all the objects created with this Factory. This can be used for memory clean ups.
	allObjects = {}, 	

	--Creates a new Artificial Intelligence actor that has a target.
	newAI = function(self, img, posX, posY, target)
		if img == nil then return nil end -- Return nil if no image
		local inst = IntelligentObject:new(img,target)
		inst.x = posX
		inst.y = posY

		table.insert(self.allObjects, inst)
		return inst
	end,

	--[[ Creates a new static render object. These objects are aligned to the top-left (0,0) ]]
	newStatic = function(self, img, posX, posY)
		if img == nil then return nil end -- Return nil if no image
		local inst = RenderObject:new(img)
		inst.x = posX
		inst.y = posY
		table.insert(self.allObjects, inst)
		return inst
	end,

	newTurret = function(self, img, posX, posY)
		if img == nil then return nil end -- Return nil if no image
		local inst = Turret:new(img)
		inst.x = posX
		inst.y = posY
		table.insert(self.allObjects, inst)
		return inst
	end,

	--[[ Creates a RenderObject that has the heading and speed properties. (it moves)]]
	new = function(self, img, posX, posY)
		-- Make sure we have all the propper parameteres
		if( (not img) or (not posX) or (not posY) ) then return nil end

		local instance = MovingObject:new(img)
		instance.x = posX
		instance.y = posY

		table.insert(self.allObjects, instance)
		return instance
	end,

	newPlayer = function(self, img, posX, posY)
		if( (not img) or (not posX) or (not posY) ) then return nil end
		playerCount = playerCount + 1

		local player = Player:new(playerCount, img)
		player.x = posX
		player.y = posY

		table.insert(self.allObjects, player)
		return player
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
