--[[Behavior state machines]]

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