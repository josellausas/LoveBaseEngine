local colMan = {
	registeredObjects = {},
	-- Use X index to find them
	mapQuadrants = {},
	dimensions = {x=0,y=0},
}

function colMan:init(mapWidth, mapHeight, numXDivision, numYDivisions)
	self.dimensions.x = mapWidth
	self.dimensions.y = mapHeight

	print("Creating a "..numXDivision.. " x " .. numYDivisions .. " collision map")
	-- Creates rows


	for row=1,numXDivision do
		local rowContainer = {}

		-- Creates Columns
		for col=1,numYDivisions do
			
			local container = { xquad = row, yquad = col, objects = {} }
			table.insert(rowContainer, container)
		
		end

		table.insert(mapQuadrants, rowContainer)
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

local function getKeysForCoords(coordX, coordY)
	return math.fmod(self.dimensions.x , coordX), math.fmod(self.dimensions.y, coordY)
end


local function getContainerForCoords(cx,cy)
	local x,y = getKeysForCoords(cx,cy)

	return self.mapQuadrants[x][y]
end

function colMan:registerObject(objToReg)
	local containerToUse = getContainerForCoords(objToReg)
	table.insert(containerToUse.objects, objToReg)
end








return colMan
