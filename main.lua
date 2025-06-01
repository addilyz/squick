
require "codex/codex"
require "squick/memmy"
require "squick/shredfx"
require "squick/slides"
-- require "tools/chart"
require "squick/bubble"
require "squick/confman"
--nodes = require "game/rpg/nodes"
--require "tools/stage"
o_ten_one = require "splashes/o-ten-one" -- love-community/splashes

squick = {}
squick.screen = {}
squick.screen.mode = "unknown"
squick.screen.width = 9
squick.screen.height = 16
squick.internal = {}
squick.internal.width = 240
squick.internal.height = 180
squick.mwl = {}
squick.mwl.width = 600
squick.mwl.height = 450
test = {
	defaultSel = 2,
	title = "Quit Editor",
	key = "exitdialog",
	description = "Close the program? Unsaved data will be lost.",
	selections = {"Yes", "No"},
	selOuts = {love.event.quit, bubble.close},
	selArgs = {{},{}}
}
local fs = love.filesystem
local fx = love.graphics
fx.setDefaultFilter("nearest","nearest")
local pages = codex.pages
local sqreener = {} -- device profiler
sqreener.frames = 0
local sqboot = {} -- bootloader splash
sqboot.gradientStart = {1,1,1,1}
sqboot.gradientDestination = {0,0,0,1}
sqboot.gradientDirection = {-.01,-.01,-.01,0}
sqboot.bootGradient = {1,1,1,1}
sqboot.gSpeed = 1/60
sqboot.gProg = 0
sqboot.gFuncs = {}
sqboot.ready = {false,false,true}
sqboot.aligned = true
sqboot.gPop = 0
sqboot.args = {}
local cacheFlag = false
local uptime = 0

function codex.update.uptime(dt)
	uptime = uptime + dt
end

function squick.start()
	print("start")
	codex.delete("WithLOVE")
	pages.expunge("WithLOVE")
	codex.delete("shred")
	pages.expunge("shred")
	shred.init(squick.internal.width,squick.internal.height,"notRuin")
end

function squick.load(args)
	--nodes.loadMap({surface={{224,246}}})
	--nodes.codex()
	if type(args) == "table" then
		sqboot.parseargs = true
		sqboot.args = {}
		for n = 1, #args, 1 do
			sqboot.args[n] = args[n]
		end
	end
--[[	for a = 1, #args, 1 do
		if args[a] == "--refresh-cache-mwl" then
			memmy.loadCache()
			cacheFlag = true
			slides.openCache(".SPLASHES-MOBILE","love2d-community-splashes")
			sqboot.cacheWithLOVE()
		end
	end]]
	local bG = sqboot.bootGradient
	fx.setBackgroundColor(bG[1],bG[2],bG[3],bG[4])
	local page = pages.getPage(500)
	page.squickBoot = squick.drawBoot()
end

function squick.drawBoot()
	local bG = sqboot.bootGradient
	fx.setColor(bG[1],bG[2],bG[3],bG[4])
	fx.rectangle("fill",0,0,squick.screen.width,squick.screen.height)
	fx.setColor(0,0,0,1)
	fx.print(fs.getSaveDirectory())
end

function squick.bootWithLOVE() --- love-community/splashes
	print("bootWithLOVE")
	splash = o_ten_one({background={0,0,0,1}})
	splash.onDone = squick.start
	local page = pages.getPage(5)
	codex.update.WithLOVE = squick.updateWithLOVE
	codex.keypressed.WithLOVE = squick.skippedWithLOVE
	codex.mousepressed.WithLOVE = squick.skippedWithLOVE
	page.WithLOVE = squick.drawnWithLOVE
end

function squick.updateWithLOVE(dt) --- love-community/splashes
	splash:update(dt)
end

function squick.skippedWithLOVE() --- love-community/splashes
	splash:skip()
end

function squick.drawnWithLOVE() --- love-community/splashes
	splash:draw()
end

