local collisions = {
	--Checks if a point is within a box
	--Arguments:
	--	x = x position of the point
	--	y = y position of the point
	--	xb = x position of the box
	--	yb = y position of the box
	--	wb = width of the box
	--	hb = height of the box
	--Returns: true if the point is inside the box, false if not
	box = function (x, y, xb, yb, wb, hb)
		return xb < x and x < (xb + wb) and yb < y and y < (yb + hb)
	end;
	--Checks if a point is within a circle
	--Arguments:
	--	x = x position of the point
	--	y = y position of the point
	--	xc = x position of the circle
	--	yc = y position of the circle
	--	rc = radius of the circle
	--Returns: true if the point is inside the circle, false if not
	circle = function (x, y, xc, yc, rc)
		local dx = x - xc
		local dy = y - yc
		return dx^2 + dy^2 < rc ^ 2
	end;
	--Checks collisions between two rectangles
	--Arguments:
	--	x1 = x position of the first box
	--	y1 = y position of the first box
	--	w1 = width of the first box
	--	h1 = height of the first box
	--	x2 = x position of the second box
	--	y2 = y position of the second box
	--	w2 = width of the second box
	--	h2 = height of the second box
	--Returns: true if the boxes collide false if not
	boxes = function (x1, y1, w1, h1, x2, y2, w2, h2)
		return x1 < (x2 + w2) and x2 < (x1 + w1) and y1 < (y2 + h2) and y2 < (y1 + h1)
	end;
	--Checks collisions between two circles
	--Arguments:
	--	ax = x position of the first circle
	--	ay = y position of the first circle
	--	ar = radius of the first circle
	--	bx = x position of the second circle
	--	by = y position of the second circle
	--	br = radius of the second circle
	--Returns: true if the circles collide false if not
	circles = function (ax, ay, ar, bx, by, br)
		local dx = bx - ax
		local dy = by - ay
		return dx^2 + dy^2 < (ar + br)^2
	end
}
return collisions