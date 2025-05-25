
index = {}
local file = {}
file.__index = file
local fs = love.filesystem
local struct = {}
struct.ignore = {
	{"."},
	{
		"LICENSE","codex","tools","main.lua","README","bubble.lua",
		"index.lua","conf.lua","slides.lua"
	}
}
struct.tags = {{"code blob",".lua"},{"dir","/"},{"plaintext",""}}
local catalog = {}
local root = {}

function index.filter(ft)
	local rmbatch = {}
	for n = 1, #ft, 1 do
		if index.sec(ft[n]) then rmbatch[#rmbatch+1] = n end
	end
	index.batchrm(ft,rmbatch)
end

function index.sec(str)
	for n = 1, #struct.ignore[1], 1 do
		if string.sub(str,1,1) == struct.ignore[1][n] then return true end
	end
	local match = ""
	for n = 1, #struct.ignore[2], 1 do
		match = string.gsub(str,struct.ignore[2][n]," ")
		if match ~= str then return true end
	end
end

function index.batchrm(ft,rmb)
	for n = #rmb, 1, -1 do
		table.remove(ft,rmb[n])
	end	
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
	local it = {}
	for n = 1, #root, 1 do
		print(tostring(n) .. ". " .. root[n])
		it = fs.getInfo(root[n])
		if it.type == "directory" then
			index.dir(root[n],"/")
		end
		for k,v in next, it do
			--print(k)
		end
	end
end

function index.dir(d,route)
	local cstr = route .. d
	catalog[cstr] = fs.getDirectoryItems(cstr)
	local dtab = catalog[cstr]
	index.filter(dtab)
	local it = {}
	for n = 1, #dtab, 1 do
		it = fs.getInfo(root[n])
		if it.type == "directory" then
			print(cstr)
			index.dir(dtab[n],cstr .. "/")
		end
	end
end

return index
