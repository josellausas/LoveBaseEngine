---------------------------------------------------------------
-- The player module
--
-- @module Player
-- @author jose@josellausas.com
---------------------------------------------------------------
local class = require 'middleclass'
local MovingObject = require 'LLBase.Renderer.MovingObject'
local Player = class('Player', MovingObject)

--[[ The parameters for tweaking the player ]]
local _DefaultConfig = 
{
	defaultHP = 100,
	defaultDamage = 10,
	defaultCollisionRadius = 80
}

---------------------------------------------------------------
-- Initializes the Player
--
-- @number playerNumber The player's number
-- @param playerImage **(Image)** The player's avatar
---------------------------------------------------------------
function Player:initialize(playerNumber, playerImage)
	-- Call the Parent's initializer for polymorphysm
	MovingObject.initialize(self, playerImage)

	-- Our member variables
	self.number = playerNumber 							-- The player's ID number
	self.hp 	= _DefaultConfig.defaultHP				-- Player's hitpoints
	self.damage = _DefaultConfig.defaultDamage 			-- How much damage per hit we can do
end

---------------------------------------------------------------
-- Tells if the player is alive
--
-- @return true if player is alive
---------------------------------------------------------------
function Player:isAlive()
	if(self.hp > 0) then
		return true
	else
	    return false
	end
end

---------------------------------------------------------------
-- Respawns the player at a given position 
--
-- @number x The x coordinate
-- @number y The y coordinate
---------------------------------------------------------------
function Player:respawn(x,y)
	self.x = x
	self.y = y
	self.hp = _DefaultConfig.defaultHP

	-- TODO: Do some animation
end


function Player:hitBy(dmg)
	self.hp = self.hp - dmg

	if( self:isAlive() == false) then
		self:die()
	end
end

function Player:die()
	-- TODO: Do some things when the player dies

end

function Player:update(dt)
	MovingObject.update(self, dt)
end

--[[
	Returns a circle object for collision testing
]]
function Player:getCollisionCircle()
	local circle = {
		x = self.x,
		y = self.y,
		r = _DefaultConfig.defaultCollisionRadius
	}

	return circle
end

return Player
