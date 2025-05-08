
require "codex/codex"
require "splash"
require "slides"

squick = {}

function squick.load()
	splash.setPrio("up")
end

function squick.update(dt)

end

function squick.keypressed(k)

end

function squick.keyreleased(k)

end

codex.add("squick",squick)

function codex.draw.squick()
	splash.draw()
end
