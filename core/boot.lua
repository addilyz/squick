local pages = codex.pages
local sqreener = {} -- device profiler
sqreener.frames = 0
local sqboot = {} -- bootloader splash
local qb = sqboot
local cacheFlag = false
local splashflags = {true, true, true}
local alpha = 0
local alphaTick = .01
local lg = love.graphics
local fs = love.filesystem
local bgi = lg.newImage("squick/assets/image/bg/boot.jpeg")

function qb.draw()
	lg.setColor(1,1,1,alpha)
	love.graphics.push()
	love.graphics.scale(100)
	love.graphics.draw(bgi,0,0)
	love.graphics.pop()
	lg.setColor(1,1,1,1)
	lg.print("working",100,100)
end

function qb.load()
	local page = codex.pages.getPage(2)
	page.bootloader = qb.draw
end

function qb.update(dt)
	alpha = alpha + dt
	if alpha > 1 then qb.bootWithLOVE() codex.delete("bootloader") end
end

function qb.bootWithLOVE() --- love-community/splashes
	print("bootWithLOVE")
	splash = o_ten_one({background={0.239,0.059,0.239,1}})
	lg.setBackgroundColor({0.239,0.059,0.239,1})
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