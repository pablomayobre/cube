require "love.filesystem" --We need filesystem

local folder = ... --We get which folder we are going to save the files in
local prog = love.thread.getChannel("progress") --Channel used to report progress
local cone = love.thread.getChannel("conection") --Channel used to know which files we need to copy

local function copy (path, directory)
	if not path or path == "" then --We dont want empty paths
		return false, "The specified path is nil or empty"
	end
	directory = directory and directory.."/" or "" --we need to save things to a directory so we add the backslash

	if not love.filesystem.exists(directory) then --If the directory doesnt exist
		assert(love.filesystem.createDirectory(directory)) --We create it
	end

	if path:find(".+%.love$") then --you need to path a .love file or else we wont copy the file
		--Supplied a love file so we binary copy it
		local file = assert(io.open(path,"rb")) --open file as binary

		local current = file:seek()			-- get current position
		local size = file:seek("end")		-- get file size
		file:seek("set", current)			-- restore position
		current = nil						-- delete the current variable

		local name = string.match(path,"[/\\]*([%w,%s]*%.love)$") --we get the name and extension of the file from the path

		local destiny = assert(love.filesystem.newFile(directory..name, "w")) --we create a new file with the same name under the appdata dir

		local chunk = 1024 --we are gonna copy it 1KB at a time
		local chunks = math.ceil(size/chunk) --number of repetitions needed to get the whole file
		local lastchunk = size%chunk --last chunk doesnt need to be full

		for i = 1, chunks do --until we copy everything
			assert(destiny:write(file:read(i == chunks and lastchunk or chunk))) --we read the origin and write in the destiny
			prog:push(destiny:getSize()/size*100)
		end

		destiny:close() --we close both files
		file:close()
		return true, directory..name --We return where we placed the final file
	else
		return false, "Currently copy doesn't support other file types or folders, you can copy them manually"
	end
end

while true do
	local msg = cone:demand()
	if msg == "break" then
		prog:push("finished")
		break
	else
		assert(copy(msg,folder))
	end
end