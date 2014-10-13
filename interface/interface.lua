local rounded = require "interface.roundrect"
local scrollbar = require "interface.scrollbar"
local recursive = require "utilities.recursive"
local collisions = require "interface.collisions"

local w,h = love.window.getDimensions()
local cube = love.graphics.newImage("assets/cube.png")

local display = {
	folder = {"Games"},
	folders = {},
	files = {},
	lineheight = 18,
	font = love.graphics.newFont("assets/verdana.ttf",16), --Didnt know what font to use so... yeah VERDANA!!
	half = 3,
	reload = false
}

local run = function (file)
	if string.match(file,"[/\\]*([%w,%s]*%.love)$") then
		execution.run = true
		execution.firsttime = true
		love.filesystem.mount(table.concat(display.folder,"/").."/"..file,execution.folder)
		display.folder = {execution.folder}
		execution.file = table.concat(display.folder,"/").."/"..file
		display.reload = true
	else
		print "false"
	end
end
local open = function (file) 
	display.folder[#display.folder + 1] = file
	display.reload = true
end

display.folders, display.files = recursive(table.concat(display.folder,"/"))
display.height = (#display.folders + #display.files) * display.lineheight
scrollbar.update(display.height)

local interface = {
	update = function (reload)
		if reload or display.reload then
			display.folders, display.files = recursive(table.concat(display.folder,"/"))
			display.height = (#display.folders + #display.files) * display.lineheight
			scrollbar.update(display.height)
			display.reload = false
		else
			scrollbar.update()
		end
	end;
	mousepressed = function (x,y,b)
		scrollbar.mousepressed(x,y,b)
		if b == "l" then
			local box = scrollbar.area
			if collisions.box(x,y,box.x,box.y,box.width,box.height) then
				local y = y - box.y + scrollbar.content.y
				index = math.ceil(y / 18)
				if index <= (#display.folders + #display.files) then
					if index > #display.folders then
						run(display.files[index - #display.folders])
					else
						open(display.folders[index])
					end
				end
			elseif collisions.box(x,y,scrollbar.area.x,190,25 + 550 - scrollbar.area.x,20) then
				local xb = scrollbar.area.x
				local newfolder = {}
				for k,v in ipairs(display.folder) do
					local width = display.font:getWidth(v) + 14
					if k == #display.folder then
						return
					end
					if x < (width + xb) and x > xb then
						newfolder[#newfolder + 1] = v
						display.folder = newfolder
						display.reload = true
						return
					else
						newfolder[#newfolder + 1] = v
						xb = xb + width + 5
					end
				end
			end
		end
	end;
	mousereleased = function (x,y,b)
		scrollbar.mousereleased(x,y,b)
	end;
	keypressed = function (k,r)
		if k == "backspace" then
			if #display.folder > 1 then
				display.folder[#display.folder] = nil
				display.reload = true
			else
				display.folder = {"Games"}
				display.reload = true
				if execution.file then love.filesystem.unmount(execution.file) end
			end
		elseif k == "up" then
			scrollbar.moveup()
		elseif k == "pageup" then
			for i=0,5 do
				scrollbar.moveup()
			end
		elseif k == "down" then
			scrollbar.movedown()
		elseif k == "pagedown" then
			for i=0,5 do
				scrollbar.movedown()
			end
		elseif k == "escape" then
			love.event.quit()
		elseif k == "lalt" or k == "ralt" then
			scrollbar.step = 1
		end
	end;
	keyreleased = function (k,r)
		if k == "lalt" or k == "ralt" then
			scrollbar.step = 5
		end
	end;
	draw = function (progress)
		local lg = love.graphics
		
		lg.setFont(display.font)
		
		lg.setColor(255,255,255,255)
		lg.setBackgroundColor(255,255,255)
		
		lg.draw(cube,0,0) --Title
		
		--Main square
		lg.setColor(220,220,255)
		lg.rectangle("fill",25,185,550,280)
		lg.setColor(155,155,255)
		lg.rectangle("line",25,185,550,280)
		--Progress bar
		lg.setColor(234,196,196)
		lg.rectangle("fill",0,h - 15,600,15)
		lg.setColor(186,140,119)
		lg.rectangle("line",0,h - 15,600,15)
		--Separation Line
		lg.setColor(0,0,109)
		lg.line(35,215,565,215)
		--Folder indicators
		lg.setScissor(25,185,550,30)
			local x = scrollbar.area.x
			for k,v in ipairs(display.folder) do
				local width = display.font:getWidth(v) + 14
				lg.setColor(240,240,255)
				rounded("fill",x,190,width,20,5,5)
				lg.setColor(96,103,210)
				rounded("line",x,190,width,20,5,5)
				lg.setColor(0,0,109)
				lg.print(v,x + 7,190)
				x = x + width + 5
			end
		lg.setScissor()
		--Scrollbar
		scrollbar.draw()
		--Progress Indicator
		if progress >= 0 then
			lg.setColor(255,0,0,128)
			lg.rectangle("fill",0,h - 15,w * (progress or 0)/100,15)
		end
		--Scrolling area (files and folders)
		lg.setScissor(scrollbar.area.x,scrollbar.area.y,scrollbar.area.width,scrollbar.area.height)
			lg.push()
				lg.translate(scrollbar.area.x,scrollbar.area.y - scrollbar.content.y)
				lg.setColor(0,0,109)
				for k,v in ipairs(display.folders) do
					lg.print("- "..v,0,(k-1)*display.lineheight + (k>1 and display.half or 0))
				end
				for k,v in ipairs(display.files) do
					lg.print(v,0,(#display.folders + k-1)*display.lineheight + display.half)
				end
			love.graphics.pop()
		love.graphics.setScissor()
	end;
}

return interface