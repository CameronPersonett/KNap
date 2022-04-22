local _, ns = ...

local dbg = ns.Debug

-- *** The enclosed code is for eventually making this module a standalone addon.
function dbg.Register(addonName, nsTable)
	if(dbg[addonName]) then
		message("CosmicDebug already has an addon registered with the name \"" .. addonName .. "\".")

	else
		dbg[addonName] = nsTable
	end
end

_G["COSMIC_DEBUG"] = dbg

function dbg.Load()
	local f = CreateFrame("Frame", "CosmicDebug_Parent", UIParent, "BackdropTemplate")
	f:SetPoint("CENTER")
	f:SetSize(800, 700)
	f:SetFrameStrata("TOOLTIP")
    f:SetBackdrop({
		bgFile = "Interface\\Addons\\KNap\\KRes\\Parent-Frame-BG",
		-- Change this to a better looking edge file (square corners)
		edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
        edgeSize = 32,
        insets = { left = 14, right = 14, top = 16, bottom = 16 }
	}) f:SetBackdropColor(0, 0, 0, 1.0)
	f:SetBackdropBorderColor(0.576, 0.914, 0.745, 1.0)
    f:SetMovable(true)
    f:SetClampedToScreen(true)
    f:SetScript("OnMouseDown", function(self, button)
        if(button == "LeftButton") then self:StartMoving() end
	end)
	f:SetScript("OnMouseUp", f.StopMovingOrSizing)
	f:Show()

	f = CreateFrame("Frame", "CosmicDebug_HeaderBar", CosmicDebug_Parent, "BackdropTemplate")
	f:SetPoint("TOP")
	f:SetSize(CosmicDebug_Parent:GetWidth(), 74)
    f:SetBackdrop({
		bgFile = "Interface\\Addons\\KNap\\KRes\\Parent-Frame-BG",
        insets = { left = 14, right = 14, top = 16, bottom = 0 }
	}) f:SetBackdropColor(0.576, 0.914, 0.745, 0.5)
    
    local headerText = CosmicDebug_HeaderBar:CreateFontString()
	headerText:SetPoint("CENTER")
	headerText:SetPoint("TOP", 0, -12)
	headerText:SetSize(200, 64)
	headerText:SetFont("Fonts\\ARIALN.ttf", 32, "MONOCHROME")
	headerText:SetText("Cosmic Debug")
	f:Show()
	
	-- f = CreateFrame("Frame", "CosmicDebug_HeaderTitle", CosmicDebug_HeaderBar, "BackdropTemplate")
	-- f:SetPoint("TOP", 0, -5)
	-- f:SetPoint("CENTER")
	-- f:SetSize(200, 64)
	-- f:SetBackdrop({
	-- 	bgFile = "Interface\\Addons\\KNap\\KRes\\Parent-Frame-BG",
    --     insets = { left = 14, right = 14, top = 16, bottom = 0 }
	-- }) f:SetBackdropColor(0.576, 0.914, 0.745, 0.5)
    -- f.text = f:CreateFontString()
	-- f.text:SetDrawLayer("OVERLAY", 2)
	-- f.text:SetFontObject("GameFontWhite")
	-- f.text:SetTextColor(1, 1, 1)
	-- f.text:SetText("Cosmic Debug")
	-- f:Show()
	
	-- f = CreateFrame("MessageFrame", "X", Y, "Z")
	--f:SetFont("Fonts\\MORPHEUS.ttf", 30, "OUTLINE")
	--f:AddMessage("Cosmic Debug", 1, 1, 1)
end 
-- ***

