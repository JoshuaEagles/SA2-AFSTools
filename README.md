# SA2-AFSTools
Extractor and Repacker for the Sonic Adventure 2 AFS files. May work on other games, I have no idea.

This comes with luajit for windows, it should work on Linux and stuff but you'll need your own luajit, not actually sure how to run it because I don't have a linux install or VM going, may test it and such later.

To run on windows: 
(For Powershell, the CMD replacement thing on newer versions of Windows 10)
Shift+Right Click blank space in this folder
Select "Open Powershell Window Here" (Alternatively to this first steps, just use cd in any powershell window to the path of luajit, it really doesn't matter, this way is just easier)
Type: ./luajit main.lua
Further instructions built into the program

(For CMD)
Same as Above but no need for a ./ before the command

Also if you're interested the reason the ./ is needed for powershell is because powershell won't run programs in a folder unless you specify you want it from that folder, which can be useful. I don't know why I'm writing this but I found it interesting, and useful.