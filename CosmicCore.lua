local _, ns = ...

local cor = ns.Core

cor.playerGroup = {}
cor.opponentGroup = {}

function cor.WaitForArenaJoinCutoff()
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

function cor.GetOpponentCompInfo()
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