--- messy framebuffer effect meant primarily for poorly scaling entire projects.
shred = {}
shred.drawPage = {}
local fx = love.graphics
fx.setDefaultFilter("nearest","nearest") -- important
local cv = {}
local vs = {}
vs.width = 0
vs.height = 0
vs.maxwidth = 1000
vs.maxheight = 1000
local ws = {}
local scalar = 0
local oScalar = 0
local buffer = 1

function shred.init(iw,ih,scale)
	scale = scale or 0
	vs.width = iw
	vs.height = ih
	scalar = scale
	shred.stepOne = shred.empty
	shred.stepTwo = shred.empty
	shred.stepThree = shred.empty
	codex.update.shred = shred.update
end

function shred.setMode(a)
	if a == "ruin" then
		cv[1] = fx.newCanvas(ws.width,ws.height)
		cv[2] = fx.newCanvas(vs.width,vs.height)
		shred.stepOne = shred.openSquish
		shred.stepTwo = shred.closeSquish
		shred.stepThree = shred.hasBuffer
	else

	end
end

function shred.getDraws()
	return shred.stepOne, shred.stepTwo, shred.stepThree
end

function shred.empty()
	
end

function shred.deriveScalar()
	ws = {}
	ws.width = fx.getWidth()
	ws.height = fx.getHeight()
	local swov = ws.width/vs.width
	local shov = ws.height/vs.height
	if swov < shov or swov == shov then
		scalar = swov
		oScalar = vs.width/ws.width
	else
		scalar = shov
		oScalar = vs.height/ws.height
	end
end

function shred.openTex()
	fx.setCanvas(cv[1])
	fx.clear()
end

function shred.openSquish()
	fx.setCanvas(cv[1])
	fx.clear()
end

function shred.closeSquish()
	fx.setCanvas()
	local id = cv[1]:newImageData()
	local img = fx.newImage(id)
	id = nil
	fx.setCanvas(cv[2])
	fx.clear()
	fx.push()
	fx.scale(oScalar)
	fx.draw(img,0,0)
	fx.pop()
	fx.setCanvas()
	img = nil
	local id = cv[2]:newImageData()
	buffer = cv[2]
	id = nil
end

function shred.close()

end

function shred.update()
	if type(buffer) ~= "number" then
		shred.update = nil
		shred.drawPage.shred = shred.hasBuffer
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