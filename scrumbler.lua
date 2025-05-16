
-- the encrypt script spits out a secondary file with the seed and cryptkey.
-- probably not that strong. probably annoying though. maybe it is strong idk.
scrumbler = {}
local blur = "abcdefghijklmnopqrstuvwxyz1234567890!@#$%^&*()`~.,<>[]{};:?/| "
local skey = ""

function scrumbler.keygen(secret) -- this may make migration headaches at some point.
	local seed = 0
	local scaley = 1
	local temp = ""
	local temp2 = ""
	local b = 0
	local z = {}
	for n = 1, #secret, 1 do
		b = 0
		if scaley > 100000000000000 then scaley = 1 end
		temp = type(secret[n])
		if temp == "string" then
			b = string.len(secret[n])
		end
		if temp == "table" then
			z = secret[n]
			for a = 1, #z, 1 do
				if scaley > 100000000000000 then scaley = 1 end
				temp2 = type(z[a])
				if temp2 == "string" then
					b = string.len(z[a])
					seed = seed + (b*scaley)
					scaley = scaley * 10
				end
				if temp2 == "table" then
					b = #z[a]
				end
				if temp2 == "boolean" then
					if z[a] then b = 11 else b = 22 end
				end
				if temp2 == "number" then b = z[a] end
				seed = seed + (b * scaley)
				scaley = scaley * 10
			end
			scaley = scaley/10
			b = 0
		end
		if temp == "boolean" then b = 23 else b = 51 end
		if temp == "number" then b = secret[n] end
		seed = seed + (b * scaley)
		scaley = scaley * 10
	end
	scrumbler.getSKey(seed)
	return seed, skey
end

function scrumbler.getSKey(seed)
	local rem = string.len(blur)
	local store = blur
	local p1 = ""
	local p2 = ""
	math.randomseed(seed)
	local a = math.random(26)
	skey = string.sub(blur,a,a)

	if a ~= 1 then
		p1 = string.sub(blur,1,a-1)
		p2 = string.sub(blur,a+1,-1)
		blur = p1 .. p2
	else
		blur = string.sub(blur,2,-1)
	end
	rem = rem - 1
	local ec = true
	while ec do
		if rem == 0 then
			ec = false
		end
		a = math.random(rem)
		skey = skey .. string.sub(blur,a,a)
		if a == 1 then
			blur = string.sub(blur,2,-1)
		elseif a == rem then
			blur = string.sub(blur,1,rem-1)
		else
			p1 = string.sub(blur,1,a-1)
			p2 = string.sub(blur,a+1,-1)
			blur = p1 .. p2
		end
		rem = rem - 1
	end
	blur = store
end

function scrumbler.encrypt(str,seed)
	if seed ~= nil then scrumbler.getSKey(seed) end
	local res = ""
	local ugh = ""
	local a = 0
	local b = 0
	for n = 1, string.len(str), 1 do
		a = string.find(skey,string.sub(str,n,n))
		res = res .. string.sub(blur,a,a)
	end
	return res
end

function scrumbler.decrypt(str,seed)
	if seed ~= nil then scrumbler.getSKey(seed) end
	local res = ""
	local nab = 0
	local a = 0
	local b = 0
	for n = 1, string.len(str),1 do
		a = string.find(blur,string.sub(str,n,n))
		res = res .. string.sub(skey,a,a)
	end
	return res
end

function scrumbler.overrideSKey(str)
	skey = str
end
