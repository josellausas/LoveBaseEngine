----------------------------------------------------
-- State machine behaviors
--
-- @author jose@josellausas.com
-- @module Behaviors
----------------------------------------------------

--- No behavior
-- @table noBehavior
local noBehavior = {}

function noBehavior:onEnter()
	print("starting to chill")
	self.speed = 0
end

function noBehavior:onUpdate(dt)
	self.heading = self.heading + dt
end

function noBehavior:onExit()
	print("No longer chilling")
end

--- Seeks a target
-- @table seekBehavior
local seekBehavior = {
	onEnter = function(agent)
		print("Agent is now seeking target at: ")
	end,
	onUpdate = function(agent, dt)
		if not (agent.target == nil) then
			agent:lookAt(agent.target)

			if(agent:distSqToTarget() < 100) then
				agent:chill()
			end
		end
	end,
	onExit = function(agent)
		print("Agent is no longer seeking target")
	end
}


--- Wander around
-- @table wanderBehavior
local wanderBehavior = {
	onEnter = function(agent)
	end,
	onUpdate = function(agent, dt)
		if not (agent.target == nil) then
			agent:lookAt(agent.target)

			if(agent:distSqToTarget() < 100) then
				agent:chill()
			end
		end
	end,
	onExit = function(agent)
		print("Agent is no longer seeking target")
	end
}


--- Behaviors
-- @table Behaviors
local Behaviors = {
	noBehavior = noBehavior, -- No behavior at all
	seekBehavior = seekBehavior -- Seek behavior
}

return Behaviors