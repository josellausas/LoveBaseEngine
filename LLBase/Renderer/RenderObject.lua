--[[
	RenderObject.lua
	================

	A basic render object for Love
]]

local UpdateFuncs  = require("LLBase.LLUpdateFuncs")
local RenderFuncs  = require("LLBase.LLRenderFuncs")

-- Define the render object
local RenderObject = 
{
	-- Constructor
	new = function(self, renderImage)
		-- Catch bad parameters
		if(renderImage == nil) then print ("Cannot build with an empty image") return nil end

		local renderObjInstance = 
		{	
			x = 100,				-- X position 
			y = 100,				-- Y position
			lifeTime = 0,					-- # of seconds it's been alive
			image 	= renderImage,			-- The image rendered
			draw 	= RenderFuncs.basic,	-- The drawFunc
			update 	= UpdateFuncs.lifetime,	-- The updateFunc
		}
		return renderObjInstance
	end,	
}

return RenderObject
