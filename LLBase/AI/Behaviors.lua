--[[Behavior state machines]]
local noBehavior = {
	onEnter = function(agent)
		print("starting to chill")
		agent.speed = 0
	end,
	onUpdate = function(agent, dt)
		agent.heading = agent.heading + dt
	end,
	onExit = function(agent)
		print("Exiting idle state")
	end
}


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


local pack = {
	noBehavior = noBehavior,
	seekBehavior = seekBehavior
}

return pack