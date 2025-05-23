
index = {}
local file = {}
file.__index = file
local fs = love.filesystem
local struct = {}
local struct.ignore = {{1,"."}}
local catalog = {}
local root = {}

function index.filter(ft)
		
end

function index.file(key,dir)
	index.files[key] = {}
	index.files[key].file = setmetatable(fs.load(dir)(),file)
	index.files[key].addr = dir
	return index.files[key]
end

function index.structure()
	catalog["root"] = fs.getDirectoryItems("/")
	root = catalog["root"]
	index.filter(root)
	for n = 1, #root, 1 do
		print(tostring(n) .. ". " .. root[n])
	end
end

return index
