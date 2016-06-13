-- Love Config file
function love.conf(t)
	t.identity 			= "baseEngine_0"
	t.modules.joystick 	= false
	t.window.title 		= "BaseEngine by Llau"
	t.window.icon 		= nil -- Filepath to an image to use as icon
	t.window.width 		= 1024
	t.window.height 	= 768
	t.window.resizable 	= true
	t.window.minWidth 	= 800
	t.window.minHeight 	= 600
	t.window.msaa 		= 0 -- Number of samples to use
	t.window.display 	= 1 -- The index of the monitor to use
end

