
stage = {}
local project = {}
local hack = {}
hack[11] = love.graphics.newFont("assets/hack.regular.ttf",11)
hack[12] = love.graphics.newFont("assets/hack.regular.ttf",12)
hack[13] = love.graphics.newFont("assets/hack.regular.ttf",13)
hack[14] = love.graphics.newFont("assets/hack.regular.ttf",14)
hack.oblique = {}
hack.oblique[11] = love.graphics.newFont("assets/hack.regularoblique.ttf",11)
hack.oblique[12] = love.graphics.newFont("assets/hack.regularoblique.ttf",12)
hack.oblique[13] = love.graphics.newFont("assets/hack.regularoblique.ttf",13)
hack.oblique[14] = love.graphics.newFont("assets/hack.regularoblique.ttf",14)
love.graphics.setFont(hack[11])

function codex.load.stage(args)
	stage.page = codex.pages.getPage(25)
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
