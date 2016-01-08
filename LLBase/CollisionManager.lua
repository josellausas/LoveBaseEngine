local colMan = {
	registeredObjects = {},
	-- Use X index to find them
	mapQuadrants = {},
	dimensions = {x=0,y=0},
}

function colMan:init(mapWidth, mapHeight, numXDivisions, numYDivisions)
	-- Clean up
	self.registeredObjects 	= {}
	self.mapQuadrants 		= {}

	self.numXDivs = numXDivisions
	self.numYDivs = numYDivisions
	self.divXLenght = mapWidth / numXDivisions
	self.divYLength = mapHeight / numYDivisions

	self.dimensions.x = mapWidth
	self.dimensions.y = mapHeight

	print("Creating a "..numXDivisions.. " x " .. numYDivisions .. " collision map")
	-- Creates rows


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

function colMan:getKeysForCoords(coordX, coordY)
	local xNum = math.floor(coordX / self.divXLenght)
	local yNum = math.floor(coordY / self.divYLength)

	return xNum, yNum
end


function colMan:getContainerForCoords(cx,cy)
	local x,y = self:getKeysForCoords(cx,cy)
	return self.mapQuadrants[x+1][y+1]
end

function colMan:registerObject(objToReg)
	local containerToUse = self:getContainerForCoords(objToReg.x, objToReg.y)
	print("Inserting object into container ["..containerToUse.xquad..","..containerToUse.yquad.."]")
	table.insert(containerToUse.objects, objToReg)
end

function colMan:update(dt, player)
	local playerQuadrant = self:getContainerForCoords(player.x, player.y)

	-- Check collision with objects inside the cuadrant:
	for i, obj in ipairs(playerQuadrant.objects) do
		-- print(obj.x, obj.y)
	end
end








return colMan
