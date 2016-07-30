-------------------------------------------------------------------------------------
-- A thread example
--
-- @author jose@josellausas.com
-------------------------------------------------------------------------------------
require("love.timer")
require("love.image")

--To perform thread operations, you have to find yourself
local this_thread = love.thread.getThread() --or love._curthread

--------------------------------------------------
-- Generates a new image
--------------------------------------------------
function generateImage()
  math.randomseed(love.timer.getTime())
  function pixelFunction(x, y, r, g, b, a)
    r = math.random(10) + b + x % 10
    g = math.random(10) + r + y % 10
    b = math.random(10) + a + x*y % 20
    a = math.random(10) + g + x+y % 15
    return math.ceil(r), math.ceil(g), math.ceil(b), math.ceil(a)
  end
  local image = love.image.newImageData(512,512)
  local response = nil
  --The thread will never leave this loop until quit recieves true
  while true do
    image:mapPixel(pixelFunction)
    --send the updated image back to the main process.
    this_thread:send("progress", image)
    if this_thread:receive("quit") then
      --leave the function and finish the thread execution
      return
    end
  end
end

--This waits for the main process to send a signal to start
this_thread:demand("run")
generateImage()


--When this part is reached the thread terminates
return thread01
