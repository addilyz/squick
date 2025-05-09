
slides = {}
local slide = {}
slide.__index = slide
local anim = {}
anim.__index = anim
local instance = {}
instance.__index = instance

function slides.import(fp)
	local t = setmetatable({},slide)
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
		t.anims = {}
		for n = 1, #a, 1 do
			t.anims[a[n][1]] = setmetatable(
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
				t.anims[a[n][1]]["i"] = -1
			else
				t.anims[a[n][1]]["i"] = 1
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
	local t = setmetatable({},instance)
	t.anim = self
	t.pos = self.first
	t.dtc = 1/self.fps
	return t
end
