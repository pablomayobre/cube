-- @module Button
-- @author Positive07 - Pablo A. Mayobre
-- @license MIT License
-- @release 0.0.1

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

--- The button class
-- @classmod button
local button = class "button"

--- Create a new button
-- Creates a new button object with the specified size in a determined position, with an optional text or as an image
-- NOTE: Image have precedence over text, so if you specify an image the image will be drawn always
-- @tparam number x The horizontal position of the button
-- @tparam number y The vertical position of the button
-- @tparam number w The width of the button
-- @tparam number h The height of the button
-- @tparam function fn The callback triggered whenever the button is pressed
-- @tparam string text An optional text to be shown inside of the button
-- @tparam Image image An image to be shown instead of the button
function button:initialize (x,y,w,h,fn,text,image)
	self.x = x or 0
	self.y = y or 0
	self.w = w or 0
	self.h = h or 0
	
	self.callback = fn
	
	self.state = "none"
	
	local text = text or ""
	if type(text) == "string" then
		self.text = text
	elseif text:type() == "Image" then
		image = text
		self.text = ""
	end
	
	self.image = image
end

function button:mousepressed ()

