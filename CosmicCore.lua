local _, ns = ...

local cor = ns.Core

local waitTable = {};
local waitFrame = nil;

function cor.Yo(bool, int, str)
    print(bool .. int .. str)
end

function KNAP_wait(delay, func, ...)
    if(type(delay)~="number" or type(func)~="function") then
        return false;
    end

    if(waitFrame == nil) then
        waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
        waitFrame:SetScript("onUpdate", function (self,elapse)
            local count = #waitTable;
            local i = 1;
            while(i<=count) do
                local waitRecord = tremove(waitTable,i);
                local d = tremove(waitRecord,1);
                local f = tremove(waitRecord,1);
                local p = tremove(waitRecord,1);
                if(d>elapse) then
                    tinsert(waitTable,i,{d-elapse,f,p});
                    i = i + 1;
                else
                    count = count - 1;
                    f(unpack(p));
                end
            end
        end);
    end

    tinsert(waitTable,{delay,func,{...}});
    return true;
end

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
	end 
    
    return status
end

-- TODO: Condense these blocks of reused code?
function cor.PollGroup(groupType, targetCriteria)
    local groupMatches = {}

    -- TODO: GET NAMES OF PLAYERS INSTEAD OF party1, ...
    if(groupType == "PARTY") then
		for i = 1, GetNumGroupMembers() do
			local _, specName, _, _, _, _, className = GetSpecializationInfoByID(GetInspectSpecialization("party"..i))

            local classStart, _ = string.find("/"..targetCriteria.class.."/", className)
            local specStart, _ = string.find("/"..targetCriteria.spec.."/", specName)
            local success = true

            if(targetCriteria.class ~= "" and classStart < 1) then
                success = false
            end

            if(targetCriteria.spec ~= "" and specStart < 1) then
                success = false
            end

            if(success) then
                table.insert(groupMatches, "party" .. i)
            end
        end

    elseif(groupType == "OPPONENT") then
        -- TODO: Change this group type to ARENA?
        for i = 1, GetNumArenaOpponentSpecs() do
			local _, specName, _, _, _, _, className = GetSpecializationInfoByID(GetArenaOpponentSpec(i))
			
			local classStart, _ = string.find("/"..targetCriteria.class.."/", className)
            local specStart, _ = string.find("/"..targetCriteria.spec.."/", specName)
            local success = true

            if(targetCriteria.class ~= "" and classStart < 1) then
                success = false
            end

            if(targetCriteria.spec ~= "" and specStart < 1) then
                success = false
            end

            if(success) then
                table.insert(groupMatches, "arena"..i)
            end
		end

    elseif(groupType == "RAID") then
		-- TODO: Complete raid group polling. GET NAMES OF PLAYERS INSTEAD OF RAID1, ...
        print("Feature not implemented yet.")
    end
    
    return groupMatches
end