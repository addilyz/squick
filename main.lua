
require "codex/codex"
require "slides"
-- require "tools/chart"
require "bubble"
--nodes = require "game/rpg/nodes"
require "memmy"
--require "tools/stage"

squick = {}
test = {
	defaultSel = 2,
	title = "Quit Editor",
	key = "exitdialog",
	description = "Close the program? Unsaved data will be lost.",
	selections = {"Yes", "No"},
	selOuts = {love.event.quit, bubble.close},
	selArgs = {{},{}}
}
cxscreen = {}
local frames = 0

function squick.load()
	--nodes.loadMap({surface={{224,246}}})
	--nodes.codex()
	love.graphics.setBackgroundColor(1,1,1,1)
	codex.update.boottick = squick.boottick
end

function squick.boottick()
	frames = frames + 1
	if frames > 4 then
		codex.update.postboot = squick.postboot
		codex.delete("boottick")
	end
end

function squick.postboot()
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	if w < h and w > 100  then
		cxscreen.mode = "portrait"
		cxscreen[1] = w
		cxscreen[2] = (cxscreen[1]/800)*600
	elseif w < 100 then
		love.window.setMode(800,600)
		cxscreen[1] = 800
		cxscreen[2] = 600
		cxscreen.mode = "window"
	else
		cxscreen.mode = "window"
		cxscreen[1] = 800
		cxscreen[2] = 600
	end
	memmy.postboot(cxscreen)
	codex.delete("postboot")
end

function squick.update(dt)
	
end

function squick.keypressed(k)
	--print(k.."squick")
	if k == "escape"--[[ and bubble.data == nil]] then 
		love.event.quit()
		--bubble.open(test)
		--codex.add("bubble",bubble)
	end
end

function squick.keyreleased(k)
	
end

codex.add("squick",squick)
