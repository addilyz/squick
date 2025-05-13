
melty = {}
local layer = {}
layer.__index = layer
local layers = {}
local keys = {}

function melty.getLayer(a) -- if you achieve melty panic please tell me.
	if layers[a] == nil then
		layers[a] = {}
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
				print("error code: melty panic")
			else
				pos = pos + 1
			end
		end
	end
	return layers[a]
end

function melty.remove(key,layertab)
	if layertab then
		for n = 1, #layertab, 1 do
			layers[layertab[n]][key] = nil
		end
	else
		for n = 1, #keys, 1 do
			if layers[keys[n]][key] then
				layers[keys[n]][key] = nil
			end
		end
	end
end

function melty.setPrio(dir)
	if dir == "up" then melty.draw = melty.drawup end
	if dir == "down" then melty.draw = melty.drawdown end
	melty.prio = dir
end

function melty.drawup()
	for n = 1, #keys, 1 do
		for k, v in next, layers[keys[n]] do
			v()
		end
	end
end

function melty.drawdown()
	for n = #keys, 1, -1 do
		for k, v in next, layers[keys[n]] do
			v()
		end
	end
end
