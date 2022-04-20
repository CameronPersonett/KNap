local _, ns = ...

local cmd = ns.Cmd

local function getCommandName(name)
	for k, v in pairs(cmd) do
		if(string.lower(k) == string.lower(name)) then
			return k
		end
	end
end

local ParseCommand = function(line)
	local cmd = {}
	
	if(line ~= nil) then
		local split = {}
		
		for str in string.gmatch(line, "([^%s]+)") do
			table.insert(split, str)
		end

		cmd.name = getCommandName(table.remove(split, 1)) or "Error"
		cmd.args = split
	end return cmd
end

function cmd.RunCommand(line)
	if(line == "") then
		cmd.Default()
	else
		local cmdParse = ParseCommand(line)
		cmd[cmdParse.name](cmdParse.args)
	end
end

function cmd.Default()
	print("Feature not implemented yet.")
end

function cmd.Help()
	print("Feature not implemented yet.")
end

function cmd.Error()
	print("Invalid command - type \"/knap help\" for a list of commands.")
end

function cmd.Test(args)
	ns.Debug.Test(args)
end