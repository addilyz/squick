
memmy = {}
local index = {}
local file = {}
file.__index = file
local fs = love.filesystem
local fx = love.graphics
local struct = fs.load("project/index.lua")()
struct.tags = {{"code blob",".lua"},{"dir","/"},{"plaintext",".txt"}}
local catalog = {}
local root = {}
local window = {0,0,0,0}
local cache = {}
local cachebuffer = {}
local cachert = {}
local cacheFlag = {}
local lfsWrite = love.filesystem.load("squick/core/threads/fs-write.lua")()
local lfsThreads = {}
local lfsChannels = {}

function codex.load.memmy()
	index.structure()
end

function memmy.initDirectory(loc)
	local loc = loc or "root"
	index.loc = loc
	index.cat = catalog[index.loc]
	index.cur = 1
	index.pre = {}
	if struct.window[1] < 1 then
		memmy.ratioResize(fx.getWidth(),fx.getHeight())
	end
	index.page = codex.pages.getPage(1028)
	index.page.memmy = memmy.draw
end

function memmy.loadCache()
	local cf = fs.load("db/cache")
	if cf == nil then
		fs.createDirectory("cache")
		fs.createDirectory("db")
		fs.write("db/cache","return {}")
		cf = fs.load("db/cache")
	end
	cache = cf()
end

function memmy.checkCache(ident)
	if type(cache[ident]) ~= "nil" then return true else return false end
end

function memmy.addCacheItem(lib,dir,ident)
	local ds = string.gsub(dir,"/","_")
	ds = string.gsub(dir,"-","_")
	local dir = "cache/" .. dir
	cachert[ds] = {}
	cachert[ds].ident = ident
	cachert[ds].dir = dir
	cachert[ds].lib = lib
end

function memmy.promoteToCacheBuffer(dir)
	local ds = string.gsub(dir,"/","_")
	ds = string.gsub(dir,"-","_")
	local dir = "cache/" .. dir
	cachebuffer[ds] = {}
	cachebuffer[ds].ident = cachert[ds].ident
	cachebuffer[ds].dir = cachert[ds].dir
	cachebuffer[ds].lib = cachert[ds].lib
	cachert[ds] = nil
end

function memmy.finalizeCacheBuffer()
	for k,v in next, cachebuffer do
		cache[k] = {}
		cache[k].ident = v.ident
		cache[k].dir = v.dir
		cache[k].lib = v.lib
	end
	memmy.tabtofile(cache,"db/cache")
end

function memmy.postboot(scr)
	if scr.mode == "portrait" then
		window[1] = 0
		window[2] = 0
		window[3] = 0
		window[4] = 0
	end
end

function memmy.draw()
	fx.push()
	fx.setColor(.8,.8,.8,1)
	fx.translate(window[3]/2,window[4]/2)
	fx.rectangle("fill",-window[1]/2,-window[2]/2,window[1],window[2])
	fx.pop()
	fx.push()
	fx.scale(12)
	fx.setColor(0,0,0,1)
	--fx.print(cxscreen.mode)
	fx.pop()
end

--[[function codex.resize.memmy(w,h)
	local scr = {}
	if w < h and w > 100  then
		scr.mode = "portrait"
		scr[1] = w
		scr[2] = (cxscreen[1]/800)*600
	elseif w < 100 then
		love.window.setMode(800,600)
		scr[1] = 800
		scr[2] = 600
		scr.mode = "window"
	else
		scr.mode = "window"
		scr[1] = 800
		scr[2] = 600
	end
	memmy.postboot(scr)
	memmy.ratioResize(w,h)
end]]--

function codex.keyreleased.memmy(k)
	if k == "lshift" or k == "rshift" then memmy.ratioResize(fx.getWidth(),fx.getHeight()) end
end

function memmy.ratioResize(w,h)
	if w < 800 then w = 800 end
	if h < 600 then h = 600 end
	window[1] = w*struct.window[1]
	window[2] = h*struct.window[2]
	window[3] = w
	window[4] = h
	window[5] = (window[1] - window[3])
	window[6] = (window[2] - window[4])
end

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

function index.loadFile(catalog,key,dir)
	index.files[key] = {}
	index.files[key].file = setmetatable(fs.load(dir .. key)(),file)
	index.files[key].addr = dir .. key
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
			index.dir(root[n],"/","root")
		end
		for k,v in next, it do
			--print(k)
		end
	end
end

function index.dir(d,route,cstr)
	local bstr = route .. d .. "/"
	local dstr = cstr .. d
	catalog[cstr] = fs.getDirectoryItems(bstr)
	local dtab = catalog[cstr]
	index.filter(dtab)
	local it = {}
	for n = 1, #dtab, 1 do
		it = fs.getInfo(bstr .. dtab[n])
		if it and it.type == "directory" then
			print(dstr .. dtab[n])
			index.dir(dtab[n],bstr,dstr)
		end
	end
end

function memmy.tabtofile(table,dir)
	local ostring = "local t = {}\n"
	for k,v in next, table do
		if type(k) == "string" then
			ostring = ostring .. "t." .. k .. " = "
		elseif type(k) == "number" then
			ostring = ostring .. "t[" .. tostring(k) .. "] = "
		end
		if type(v) == "number" then
			ostring = ostring .. tostring(v) .. "\n"
		elseif type(v) == "string" then
			ostring = ostring .. "\"" .. v .. "\"\n"
		elseif type(v) == "table" then
			ostring = ostring .. "{}\n"
			local namestring = "t"
			if type(k) == "string" then
				namestring = namestring .. "[\"" .. k .. "\"]"
			else
				namestring = namestring .. "[" .. tostring(k) .. "]"
			end
			ostring = ostring .. memmy.ttfrecurse(v,namestring)
		elseif type(v) == "function" then
			ostring = ostring .. "nil\n"
		elseif type(v) == "boolean" then
			if v then
				ostring = ostring .. "true\n"
			else
				ostring = ostring .. "false\n"
			end
		end
	end
	ostring = ostring .. "return t"
	lfsThreads[#lfsThreads+1] = love.thread.newThread(lfsWrite)
	lfsThreads[#lfsThreads]:start(ostring,dir)
	lfsChannels[#lfsChannels+1] = love.thread.getChannel(dir)
end

function codex.update.memmy(dt)
	for n = 1, #lfsChannels, 1 do
		if lfsChannels[n]:pop() == true then
			table.remove(lfsChannels,n)
			table.remove(lfsThreads,n)
			return
		end
	end
end

function memmy.ttfrecurse(table,name)
	local ostring = ""
	for k,v in next, table do
		if type(k) == "string" then
			ostring = ostring .. name .. "[\"" .. k .. "\"] = "
		elseif type(k) == "number" then
			ostring = ostring .. name .. "[" .. tostring(k) .. "] = "
		end
		if type(v) == "number" then
			ostring = ostring .. tostring(v) .. "\n"
		elseif type(v) == "string" then
			ostring = ostring .. "\"" .. v .. "\"\n"
		elseif type(v) == "table" then
			ostring = ostring .. "{}\n"
			local namestring = name .. "["
			if type(k) == "string" then
				local namestring = namestring .. "\"" .. k .. "\"]"
			else
				local namestring = namestring .. tostring(k) .. "]"
			end
			ostring = ostring .. memmy.ttfrecurse(v,namestring)
		elseif type(v) == "function" then
			ostring = ostring .. "nil\n"
		elseif type(v) == "boolean" then
			if v then
				ostring = ostring .. "true\n"
			else
				ostring = ostring .. "false\n"
			end
		end
	end
	return ostring
end
