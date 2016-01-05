Inteligencia Artificial para juegos
===================================

1. Introduccion y setup
------------------------

### Variables

	local x = "Hola q ase?"
	print(x)

	-- un comentario
	local n_1 = 42
	local n_2 = 43


	local z  = n_1 + n_2

	--[[ Comentario de varias lineas
		

		Aqui tambien es comentario.

		"Z es la suma de 42 y 43"
	]]
	print(z)


### Funciones

	local sumar = function(left,right)
		local x = left + right

		return x
	end


	local mensaje = "La respuesta es: " .. sumar(1 + 4)

	print(mensaje)

### Tablas y diccionarios

	local tabla = {}
	table.insert(tabla, "uno")
	table.insert(tabla, "dos")
	table.insert(tabla, "tres")

	for i,v in ipairs(tabla) do
		print(v)
	end

	local diccionario = {
		uno = "El Primero",
		dos = "El Segundo",
		tres = "El Tercero",
	}

	diccionario.cuarto = "El cuarto"
	diccionario.cinco = "El quinto"

	print(diccionario["uno"])
	-- En lua iniciamos los indices en 1!!!
	print(diccionario[table[1]])

	function diccionario.printAll()
		for k,v in pairs(diccionario) do
			print("->" .. k .. " = " .. v )
		end
	end




2. Hello Lua with Love!
------------------------

	function love.load()
		love.graphics.setNewFont(12)
		love.graphics.setBackgroundColor(255,255,255)
	end

	function love.draw()
		love.graphics.print("Hello World!", 400, 300)
	end

3. Hello Objects!
-----------------


	local ObjectFactory = require("ObjectFactory")

	local imgx 		= 100
	local imgy 		= 100
	local blueTile 	= nil
	local redTile  	= nil
	local target 	= nil
	local ai_01 	= nil
	local ai_02 	= nil
	local ai_03 	= nil
	local ai_04 	= nil
	local ai_05 	= nil


	function love.load()
		love.graphics.setNewFont(12)
		love.graphics.setBackgroundColor(255,255,255)

		-- Load the images here
		blueTile   = love.graphics.newImage("art/tileBlue_04.png")
		redTile    = love.graphics.newImage("art/tileRed_04.png")
		playerShip = love.graphics.newImage("art/playerShip3_blue.png")

		target = ObjectFactory:new(redTile, 200, 200)

		ai_01 = ObjectFactory:newAI(playerShip, 100, 500, target)
		ai_02 = ObjectFactory:newAI(playerShip, 200, 500, target)
		ai_03 = ObjectFactory:newAI(playerShip, 300, 500, target)
		ai_04 = ObjectFactory:newAI(playerShip, 400, 500, target)
		ai_05 = ObjectFactory:newAI(playerShip, 500, 500, target)
		

	end

	function love.update(dt)
		if love.keyboard.isDown("up") then
			
		end

		ObjectFactory:update(dt)

	end

	function love.draw()
		
		ObjectFactory:draw()
		
	end

	function love.mousepressed(x,y,button)
		print("mouse pressed")
		print(button)
		if button == 1 then
			imgx, imgy = x,y
			target.x = x
			target.y = y
		end
	end

	function love.mousereleased(x,y,button)
		if (button == '1') then
			-- Do something
		end
	end

	function love.keypressed(key)
		if key == 'b' then
			
			ai_01.speed = 25
			ai_02.speed = 12
			ai_03.speed = 31
			ai_04.speed = 24
			ai_05.speed = 100
		end
	end

	function love.keyreleased(key)
		-- The key was released
	end

	function love.focus(f)
		if not f then
			print("Lost focus")
		else
			print("Gained focus")
		end
	end

	function love.quit()
		-- Before quits runs this:
	end