-- This function is logic I found on a WowInterface forum post from Ketho that
-- sets up the KethoEditBox. I'm looking into designing my own text display
-- frame, but this should work in the meantime. Thanks, Ketho!
function dbg.ShowText(text)
    if not KethoEditBox then
        local f = CreateFrame("Frame", "KethoEditBox", UIParent, "DialogBoxFrame")
        f:SetPoint("CENTER")
        f:SetSize(600, 500)
        
        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
            edgeSize = 16,
            insets = { left = 8, right = 6, top = 8, bottom = 8 },
        })
        f:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
        
        -- Movable
        f:SetMovable(true)
        f:SetClampedToScreen(true)
        f:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                self:StartMoving()
            end
        end)
        f:SetScript("OnMouseUp", f.StopMovingOrSizing)
        
        -- ScrollFrame
        local sf = CreateFrame("ScrollFrame", "KethoEditBoxScrollFrame", KethoEditBox, "UIPanelScrollFrameTemplate")
        sf:SetPoint("LEFT", 16, 0)
        sf:SetPoint("RIGHT", -32, 0)
        sf:SetPoint("TOP", 0, -16)
        sf:SetPoint("BOTTOM", KethoEditBoxButton, "TOP", 0, 0)
        
        -- EditBox
        local eb = CreateFrame("EditBox", "KethoEditBoxEditBox", KethoEditBoxScrollFrame)
        eb:SetSize(sf:GetSize())
        eb:SetMultiLine(true)
        eb:SetAutoFocus(false) -- dont automatically focus
        eb:SetFontObject("ChatFontNormal")
        eb:SetScript("OnEscapePressed", function() f:Hide() end)
        sf:SetScrollChild(eb)
        
        -- Resizable
        f:SetResizable(true)
        f:SetMinResize(150, 100)
        
        local rb = CreateFrame("Button", "KethoEditBoxResizeButton", KethoEditBox)
        rb:SetPoint("BOTTOMRIGHT", -6, 7)
        rb:SetSize(16, 16)
        
        rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
        
        rb:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                f:StartSizing("BOTTOMRIGHT")
                self:GetHighlightTexture():Hide() -- more noticeable
            end
        end)
        rb:SetScript("OnMouseUp", function(self, button)
            f:StopMovingOrSizing()
            self:GetHighlightTexture():Show()
            eb:SetWidth(sf:GetWidth())
        end)
        f:Show()
    end
    
    if text then
        KethoEditBoxEditBox:SetText(text)
    end
    KethoEditBox:Show()
end

-- This function traverses a table recursively and builds a string representing it.
-- The string is still ugly, however; I'm trying to find a way to make it better.
function dbg.TableToText(tableIn, level)
	local text = ""
	
	if(level == nil) then
		level = 0
		text = "root\n"
	end
	
	for k, v in pairs(tableIn) do
        for i = 0, level do
			text = text.."| "
		end
		
		if (type(v) == "table") then
			text = text..k.."\n"..dbg.TableToText(v, level+1)
		else
			text = text..k..": "..tostring(v).."\n"
		end
	end
	
	return text
end

-- This function combines the previous two functions for shorthand.
function dbg.DisplayTable(t)
    dbg.ShowText(dbg.TableToText(t))
end

-- This function gets a table's field's key-value pair by a name even if that
-- name is not case-accurate.
local function getPairIgnoreCase(name, t)
	for k, v in pairs(t) do
		if(string.lower(k) == string.lower(name)) then
			return k, v
		end
	end
end

-- This function traverses the addon's namespace recursively to return the value
-- of the specified field at the url.
local function getFieldByURL(url, curTable)
	if(not curTable) then
		curTable = ns

		if(url:sub(1, 3) == "ns.") then
			url = url:sub(4, url:len())
		end
	end

	local curKey = url
	local nextDot, _ = url:find("%.")
	local nextColon, _ = url:find("%:")
	local nextURL = nil

	if(nextDot and ((not nextColon) or (nextDot < nextColon))) then
		curKey = url:sub(1, nextDot - 1)
		nextURL = url:sub(nextDot + 1, url:len())
	
	elseif(nextColon and ((not nextDot) or (nextColon < nextDot))) then
		curKey = url:sub(1, nextColon - 1)
		nextURL = url:sub(nextColon + 1, url:len())
	end

    local _, curValue = getPairIgnoreCase(curKey, curTable)

	if(curValue and nextDot or nextColon) then
		if(type(curValue) == "table") then
			return getFieldByURL(nextURL, curValue)

		else
			print("Error: member \"" .. curKey .. "\" is not a table; it cannot be traversed.")
			return nil
		end

	elseif(curValue) then
		return curValue

	else
		print("No key \"" .. curKey .. "\" exists.")
		return nil
	end
end

local function setFieldByURL(value, url, curTable)
	if(not curTable) then
		curTable = ns

		if(url:sub(1, 3) == "ns.") then
			url = url:sub(4, url:len())
		end
	end

	local curKey = url
	local nextDot, _ = url:find("%.")
	local nextColon, _ = url:find("%:")
	local nextURL = nil

	if(nextColon) then
		print("Error: functions are not able to be modified.")
		return false

	elseif(nextDot) then
		curKey = url:sub(1, nextDot - 1)
		nextURL = url:sub(nextDot + 1, url:len())
	end

    local _, curValue = getPairIgnoreCase(curKey, curTable)

	if(curValue and nextDot) then
		if(type(curValue) == "table") then
			return setFieldByURL(value, nextURL, curValue)

		else
			print("Error: member \"" .. curKey .. "\" is not a table; it cannot be traversed.")
			return false
		end

	elseif(curValue) then
		curTable[curKey] = value
		return true

	else
		print("No key \"" .. curKey .. "\" exists.")
		return false
	end
