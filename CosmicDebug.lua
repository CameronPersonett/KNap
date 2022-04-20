local _, ns = ...

local dbg = ns.Debug

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
local function getValueByURL(url, curTable)
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
			return getValueByURL(nextURL, curValue)

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
	end
end

-- This function is for general debugging. It will display table structures,
-- call functions and print primitive data types depending on the arguments.
function dbg.Test(args)
    local varURL = tremove(args, 1)
	local var = getValueByURL(varURL)

	if(type(var) == "table") then
		dbg.DisplayTable(var)

	elseif(type(var) == "function") then
		callModuleFunction(var, args)

	elseif(var) then
		print(varURL .. ": " .. var)
	end
end