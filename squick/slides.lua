
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
local cache = {}
local fs = love.filesystem
local fx = love.graphics

function slides.import(key,fp)
	store.slides[key] = setmetatable({},slide)
	local t = store.slides[key]
	t.key = key
	t.temp = fs.load(fp)()
	t.image = fx.newImage(t.temp.ipath)
	local sw = t.image:getWidth()
	local sh = t.image:getHeight()
	t.quads = {}
	for n = 1, #t.temp.coords, 1 do
		t.quads[n] = fx.newQuad(
			t.temp.coords[n][1],
			t.temp.coords[n][2],
			t.temp.coords[n][3],
			t.temp.coords[n][4],
			sw,sh
		)
	end
	if t.temp.anims then
		local a = t.temp.anims
		store.anims[key] = {}
		t.anims = store.anims[key]
		for n = 1, #a, 1 do
			t.anims[n] = setmetatable(
				{
					first = a[n][2],
					last = a[n][3],
					fps = a[n][4],
					mh = a[n][5],
					mv = a[n][6],
					slide = t
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
	if t.temp.tiles then
		t.tiles = {}
		for n = 1, #t.temp.tiles, 1 do
			t.tiles[n] = t.temp.tiles[n]
		end
	end
	t.temp = nil
	return t
end

function slide:present(quad,x,y)
	fx.setColor(1,1,1,1)
	fx.draw(self.image,self.quads[quad],x,y)
end

function anim:getInstance(fpso)
	local fpso = fpso or self.fps
	local key = self.slide.key
	store.insts[key][#store.insts[key]+1] = setmetatable({},instance)
	local t = store.insts[key][#store.insts[key]]
	t.anim = self
	t.pos = self.first
	t.dtc = 0
	t.dtl = 1/fpso
	return t
end

function slides.update(dt)
	for k,v in next, store.slides do
		v:update(dt)
	end
end

function slide:update(dt)
	for k,v in next, store.insts[self.key] do
		v:update(dt)
	end
end

function instance:update(dt)
	self.dtc = self.dtc + dt
	if self.dtc >= self.dtl then
		if self.pos == self.anim.last then
			self.pos = self.anim.first-self.anim.i
		end
		self.dtc = self.dtc - self.dtl
		self.pos = self.pos + self.anim.i
	end
end

function instance:draw(x,y)
	self.anim.slide:present(self.pos,x,y)
end

function slides.openCache(loc,ident)
	if memmy then
		fs.createDirectory("cache/slides/"..loc)
		memmy.addCacheItem("slides",loc,ident)
		cache.dir = "cache/slides/"..loc.."/"
		cache.fn = ident
		cache.loc = loc
		cache.num = 1
		cache.data = {}
	end
end

function slides.cache(image)
	cache.data[cache.num] = image:newImageData()
	cache.data[cache.num]:encode("png",cache.dir..cache.fn.. "-"..cache.num..".png")
	cache.num = cache.num + 1
end

function slides.closeCache()
	memmy.promoteToCacheBuffer(cache.loc)
	memmy.finalizeCacheBuffer()
end

