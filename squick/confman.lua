
local conf = {}
local fs = love.filesystem
local fx = love.graphics
local stor = {}
local curs = {}
local prvw = {}
local frb = false

function conf.load()
	print("yup")
	if type(fs.getInfo("config/default")) == "table" then
		stor = fs.load("config/default")()
		if stor.firstrun then
			frb = true
		end
	end
end

function conf.mgr(curr)
	
end

function conf.update()

end

function conf.draw()

end
codex.add("conf",conf)
return conf
