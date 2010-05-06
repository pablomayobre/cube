local width,height
local logo 		= require "interface.logo"
local interface	= require "interface.files"

love.load = function ()
	width,height = love.graphics.getDimensions()
	logo:load()
	files:load(width,height)
end

love.update = function (dt)
	
end

love.draw = function ()
	logo:draw(width,height)
	files:draw()
end

love.mousepressed = function ()
	
end

love.mousereleased = function ()
	
end

love.resize = function (w,h)
	width,height = w,h
end