--[[
	A defensive Turret
]]

local UpdateFuncs  = require("LLBase.LLUpdateFuncs")			-- A function table
local RenderFuncs  = require("LLBase.LLRenderFuncs")			-- A function table
local MovingObject = require("LLBase.Renderer.MovingObject")	-- Base moving object
local AIBehaviors  = require("LLBase.AI.Behaviors")				-- State Machines
local AI 		   = require "LLBase.AI.Agent"

local Turret = {}


function Turret:new(image)
	-- Inherit from an AI agent
	local instance = AI:new(image, nil)
		-- Return nil if we have failed
		if(instance == nil) then
			return nil
		end

		instance.bullets = {} -- Stores the bullets

		function instance:attack(target)
			self:seek(target)
			
			-- TODO: shoot behavior here
		end
	return instance
end




return Turret





