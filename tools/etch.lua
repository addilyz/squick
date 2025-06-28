local lg = love.graphics
local etch = {}
local curs = {16,16}
local res = {32,32}
local cam = {lg.getWidth()/20,lg.getHeight()/20,10}
cam[1] = cam[1] - res[1]/2
cam[2] = cam[2] - res[2]/2
local down = {down = false, left = false, up = false, right = false, lshift = false, lctrl = false}
local project = {}
local pointex = {}
local plot = {}
local mode = "tris"
local bg = {.4,.4,.5,1}
local prev = {}
local scayl = 10
lg.setDefaultFilter("nearest","nearest")
local page = {}
project.__index = project
local cv = lg.newCanvas()

function etch.drawBG()
	lg.setColor(bg[1],bg[2],bg[3],bg[4])
	lg.rectangle("fill",0,0,lg.getWidth(),lg.getHeight())
end

function etch.draw()
	lg.push()
	lg.setCanvas(cv)
	lg.setColor(1,1,1,1)
	lg.polygon("fill",0,0,10,10,30,10)
	lg.setCanvas()
	lg.pop()
	lg.push()
	lg.scale(scayl)
	lg.draw(cv,0,0)
	lg.pop()
end

function etch.drawUI()

end

function etch.keypressed(k)
	if type(down[k]) == "boolean" then
		down[k] = v
	end
	if k == "-" and down.lctrl then scayl = scayl - 1 end
end

function etch.keyreleased(k)
	if type(down[k]) == "boolean" then
		down[k] = v
	end
end

function etch.load(blargs)
	if blargs and type(blargs[1]) == "number" then
		
	end
	pages=codex.pages
	pageOne = pages.getPage(1)
	pageTwo = pages.getPage(2)
	pageThree = pages.getPage(3)
	pageOne.etch = etch.drawBG
	pageTwo.etch = etch.draw
	pageThree.etch = etch.drawUI
end

return etch