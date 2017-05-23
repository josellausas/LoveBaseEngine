---------------------------------
-- A defensive Turret
--
-- @module Turret
---------------------------------
local class 	   = require 'middleclass'
local MovingObject = require("engine.objects.abstract.MovingObject")	-- Base moving object
local AIBehaviors  = require("engine.ai.BehaviorFunctions")				-- State Machines
local AI 		   = require("engine.objects.Agent")

local Turret = class('Turret', AI)

---------------------------------
-- Initialize the thing
--
-- @param image The image
---------------------------------
function Turret:initialize(image)
	AI.initialize(self, image, nil)
	self.bullets = {} -- Stores the bullets
end

---------------------------------
-- Attack the target
--
-- @param target The thing to attack
---------------------------------
function Turret:attack(target)
	AI.seek(self, target)
	-- TODO: shoot behavior here
end

return Turret
