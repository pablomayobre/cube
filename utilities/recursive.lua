return function (folder)
    local lfs = love.filesystem
    local filesTable = lfs.getDirectoryItems(folder)
	
	local folders = {}
	local files = {}
	
    for i,v in ipairs(filesTable) do
        local file = folder.."/"..v
        if lfs.isFile(file) then
            files[#files + 1] = v
        elseif lfs.isDirectory(file) then
			folders[#folders + 1] = v
        end
    end
	
	table.sort(files)
	table.sort(folders)
	
    return folders, files
end