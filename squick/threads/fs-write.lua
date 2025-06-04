local threadCode = [[
local ostring, loc = ...
local flag = false
local channel = love.thread.getChannel(loc)
while flag == false do
	flag = love.filesystem.write(loc,ostring)
	channel:push(flag)
end
]]
