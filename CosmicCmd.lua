local _, ns = ...

local ParseCommand = function(line)
	local cmd = {}
	
	if(line ~= nil) then
		local split = {}
		
		for str in string.gmatch(line, "([^%s]+)") do
			table.insert(split, str)
		end
	
		cmd.name = table.remove(split, 1)
		cmd.args = split
	end
	
    return cmd
end

-- For some reason the first parameter is always this object? Don't know why
function ns.Cmd.RunCommand(self, line)
	if(line == "") then
		ns.Cmd:Default()
	else
		local cmd = ParseCommand(line)
		print(ns.Debug:TableToText(cmd))
		ns.Cmd[cmd.name](cmd.args)
	end
end

function ns.Cmd:Default()
	print("YO")
end