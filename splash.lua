
splash = {}
local layers = {}
local keys = {}

function splash.getLayer(a) -- we should not end up in the splash dungeon.
	if layers[a] == nil then
		layers[a] = {}
		if keys[1] == nil then keys[1] = a else
			local cond = true
			local pos = 1
			while cond do
				if keys[pos] == nil then
					keys[pos] = a
					cond = false
				elseif a < keys[pos] then 
					table.insert(keys,pos,a)
					cond = false
				elseif a == keys[pos] then
					cond = false
					print("error code: splash dungeon")
				else
					pos = pos + 1
				end
			end
		end
	end
	return layers[a]
end

function splash.setPrio(dir)
	if dir == "up" then splash.draw = splash.drawup end
	if dir == "down" then splash.draw = splash.drawdown end
end

function splash.drawup()
	for n = 1, #keys, 1 do
		for k, v in next, layers[keys[n]] do
			v()
		end
	end
end

function splash.drawdown()
	for n = #keys, 1, -1 do
		for k, v in next, layers[keys[n]] do
			v()
		end
	end
end
