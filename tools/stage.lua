
stage = {}
local project = {}
local hack = {
	11 = love.graphics.newFont("assets/Hack-Regular.ttf",11)
	12 = love.graphics.newFont("assets/Hack-Regular.ttf",12)
	13 = love.graphics.newFont("assets/Hack-Regular.ttf",13)
	14 = love.graphics.newFont("assets/Hack-Regular.ttf",14)
}
love.graphics.setFont(hack[11])

function codex.load.stage(args)
	stage.page = codex.page.getPage(25)
	stage.page.stage = stage.draw
end

function codex.textinput.stage(t)
	
end

function codex.keypressed.stage(k)

end

function codex.keyreleased.stage(k)

end

function stage.draw()
	
end
