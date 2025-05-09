
slides = {}
local slide = {}
slide.__index = slide
local anim = {}
anim.__index = anim
local instance = {}
instance.__index = instance
local store = {}
store.slides = {}
store.anims = {}
store.insts = {}

function slides.import(fp)
	store.slides[#store.slides+1] = setmetatable({},slide)
	local t = store.slides[#store.slides]
	t.temp = love.filesystem.load(fp)()
	t.image = love.graphics.newImage(t.temp.ipath)
	local sw = t.image:getWidth()
	local sh = t.image:getHeight()
	t.quads = {}
	for n = 1, #t.temp.coords, 1 do
		t.quads[n] = love.graphics.newQuad(
			t.temp.coords[n][1],
			t.temp.coords[n][2],
			t.temp.coords[n][3],
			t.temp.coords[n][4],
			sw,sh
		)
	end
	if t.temp.anims then
		local a = t.temp.anims
		store.anims[#store.anims+1] = {parent = t}
		t.anims = store.anims[#store.anims]
		for n = 1, #a, 1 do
			t.anims[n] = setmetatable(
				{
					first = a[n][2],
					last = a[n][3],
					fps = a[n][4]
					mh = a[n][5],
					mv = a[n][6]
				},
				anim
			)
			if a[n][2] > a[n][3] then 
				t.anims[n]["i"] = -1
			else
				t.anims[n]["i"] = 1
			end
		end
	end
	if t.temp.slides then
		t.slides = {}
		for n = 1, #t.temp.slides, 1 do
			t.slides[n] = t.temp.slides[n]
		end
	end
	t.temp = nil
	return t
end

function slide:update(dt)
	for n = 1, #self.anims, 1 do
		self.anims[n]:update(dt)
	end
end

function slide:present(quad,x,y)
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.image,self.quads[quad],x,y)
end

function anims:getInstance(fpso)
	if fpso then
		local fps = fpso
	else
		local fps = self.fps
	end
	self.insts[#self.insts+1] = setmetatable({},instance)
	local t = self.insts[#self.insts]
	t.pos = self.first
	t.dtc = 0
	t.dtl = 1/self.fps
	return t
end

function instance:update(dt)
	self.dtc = self.dtc + dt
	if self.dtc > self.dtl then
		self.dtc = self.dtc - self.dtl
		self.pos = self.pos + self.i
	end
end

function instance:draw(x,y)
	self.anim
end
