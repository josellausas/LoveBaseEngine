local class = require 'middleclass'
local AI = require 'LLBase.AI.Agent'

local Enemy = class('Enemy', AI)

local _DefaultConfig = {
	hp = 20,
	dmg = 5,
	radius = 10,
}

function Enemy:initialize(img)
	AI.initialize(self, img)

	self.hp  =_DefaultConfig.hp
	self.damage = _DefaultConfig.dmg
end

function Enemy:respawn(x,y)
	self.hp  =_DefaultConfig.hp
end


return Enemy
