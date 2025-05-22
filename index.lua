
index = {}
local file = {}
file.__index = file
fs = love.filesystem
struct = {}

function index.file(key,loc)

	index.files[key] = {
		file = setmetatable(fs.load(loc)(),file),
		addr = loc
	}
	return index.files[key]
end

function index.structure()
	love.filesystem.getDirectoryItems("/")
	
end

return index

function file:add(key,data)
	self[key] = data
end
