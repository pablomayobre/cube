-- @module Scrollbar
-- @author Positive07 - Pablo A. Mayobre
-- @license MIT License
-- @release 0.1.0

local class = require "utilities.middleclass"

--- Simple Bounding Box collision check
-- @local box
-- checks collisions between a point and a box defined by it x position, its y position and it's width and height.
-- @tparam number x The horizontal position of the point
-- @tparam number y The vertical position of the point
-- @tparam number xb The horizontal position of the box
-- @tparam number yb The vertical position of the box
-- @tparam number wb The width of the box
-- @tparam number hb The height of the box
local box = function (x, y, xb, yb, wb, hb)
	return xb < x and x < (xb + wb) and yb < y and y < (yb + hb)
end

--- The scrollbar class
-- @classmod scrollbar
local scrollbar = class "scrollbar"

--- Creating a new scrollbar
-- A new scrollbar is created a new object.
-- This object needs to know it's position, and three different sizes (to determine the height)
-- @tparam number x the x position where the scrollbar will be drawn
-- @tparam number y the y position for the scrollbar
-- @tparam number size this is the size of the whole scrollbar
-- @tparam number width the width of the scrollbar
-- @tparam number cont the size of the whole content
-- @tparam number area the size of the area where the content will be drawn
-- @return scrollbar a new scrollbar
function scrollbar:initialize (x, y, size, width, cont, area)
	-- @todo Add a type argument to handle horizontal scrollbars
	local x		= type(x)=="number" 	and x or 0
	local y		= type(y)=="number" 	and y or 0
	local size	= type(size)=="number" 	and size or 1
	local width	= type(width)=="number"	and width or 1
	local cont	= type(cont)=="number" 	and cont or 1
	local area	= type(area)=="number" 	and area or 1

	self.step = 5

	self.area = area
	self.color = {}

	self.x = width < 0 and x + width or x
	self.y = size < 0 and y + size or y

	self.w = width < 0 and - width or width
	self.h = size < 0 and - size or size

	self.handle = {
		x = self.x,
		y = 0,
		w = self.w,
		h = self.h
	}

	self.click = {
		y = 0,
		currenty = 0,
		clicked = false
	}

	self.onHovered = function () return end
	self.onClicked = function () return end

	self.minsize = 30

	self:setContent(cont or 0)
end

--- Set the position
-- Change the position of the scrollbar in screen to a different possition defined as a point with x and y
-- @tparam number x the position in the horizontal axis
-- @tparam number y the position in the vertical axis
function scrollbar:setPosition(x,y)
	self.x = x or self.x
	self.y = y or self.y
	self.handle.x = x or self.x
end

--- Sets the scrollbar size
-- This sets how much space the scrollbar has to move and resize in.
-- @tparam number size the new size of the scrollbar
-- @tparam number width the new width of the scrollbar
function scrollbar:setSize(size,width)

	local p
	if size ~= self.h and size then
		p = self:getScrollPosition()
	end

	local size,width = size or self.h, width or self.w

	if size < 0 then
		self.y = self.y + size
		self.h = - size
	else
		self.h = size
	end

	if width < 0 then
		self.x = self.x + width
		self.w = - width
	else
		self.w = width
	end

	if p then
		self:setScrollPosition(p)
	end

	self.handle.w = self.w
end

--- Sets the area
-- Sets the area of the viewport, this is useful when resizing and such
-- @tparam number area the new size of the area
function scrollbar:setArea(area)
	if area then
		local area = area > 0 and area or - area
		local p = self:getScrollPosition()
		local oldarea = self.area

		self.area = area
		self.handle.h = math.max(self.area * self.h / self.content, self.minsize)
		self.content = (self.content > self.area and self.content > oldarea) and self.content or self.area

		self:setScrollPosition(p)

		self:setContent(self.content) --This works for now, but should be fixed... its kind of an ugly hack
	end
end

--- Set the content height
-- Every time the contents height changes you must update the scrollbar to resize accordingly, to do that use this function
-- @tparam number cont the content height
function scrollbar:setContent(cont)
	if cont then
		local cont = cont > 0 and cont or - cont

		local a = self.h - self.handle.h
		local t = a > 0 and self.handle.y * (self.content - self.area) / a or 0
		if t > cont then
			t = cont
		end

		self.content = cont > self.area and cont or self.area
		self.handle.h = math.max(self.area * self.h / self.content, self.minsize)

		a = self.content - self.area 
		local newy = a > 0 and t * (self.h - self.handle.h) / a or 0
		local maxy = self.h - self.handle.h
		self.handle.y = math.max(math.min(newy, maxy),0)
	end
end

--- Get the scrolling position
-- This functions allows you to get the content position as the percentage of scrolling
-- 1 meaning that the content is scrolled to the bottom and 0 indicating that it is scrolled at the top
-- @treturn number p a number from 0 to 1 indicating the position
function scrollbar:getScrollPosition()
	return (self.h - self.handle.h) == 0 and 0 or self.handle.y / (self.h - self.handle.h)
