local struct = require "struct"

adxForWrite = {}

function readHeader()
	nomOfADX = struct.unpack("<I", fileAFS:read(4))
	local contentsOfAFS = {}
	for i = 1, nomOfADX do
		local fileADX = {
			position = struct.unpack("<I", fileAFS:read(4)),
			length = struct.unpack("<I", fileAFS:read(4))
		} --end fileADX
		table.insert(contentsOfAFS, fileADX)
	end --for
	return contentsOfAFS
end--readHeader

function getADX() --get files to package into AFS file
	
end

function writeToADX(fileADX, count)
	fileAFS:seek("set", fileADX.position)
	ADXForWrite = assert(io.open("workspace/adx/" .. count .. ".adx", "wb"))
	ADXForWrite:write(fileAFS:read(fileADX.length))
end --writeToADX

function writeToAFS()
	
end

repeat
	print("type \"r\" to read from AFS file titled \"file.afs\" in /workspace/, or \"w\" to write all ADX files in /workspace/adx to a file called output.afs in /workspace/")
	inputLine = io.read("*line")
	if inputLine == "r" then
		fileAFS = io.open("file.afs", "rb") --hardcoded, not gonna make a gui for this
		fileAFS:read(4) -- set the position to just past the intital 4 bytes which are useless
		for i, fileADX in pairs(readHeader()) do --readHeader returns the length and position of each adx file
			writeToADX(fileADX, i)
		end --for
	elseif inputLine == "w" then
		getADX()
		for i in pairs(adxForWrite)  do
			writeToAFS()
		end --for
	else
		print("error, input wasn't \"r\" or \"w\"")
	end --if elseif
	print("restart? y/n")
	inputLine = io.read("*line")
until inputLine ~= "y"