local _, ns = ...

local cmd = ns.Cmd

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

-- For some reason the first parameter is always the self object? Don't know why
function cmd.RunCommand(line)
	if(line == "") then
		cmd.Default()
	else
		local cmd = ParseCommand(line)
		print(ns.Debug:TableToText(cmd))
		cmd[cmd.name](cmd.args)
	end
end

function cmd.Default()
	print("YO")
end