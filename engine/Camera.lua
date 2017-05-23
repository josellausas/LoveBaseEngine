--[[ Una camara para Love2D por Llau ]]

--[[ The camera table]]
local c = {
	x = 0,
	y = 0,
	scaleX = 4,
	scaleY = 4,
	rotation = 0
}

--[[ Sets the camera into the stack ]]
function c:set()
	love.graphics.push()
	love.graphics.rotate(-self.rotation)
	love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
	love.graphics.translate(-self.x, -self.y)
end

-- [[ Removes the Camera from the stack ]]
function c:unset()
	love.graphics.pop()
end

-- [[ Moves the camera dx, dy amounts]]
function c:move(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

--[[ Rotates the camera ]]
function c:rotate(dr)
	self.rotation = self.rotation + dr
end

--[[ Changes the scale ]]
function c:scale(sx, sy)
	sx = sx or 1
	self.scaleX = self.scaleX + sx
	self.scaleY = self.scaleY + sy
end

-- [[ Sets the camera position ]]
function c:setPosition(x,y)
	self.x = x or self.x
	self.y = y or self.y
end

-- [[ Sets the camera scale ]]
function c:setScale(sx, sy)
	self.scaleX = sx or self.scaleX
	self.scaleY = sy or self.scaleY
end

--[[ Returns the mouse position relative to the camera ]]
function c:mousePosition(x,y)
	return x * self.scaleX + self.x , y * self.scaleY + self.y
end

return c


