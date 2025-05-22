
local node = {} -- in case you want the namespace idk
local map = {}
map.__index = map
node.maps = {}
node.page = 13 -- battles will have their base page start at 11.
local assets = {}
local lg = love.graphics
local size = {18,16}

function node.loadMap(table)
	node.maps[#node.maps+1] = setmetatable(table,map)
	node.prerenderGUI(1)
	return node.maps[#node.maps+1]
end

function node.codex()
	if codex then
		codex.add("nodes",node)
		codex.pages.funcAtKeyInPage(node.draw,"nodes",node.page)
	end
end

function node.draw()
	for n = 1, #node.maps, 1 do
		node.maps[n]:draw()
	end
	lg.setColor(1,1,1,1)
	lg.setBlendMode("alpha")
end

function node.mousemoved()
	
end


function map:draw()
	local s = self.surface
	for n = 1, #s, 1 do
		lg.draw(assets.dia,s[n][1],s[n][2])
	end
end

function node.prerenderGUI(scale)
	lg.setLineWidth(4)
	assets.dia = node.diamondRTT(scale*16,scale*20,{.8,.7,.3,1})
end

function node.diamondRTT(w,h,c,c2,lw)
	local tex = lg.newCanvas(w,h)
	lg.setColor(1,1,1,1)
	if type(c) == "table" then
		if c[1] == nil then
			lg.setColor(c.r,c.g,c.b,c.a)
		else
			lg.setColor(c[1],c[2],c[3],c[4])
		end
	end
	lg.setCanvas(tex)
	local v = {
		w/2,0,
		w,h/2,
		w/2,h,
		0,h/2
	}
	lg.polygon("fill",v)
	if type(c2) == "table" then
		if c[1] == nil then
			lg.setColor(c.r,c.g,c.b,c.a)
		else
			lg.setColor(c[1],c[2],c[3],c[4])
		end
		local ls = lg.getLineWidth()
		if type(lw) == "number" then
			lg.setLineWidth(lw)
		end
		lg.polygon("line",v)
		lg.setLineWidth(ls)
	end
	lg.setCanvas()
	local o = tex:newImageData()
	tex = nil
	return lg.newImage(o)
	
end

return node
