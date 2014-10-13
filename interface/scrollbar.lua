local collisions = require "interface.collisions"
local rounded = require "interface.roundrect"
local scrollbar = {
	step = 5,
	color = {0,0,255,128},
	area = {
		height = 228,
		width = 520,
		x = 38,
		y = 224,
	};
	scroll = {
		height = 218,
		width = 12,
		x = 555,
		y = 229,
	};
	up = {
		height = 8,
		width = 12,
		x = 555,
		y = 221,
		polygon = function (self)
			return {
				self.x, self.y + self.height,
				self.x + self.width, self.y + self.height,
				self.x + self.width/2, self.y
			}
		end,
	};
	down = {
		height = 8,
		width = 12,
		x = 555,
		y = 447,
		polygon = function (self)
			return {
				self.x,self.y,
				self.x + self.width, self.y,
				self.x + self.width/2, self.y + self.height
			}
		end,
	};
	handle = {
		click = false,
		realy = 229,
		x = 555,
		y = 0,
		height = 0,
		width = 12,
	};
	click = {
		x = 0,
		y = 0
	};
	content = {
		height = 0,
		y = 0,
	}
}
scrollbar.moveup = function ()
	scrollbar.handle.y = math.max(scrollbar.handle.y - scrollbar.step, 0)
end
scrollbar.movedown = function ()
	scrollbar.handle.y = math.min(scrollbar.handle.y + scrollbar.step, scrollbar.scroll.height - scrollbar.handle.height)
end
scrollbar.update = function (totalheight)
	if totalheight then
		local max = math.max
		scrollbar.content.height = totalheight > scrollbar.area.height and totalheight or scrollbar.area.height
		scrollbar.content.y = 0
		scrollbar.handle.y = 0
		scrollbar.handle.height = max(scrollbar.area.height * scrollbar.scroll.height / scrollbar.content.height, 30)
	end
	
	local mx,my = love.mouse.getPosition()
	if scrollbar.handle.click then
		local max,min = math.max, math.min
		local newy = scrollbar.click.currenty + (my - scrollbar.click.y)
		local maxy = scrollbar.scroll.height - scrollbar.handle.height
		scrollbar.handle.y = max(min(newy, maxy),0)
	elseif scrollbar.up.pressed then
		--Here I wanted to implement some kind of acceleration
	elseif scrollbar.down.pressed then
		--Here I wanted to implement some kind of acceleration
	end
	
	local height = (scrollbar.content.height - scrollbar.area.height)
	local contah = (scrollbar.scroll.height - scrollbar.handle.height)
	local radio = contah > 0 and height / contah or 0
	
	scrollbar.content.y = scrollbar.handle.y * radio
	
end
scrollbar.mousepressed = function (x,y,b)
	if scrollbar.handle.height < scrollbar.scroll.height then
		local max,min = math.max,math.min
		if b == "l" then
			local xb,yb = scrollbar.scroll.x, scrollbar.handle.realy + scrollbar.handle.y
			local wb,hb = scrollbar.scroll.width, scrollbar.handle.height
			local yc,hc = scrollbar.scroll.y, scrollbar.scroll.height
			
			local ux, uy = scrollbar.up.x, scrollbar.up.y
			local uh, uw = scrollbar.up.height, scrollbar.up.width
			local dx, dy = scrollbar.down.x, scrollbar.down.y
			local dh, dw = scrollbar.down.height, scrollbar.down.width
			if collisions.box(x,y,xb,yb,wb,hb) then
				scrollbar.handle.click = true
				scrollbar.click = {x = x, y = y, currenty = scrollbar.handle.y}
			elseif collisions.box(x,y,xb,yc + 10,wb,hc - 20) then
				if y > yb then
					scrollbar.handle.y = y - scrollbar.handle.realy - scrollbar.handle.height + 10
				else
					scrollbar.handle.y = y - scrollbar.handle.realy - 10 
				end
				scrollbar.handle.click = true
				scrollbar.click = {x = x, y = y, currenty = scrollbar.handle.y}
			elseif collisions.box(x,y,ux,uy,uw,uh) then
				scrollbar.handle.y = max(scrollbar.handle.y - scrollbar.step, 0)
				scrollbar.up.pressed = true
			elseif collisions.box(x,y,dx,dy,dw,dh) then
				scrollbar.handle.y = min(scrollbar.handle.y + scrollbar.step, scrollbar.scroll.height - scrollbar.handle.height)
				scrollbar.down.pressed = true
			end
		end
		if b == "wu" then
			scrollbar.handle.y = max(scrollbar.handle.y - scrollbar.step, 0)
		elseif b == "wd" then
			scrollbar.handle.y = min(scrollbar.handle.y + scrollbar.step, scrollbar.scroll.height - scrollbar.handle.height)
		end
	end
end
scrollbar.mousereleased = function (x,y,b)
	if b == "l" then
		scrollbar.handle.click = false
		scrollbar.up.pressed = false
		scrollbar.down.pressed = false
	end
end
scrollbar.draw = function ()
	if scrollbar.handle.height < scrollbar.scroll.height then
		local lg = love.graphics
		lg.setColor(scrollbar.color)
		lg.polygon("fill",scrollbar.up.polygon(scrollbar.up))
		lg.polygon("line",scrollbar.up.polygon(scrollbar.up))
		lg.polygon("fill",scrollbar.down.polygon(scrollbar.down))
		lg.polygon("line",scrollbar.down.polygon(scrollbar.down))
		rounded("fill",scrollbar.handle.x,scrollbar.handle.realy + scrollbar.handle.y,scrollbar.handle.width,scrollbar.handle.height,5,5)
		rounded("line",scrollbar.handle.x,scrollbar.handle.realy + scrollbar.handle.y,scrollbar.handle.width,scrollbar.handle.height,5,5)
	end
end
return scrollbar