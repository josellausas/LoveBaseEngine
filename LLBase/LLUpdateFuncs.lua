
--[[ Updates the lifetime of an object ]]
local update_lifeTime = function(self, dt)
	self.lifeTime = self.lifeTime + dt
end



--[[Moves the object in the direction it is facing]]
local update_movement = function(self, dt)
	-- Move towards the forwards vector at the given speed.
	local fwdVector = {
		x = math.cos(self.heading),
		y = math.sin(self.heading)
	}
	-- Update the position with deltas. Remember the physics from shcool?
	self.x = self.x + (fwdVector.x * self.speed * dt)
	self.y = self.y + (fwdVector.y * self.speed * dt)
end



--[[Looks at the target if he have one.]]
local update_intelligence = function(self, dt)
	self.currentBehavior.onUpdate(self,dt)
end

local p = {}
p.lifeTime = update_lifeTime
p.movement = update_movement
p.intelligence = update_intelligence 
return p