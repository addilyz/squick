
chart = {}
local curs = {16,16}
local res = {32,32}
local cam = {love.graphics.getWidth()/20,love.graphics.getHeight()/20,10}
cam[1] = cam[1] - res[1]/2
cam[2] = cam[2] - res[2]/2
local down = {down = false, left = false, up = false, right = false}
local repeattoy = {2,4,8,1,0,1,0}
local project = {}
local pointex = {}
love.graphics.setDefaultFilter("nearest","nearest")
local camcan = love.graphics.newCanvas(res[1],res[2])
local page = {}
project.__index = project

function codex.load.chart()
	print("haii")
	local tex = love.graphics.newCanvas()
	love.graphics.setBackgroundColor(.11,.11,.1)
	love.graphics.setCanvas(tex)
	love.graphics.points(1,1)
	love.graphics.setCanvas()
	local idt = tex:newImageData()
	pointex = love.graphics.newImage(idt)
	page = codex.pages.getPage(1)
	page.chart = chart.drawf
end

function codex.keypressed.chart(k)
	print(k)
	if k == "down" then curs[2] = curs[2] + 1 down[k] = true end
	if k == "up" then curs[2] = curs[2] - 1 down[k] = true end
	if k == "left" then curs[1] = curs[1] - 1 down[k] = true end
	if k == "right" then curs[1] = curs[1] + 1 down[k] = true end
	if curs[1] < 0 then curs[1] = 0 end
	if curs[2] < 0 then curs[2] = 0 end
	if curs[1] > res[1]-1 then curs[1] = res[1]-1 end
	if curs[2] > res[2]-1 then curs[2] = res[2]-1 end
end

function codex.update.chart(dt)
	if down.down == false and down.up == false and down.left == false and down.right == false then 
		repeattoy[5] = 0
		repeattoy[6] = 1
		repeattoy[7] = 0
	else
		repeattoy[5] = repeattoy[5] + dt
		if repeattoy[5] >= repeattoy[4] then
			repeattoy[5] = 0
			repeattoy[6] = repeattoy[6] + 1
			if repeattoy[6] > 3 then repeattoy[6] = 3 end
		end
		repeattoy[7] = repeattoy[7] + dt
		if 1/repeattoy[repeattoy[6]] < repeattoy[7] then
			repeattoy[7] = repeattoy[7] - 1/repeattoy[repeattoy[6]]
			for k,v in next, down do
				if v then codex.keypressed.chart(k) end
			end
		end
	end
end

function codex.keyreleased.chart(k)
	if k == "down" or k == "right" or k == "left" or k == "up" then
		down[k] = false
	end
end

function chart.drawf()
	love.graphics.push()
	love.graphics.setCanvas(camcan)
	love.graphics.clear()
	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle("fill",0,0,res[1],res[2])
	love.graphics.setColor(.8,.8,.8,1)
	love.graphics.rectangle("fill",res[1]/4,0,res[1]/4,res[2]/4)
	love.graphics.rectangle("fill",0,res[2]/4,res[1]/4,res[2]/4)
	love.graphics.rectangle("fill",res[1]*3/4,0,res[1]/4,res[2]/4)
	love.graphics.rectangle("fill",0,res[2]*3/4,res[1]/4,res[2]/4)
	love.graphics.rectangle("fill",res[1]/2,res[2]/4,res[1]/4,res[2]/4)
	love.graphics.rectangle("fill",res[1]/4,res[2]/2,res[1]/4,res[2]/4)
	love.graphics.rectangle("fill",res[1]/2,res[2]*3/4,res[1]/4,res[2]/4)
	love.graphics.rectangle("fill",res[1]*3/4,res[2]/2,res[1]/4,res[2]/4)
	love.graphics.setCanvas()
	love.graphics.scale(cam[3])
	love.graphics.setColor(.05,.05,.05,.1)
	love.graphics.push()
	love.graphics.translate(cam[1],cam[2])
	love.graphics.rectangle("fill",-1,-1,res[1]+2,res[2]+2)
	love.graphics.pop()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(camcan,cam[1],cam[2])
	local id = camcan:newImageData()
	local r,g,b,a = id:getPixel(curs[1],curs[2])
	love.graphics.translate(cam[1],cam[2])
	love.graphics.setColor(1-r,1-g,1-b,.9)
	chart.loresp(curs[1],curs[2])
	love.graphics.pop()
end

function chart.loresp(x,y) -- might need to ask someone about this.
	love.graphics.draw(pointex,x-1,y)
end
