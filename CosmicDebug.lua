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
	-- We'll use this variable to create all of the frames for our UI
	local f = nil
	
	-- CosmicDebug_Parent
	if(true) then
		f = CreateFrame("Frame", "CosmicDebug_Parent", UIParent, "BackdropTemplate")
		f:SetPoint("CENTER")
		f:SetSize(800, 843)
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
	end

	-- CosmicDebug_TitleBar
	if(true) then
		f = CreateFrame("Frame", "CosmicDebug_TitleBar", CosmicDebug_Parent, "BackdropTemplate")
		f:SetPoint("TOP")
		f:SetSize(CosmicDebug_Parent:GetWidth(), 74)
		f:SetBackdrop({
			bgFile = "Interface\\Addons\\KNap\\KRes\\Parent-Frame-BG",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
			edgeSize = 32,
			insets = { left = 14, right = 14, top = 16, bottom = 16 }
			--insets = { left = 14, right = 14, top = 16, bottom = 0 }
		}) f:SetBackdropColor(0.576, 0.914, 0.745, 0.75)
		f:SetBackdropBorderColor(0.576, 0.914, 0.745, 1.0)
		
		local headerText = CosmicDebug_TitleBar:CreateFontString()
		headerText:SetPoint("CENTER")
		headerText:SetPoint("TOP", 0, -4)
		headerText:SetSize(200, 64)
		headerText:SetFont("Fonts\\ARIALN.ttf", 32, "MONOCHROME")
		headerText:SetText("Cosmic Debug")
		f:Show()
	end

	-- CosmicDebug_HeaderBar
	if(true) then
		f = CreateFrame("Frame", "CosmicDebug_HeaderBar", CosmicDebug_Parent, "BackdropTemplate")
		f:SetPoint("TOP", 0, -45)
		f:SetSize(CosmicDebug_Parent:GetWidth(), 66)
		f:SetBackdrop({
			bgFile = "Interface\\Addons\\KNap\\KRes\\Parent-Frame-BG",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
			edgeSize = 32,
			insets = { left = 14, right = 14, top = 16, bottom = 16 }
			--insets = { left = 14, right = 14, top = 16, bottom = 0 }
		}) f:SetBackdropColor(0.576, 0.914, 0.745, 0.50)
		f:SetBackdropBorderColor(0.576, 0.914, 0.745, 1.0)
		f:Show()
	end

	-- CosmicDebug_HeaderBar_HomeButton
	if(true) then
		f = CreateFrame("Button", "CosmicDebug_HeaderBar_SearchButton", CosmicDebug_HeaderBar)
		f:SetPoint("LEFT", 16, 0)
		f:SetSize(32, 32)
		f:SetNormalTexture("Interface\\Addons\\KNap\\KRes\\Home")
		-- TODO: SET SCRIPT FOR HOME
		f:Show()
	end

	-- CosmicDebug_HeaderBar_UpButton
	if(true) then
		f = CreateFrame("Button", "CosmicDebug_HeaderBar_UpButton", CosmicDebug_HeaderBar)
		f:SetPoint("LEFT", 51, 0)
		f:SetSize(32, 32)
		f:SetNormalTexture("Interface\\Addons\\KNap\\KRes\\Arrow-Up-Disabled")
		-- TODO: SET SCRIPT FOR UP
		f:Show()
	end

	-- CosmicDebug_HeaderBar_BackButton
	if(true) then
		f = CreateFrame("Button", "CosmicDebug_HeaderBar_BackButton", CosmicDebug_HeaderBar)
		f:SetPoint("LEFT", 85, 0)
		f:SetSize(32, 32)
		f:SetNormalTexture("Interface\\Addons\\KNap\\KRes\\Arrow-Left-Disabled")
		-- TODO: SET SCRIPT FOR BACK
		f:Show()
	end

	-- CosmicDebug_HeaderBar_ForwardButton
	if(true) then
		f = CreateFrame("Button", "CosmicDebug_HeaderBar_ForwardButton", CosmicDebug_HeaderBar)
		f:SetPoint("LEFT", 119, 0)
		f:SetSize(32, 32)
		f:SetNormalTexture("Interface\\Addons\\KNap\\KRes\\Arrow-Right-Disabled")
		-- TODO: SET SCRIPT FOR FORWARD
		f:Show()
	end

	-- CosmicDebug_HeaderBar_CloseButton
	if(true) then
		f = CreateFrame("Button", "CosmicDebug_HeaderBar_CloseButton", CosmicDebug_HeaderBar)
		f:SetPoint("RIGHT", -16, 0)
		f:SetSize(32, 32)
		f:SetNormalTexture("Interface\\Addons\\KNap\\KRes\\Close")
		-- TODO: SET SCRIPT FOR CLOSE
		f:Show()
	end

	-- CosmicDebug_HeaderBar_MinimizeButton
	if(true) then
		f = CreateFrame("Button", "CosmicDebug_HeaderBar_MinimizeButton", CosmicDebug_HeaderBar)
		f:SetPoint("RIGHT", -50, 0)
		f:SetSize(32, 32)
		f:SetNormalTexture("Interface\\Addons\\KNap\\KRes\\Minimize")
		-- TODO: SET SCRIPT FOR MINIMIZE
		f:Show()
	end

	-- CosmicDebug_HeaderBar_ConfigButton
	if(true) then
		f = CreateFrame("Button", "CosmicDebug_HeaderBar_ConfigButton", CosmicDebug_HeaderBar)
		f:SetPoint("RIGHT", -84, 0)
		f:SetSize(32, 32)
		f:SetNormalTexture("Interface\\Addons\\KNap\\KRes\\Config")
		-- TODO: SET SCRIPT FOR CONFIG
		f:Show()
	end

	-- CosmicDebug_HeaderBar_RefreshButton
	if(true) then
		f = CreateFrame("Button", "CosmicDebug_HeaderBar_RefreshButton", CosmicDebug_HeaderBar)
		f:SetPoint("RIGHT", -118, 0)
		f:SetSize(32, 32)
		f:SetNormalTexture("Interface\\Addons\\KNap\\KRes\\Refresh")
		-- TODO: SET SCRIPT FOR REFRESH
		f:Show()
	end

	-- CosmicDebug_UrlFrame
	if(true) then
		f = CreateFrame("Frame", "CosmicDebug_UrlFrame", CosmicDebug_Parent, "BackdropTemplate")
		f:SetPoint("TOPLEFT", 0, -81)
		f:SetSize(CosmicDebug_Parent:GetWidth(), CosmicDebug_HeaderBar:GetHeight() - 5)
		f:SetBackdrop({
			bgFile = "Interface\\Addons\\KNap\\KRes\\Parent-Frame-BG",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
			edgeSize = 32,
			insets = { left = 14, right = 14, top = 16, bottom = 16 }
			--insets = { left = 14, right = 14, top = 16, bottom = 0 }
		}) f:SetBackdropColor(0.576, 0.914, 0.745, 0.25)
		f:SetBackdropBorderColor(0.576, 0.914, 0.745, 1.0)
		
		local urlText = CosmicDebug_UrlFrame:CreateFontString("CosmicDebug_HeaderBar_UrlText")
		urlText:SetPoint("LEFT", 24, 0)
		urlText:SetFont("Fonts\\ARIALN.ttf", 20, "MONOCHROME")
		urlText:SetText("root")
		f:Show()
	end

	-- CosmicDebug_FieldsFrame
	if(true) then
		f = CreateFrame("Frame", "CosmicDebug_FieldsFrame", CosmicDebug_Parent, "BackdropTemplate")
		f:SetPoint("TOP", 0, -45 - 66)
		f:SetSize(CosmicDebug_Parent:GetWidth(), 732)
		f:SetBackdrop({
			--bgFile = "Interface\\Addons\\KNap\\KRes\\Parent-Frame-BG",
			insets = { left = 14, right = 14, top = 16, bottom = 16 }
		}) --f:SetBackdropColor(0.576, 0.914, 0.745, 0.50)
		f:Show()
	end

	-- CosmicDebug_FieldsFrame_FieldFrame(1-16)
	if(true) then
		local varSize = 0

		for i = 1, 20 do
			f = CreateFrame("Frame", "CosmicDebug_FieldsFrame_FieldFrame" .. i, CosmicDebug_FieldsFrame, "BackdropTemplate")
			f:SetPoint("TOP", 0, -1 + (-35 * (i - 1)))

			if(mod(i, 2) == 1) then
				varSize = 67

			else
				varSize = 68
			end

			f:SetSize(CosmicDebug_Parent:GetWidth(), varSize)
			f:SetBackdrop({
				bgFile = "Interface\\Addons\\KNap\\KRes\\Parent-Frame-BG",
				insets = { left = 14, right = 14, top = 16, bottom = 16 }
			})
			
			if(mod(i, 2) == 1) then
				f:SetBackdropColor(1, 1, 1, 0.25)

			else
				f:SetBackdropColor(1, 1, 1, 0.125)
			end
		end
	end

	-- CosmicDebug_FieldsFrame_FieldFrame(1-16)_TypeIcon
	if(true) then
		local varSize = 0

		for i = 1, 20 do
			f = CreateFrame("Frame", "TypeIcon" .. i, _G["CosmicDebug_FieldsFrame_FieldFrame" .. i])
			f:SetPoint("LEFT", 16, 0)
			f:SetSize(31, 31)

			local iconTexture = f:CreateTexture("TypeIcon" .. i .. "_Texture")
			iconTexture:SetAllPoints(f)
			iconTexture:SetTexture("Interface\\Addons\\KNap\\KRes\\Nil")
			f:Show()
		end
	end

	-- CosmicDebug_FieldsFrame_FieldFrame(1-16)_ActionButton
	if(true) then
		local varSize = 0

		for i = 1, 20 do
			f = CreateFrame("Button", "ActionButton" .. i, _G["CosmicDebug_FieldsFrame_FieldFrame" .. i])
			f:SetPoint("RIGHT", -16, 0)
			f:SetSize(31, 31)
			f:SetNormalTexture("Interface\\Addons\\KNap\\KRes\\Caret-Right")
			f:Show()
		end
	end
	
	
	-- f = CreateFrame("Frame", "CosmicDebug_HeaderTitle", CosmicDebug_TitleBar, "BackdropTemplate")
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