function sqboot.cacheWithLOVE() --- love-community/splashes
	print("bootWithLOVE")
	mwlCacheRefresh()
	splash = o_ten_one({background={0,0,0,1}})
	splash.onDone = mwlCacheClose
	local page = pages.getPage(5)
	page.cwl = squick.drawnWithLOVE()
	mwlCacheRefresh()
end

function mwlCacheRefresh() -- love-community/splashes
	print("Made With LOVE Cache")
	shred.init(squick.mwl.width,squick.mwl.height)
	shred.deriveScalar()
	shred.setMode("ruin")
	local shredone = pages.getPage(1)
	local shredtwo = pages.getPage(100)
	
	local s = "mwl"
	local tex = shred.getCV(2)
	while cacheFlag do
		splash:update(1/60)
		pages.draw()
		tex = shred.getCV(2)
		slides.cache(tex)
	end
	slides.cache(tex)
end


function mwlCacheClose()
	cacheFlag = false
end

function codex.update.squickBoot(dt)
	if uptime > 1 then
		a = b
		if sqboot.parseargs then
			local args = sqboot.args
			for a = 1, #args, 1 do
				if args[a] == "--refresh-cache-mwl" then
					memmy.loadCache()
					cacheFlag = true
					slides.openCache(".SPLASHES-MOBILE","love2d-community-splashes")
					sqboot.cacheWithLOVE()
				end
     	end
			sqboot.parseargs = false
		else
			codex.update.squickBoot = sqboot.update
		end
	end
	sqboot.gradientStep(dt)
end

function sqboot.update(dt)
	sqboot.gradientStep(dt)
end

function sqboot.shredUp()
	print("shredUp")
	shred.init(squick.mwl.width,squick.mwl.height)
	shred.deriveScalar()
	shred.setMode("ruin")
end

function sqboot.bounce()
	print("bounce")
	if sqboot.ready[1] and sqboot.ready[2] and sqboot.ready[3] and sqboot.aligned then
		sqboot.shredUp()
		codex.update.squickBoot = sqboot.gradientEscape
		return
	elseif sqboot.aligned == false then
		sqboot.aligned = true
	else
		sqboot.aligned = false
	end
	if sqboot.aligned == false then
		local gD = sqboot.gradientDirection
		sqboot.gStore = {gD[1],gD[2],gD[3],gD[4]}
		local gS = sqboot.gStore
		gD[1] = -gS[1]
		gD[2] = -gS[2]
		gD[3] = -gS[3]
		gD[4] = -gD[4]
	else
		local gD = sqboot.gradientDirection
		local gS = sqboot.gStore
		gD[1] = gS[1]
		gD[2] = gS[2]
		gD[3] = gS[3]
		gD[4] = gS[4]
	end
	local des = sqboot.gradientDestination
	local ope = sqboot.gradientStart
	local store = {des[1],des[2],des[3],des[4]}
	des[1] = ope[1]
	des[2] = ope[2]
	des[3] = ope[3]
	des[4] = ope[4]
	ope[1] = store[1]
	ope[2] = store[2]
	ope[3] = store[3]
	ope[4] = store[4]
	sqboot.setGradient()
end

function sqboot.tick(dt)
	print("tick")
	sqboot.gradientCycle(dt)
end

function sqboot.gradientStep(dt)
	print("gradientStep")
	sqboot.setGradient(dt)
end

function sqboot.setGradient(dt)
	print("setGradient")
	for n = 1, 4, 1 do
		if sqboot.gradientDirection[n] < 0 then
			sqboot.gFuncs[n] = sqboot.gradientDown
		elseif sqboot.gradientDirection == 0 then
			sqboot.gFuncs[n] = sqboot.empty
		else
			sqboot.gFuncs[n] = sqboot.gradientUp
		end
	end
	sqboot.gradientStep = sqboot.tick
end

