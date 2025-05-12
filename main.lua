
require "codex/codex"
require "melty"
require "slides"
require "tools/chart"
require "bubble"

squick = {}
melty.setPrio("up")
test = {
	defaultSel = 2,
	title = "Quit App",
	description = "Close the app? Unsaved data will be lost.",
	selections = {"Yes", "No"},
	selOuts = {love.event.quit, codex.remove},
	selArgs = {{},{"bubble"}}
}

function squick.update(dt)

end

function squick.keypressed(k)
	--print(k.."squick")
	if k == "escape" and bubble.data == nil then 
		bubble.open(test)
		codex.add("bubble",bubble)
	end
end

function squick.keyreleased(k)

end

function squick.draw()
	melty.draw()
end

codex.add("squick",squick)