end

local strToBool = {}
strToBool["true"] = true
strToBool["false"] = false

local function parseVar(str)
	str = string.lower(str)

	if(str:match("nil")) then
		return nil

	elseif(str:match("true") or str:match("false")) then
		return strToBool[str]

	elseif(str:match("(%d+%,)*%d%.?%d?") or str:match("%d?%.%d")) then
		return tonumber(str)

	else
		return str
	end
end

local function createTable(args, level)
	-- TODO: Get the rest of the arguments and create a new table
	--       with those arguments.
	if(not level) then
		level = 0
	end
	
	local curTable = {}
	local subTableLevel = 0
	local nextKey = nil

	-- fuck lol shit table fuck 69 end piss 420

	for i = 1, table.getn(args) do
		local curArg = string.lower(args[i])

		if(curArg == "table") then
			subTableLevel = subTableLevel + 1
			
			if(subTableLevel == (level + 1)) then
				curTable[nextKey] = createTable(args, level + 1)
				nextKey = nil
			end 

		elseif(curArg == "end") then
			subTableLevel = subTableLevel - 1
		end

		if(level == subTableLevel and curArg ~= "table" and curArg ~= "end") then
			if(nextKey) then
				curTable[nextKey] = createVar(curArg)
				nextKey = nil

			else
				nextKey = curArg
			end
		end
	end return curTable
end

local function createVar(args)
	--return parseVar(args[1])
	str = string.lower(str)

	if(str:match("nil")) then
		return nil

	elseif(str:match("true") or str:match("false")) then
		return strToBool[str]

	elseif(str:match("(%d+%,)*%d%.?%d?") or str:match("%d?%.%d")) then
		return tonumber(str)

	else
		return str
	end
end

-- This function calls another of this addon's functions dynamically with up to
-- five arguments. This could be easily expanded to support more if necessary. 
local function callModuleFunction(funcVar, args)
	local numArgs = args and table.getn(args) or 0
	-- local numParams = debug.getinfo(funcVar).nparams
	local numParams = numArgs

	-- if(numArgs > numParams) then
	-- 	print("Warning: " .. numArgs .. " args passed instead of the " .. numParams .. " needed.")

	-- elseif(numArgs < numParams) then
	-- 	print("Error: " .. numArgs .. " passed; " .. numParams .. " needed.")
	-- 	return
	-- end

	if(numParams == 0) then
		funcVar()

	elseif(numParams == 1 and numArgs >= 1) then
		funcVar(args[1])

	elseif(numParams == 2 and numArgs >= 2) then
		funcVar(args[1], args[2])

	elseif(numParams == 3 and numArgs >= 3) then
		funcVar(args[1], args[2], args[3])

	elseif(numParams == 4 and numArgs >= 4) then
		funcVar(args[1], args[2], args[3], args[4])

	elseif(numParams == 5 and numArgs >= 5) then
		funcVar(args[1], args[2], args[3], args[4], args[5])

	else
		print("Error: only 5 args supported; " .. numArgs .. " given.")
		return false
	end return true
end

-- TODO: Remove these? Maybe make them more robust?
dbg.TestTable = {}
dbg.TestString = ""

-- This function is for general debugging. It will display table structures and
-- primitive data types as well as call functions depending on the arguments.
function dbg.Test(args)
	if(table.getn(args) >= 2) then
		local cmd = tremove(args, 1)
		local varURL = tremove(args, 1)
		local var = getFieldByURL(varURL)

		if(var) then
			if(string.lower(cmd) == "poll") then
				if(type(var) == "table") then
					dbg.DisplayTable(var)
					
				else
					dbg.ShowText(varURL .. ": " .. var)
				end
	
			elseif(string.lower(cmd) == "set") then
				if(table.getn(args) > 1) then
					if(setFieldByURL(createTable(args), varURL)) then
						print("Success.")
					end
					
				elseif(setFieldByURL(createVar(args), varURL)) then
					print("Success.")
				end
	
			elseif(string.lower(cmd) == "call") then
				if(var and (type(var) == "function")) then
					-- Todo: see if there is a colon and account for that when
					--       calling the function
					if(callModuleFunction(var, args)) then
						print("Success.")
					end
	
				else
					print("Error: url \"" .. varURL .. "\" does not lead to a function.")
				end
			end

		else
			print("Error: field \"" .. varURL .. "\" does not exist.")
		end

	else
		print("Error: not enough test arguments given.")
	end
end

-- REMOVE THIS
dbg.Load()