function sqboot.gradientEscape()
	print("gradientEscape")
	for n = 1, 4, 1 do
		sqboot.gFuncs[n](n)
	end
	local bG = sqboot.bootGradient
	fx.setBackgroundColor(bG[1],bG[2],bG[3],bG[4])
	if sqboot.gPop == 4 then
		memmy.tabtofile(sqboot,"test1.lua")
		pages.expunge("squickBoot")
		codex.delete("squickBoot")
		print("squickBoot deleted!")
		sqboot = nil
		squick.bootWithLOVE()
	else
		sqboot.gPop = 0
	end
end

function sqboot.gradientCycle(dt)
	print("gradientCycle")
	sqboot.gProg = sqboot.gProg + dt
	if sqboot.gProg > sqboot.gSpeed then
		sqboot.gProg = 0
		for n = 1, 4, 1 do
			sqboot.gFuncs[n](n)
		end
		local bG = sqboot.bootGradient
		fx.setBackgroundColor(bG[1],bG[2],bG[3],bG[4])
		if sqboot.gPop == 4 then
			sqboot.bounce()
		else
			sqboot.gPop = 0
		end
	sqboot.gProg = sqboot.gProg + dt
	if sqboot.gProg > sqboot.gSpeed then
		sqboot.gProg = 0
		for n = 1, 4, 1 do
			sqboot.gFuncs[n](n)
		end
		local bG = sqboot.bootGradient
		fx.setBackgroundColor(bG[1],bG[2],bG[3],bG[4])
		if sqboot.gPop == 4 then
			sqboot.bounce()
		else
			sqboot.gPop = 0
		end
	end
end

function sqboot.gradientUp(n)
	print("gradientUp["..tostring(n).."]")
	if sqboot.bootGradient[n] < sqboot.gradientDestination[n] then
		sqboot.bootGradient[n] = sqboot.bootGradient[n] + sqboot.gradientDirection[n]
	else
		sqboot.bootGradient[n] = sqboot.gradientDestination[n]
		sqboot.gFuncs[n] = sqboot.empty
	end
end

function sqboot.gradientDown(n)
	print("gradientDown["..tostring(n).."]")
	if sqboot.bootGradient[n] > sqboot.gradientDestination[n] then
		sqboot.bootGradient[n] = sqboot.bootGradient[n] + sqboot.gradientDirection[n]
	else
		sqboot.bootGradient[n] = sqboot.gradientDestination[n]
		sqboot.gFuncs[n] = sqboot.empty
	end
end

function sqboot.empty(n)
	print("empty["..tostring(n).."]")
	sqboot.gPop = sqboot.gPop + 1
end

function codex.update.sqreener() -- sqreener detects phone.
	sqreener.frames = sqreener.frames + 1
	if sqreener.frames < 2 then
		if type(fs.getInfo("config/default")) == "table" then
			local sqrtab = fs.load("config/default")()
			sqboot.ready[1] = true
			sqboot.ready[2] = true
			squick.screen = sqrtab.screen
			codex.delete("sqreener")
		end
	end
	if sqreener.frames > 10 then
		sqreener.sqreen()
	end
end

function sqreener.sqreen()
	local w = fx.getWidth()
	local h = fx.getHeight()
	
	if h > w and w > 10 then
		squick.screen = {w,h}
		squick.screen.mode = "portrait"
		--sqboot.cachedWithLOVE()
	else
		squick.screen = {w,h}
		squick.screen.mode = "desktop"
		sqboot.ready[2] = true
		love.window.setMode(800,600)
	end
	sqreener.frConfig()
	codex.delete("sqreener")
	sqboot.ready[1] = true
end

function sqreener.frConfig()
	local ostring = "local t={}\nt.screen={"
	ostring = ostring .. tonumber(squick.screen[1]) .. "," .. tonumber(squick.screen[2])
	ostring = ostring .. "}\nt.screen.mode=" .. squick.screen.mode .. "\n"
	ostring = ostring .. "return t"
	fs.createDirectory("config")
	fs.write("config/default",ostring)
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
