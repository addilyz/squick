local threadCode = [[
local table, dir = ...

love.thread.getChannel('complete'):push(false)
function ttfrecurse(tab,nam)
	local rstring = ""
	for k,v in next, tab do
		if type(k) == "string" then
			rstring = rstring .. nam .. "[\"" .. k .. "\"] = "
		elseif type(k) == "number" then
			rstring = rstring .. nam .. "[" .. tostring(k) .. "] = "
		end
		if type(v) == "number" then
			rstring = rstring .. tostring(v) .. "\n"
		elseif type(v) == "string" then
			rstring = rstring .. "\"" .. v .. "\"\n"
		elseif type(v) == "table" then
			rstring = rstring .. "{}\n"
			local namstring = nam .. "["
			if type(k) == "string" then
				local namstring = namstring .. "\"" .. k .. "\"]"
			else
				local namstring = namstring .. tostring(k) .. "]"
			end
			rstring = rstring .. ttfrecurse(v,namstring)
		elseif type(v) == "function" then
			rstring = rstring .. "nil\n"
		end
	end
	return rstring
end

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
		end
	end
	ostring = ostring .. "return t"
	fs.write(dir,ostring)
	love.thread.getChannel('complete'):push(true)
end

]]
return threadCode