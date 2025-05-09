
require "codex/codex"
require "melty"
require "slides"

squick = {}

function squick.load()
	melty.setPrio("up")
end

function squick.update(dt)

end

function squick.keypressed(k)

end

function squick.keyreleased(k)

end

function squick.draw()
	melty.draw()
end

codex.add("squick",squick)
