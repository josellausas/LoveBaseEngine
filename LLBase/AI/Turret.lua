--[[
	A defensive Turret
]]
local class 	   = require 'middleclass'
local MovingObject = require("LLBase.Renderer.MovingObject")	-- Base moving object
local AIBehaviors  = require("LLBase.AI.Behaviors")				-- State Machines
local AI 		   = require "LLBase.AI.Agent"

local Turret = class('Turret', AI)

function Turret:initialize(image)
	AI.initialize(self, image, nil)
	self.bullets = {} -- Stores the bullets
end

function Turret:attack(target)
	AI.seek(self, target)			
	-- TODO: shoot behavior here
end

return Turret
