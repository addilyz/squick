
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

function squick.load()
	--nodes.loadMap({surface={{224,246}}})
	--nodes.codex()
	love.graphics.setBackgroundColor(1,1,1,1)
	codex.update.postboot = squick.postboot
end

function squick.postboot()
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	if w < h and w > 100  then
		cxscreen.mode = "portrait"
		cxscreen[1] = w
		cxscreen[2] = h
	elseif w < 100 then
		love.window.setMode(800,600)
		cxscreen[1] = 800
		cxscreen[2] = 600
		cxscreen.mode = "window"
	else
		cxscreen[1] = 800
		cxscreen[2] = 600
	end
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
