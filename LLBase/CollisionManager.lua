-----------------------------------------------------------
-- Collision Manager
--
-- @author jose@josellausas.com
-----------------------------------------------------------
local colMan = {
	registeredObjects = {},
	-- Use X index to find them
	mapQuadrants = {},
	dimensions = {x=0,y=0},
	world = nil,
}

-----------------------------------------------------------
-- Initializes the collision manager
--
-- @param mapWidth **(Number)** The map width
-- @param mapHeight **(Number)** The map height
-- @param numXDivisions **(Number)** The number of horizontal divisions
-- @param numYDivisions **(Number)** The number of vertical divisions
-----------------------------------------------------------
function colMan:init(mapWidth, mapHeight, numXDivisions, numYDivisions)
	-- Clean up
	self.registeredObjects 	= {}
	self.mapQuadrants 		= {}

	-- Set the physics scale
	love.physics.setMeter(64)
	-- Setup a love world
	self.world = love.physics.newWorld(0,0, true)


	self.numXDivs   = numXDivisions
	self.numYDivs   = numYDivisions
	self.divXLenght = mapWidth / numXDivisions
	self.divYLength = mapHeight / numYDivisions

	self.dimensions.x = mapWidth
	self.dimensions.y = mapHeight

	print("Creating a "..numXDivisions.. " x " .. numYDivisions .. " collision map")
	-- Creates rows

	-- Loop the divisions and process them
	for row=1,numXDivisions do
		local rowContainer = {}

		-- Creates Columns
		for col=1,numYDivisions do

			print("Creating container: " ..row .. " - " .. col)
			
			local container = { xquad = row, yquad = col, objects = {} }
			table.insert(rowContainer, container)
		
		end

		table.insert(self.mapQuadrants, rowContainer)
	end

end


-----------------------------------------------------------
-- Returns a list of objects inside a given quadrant
--
-- @number x The x factor
-- @number y The y factor
-- @return **(Table)** A table of objects inside the quadrant
-----------------------------------------------------------
function colMan:getQuadrantObjects(x,y)
	local container = self.mapQuadrants[x][y]

	if not (container.xquad == x) then
		print("Wrong x")
	end

	if not (container.yquad == y) then
		print("Wrong y")
	end

	return container.objects
end

-----------------------------------------------------------
-- Gets the sector keys for the given coordinates
-- 
-- @number coordX The x coordinates
-- @number coordY The y coordinates
-- @return **(Array)** __[x,y]__ The x and y coordinate
-----------------------------------------------------------
function colMan:getKeysForCoords(coordX, coordY)
	local xNum = math.floor(coordX / self.divXLenght)
	local yNum = math.floor(coordY / self.divYLength)

	return xNum, yNum
end

-----------------------------------------------------------
-- Returns the cotainer quadrant for the given coordinates
--
-- @number cx The x coordiante
-- @number cy The y coordinate
-- @return **(Table)** The quadrant
-----------------------------------------------------------
function colMan:getContainerForCoords(cx,cy)
	local x,y = self:getKeysForCoords(cx,cy)
	return self.mapQuadrants[x+1][y+1]
end

-----------------------------------------------------------
-----------------------------------------------------------
function colMan:registerObject(objToReg)

	local body = love.physics.newBody(self.world, objToReg.x, objToReg.y, "dynamic")

	objToReg.collisionBody = body


	local containerToUse = self:getContainerForCoords(objToReg.x, objToReg.y)
	print("Inserting object into container ["..containerToUse.xquad..","..containerToUse.yquad.."]")
	table.insert(containerToUse.objects, objToReg)
end

-----------------------------------------------------------
-----------------------------------------------------------
function colMan:update(dt, player)
	-- Update the physics world:
	self.world:update(dt)
	

	local playerQuadrant = self:getContainerForCoords(player.x, player.y)

	-- Check collision with objects inside the cuadrant:
	for i, obj in ipairs(playerQuadrant.objects) do
		-- print(obj.x, obj.y)
	end
end








return colMan
