--[[
	RenderObject.lua
	================

	A basic render object for Love
]]
local class 	   = require("middleclass")
local UpdateFuncs  = require("LLBase.LLUpdateFuncs")
local RenderFuncs  = require("LLBase.LLRenderFuncs")

-- Toggles Debug Mode
local renderDebug = true

-- Define the render object
local RenderObject = class('RenderObject')

function RenderObject:initialize(renderImage)
	-- Catch bad parameters
	if(renderImage == nil) then 
		print ("Cannot build with an empty image") 
		return nil 
	end

		
	self.x = 100				-- X position 
	self.y = 100				-- Y position
	self.lifeTime = 0					-- # of seconds it's been alive
	self.image 	= renderImage			-- The image rendered
	-- This sets the dynamic functions
	self.draw 	= RenderFuncs.basic	-- The drawFunc
	self.update = UpdateFuncs.lifetime	-- The updateFunc
	-- Debug flag	
	self.debug = renderDebug
end

return RenderObject
