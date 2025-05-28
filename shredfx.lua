--- messy framebuffer effect meant primarily for poorly scaling entire projects.
shred = {}
local fx = love.graphics
local cv = {}
local vs = {}
vs.width = 0
vs.height = 0
vs.maxwidth = 1000
vs.maxheight = 1000
local scalar = 0
local buffer = 1

function shred.init(iw,ih)
	vs.width = iw
	vs.height = ih
end

function shred.openTex()
	cv = fx.newCanvas(vs.width,vs.height)
	fx.setCanvas(cv)
end

function shred.update()
	if type(buffer) ~= "number" then
		shred.update = nil
		shred.draw = shred.hasBuffer
	end
end

function shred.closeTexGetImg()
	fx.setCanvas()
	local id = cv:newImageData()
	buffer = fx.newImage()
end

function shred.hasBuffer()
	fx.push()
	fx.scale(scalar)
	fx.draw(buffer,0,0)
	fx.pop()
end