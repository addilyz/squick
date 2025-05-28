
require "codex/codex"
require "slides"
-- require "tools/chart"
require "bubble"
--nodes = require "game/rpg/nodes"
--require "memmy"
--require "tools/stage"

squick = {}
squick.screen = {}
squick.screen.mode = "unknown"
squick.screen.width = 9
squick.screen.height = 16
test = {
	defaultSel = 2,
	title = "Quit Editor",
	key = "exitdialog",
	description = "Close the program? Unsaved data will be lost.",
	selections = {"Yes", "No"},
	selOuts = {love.event.quit, bubble.close},
	selArgs = {{},{}}
}
fs = love.filesystem
local sqreener = {}
sqreener.frames = 0
local sqboot = {}
sqboot.gradientStart = {0,0,0,1}
sqboot.gradientDestination = {1,1,1,1}
sqboot.gradientDirection = {.01,.01,.01,0}
sqboot.bootGradient = {0,0,0,1}
sqboot.gFuncs = {}

function squick.load()
	--nodes.loadMap({surface={{224,246}}})
	--nodes.codex()
	love.graphics.setBackgroundColor(sqboot.bootGradient[1],sqboot.bootGradient[2],sqboot.bootGradient[3],sqboot.bootGradient[4])
	local page = codex.pages.getPage(500)
	page.squickBoot = squick.drawBoot()
end

function squick.drawBoot()
	local bG = sqboot.bootGradient
	love.graphics.setColor(bG[1],bG[2],bG[3],bG[4])
	love.graphics.rectangle("fill",0,0,squick.screen.width,squick.screen.height)
	love.graphics.setColor(0,0,0,1)
	love.graphics.print(love.filesystem.getSaveDirectory())
end

function codex.update.squickBoot()
	sqboot.gradientStep()
end

function sqboot.gradientStep()
	sqboot.setGradient()
end

function sqboot.setGradient()
	for n = 1, 4, 1 do
		if sqboot.gradientDirection[n] < 0 then
			sqboot.gFuncs[n] = sqboot.gradientDown
		elseif sqboot.gradientDirection == 0 then
			sqboot.gFuncs[n] = sqboot.empty
		else
			sqboot.gFuncs[n] = sqboot.gradientUp
		end
	end
	sqboot.gradientStep = sqboot.gradientCycle
end

function sqboot.gradientCycle()
	for n = 1, 4, 1 do
		sqboot.gFuncs[n](n)
	end
	love.graphics.setBackgroundColor(sqboot.bootGradient[1],sqboot.bootGradient[2],sqboot.bootGradient[3],sqboot.bootGradient[4])
end

function sqboot.gradientUp(n)
	if sqboot.bootGradient[n] < sqboot.gradientDestination[n] then
		sqboot.bootGradient[n] = sqboot.bootGradient[n] + sqboot.gradientDirection[n]
	else
		sqboot.bootGradient[n] = sqboot.gradientDestination[n]
		sqboot.gFuncs[n] = sqboot.empty
	end
end

function sqboot.gradientDown(n)
	if sqboot.bootGradient[n] > sqboot.gradientDestination[n] then
		sqboot.bootGradient[n] = sqboot.bootGradient[n] + sqboot.gradientDirection[n]
	else
		sqboot.bootGradient[n] = sqboot.gradientDestination[n]
		sqboot.gFuncs[n] = sqboot.empty
	end
end

function sqboot.empty(n)

end

function codex.update.sqreener() -- sqreener detects phone.
	sqreener.frames = sqreener.frames + 1
	if sqreener.frames < 2 then
		if type(love.filesystem.getInfo("config/default")) == "table" then
			local sqrtab = love.filesystem.load("config/default")()
			squick.screen = sqrtab.screen
			codex.delete("sqreener")
		end
	end
	if sqreener.frames > 10 then
		sqreener.sqreen()
	end
end

function sqreener.sqreen()
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	
	if h > w and w > 10 then
		squick.screen = {w,h}
		squick.screen.mode = "portrait"
	else
		squick.screen = {w,h}
		squick.screen.mode = "desktop"
		love.window.setMode(800,600)
	end
	sqreener.frConfig()
	codex.delete("sqreener")
end

function sqreener.frConfig()
	local ostring = "local t={}\nt.screen={"
	ostring = ostring .. tonumber(squick.screen[1]) .. "," .. tonumber(squick.screen[2])
	ostring = ostring .. "}\nt.screen.mode=" .. squick.screen.mode .. "\n"
	ostring = ostring .. "return t"
	love.filesystem.createDirectory("config")
	love.filesystem.write("config/default",ostring)
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
