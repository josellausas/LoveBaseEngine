-----------------------------------------------------------
-- The game module
-- This is the main file for the Game. It centrilizes the control for behavior
--
-- Notes
-- -----
-- When the game loads, it scans the `/levels` directory for `*.lua` files and loads each one as a level.
--
-- @author 	jose@josellausas
-- @see levels/level01.lua
-- @see LLBase/ObjectFactory.lua
-----------------------------------------------------------
local class 			= require('middleclass')
local Camera 			= require("LLBase.LLCamera")			--- > The user's view
local ObjectFactory 	= require("LLBase.ObjectFactory")		--- > Object Manager
local UIMan 			= require("LLBase.UIManager")			--- > User Interface Manager 		(en desarrollo)
local ColMan 			= require("LLBase.CollisionManager")	--- > The Collision Manager 		(en desarrollo)
local EffectsMan		= require("LLBase.EffectsMan")			--- > The SFX Manager 				(en desarrollo)
local Player 			= require 'LLBase.Game.Player'			--- > The Player Object


-- Setup the camera defaults
local cameraSpeed 	= 800										---> Controlls how fast the camera can move
local camScale 		= Camera.scaleX								---> Scales the camera
local textToPrint = ""

----------------------
-- The game table
-- @table game
local game = {
	showDebug 			 = true, -- Debug mode
	showUI 				 = true, -- Show the User interface
	player 				 = nil,	 -- The player
	team 				 = nil,	 -- The teams
	enemies 			 = nil,	 -- The enemies
	turrets 			 = nil,  -- The turrets
	currentLevelSettings = nil,  -- The current level settings
	loadedImages 		 = nil,  -- Loaded images table
}

-- Some flags. Used for building unique tags when Units are created
local _enemyCount 	= 0
local _turretCount 	= 0
local _imageCount 	= 0

-- Set some things
game.showDebug  = true
game.showUI 	= true
game.player 	= nil
game.team 		= {}
game.enemies 	= {}
game.turrets 	= {}
game.currentLevelSettings = nil
game.loadedImages = {
	playerTile = nil,
	ship = nil,
}

---------------------------------------------------
-- The Scree's Width
--
-- @return The Height number
---------------------------------------------------
local function getWidth()
	return love.graphics.getWidth()
end

---------------------------------------------------
-- The Screen's Height
--
-- @return The Height number
---------------------------------------------------
local function getHeight()
	return love.graphics.getHeight()
end


---------------------------------------------------
-- Loads an image to the loaded images dictionary
--
-- @param name The image string identifier
-- @param path The Images Path
---------------------------------------------------
function game:loadImage(name, path)
	if not (self.loadedImages[name] == nil) then
		print("WARNING: RELOADING AN IMAGE!!!")
	end
	-- Store the thing in our dictionary
	-- We have to be careful how many times we call this
	self.loadedImages[name] = love.graphics.newImage(path)
	-- Keep track of the count:
	_imageCount = _imageCount + 1
end


---------------------------------------------------
-- Loads a gameLevel
--
-- @param levelName The levelname from the levels folder
---------------------------------------------------
function game:loadLevel(levelName)

	-- This is good to do when you need randomness
	-- Seed the value with a number to always get the same randomness (for testing, and such...)
	math.randomseed(os.time())

	--==========
	-- UNO
	print("Loading images")
		-- Load the images here
		-- TODO: get these from the settings
		self:loadImage("player", 	"art/tileBlue_04.png")
		self:loadImage("ship", 		"art/playerShip3_blue.png")
		self:loadImage("turret", 	"art/Meteors/meteorBrown_big1.png")
		self:loadImage("explosion", "art/Effects/puff00.png")
	print("Done loading images")

	--==========
	-- DOS
	print("Starting level " .. levelName)
		-- Load level settings from file
		local levelSettings = require("levels."..levelName)
		self.currentLevelSettings = levelSettings
	print("Level settings loaded!")

	--==========
	-- TRES
	print("Initializing Collisions")
		-- We are using 10x10 grids for now.
		ColMan:init(levelSettings.mapWidth, levelSettings.mapHeight, 10, 10)
	print("Done creating collision map")

	--==========
	-- CUATRO
	print("Creating Player")
		self.player = ObjectFactory:newPlayer(
			self.loadedImages["player"],levelSettings.mapWidth*0.5,
			levelSettings.mapHeight*0.5
		)
		ColMan:registerObject(self.player)

	print("Done creating Player")

	--==========
	-- CINCO
	print("Creating AI")
		-- Figure out the posible places we can create an enemy
		local radius 		= levelSettings.targetRadius
		local speedRange 	= levelSettings.targetRadius

		-- Loop and randomize between our space of posibilities
		for i = 1, levelSettings.numAI do
			local posX = math.random(1, levelSettings.mapWidth)
			local posY = math.random(1, levelSettings.mapHeight)
			-- Creativity by Creation
			self:createAI(radius, speedRange, posX, posY)
		end

		-- Creating turrets
		for i = 1, levelSettings.numTurrets do
			-- A random position
			local posX = math.random(1, levelSettings.mapWidth)
			local posY = math.random(1, levelSettings.mapHeight)

			-- Create a turret
			local turret = ObjectFactory:newTurret(self.loadedImages["turret"], posX, posY)

			-- Keep track of the things
			_turretCount = _turretCount + 1

			-- Sort them by tags so we can find them later
			local turretTag = "turret".._turretCount
			self.turrets[turretTag] = turret
			turret.tag = turretTag
		end
	print("Done creating AI")

	--==========
	-- MAAAAAAAAMBO!
	self:centerCamera({
		x=levelSettings.mapHeight*0.5,
		y=levelSettings.mapWidth*0.5
	})

	-- MORE MUSIC HERE ->
	-- TODO: Music
