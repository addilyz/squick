
local PATH = "squick/submodules/addilyz/"
CODEX_PATH = PATH .. "codex"
require "squick/submodules/addilyz/codex/codex"
local sugar = require "squick/submodules/addilyz/codex/sugar"
CODEX_PATH = nil
GRAFFICKS_PATH = PATH .. "grafficks"
require "squick/submodules/addilyz/grafficks/slides"
require "squick/submodules/addilyz/grafficks/bubble"
GRAFFICKS_PATH = nil
--require "squick/tools/stage"
o_ten_one = require "squick/submodules/love2d-community/splashes/o-ten-one" -- love-community/splashes

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
squick.uptime = 0
closeDialog = {
	defaultSel = 2,
	title = "Quit Editor",
	key = "exitdialog",
	description = "Close the program? Unsaved data will be lost.",
	selections = {"Yes", "No"},
	selOuts = {love.event.quit, bubble.close},
	selArgs = {{},{}}
}
local etch = {}
sugar.bootloader("squick/core/boot")
lg = love.graphics
lg.setDefaultFilter("nearest","nearest")
local pages = codex.pages

local startEtch = function(args)
	print("hi")
	etch = require "squick/tools/etch"
	etch.load(args)
	codex.add("etch",etch)
end

local startBoxer = function(args)
	print("yoooo  uh huh")
	boxer = require "squick/tools/boxer"
	boxer.load(args)
	codex.add("boxer",boxer)
end

function squick.load()
	sugar.dna.add("-e",startEtch)
	sugar.dna.add("--etch",startEtch)
	sugar.dna.add("-b",startBoxer)
	sugar.dna.add("--boxer",startBoxer)
end

function codex.update.uptime(dt)
	squick.uptime = squick.uptime + dt
end
local cv = lg.newCanvas()
local fad = 0
function squick.start()
	print("start")
	codex.delete("WithLOVE")
	pages.expunge("WithLOVE")
	codex.delete("shred")
	pages.expunge("shred")
	codex.delete("bootloader")
	pages.expunge("bootloader")
	cv = lg.newCanvas(squick.internal.width,squick.internal.height)
	local low = pages.getPage(1)
	local high = pages.getPage(10000)
	codex.update.fader = function(dt)
		fad = fad + dt/5
		if fad > 1 then fad = 1 codex.update.fader = nil end
	end
	low.squick = function()
		lg.setCanvas(cv)
		lg.setColor(0,0,0,fad)
		lg.rectangle("fill",0,0,240,180)
		lg.setColor(1,1,1,1)
	end
	high.squick = function()
		lg.setCanvas()
		lg.push()
		lg.scale(lg.getWidth()/240)
		lg.draw(cv)
		lg.pop()
	end
	grid = require "runtime/grid"
	codex.add("grid",grid)
	grid.start()
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
