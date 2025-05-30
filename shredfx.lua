--- messy framebuffer effect meant primarily for poorly scaling entire projects.
shred = {}
shred.drawPage = {}
shred.mode = "none"
shred.textwoavailable = false
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
	print("shred init")
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
	print("shred setMode: " .. a)
	if a == "ruin" then
		shred.mode = "ruin"
		cv[1] = fx.newCanvas(vs.width,vs.height)
		cv[2] = fx.newCanvas(ws.width,ws.height)
		shred.textwoavailable = false
		shred.stepOne = shred.openSquish
		shred.stepTwo = shred.closeSquish
		shred.stepThree = shred.hasBuffer
	else
		shred.mode = "shred"
		cv[1] = fx.newCanvas(vs.width,vs.height)
		cv[2] = nil
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
	fx.push()
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
	buffer = nil
	local id = cv[2]:newImageData()
	buffer = fx.newImage(id)
	id = nil
end

function shred.singleClose()
	fx.pop()
	fx.setCanvas()
	fx.push()
	fx.scale(scalar)
	fx.draw(cv[1],0,0)
	fx.pop()
end

function shred.update()
	print("SHRED UPDATE")
	if type(buffer) ~= "number" and type(buffer) ~= nil then
		codex.update.shred = nil
		shred.drawPage.shred = shred.stepThree
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