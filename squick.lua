
local PATH = "squick/submodules/addilyz/"
CODEX_PATH = PATH .. "codex"
require "squick/submodules/addilyz/codex/codex"
CODEX_PATH = nil
require "squick/core/memmy"
GRAFFICKS_PATH = PATH .. "grafficks"
require "squick/submodules/addilyz/grafficks/shredfx"
require "squick/submodules/addilyz/grafficks/slides"
require "squick/submodules/addilyz/grafficks/bubble"
GRAFFICKS_PATH = nil
-- require "squick/tools/chart"
require "squick/core/confman"
--nodes = require "game/rpg/nodes"
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
love.graphics.setDefaultFilter("nearest","nearest")
require "squick/core/boot"
local pages = codex.pages


function codex.update.uptime(dt)
	squick.uptime = squick.uptime + dt
end

function squick.start()
	print("start")
	codex.delete("WithLOVE")
	pages.expunge("WithLOVE")
	codex.delete("shred")
	pages.expunge("shred")
	shred.init(squick.internal.width,squick.internal.height,"notRuin")
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
