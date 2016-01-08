--[[ Una camara para Love2D por Llau ]]

c = {
	x = 0,
	y = 0,
	scaleX = 2,
	scaleY = 2,
	rotation = 0
}

function c:set()
	love.graphics.push()
	love.graphics.rotate(-self.rotation)
	love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
	love.graphics.translate(-self.x, -self.y)
end


function c:unset()
	love.graphics.pop()
end

function c:move(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

function c:rotate(dr)
	self.rotation = self.rotation + dr
end

function c:scale(sx, sy)
	sx = sx or 1
	self.scaleX = self.scaleX + sx
	self.scaleY = self.scaleY + sy
end

function c:setPosition(x,y)
	self.x = x or self.x
	self.y = y or self.y
end

function c:setScale(sx, sy)
	self.scaleX = sx or self.scaleX
	self.scaleY = sy or self.scaleY
end


function c:mousePosition(x,y)
	return x * self.scaleX + self.x , y * self.scaleY + self.y
end

return c


