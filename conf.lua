
function love.conf(t)
	t.identity = "squick"
	t.appendidentity = true
	t.console = true
	t.version = "11.5"
	t.window.title = "squick"
	t.window.resizable = false
	t.window.highdpi = false
	t.window.usedpiscale = false
	t.window.vsync = 0
	t.window.width = 9
	t.window.height = 16
	t.window.minwidth = 800
	t.window.minheight = 600
	t.externalstorage = false
	t.audio.mixwithsystem = true
end
