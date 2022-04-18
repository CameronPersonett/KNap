local _, ns = ...

ns.Core.playerGroup = {}
ns.Core.opponentGroup = {}

function ns.Core:WaitForArenaJoinCutoff()
	local status = {}
	status.success = false
	status.error = "No arena timer exists."

	local arenaTimer = _G["TimerTrackerTimer1"]

	while(arenaTimer ~= nil) do
		local time = arenaTimer.time

		if(time < 30) then
			status.success = true
			status.error = ""
			break;

		elseif(status.error == "No arena timer exists.") then
			status.error = "Player was removed from the arena."

		else
			KNAP_wait(1)
		end
	end return status
end

function ns.Core:GetOpponentCompInfo()
	local oppComp = {}
	
	for i=1, GetNumArenaOpponentSpecs() do
		local target = "arena"..i
		
		oppComp[target] = {}
		
		local specID = GetArenaOpponentSpec(i)
		local _, specName, _, _, _, _, className = GetSpecializationInfoByID(specID)
		
		oppComp[target].className = className
		oppComp[target].specName = specName
		oppComp[target].specID = specID
	end
	
	if(table.getn(oppComp)>0) then
		return oppComp
	else
		return "Could not get opponent composition."
	end
end



-- TODO: Move this to another file - CosmicDialog?
function ns.Core:ChooseClassTarget(className, target1, target2, target3)
	local classNameText = "|c"..RAID_CLASS_COLORS[string.upper(className)].colorStr..className.."|r"
	
	StaticPopupDialogs["KNAP_CHOOSE_CLASS_TARGET"] = {
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
	} StaticPopup_Show("KNAP_CHOOSE_CLASS_TARGET")
end