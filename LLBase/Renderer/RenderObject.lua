local UpdateFuncs  = require("LLBase.LLUpdateFuncs")
local RenderFuncs  = require("LLBase.LLRenderFuncs")
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

return RenderObject
