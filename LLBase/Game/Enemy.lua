--------------------------------------------------
-- Enemy module
--
-- @author jose@josellausas.com
---------------------------------------------------
local class = require 'middleclass'
local AI 	= require 'LLBase.AI.Agent'

local Enemy = class('Enemy', AI)

local _DefaultConfig = {
	hp  	= 20,
	dmg 	= 5,
	radius 	= 10,
}

---------------------------------------------------
-- Initializes a new Enemy
--
-- @param img **(Image)** The image for this enemy
---------------------------------------------------
function Enemy:initialize(img)
	AI.initialize(self, img)

	self.hp  =_DefaultConfig.hp
	self.damage = _DefaultConfig.dmg
end


---------------------------------------------------
-- Respawns the enemy at the given position
--
-- @number x The x coordinate
-- @number y The y coordinate
---------------------------------------------------
function Enemy:respawn(x,y)
	self.hp  =_DefaultConfig.hp
end


return Enemy
