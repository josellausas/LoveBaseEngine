--[[ Game.lua by jose@josellausas.com ]]


local ObjectFactory = require("ObjectFactory")

-- The game object
local game = {
	currentLevelSettings = nil,
	levelNames = {},
	player = nil,
	loadedImages = {
		playerTile = nil,
		ship = nil,
	},
	enemies = {},
}


-- Window width
local function getWidth()
	return love.graphics.getWidth()
end

-- Window height
local function getHeight()
	return love.graphics.getHeight()
end




function game:loadImage(name, path)

	if not (self.loadedImages[name] == nil) then
		print("RELOADING AN IMAGE!!!")
	end
	
	self.loadedImages[name] = love.graphics.newImage(path)
end

function game:loadLevel(levelName)

	math.randomseed(os.time())
	print("Loading images")
		-- Load the images here
		-- TODO: get these from the settings
		self:loadImage("player", "art/tileBlue_04.png")
		self:loadImage("ship", "art/playerShip3_blue.png")
	print("Done loading images")



	print("Starting level " .. levelName)
		-- Load level settings from file
		local levelSettings = require("levels."..levelName)
		self.currentLevelSettings = levelSettings
	print("Level settings loaded!")



	print("Creating Player")
		self.player = ObjectFactory:new(self.loadedImages["player"], 200, 200)
	print("Done creating Player")


	
	print("Creating AI")
		local radius 		= levelSettings.targetRadius
		local speedRange 	= levelSettings.targetRadius

		for i=1,levelSettings.numAI do
			local posX = math.random(0, levelSettings.mapWidth)
			local posY = math.random(0, levelSettings.mapHeight)

			self:createAI(radius, speedRange, posX, posY)
		end
	print("Done creating AI")
end

function game:createAI(radius, speedRange, posX, posY)
	-- Use the object factory
	local enemyAI = ObjectFactory:newAI(self.loadedImages["ship"], posX, posY, nil)
	enemyAI.speed = math.random(speedRange)
	table.insert(self.enemies, enemyAI)
end


local function loadUserSettings()
	-- TODO: Implement this
	return {currentLevel = "level01"}
end




function game:init(settings)
	-- Fail if we have nil settings 
	if settings == nil then print("Failed to load settings") return nil end;

	-- Start to launch the game
	print("Launching " .. settings.gameTitle .. "...")

	-- Load the levelNames
	local levelNames = settings.levels

	print("Attempting to load "..#levelNames.." levels")


	
	local successCount = 0
	for i,filename in ipairs(levelNames) do
		-- Load level file
		local path = "levels."..filename
		local levelSettings = require(path)

		if not (levelSettings == nil) then
			print("Level "..levelSettings.name.. " was loaded!")
			successCount = successCount + 1
		end
	end

	print("Finished loading "..successCount.." levels")

	print("Loading user settings ...")
	-- Load the user settings
	local userSettings = loadUserSettings()

	print("Finished loading user settings ...")

	-- Get the users current level
	self:loadLevel(userSettings.currentLevel)
end

function game:update(dt)
	ObjectFactory:update(dt)
end 


function game:draw()
	ObjectFactory:draw()
end


return game

