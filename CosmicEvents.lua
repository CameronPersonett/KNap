local _, ns = ...

local evh = ns.EventHandler

local cosmicParent = CreateFrame("Frame")
cosmicParent:RegisterEvent("PLAYER_LOGIN")
cosmicParent:RegisterEvent("PLAYER_ENTERING_WORLD")
cosmicParent:RegisterEvent("UPDATE_MACROS")
cosmicParent:RegisterEvent("PARTY_MEMBERS_CHANGED")
cosmicParent:RegisterEvent("ARENA_OPPONENT_UPDATE")

local cosmicParent_OnEvent = function(self, event, ...)
	evh[event](self, ...)
end cosmicParent:SetScript("OnEvent", cosmicParent_OnEvent)

function evh:PLAYER_LOGIN(...)
	self:UnregisterEvent("PLAYER_LOGIN")
	
	-- TODO: Do preliminary scan for macros. See if this character has been scanned before.
	--       If it hasn't, ask for a scan and reload to save the unmodified macros.
	--       If it has, compare the saved macros to the scanned ones and ask for a reimport and reload.
end

function evh:PLAYER_ENTERING_WORLD(...)
	-- TODO: If this is an arena, wait for the opposing team to load in and run the preliminary injection
	--       for guaranteed targets. Once that is done, bring up the configuration frame, confirm changes
	--       and run the primary injection.
	--       If this is not an arena, run the restore injection.
end

function evh:UPDATE_MACROS(...)
	-- TODO: When macros are updated by the user (not the addon [track this with a global boolean]), ask
	--       the user for a scan and reload.
end

function evh:PARTY_MEMBERS_CHANGED(...)
	-- TODO: When a group is formed/changed, update the group data in ns.Core.PlayerGroup.
end

function evh:ARENA_OPPONENT_UPDATE(...)
	-- TODO: This might not be the correct event, but use this as an anchor point at which to scan the
	--       enemy team in order to see if it matches the size of your home/instance team. If it does,
	--       open the configuration frame, confirm changes and run the primary injection.
	--       ALSO OPEN CONFIGURATION FRAME IF COUNTDOWN REACHES THE CUTOFF TIME FOR ENTERING.
end