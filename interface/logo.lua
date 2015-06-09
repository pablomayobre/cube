local logo = {}

logo:load = function ()
	self.icon	= love.graphics.newImage("icon.png")
	self.cube	= love.graphics.newImage("cube.png")

	self.w1,self.h1 = self.cube:getDimensions()
	self.w2,self.h2 = self.icon:getDimensions()
end

logo:draw = function (w,h)
	local self.h = h/5
	local self.w = w - (w/20)
	--Weird way to determine which image shall be used and where should it be positioned
	if self.w1 * self.h/self.h1 > self.w then
		if self.h2 * self.w/self.w2 > self.h then
			love.graphics.draw(self.icon,w/2,h/10,0,self.h/self.h2,nil,self.w2/2,self.h2/2)
			return
		else
			love.graphics.draw(self.icon,w/2,h/10,0,self.w/self.w2,nil,self.w2/2,self.h2/2)
			return
		end
	else
		love.graphics.draw(self.cube,w/2,h/10,0,self.h/self.h1,nil,self.w1/2,self.h1/2)
		return
	end
end

return logo