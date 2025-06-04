
local grid = {}
local field = {}
field.__index = field
local grid.rot = 0
local grid.angle = 0
local fx = love.graphics
local fs = love.filesystem
local lt = love.thread
fs.appendDirectory(true)
if type(fs.getInfo("squick/tactics/grid/global")) == "table" then grid.settings = fs.load("squick/tactics/grid/global")() end
local threads = {}
local rowThread = [[
]]

function grid.new(loc,canvas)
	if type(canvas) == "table" then
		field.hasTexture = true
	end
	local fieldObject = setmetatable(fs.load(loc)(),field)
	return fieldObject
end

function field:preLoad()
	if self.useProjectSettings then
		self.settings = grid.settings
	end
	for y = 1, #self, 1 do
		for x = 1, #self[y], 1 do
			
		end
	end
end

function field:update(dt)
	
end

function field:preRenderAdjust(yaw,pitch)
	
end

function field:draw()
	
end
