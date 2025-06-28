local pages = codex.pages
local sqreener = {} -- device profiler
sqreener.frames = 0
local sqboot = {} -- bootloader splash
local qb = sqboot
local cacheFlag = false
local splashflags = {true, true, true}
local targetColor = {}
local color = {0,0,0,1}
local startColor = love.graphics.getBackgroundColor()
local speedColor = {.01,.01,.01}
local lg = love.graphics
local fs = love.filesystem

function qb.draw()
	lg.setColor(color[1],color[2],color[3],color[4])
	lg.setColor(1,1,1,1)
	lg.print("working",100,100)
end

function qb.load()
	local page = codex.pages.getPage(4)
	page.bootloader = qb.draw
end

qb.update()

function qb.bootWithLOVE() --- love-community/splashes
	print("bootWithLOVE")
	splash = o_ten_one({background={0,0,0,1}})
	splash.onDone = squick.start
	local page = pages.getPage(5)
	codex.update.WithLOVE = sqboot.updateWithLOVE
	codex.keypressed.WithLOVE = sqboot.skippedWithLOVE
	codex.mousepressed.WithLOVE = sqboot.skippedWithLOVE
	page.WithLOVE = sqboot.drawnWithLOVE
end

function qb.updateWithLOVE(dt) --- love-community/splashes
	splash:update(dt)
end

function qb.skippedWithLOVE() --- love-community/splashes
	splash:skip()
end

function qb.drawnWithLOVE() --- love-community/splashes
	splash:draw()
end

function qb.shredUp()
	print("shredUp")
	shred.init(squick.mwl.width,squick.mwl.height)
	shred.deriveScalar()
	shred.setMode("ruin","SPLASHES")
end

return qb