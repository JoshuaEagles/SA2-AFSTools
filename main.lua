local struct = require "struct"
require "lfs"

function readHeader() --used for reading the afs
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

function writeToADX(fileADX, count) -- using for reading the afs
	fileAFS:seek("set", fileADX.position)
	ADXForWrite = assert(io.open("workspace/adx/" .. numberFormatFourDigits(count) .. ".adx", "wb"))
	ADXForWrite:write(fileAFS:read(fileADX.length))
end --writeToADX

function getADX() --get files to package into AFS file, used for writing
	local adxForWrite = {}
	for currentFile in lfs.dir(lfs.currentdir() .. "/workspace/adx") do
		if string.sub(currentFile, string.len(currentFile) - 3, string.len(currentFile)) == ".adx" then --check file extention
			local fileADX = {
				currentFile,
				lfs.attributes(lfs.currentdir() .. "/workspace/adx/" .. currentFile).size
			} --end fileADX
			table.insert(adxForWrite, fileADX) 
		end --if
	end --for
	return adxForWrite
end --getADX

function writeToAFS(i, fileADX) --used for writing
	newAFS:seek("set", 8 +(i - 1) * 8) --set it to the next unused portion of the header
	newAFS:write(struct.pack("<I", offset), struct.pack("<I", fileADX[2]))
	newAFS:seek("set", offset)
	local ADXForRead = io.open("workspace/adx/" .. fileADX[1], "rb")
	newAFS:write(ADXForRead:read(fileADX[2])) 
	offset = offset + fileADX[2]
	offset = 2048 * (math.floor(offset / 2048) + 1) --aligns the offset to a multiple of 512, something about byte boundaries or something, idk
end --write to AFS

-- formats a number to four digits eg. 1 > 0001, 27 > 0027, etc
function numberFormatFourDigits(number)
	if number > 999 then
		return tostring(number)
	elseif number > 99 then
		return "0" .. number
	elseif number > 9 then
		return "00" .. number
	else
		return "000" .. number
	end --if elseif elseif elseif
end --numberFormatFourDigits

lfs.mkdir(lfs.currentdir() .. "/workspace")
lfs.mkdir(lfs.currentdir() .. "/workspace/adx")
repeat
	print("type \"r\" to read from AFS file titled \"file.afs\" in /workspace/, or \"w\" to write all ADX files in /workspace/adx to a file called output.afs in /workspace/")
	local inputLine = io.read("*line")
	if inputLine == "r" then
		fileAFS = io.open("workspace/file.afs", "rb") --hardcoded, not gonna make a gui for this
		fileAFS:seek("set", 4) -- set the position to just past the intital 4 bytes which are useless
		for i, fileADX in pairs(readHeader()) do --readHeader returns the length and position of each adx file
			writeToADX(fileADX, i)
		end --for
	elseif inputLine == "w" then
		local adxForWrite = getADX()
		offset = 524288
		newAFS = io.open("workspace/newFile.afs", "wb")
		newAFS:write("AFS\0" .. struct.pack("<I", #adxForWrite))
		for i, fileADX in pairs(adxForWrite)  do
			writeToAFS(i, fileADX)
		end --for
	else
		print("error, input wasn't \"r\" or \"w\"")
	end --if elseif
	print("restart? y/n")
	inputLine = io.read("*line")
until inputLine ~= "y"