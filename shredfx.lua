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
local oScalar = 0
local buffer = 1

function shred.init(iw,ih,scale)
	scale = scale or 0
	vs.width = iw
	vs.height = ih
	scalar = scale
end

function shred.deriveScalar()
	local sw = fx.getWidth()
	local sh = fx.getHeight()
	local swov = sw/vs.width
	local shov = sh/vs.height
	if swov < shov or swov == shov then
		scalar = swov
		oScalar = vs.width/sw
	else
		scalar = shov
		oScalar = vs.height/sh
	end
end

function shred.openTex()
	cv = fx.newCanvas(vs.width,vs.height)
	fx.setCanvas(cv)
end

function shred.update()
	if type(buffer) ~= "number" then
		shred.update = nil
		shred.drawFunc = shred.hasBuffer
	end
end

function shred.draw()
	shred.drawFunc()
end

function shred.drawFunc()

end

function shred.closeTexGetImg()
	fx.setCanvas()
	local id = cv:newImageData()
	buffer = fx.newImage(id)
	cv = nil
end

function shred.hasBuffer()
	fx.push()
	fx.scale(scalar)
	fx.draw(buffer,0,0)
	fx.pop()
end