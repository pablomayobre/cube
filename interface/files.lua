local scroll = require "interface.scrollbar"
local button = require "interface.button"

local files = {}

local checkdir = function (fold)
	if not (love.filesystem.exists(fold) and love.filesystem.isDirectory(fold)) then
		love.filesystem.createDirectory(fold)
	end
end

files:load = function (w,h)
	--Load icons
	self.fileicon = love.graphics.newImage("assets/fileicon.png")
	self.foldicon = love.graphics.newImage("assets/foldicon.png")
	--Load font
	self.font = love.graphics.newFont("assets/font.ttf",120) --Load it with higher resolution to scale it down
	--Load the font for real
	local width = self.font:getWidth("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
	local lineheight = self.font:getAscent() + self.font:getDescent()
	--Create an scrollbar
	self.scrollbar = scroll:new()
	--Check if the "games" folder exists and if it doesnt create it
	checkdir("games")
	--Start at the games folder
	self.folder = {"games"}
	--Load the files and folders in the "games" folder
	self:reload()
	
	--Scrollbar Config
	self.scrollbar.onClicked = function (t)
		if t == "handle" or t == "up" or t == "down" then
			self.gotowidth = 12
			self.gotocolor = 100
		elseif t == "none" then
			self.gotowidth = 3
			self.gotocolor = 100
		end
	end
	self.scrollbar.onHovered = function (t)
		if t == "up" or t == "down" then
			self.gotowidth = 12
			self.gotocolor = 200
		elseif t == "handle" then
			self.gotowidth = 12
			self.gotocolor = 120
		elseif t == "none" then
			self.gotowidth = 3
			self.gotocolor = 200
		end
	end
	self.scrollbar.color[4] = 100
	self.scrollbar.handle.w = 3
	self.scrollbar.handle.x = w-8
	self.scrollbar.gotocolor = 100
	self.scrollbar.gotowidth = 3
end

files:update = function (dt)
	local x,y = love.mouse.getPosition()

	self.trans = self.scrollbar:update(x,y)
	
	

	local fn = self.scrollbar.color[4] > self.scrollbar.gotocolor and math.floor or math.ceil
	self.scrollbar.color[4] = fn(self.scrollbar.color[4] + (self.scrollbar.gotocolor-self.scrollbar.color[4])* dt * 10)
	local fn = self.scrollbar.handle.w > self.scrollbar.gotowidth and math.floor or math.ceil
	self.scrollbar.handle.w = fn(self.scrollbar.handle.w + (self.scrollbar.gotowidth-self.scrollbar.handle.w)* dt * 10)
	self.scrollbar.handle.x = w - (self.scrollbar.handle.w + 5)

end

files:draw = function ()
	
end

files:reload = function ()
	--Get the path to the folder
	local folder = table.concat(self.folder,"/").."/"
	--Get the items in the folder
    local filesTable = love.filesystem.getDirectoryItems(folder)
	--Clear the files and folders
	self.files, self.folders = {}, {}
	--Look at the items in the folder
    for i,v in ipairs(filesTable) do
        local file = folder..v
		--Separate files and folders
        if love.filesystem.isFile(file) then
            self.files[#self.files + 1] = v
        elseif love.filesystem.isDirectory(file) then
			self.folders[#self.folders + 1] = v
        end
    end
	--Sort them (so they look nice), not sure if needed
	table.sort(self.files)
	table.sort(self.folders)

	self:resize()
end

file:resize = function (w,h)
	local w = w or love.graphics.getWidth()
	local h = h or love.graphics.getHeight()

	self.lineheight = 

	self.height = (#self.folders + #self.files) * self.lineheigh
	self.fontscale = self.lineheight  / lineheight

	self.scrollbar:setSize()
	self.scrollbar:setWidth()
	self.scrollbar:setPosition()

	self.scrollbar:setContent(self.height)
	self.scrollbar:setArea()
end