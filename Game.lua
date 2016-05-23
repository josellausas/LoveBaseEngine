--[[ Game.lua by jose@josellausas.com 

Main Game
=========

EN
--
Main game file. Manage gameplay and user interaction here.


ES
--
Archivo principal desde el cual se controlan las 
reglas del juego y la interacción con el usuario.

]]
local Camera 			= require("LLBase.LLCamera")			-- La camara del juagador
local ObjectFactory 	= require("LLBase.ObjectFactory")		-- La fabrica de objetos 
local UIMan 			= require("LLBase.UIManager")			-- El encargado de los menús (en desarrollo)
local ColMan 			= require("LLBase.CollisionManager")	-- El encargado de las colisiones (en desarrollo)
local EffectsMan		= require("LLBase.EffectsMan")			-- El encargado de los efectos (en desarrollo)
local Player 			= require 'LLBase.Game.Player'

-- Setup the camera defaults
local cameraSpeed 	= 800
local camScale 		= Camera.scaleX

-- Build the Game object
local game = {}

local enemyCount = 0
local turretCount = 0

game.showDebug = true
game.showUI 	= true
game.player 	= nil
game.team 		= {}
game.enemies 	= {}
game.turrets = {}
game.currentLevelSettings = nil
game.loadedImages = {
	playerTile = nil,
	ship = nil,
}
	
-- Window width
local function getWidth()
	return love.graphics.getWidth()
end

-- Window height
local function getHeight()
	return love.graphics.getHeight()
end

--[[ Loads an image to the loaded images dictionary ]]
function game:loadImage(name, path)

	if not (self.loadedImages[name] == nil) then
		print("WARNING: RELOADING AN IMAGE!!!")
	end
	
	self.loadedImages[name] = love.graphics.newImage(path)
end


--[[ Loads a gameLevel]]
function game:loadLevel(levelName)

	-- This is good to do when you need randomness
	-- Seed the value with a number to always get the same randomness (for testing, and such...)
	math.randomseed(os.time() * os.time())

	-- UNO
	print("Loading images")
		-- Load the images here
		-- TODO: get these from the settings
		self:loadImage("player", "art/tileBlue_04.png")
		self:loadImage("ship", "art/playerShip3_blue.png")
		self:loadImage("turret", "art/ufoRed.png")
		self:loadImage("explosion", "art/Effects/puff00.png")
	print("Done loading images")


	-- DOS
	print("Starting level " .. levelName)
		-- Load level settings from file
		local levelSettings = require("levels."..levelName)
		self.currentLevelSettings = levelSettings
	print("Level settings loaded!")


	-- TRES
	print("Initializing Collisions")
		-- We are using 10x10 grids for now.
		ColMan:init(levelSettings.mapWidth, levelSettings.mapHeight, 10, 10)
	print("Done creating collision map")


	-- CUATRO
	print("Creating Player")
		self.player = ObjectFactory:newPlayer(self.loadedImages["player"],levelSettings.mapWidth*0.5,  levelSettings.mapHeight*0.5)
		ColMan:registerObject(self.player)
	print("Done creating Player")

	-- CINCO
	print("Creating AI")
		local radius 		= levelSettings.targetRadius
		local speedRange 	= levelSettings.targetRadius

		for i=1,levelSettings.numAI do
			local posX = math.random(1, levelSettings.mapWidth)
			local posY = math.random(1, levelSettings.mapHeight)

			self:createAI(radius, speedRange, posX, posY)
		end

		-- Creating turrets
		for i=1, levelSettings.numTurrets do
			local posX = math.random(1, levelSettings.mapWidth)
			local posY = math.random(1, levelSettings.mapHeight)
			local turret = ObjectFactory:newTurret(self.loadedImages["turret"], posX, posY)
			turretCount = turretCount + 1
			local turretTag = "turret"..turretCount
			self.turrets[turretTag] = turret
			turret.tag = turretTag
		end
	print("Done creating AI")

	-- MAAAAAAAAMBO!
	self:centerCamera({x=levelSettings.mapHeight*0.5,y=levelSettings.mapWidth*0.5})

	-- MORE MUSIC HERE ->
end


function game:centerCamera(target)
	Camera:setPosition( target.x - (getWidth() * 0.5 * camScale), 
						target.y - (getHeight() * 0.5 * camScale))
end

function game:centerCamPlayer()
	self:centerCamera(self.player)
end



function game:createAI(radius, speedRange, posX, posY)
	-- Use the object factory
	local enemyAI = ObjectFactory:newAI(self.loadedImages["ship"], posX, posY, nil)
	enemyAI.speed = math.random(speedRange) -- Gives them a random speed

	-- Add it to the enemy list
	enemyCount = enemyCount + 1
	local tag = "enemy"..enemyCount
	self.enemies[tag] = enemyAI
	enemyAI.tag = tag

	-- Register it for collision detection
	ColMan:registerObject(enemyAI)

	-- Tell it to seek out the player
	enemyAI:seek(self.player)
end


local function loadUserSettings()
	-- TODO: Implement this
	return {currentLevel = "level01"}
end

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

--[[
	Updates the Camera
]]
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


--[[
	Updates the Game
]]
local textToPrint = ""
function game:update(dt)

	ColMan:update(dt, self.player)

	-- Refresh the things
	UIMan:update(dt)

	ObjectFactory:update(dt)

	-- Refresh the thing that views the things
	local camDx, camDy = getCameraDeltas(dt)
	Camera:move(camDx, camDy)

	-- Update shiny stuff
	-- EffectsMan:update(dt)
	textToPrint = "Total Enemies: " .. enemyCount

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
				turretValue.image = self.loadedImages["explosion"]
			end
		end
	end
end 

--[[
	Draws the Game
]]
function game:draw()
	-- All a matter of perspective ;)
	Camera:set()
		-- Draw the objects
		ObjectFactory:draw()
		-- Draw the shiny shit on-top
		-- EffectsMan:draw()
	Camera:unset()

	-- This goes on top of anything else
	UIMan:draw()

	if(game.showDebug == true) then
		love.graphics.print(textToPrint,10,10,0,1,1,0,0,0,0)
	end

end


function game:zoomOut()
	Camera:move(-getWidth()*0.5, -getHeight()*0.5)
	camScale = camScale + 1
	Camera:setScale(camScale,camScale)
end

function game:zoomIn()
	camScale = camScale - 1
	Camera:setScale(camScale,camScale)
	Camera:move(getWidth()*0.5, getHeight()*0.5)
end

return game

