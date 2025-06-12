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

function shred.init(iw,ih,scale)
	print("shred init")
	print("iw: "..iw)
	print("ih: "..ih)
	scale = scale or 0
	vs.width = iw
	vs.height = ih
	scalar = scale
end

function shred.setMode(a,cacheIdent)
	print("shred setMode: " .. a)
	if a == "ruin" then -- these items should be cached incase of no cv availability/compatibility!
		shred.mode = "ruin"
		if type(cacheIdent) == "nil" then
			print("missing cacheIdentity on setMode(\"ruin\")!")
		elseif memmy.checkCache(cacheIdent) == false then
			print("missing library-suggested cache item, run --refresh-cache-"..cacheIdent.. " to build.")
		end
		cv[1] = fx.newCanvas(ws.width,ws.height)
		cv[2] = fx.newCanvas(vs.width,vs.height)
		shred.textwoavailable = false
		local one = codex.pages.getPage(1)
		local two = codex.pages.getPage(100)
		one.shred = shred.openSquish
		two.shred = shred.closeSquish
	else
		shred.mode = "shred"
		cv[1] = fx.newCanvas(vs.width,vs.height)
		cv[2] = nil
	end
end

function shred.empty()
	
end

function shred.deriveScalar()
	print("derive")
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
	fx.setBlendMode("alpha","alphamultiply")
	--print("squish1")
	fx.setColor(1,1,1,1)
	fx.setCanvas(cv[1])
	fx.clear()
	fx.push()
end

function shred.closeSquish()
	--print("squish2")
	fx.pop()
	fx.setCanvas()
	fx.setBlendMode("alpha","premultiplied")
	fx.setCanvas(cv[2])
	fx.clear()
	fx.push()
	fx.scale(oScalar)
	fx.draw(cv[1],0,0)
	fx.pop()
	fx.setCanvas()
	fx.push()
	fx.scale(scalar)
	fx.draw(cv[2],0,0)
	fx.pop()
	fx.setBlendMode("alpha")
end

function shred.getCV(num)
	return cv[num]
end

function shred.singleClose()
	fx.pop()
	fx.setCanvas()
	fx.push()
	fx.scale(scalar)
	fx.draw(cv[1],0,0)
	fx.pop()
end
