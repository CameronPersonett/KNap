local _, ns = ...

local cor = ns.Core

function cor.WaitForArenaJoinCutoff()
	local status = {}
	status.success = false
	status.error = "No arena timer exists."

	local arenaTimer = _G["TimerTrackerTimer1"]

	while(arenaTimer) do
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

-- TODO: Condense these blocks of reused code?
function cor.PollGroup(groupType, targetCriteria)
    local groupMatches = {}

    -- TODO: GET NAMES OF PLAYERS INSTEAD OF party1, ...
    if(groupType == "PARTY") then
		for(i = 1, GetNumGroupMembers()) do
			local _, specName, _, _, _, _, className = GetSpecializationInfoByID(GetInspectSpecialization("party"..i))

            local classStart, _ = string.find("/"..targetCriteria.class.."/", className)
            local specStart, _ = string.find("/"..targetCriteria.spec.."/", specName)
            local success = true

            if(targetCriteria.class and ~classStart) then
                success = false
            end

            if(targetCriteria.spec and ~specStart) then
                success = false
            end

            if(success) then
                table.insert(groupMatches, "party"..i)
            end
        end

	-- TODO: Change this group type to ARENA?
    elseif(groupType == "OPPONENT") then
        for(i=1, GetNumArenaOpponentSpecs()) do
			local _, specName, _, _, _, _, className = GetSpecializationInfoByID(GetArenaOpponentSpec(i))
			
			local classStart, _ = string.find("/"..targetCriteria.class.."/", className)
            local specStart, _ = string.find("/"..targetCriteria.spec.."/", specName)
            local success = true

            if(targetCriteria.class and ~classStart) then
                success = false
            end

            if(targetCriteria.spec and ~specStart) then
                success = false
            end

            if(success) then
                table.insert(groupMatches, "arena"..i)
            end
		end

    else if(groupType == "RAID") then
		-- TODO: Complete raid group polling. GET NAMES OF PLAYERS INSTEAD OF RAID1, ...

    else
		print("Invalid group type. @CosmicCore.PollGroup()")
		return nil
    end return groupMatches
end