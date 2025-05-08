
require "codex/codex"
require "splash"
require "slides"

squick = {}
uilayer = splash.getLayer(1000)
alayer = splash.getLayer(1)
blayer = splash.getLayer(2)

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
