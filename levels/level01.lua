------------------------------------------------------
-- Level 01
-- The first level of the game
--
-- @author jose@zunware.com
------------------------------------------------------


--- First level
-- @table level01
local level01 = {
	name = "Base level 01", -- The name
	levelType = "LEVEL",	-- The level type
	numAI = 25,				-- Number of AI 
	numTurrets = 100,		-- Number of AI Turrets
	targetRadius = 200,		-- Targeting radius
	
	speedRage = {
		min=100, max=500
	},	-- Speed randomization
	mapWidth = 4096,			-- The map's width
	mapHeight = 4096,			-- The map's height
}

return level01
