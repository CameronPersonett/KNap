CosmicKiddNappers = {}

SLASH_CKN1 = "/knap"

SlashCmdList["CKN"] = function()
	local t = _G["TimerTrackerTimer1"]
	print(t.time)
end

function traverse(table, j)
	for k, v in pairs(table) do
		if (type(v) == "table") then
			traverse(v, k)
		else
			print(j, k, v)
		end
	end
end

local cosmicParent = CreateFrame("Frame")
cosmicParent:RegisterEvent("PLAYER_LOGIN")
cosmicParent:RegisterEvent("PLAYER_ENTERING_WORLD")
cosmicParent:RegisterEvent("ARENA_OPPONENT_UPDATE")

local cosmicParent_OnEvent = function(self, event, ...)
	CosmicKiddNappers[event](self, ...)
end cosmicParent:SetScript("OnEvent", cosmicParent_OnEvent)

function CosmicKiddNappers:PLAYER_LOGIN(...)
	self:UnregisterEvent("PLAYER_LOGIN")
	
	-- TODO: Do preliminary scan for macros. See if this character has been scanned before.
	--       If it hasn't, ask for a scan and reload to save the unmodified macros.
	--       If it has, compare the saved macros to the scanned ones and ask for a reimport and reload.
end

function CosmicKiddNappers:PLAYER_ENTERING_WORLD(...)
	-- TODO: If this is an arena, wait for the opposing team to load in and run the preliminary injection
	--       for guaranteed targets. Once that is done, bring up the configuration frame, confirm changes
	--       and run the primary injection.
	--       If this is not an arena, run the restore injection.
end

function CosmicKiddNappers:ARENA_OPPONENT_UPDATE(...)
	-- TODO: This might not be the correct event, but use this as an anchor point at which to scan the
	--       enemy team in order to see if it matches the size of your home/instance team. If it does,
	--       open the configuration frame, confirm changes and run the primary injection.
	--       ALSO OPEN CONFIGURATION FRAME IF COUNTDOWN REACHES THE CUTOFF TIME FOR ENTERING.
end

function CKN_ChooseClassTarget(className, target1, target2, target3)
	local classNameText = "|c"..RAID_CLASS_COLORS[string.upper(className)].colorStr..className.."|r"
	
	StaticPopupDialogs["CKN_CHOOSE_CLASS_TARGET"] = {
		text = "Which "..classNameText.." should be assigned?",
		button1 = target1,
		button2 = target2,
		button3 = target3,
		OnAccept = function()
			ChosenTarget = target1
		end,
		OnCancel = function()
			ChosenTarget = target2
		end,
		OnAlt = function()
			ChosenTarget = target3
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	} StaticPopup_Show("CKN_CHOOSE_CLASS_TARGET")
end