
require "codex/codex"
require "slides"
-- require "tools/chart"
require "bubble"
nodes = require "game/rpg/nodes"
require "index"
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

function squick.load()
	nodes.loadMap({surface={{224,246}}})
	nodes.codex()
	index.structure()
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