end

--- Set the scrolling position
-- This functions sets the position of the content with a number indicating the percentage of scrolling
-- @tparam number p a number from 0 to 1 indicating the position
function scrollbar:setScrollPosition(p)
	local p = p > 1 and 1 or p < 0 and 0 or p
	self.handle.y = (self.h - self.handle.h) * p
end

--- Move the content up
-- You can use this function to move the content up by a step
-- @tparam number step the size of the step, defaults to scrollbar.step (5)
function scrollbar:moveUp (step)
	local step = step or self.step
	self.handle.y = math.max(self.handle.y - step, 0)
end

--- Move the content down
-- You can use this function to move the content down by a step
-- @see scrollbar:moveUp
-- @tparam number step the size of the step, defaults to scrollbar.step (5)
function scrollbar:moveDown (step)
	local step = step or self.step
	self.handle.y = math.min(self.handle.y + step, self.h - self.handle.h)
end

--- Updating the scrollbar
-- The scrollbar must be updated so that it resembles the lastest changes. Doing this is simple, just call this method in love.update.
-- You must pass the current position of the mouse, and the delta time of the update, but currently it is not used so you could get ahead of it and pass nil
-- This method calculates how much the content must be displaced to match the position of the scrollbar, and returns it as a value.
-- @tparam number x the horizontal position of the mouse (love.mouse.getX)
-- @tparam number y the vertical position of the mouse (love.mouse.getY)
-- @treturn number disp how much the content needs to be translated
function scrollbar:update (x, y)
	assert (type(x)=="number", "Argument #2 at scrollbar:update, number expected got "..type(x))
	assert (type(y)=="number", "Argument #3 at scrollbar:update, number expected got "..type(y))

	if self.click.clicked then
		local newy = self.click.currenty + (y - self.click.y)
		local maxy = self.h - self.handle.h
		self.handle.y = math.max(math.min(newy, maxy),0)
	else
		local xb, yb = self.x, self.y + self.handle.y
		local wb, hb = self.w, self.handle.h
		local yc, hc = self.y, self.h
		if box(x,y,xb,yb,wb,hb) then
			self:onHovered("handle")
		elseif box(x,y,xb,yc + 10,wb,hc - 20) then
			if y > yb then
				self:onHovered("up")
			else
				self:onHovered("down")
			end
		else
			self:onHovered("none")
		end
	end

	local height = (self.content - self.area)
	local contah = (self.h - self.handle.h)
	local radio = contah > 0 and height / contah or 0

	return -(self.handle.y * radio) or 0
end

--- Drawing the scrollbar
-- This method is used to draw the scrollbar in screen, you dont need to specify any parameter.
-- This method must be called in the love.draw callback.
function scrollbar:draw ()
	if self.handle.h < self.h then
		local r,g,b,a = love.graphics.getColor()
		love.graphics.setColor(self.color[1] or r, self.color[2] or g, self.color[3] or b, self.color[4] or a)
		love.graphics.rectangle("fill", self.handle.x, self.y + self.handle.y, self.handle.w ,self.handle.h)
		love.graphics.setColor(r, g, b, a)
	end
end

--- Mouse pressed event
-- Many of the functions of the scrollbar are based on the mouse. So nowing it's position and when it is clicked is a must.
-- For this task you must call this function in your love.mousepressed event.
-- @tparam number x the mouse horizontal position
-- @tparam number y the mouse vertical position
-- @tparam string b the button pressed in the mouse
function scrollbar:mousepressed (x,y,b)
	if self.handle.h < self.h then
		local max,min = math.max,math.min
		if b == "l" then
			local xb, yb = self.x, self.y + self.handle.y
			local wb, hb = self.w, self.handle.h
			local yc, hc = self.y, self.h

			if box(x,y,xb,yb,wb,hb) then
				self:onClicked("handle")
				self.click = {y = y, currenty = self.handle.y, clicked = true}
			elseif box(x,y,xb,yc + 10,wb,hc - 20) then
				if y > yb then
					self:onClicked("up")
					self.handle.y = y - self.y - self.handle.h + 10
				else
					self:onClicked("down")
					self.handle.y = y - self.y - 10
				end
				self.click = {y = y, currenty = self.handle.y, clicked = true}
			end
		end

		if b == "wu" then
			self:onClicked("wheel up")
			self.handle.y = max(self.handle.y - self.step, 0)
		elseif b == "wd" then
			self:onClicked("wheel down")
			self.handle.y = min(self.handle.y + self.step, self.h - self.handle.h)
		end
	end
end

--- Mouse released event
-- We also need to know when and where the mouse buttons are released.
-- For this task you must call this function in your love.mousereleased event.
-- @tparam number x the mouse horizontal position
-- @tparam number y the mouse vertical position
-- @tparam string b the button that was released
function scrollbar:mousereleased (x,y,b)
	if b == "l" then
		if self.click.clicked then
			self:onClicked("none")
		end
		self.click.clicked = false
	end
end

return scrollbar