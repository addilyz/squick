

bubble = {}
local floe = {}
local theme = {
	background = {r = .20, g = .19, b = .20, a = 1},
	primary = {r = .18, g = .17, b = .18, a = 1},
	activity = {r = .8, g = .8, b = .8, a = 1},
	text = {r = 1, g = 1, b = 1, a = 1}
}
local spec = {}
local floa = 0

function bubble.open(tab,colortheme)
	bubble.data = tab
	bubble.sel = {false,bubble.data.defaultSel,false}
	if colortheme then theme = colortheme end
	if melty.prio == "up" then floa = 10000 floe = melty.getLayer(10000) end
	if melty.prio == "down" then floa = 1 floe = melty.getLayer(1) end
	floe.bubble = bubble.floefunc
	spec[1] = love.graphics.getWidth()/2
	spec[2] = love.graphics.getHeight()/2
end

function bubble.update()
	
end

function bubble.keypressed(k)
	if k == "left" then bubble.sel[2] = bubble.sel[2] - 1 end
	if k == "right" then bubble.sel[2] = bubble.sel[2] + 1 end
	if k == "space" or k == "return" then
		if type(bubble.data.selOuts[bubble.sel[2]]) == "function" then
			bubble.data.selOuts[bubble.sel[2]](bubble.data.selArgs[bubble.sel[2]])
		end
	end
end

function bubble.close()
	melty.remove("bubble",{floa})
	codex.delete("bubble")
	bubble.data = nil	
end

function bubble.mousepressed(mx,my,mb)
	
end

function bubble.mousereleased(mx,my,mb)
	
end

function bubble.floefunc()
	love.graphics.push()
	love.graphics.translate(spec[1],spec[2])
	bubble.setColor("background")
	love.graphics.rectangle("fill",-250,-150,500,300)
	bubble.setColor("primary")
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("line",-250,-150,500,300)
	if bubble.sel[2] == 1 then bubble.setColor("activity") end
	love.graphics.rectangle("fill",-150,50,100,50)
	if bubble.sel[2] == 1 then
		bubble.setColor("primary")
	else
		bubble.setColor("activity")
	end
	love.graphics.rectangle("fill",50,50,100,50)
	love.graphics.pop()
end

function bubble.setColor(key)
	love.graphics.setColor(
		theme[key]["r"],
		theme[key]["g"],
		theme[key]["b"],
		theme[key]["a"]
	)
end

return bubble