end



---------------------------------------------------
-- Centers the camera on a coordinate
--
-- @param target {x,y}
---------------------------------------------------
function game:centerCamera(target)
	Camera:setPosition( target.x - (getWidth() * 0.5 * camScale),
						target.y - (getHeight() * 0.5 * camScale))
end


--[[!*
	Centers the camera on the player's position
]]
function game:centerCamPlayer()
	self:centerCamera(self.player)
end


---------------------------------------------------
-- Creates a new Artifical Inteligence
--
-- @param radius The radius
-- @param speedRange The range of speed it can have
-- @param posX X position
-- @param posY Y position
---------------------------------------------------
function game:createAI(radius, speedRange, posX, posY)
	-- Use the object factory
	local enemyAI = ObjectFactory:newAI(self.loadedImages["ship"], posX, posY, nil)
	enemyAI.speed = math.random(speedRange) -- Gives them a random speed

	-- Add it to the enemy list
	_enemyCount = _enemyCount + 1
	local tag = "enemy".._enemyCount

	-- Sort by tags so we can find them later
	self.enemies[tag] = enemyAI
	enemyAI.tag = tag

	-- Register it for collision detection
	ColMan:registerObject(enemyAI)

	-- Tell it to seek out the player
	enemyAI:seek(self.player)
end

---------------------------------------------------
-- Loads the User's Settings
-- @return **({})** A table
---------------------------------------------------
local function loadUserSettings()
	-- TODO: Implement this
	return {currentLevel = "level01"}
end

---------------------------------------------------
-- Initializes the game
--
-- @param **({})** settings {}
---------------------------------------------------
function game:init(settings)
	-- Fail if we have nil settings
	if settings == nil then
		print("Failed to load settings")
		return nil
	end

	-- Start to launch the game
	print("Launching " .. settings.gameTitle .. "...")

	-- Starts the Shiny stuff
	print("Initializing Particles...")
		EffectsMan:init({hola="Hola"})	-- Start the effects manager
	print("Done with particle setup.")

	-- Start UI
	print("Starting UI...")
		UIMan:init({hola="hola"})	-- Start the UI
	print("Done with UI.")

	-- Load the levelNames
	local levelNames = settings.levels
	print("Attempting to load "..#levelNames.." levels...")

	--[[
		Loads the files in the levels/ directory and parses them
	]]
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

	-- We could stop showing the loading screen here...
	print("Finished loading "..successCount.." levels")

	-- Load the user settings
	print("Loading user settings ...")
	local userSettings = loadUserSettings()
	print("Finished loading user settings ...")

	-- Get the users current level
	self:loadLevel(userSettings.currentLevel)
end

---------------------------------------------------
-- Updates the Camera
--
-- @number dt Time delta
---------------------------------------------------
local function getCameraDeltas(dt)
	local moveAmount = dt * cameraSpeed
	local deltaX = 0
	local deltaY = 0
	if love.keyboard.isDown("left") then
		deltaX = -moveAmount
	elseif love.keyboard.isDown("right")then
		deltaX = moveAmount
	end
	if love.keyboard.isDown("up") then
		deltaY = -moveAmount
	elseif love.keyboard.isDown("down")then
		deltaY = moveAmount
	end
	return deltaX, deltaY
end


---------------------------------------------------
-- Updates the Game
--
-- @number dt Delta Time
---------------------------------------------------
function game:update(dt)

	ColMan:update(dt, self.player)

	-- Refresh the things
	UIMan:update(dt)

	ObjectFactory:update(dt)

	-- Refresh the thing that views the things
	local camDx, camDy = getCameraDeltas(dt)
	Camera:move(camDx, camDy)

	-- Update shiny stuff
	EffectsMan:update(dt)
	textToPrint = "Total Enemies: " .. _enemyCount

	local p1Circle = self.player:getCollisionCircle()

	for k,v in pairs(self.enemies) do
		-- Check for collision with player
		local collisionDetected = v:isInsideCircle(p1Circle.x, p1Circle.y, p1Circle.r)
		if(collisionDetected == true) then
			v.renderFlag = false
			self.enemies[k] = nil
		end

		-- Check for collisions with the Turrets
		for turretKey, turretValue in pairs(self.turrets) do
			if(turretValue:isInsideCircle(v.x, v.y, 40)) then
				v.renderFlag = false
				self.enemies[k] = nil
				-- turretValue.renderFlag = false
				turretValue:setImage(self.loadedImages["explosion"])
			end
		end
	end
end

---------------------------------------------------
-- Draws the Game
---------------------------------------------------
function game:draw()
	-- All a matter of perspective ;)
	Camera:set()
	-- Draw the objects
	ObjectFactory:draw()
	-- Draw the shiny shit on-top
	EffectsMan:draw()
	Camera:unset()

	-- This goes on top of anything else
	UIMan:draw()

	if(game.showDebug == true) then
		love.graphics.print(textToPrint,10,10,0,1,1,0,0,0,0)
	end

end

---------------------------------------------------
-- Zooms out the camera
---------------------------------------------------
function game:zoomOut()
	Camera:move(-getWidth()*0.5, -getHeight()*0.5)
	camScale = camScale + 1
	Camera:setScale(camScale,camScale)
end


---------------------------------------------------
-- Zooms in the camera
---------------------------------------------------
function game:zoomIn()
	camScale = camScale - 1
	Camera:setScale(camScale,camScale)
	Camera:move(getWidth()*0.5, getHeight()*0.5)
end

return game
