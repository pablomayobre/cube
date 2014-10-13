return function (mode, x, y, width, height, xround, yround, num)
	if not num then bl,br,tr,tl = true, true, true, true else
		local s = 0
		if num%2 - s == 1 then bl = true; s = s + 1 else bl = false end
		if num%4 - s == 2 then br = true; s = s + 2 else br = false end
		if num%8 - s == 4 then tr = true; s = s + 4 else tr = false end
		if num%16 - s == 8 then tl = true else tl = false end
	end
	local points, precision = {}, (xround + yround)
	local hP, sin, cos = .5*math.pi, math.sin, math.cos
	if xround > width*.5 then xround = width*.5 end
	if yround > height*.5 then yround = height*.5 end
	local X1, Y1, X2, Y2 = x + xround, y + yround, x + width - xround, y + height - yround
	if tr then
		for i = 0, precision do
			local a = (i/precision-1)*hP
			points[#points+1] = X2 + xround*cos(a)
			points[#points+1] = Y1 + yround*sin(a)
		end
	else
		points[#points+1] = x + width
		points[#points+1] = y
	end
	if br then
		for i = 0, precision do
			local a = (i/precision)*hP
			points[#points+1] = X2 + xround*cos(a)
			points[#points+1] = Y2 + yround*sin(a)
		end
	else
		points[#points+1] = x + width
		points[#points+1] = y + height
	end
	if bl then
		for i = 0, precision do
			local a = (i/precision+1)*hP
			points[#points+1] = X1 + xround*cos(a)
			points[#points+1] = Y2 + yround*sin(a)
		end
	else
		points[#points+1] = x
		points[#points+1] = y + height
	end
	if tl then
		for i = 0, precision do
			local a = (i/precision+2)*hP
			points[#points+1] = X1 + xround*cos(a)
			points[#points+1] = Y1 + yround*sin(a)
		end
	else
		points[#points+1] = x
		points[#points+1] = y
	end
	love.graphics.polygon(mode, unpack(points))
end


