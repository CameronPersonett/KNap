local _, ns = ...

local mac = ns.Macros

mac.Clean = {}
mac.Modified = {}

mac.Procs = {}
mac.Procs.current = "NONE"
mac.Procs.PvP = {}
mac.Procs.PvE = {}

-- The MissingTargets table contains the raw/data key-value pairs for targets
-- that cannot be automatically identified
mac.MissingTargets = {}

-- The Sub table contains the keyword/substitution strings for each target
-- denoted by a particular keyword
mac.Sub = {}

mac.locked = false

function mac.Import()
	for i=1, 54 do
		local macroName, macroTex, macroBody, isLocal = GetMacroInfo(i)
		
		local curMacro = {
            number = i,
            name = macroName,
            texture = macroTex,
            body = macroBody,
            isLocal = isLocal -- Maybe not needed?
        } table.insert(mac.Clean, curMacro)
	end
end

function mac.Filter()
    for i = table.getn(mac.Clean), 1, -1 do
        local curMacro = mac.Clean[i]
        curMacro.keywords = mac.GetKeywords(curMacro)

        if(table.getn(curMacro.keywords) == 0) then
            tremove(mac.Clean, i)
        end
    end
end

--  return keywords:
--      keyword:
--          target - the enemy/role/class/spec that the keyword refers to
--          number - the index of the target if there are more than one of the same type
--          group  - the group identifier (party/raid/opponent)
--      ...
function mac.GetKeywords(macro)
    local keywords = {}

    local bodySub = macro.body

    while(bodySub and bodySub:find("KNAP[_](%a+)(%d*)[_]?(P?R?O?)")) do
        local start, finish, target, number, group = nil, nil, nil, nil, nil

        --keyword.start, keyword.finish, keyword.contentType, keyword.target, keyword.number keyword.group = bodySub.find("KNAP[_](%a+)(%d*)[_]?(P?R?O?)")
        start, finish, target, number, group = bodySub:find("KNAP[_](%a+)(%d*)[_]?(P?R?O?)")

        local keyword = {
            raw = bodySub:sub(start, finish),
            start = start,
            finish = finish,
            target = target,
            number = number,
            group = group
        }

        tinsert(keywords, keyword)
        bodySub = bodySub:sub(keyword.finish+1, bodySub:len())
    end return keywords
end

function mac.BuildProcs()
    for _, macro in pairs(mac.Clean) do
        for _, keyword in pairs(macro.keywords) do
            if(string.lower(macro.name:sub(1, 3)) == "pvp" and not mac.Procs.PvP[keyword.raw]) then
                mac.Procs.PvP[keyword.raw] = {
                    keyword = keyword,
                    targetCriteria = mac.GetTargetCriteriaByID(keyword.target)
                }

            elseif(string.lower(macro.name:sub(1, 3)) == "pve" and not mac.Procs.PvE[keyword.raw]) then
                mac.Procs.PvE[keyword.raw] = {
                    keyword = keyword,
                    targetCriteria = mac.GetTargetCriteriaByID(keyword.target)
                }

            else
                if(not mac.Procs.PvP[keyword.raw]) then
                    mac.Procs.PvP[keyword.raw] = {
                        keyword = keyword,
                        targetCriteria = mac.GetTargetCriteriaByID(keyword.target)
                    }

                elseif(not mac.Procs.PvE[keyword.raw]) then
                    mac.Procs.PvE[keyword.raw] = {
                        keyword = keyword,
                        targetCriteria = mac.GetTargetCriteriaByID(keyword.target)
                    }
                end
            end
        end
    end
end

function mac.GetTargetCriteriaByID(id)
    local targetCriteria = {
        enemy = "",
        class = "",
        spec = ""
    }

    -- Not sure how boss will be implemented/used yet
    if(id == "BSS") then
        targetCriteria.enemy = "Boss"

    elseif(id == "TNK") then
        targetCriteria.spec = "/Protection/Guardian/Blood/Vengeance/Brewmaster/"
    elseif(id == "HLR") then
        targetCriteria.spec = "/Holy/Discipline/Restoration/Mistweaver/"
    elseif(id == "DPS") then
        targetCriteria.spec = "/Arms/Fury/Retribution/Frost/Unholy/"..
        "Marksmanship/Beast Mastery/Survival/Enhancement/Elemental/"..
        "Feral/Balance/Subtlety/Assassination/Outlaw/Windwalker/Havoc/"..
        "Fire/Frost/Arcane/Shadow/Affliction/Demonology/Destruction/"
    
    elseif(id == "WR") then
        targetCriteria.class = "Warrior"
    elseif(id == "PN") then
        targetCriteria.class = "Paladin"
    elseif(id == "DK") then
        targetCriteria.class = "Death Knight"
    elseif(id == "HR") then
        targetCriteria.class = "Hunter"
    elseif(id == "SN") then
        targetCriteria.class = "Shaman"
    elseif(id == "DD") then
        targetCriteria.class = "Druid"
    elseif(id == "RG") then
        targetCriteria.class = "Rogue"
    elseif(id == "MK") then
        targetCriteria.class = "Monk"
    elseif(id == "DH") then
        targetCriteria.class = "Demon Hunter"
    elseif(id == "PT") then
        targetCriteria.class = "Priest"
    elseif(id == "MG") then
        targetCriteria.class = "Mage"
    elseif(id == "WK") then
        targetCriteria.class = "Warlock"

    elseif(id == "AM") then
        targetCriteria.class = "Warrior"
        targetCriteria.spec = "/Arms/"
    elseif(id == "FR") then
        targetCriteria.class = "Warrior"
        targetCriteria.spec = "/Fury/"
    elseif(id == "WP") then
        targetCriteria.class = "Warrior"
        targetCriteria.spec = "/Protection/"
    elseif(id == "RN") then
        targetCriteria.class = "Paladin"
        targetCriteria.spec = "/Retribution/"
    elseif(id == "NH") then
        targetCriteria.class = "Paladin"
        targetCriteria.spec = "/Holy/"
    elseif(id == "PP") then
        targetCriteria.class = "Paladin"
        targetCriteria.spec = "/Protection/"
    elseif(id == "DF") then
        targetCriteria.class = "Death Knight"
        targetCriteria.spec = "/Frost/"
    elseif(id == "UL") then
        targetCriteria.class = "Death Knight"
        targetCriteria.spec = "/Unholy/"
    elseif(id == "BD") then
        targetCriteria.class = "Death Knight"
        targetCriteria.spec = "/Blood/"
    elseif(id == "MP") then
        targetCriteria.class = "Hunter"
        targetCriteria.spec = "/Marksmanship/"
    elseif(id == "BM") then
        targetCriteria.class = "Hunter"
        targetCriteria.spec = "/Beast Mastery/"
    elseif(id == "SL") then
        targetCriteria.class = "Hunter"
        targetCriteria.spec = "/Survival/"
    elseif(id == "ET") then
        targetCriteria.class = "Shaman"
        targetCriteria.spec = "/Enhancement/"
    elseif(id == "EL") then
        targetCriteria.class = "Shaman"
        targetCriteria.spec = "/Elemental/"
    elseif(id == "SR") then
        targetCriteria.class = "Shaman"
        targetCriteria.spec = "/Restoration/"
    elseif(id == "FL") then
        targetCriteria.class = "Druid"
        targetCriteria.spec = "/Feral/"
    elseif(id == "BC") then
        targetCriteria.class = "Druid"
        targetCriteria.spec = "/Balance/"
    elseif(id == "DR") then
        targetCriteria.class = "Druid"
        targetCriteria.spec = "/Restoration/"
    elseif(id == "GN") then
        targetCriteria.class = "Druid"
        targetCriteria.spec = "/Guardian/"
    elseif(id == "ST") then
        targetCriteria.class = "Rogue"
        targetCriteria.spec = "/Subtlety/"
    elseif(id == "AS") then
        targetCriteria.class = "Rogue"
        targetCriteria.spec = "/Assassination/"
    elseif(id == "OW") then
        targetCriteria.class = "Rogue"
        targetCriteria.spec = "/Outlaw/"
    elseif(id == "WI") then
        targetCriteria.class = "Monk"
        targetCriteria.spec = "/Windwalker/"
    elseif(id == "MR") then
        targetCriteria.class = "Monk"
        targetCriteria.spec = "/Mistweaver/"
    elseif(id == "BR") then
        targetCriteria.class = "Monk"
        targetCriteria.spec = "/Brewmaster/"
    elseif(id == "HC") then
        targetCriteria.class = "Demon Hunter"
        targetCriteria.spec = "/Havoc/"
    elseif(id == "VC") then
        targetCriteria.class = "Demon Hunter"
        targetCriteria.spec = "/Vengeance/"
    elseif(id == "FI") then
        targetCriteria.class = "Mage"
        targetCriteria.spec = "/Fire/"
    elseif(id == "MF") then
        targetCriteria.class = "Mage"
        targetCriteria.spec = "/Frost/"
    elseif(id == "AR") then
        targetCriteria.class = "Mage"
        targetCriteria.spec = "/Arcane/"
    elseif(id == "SW") then
        targetCriteria.class = "Priest"
        targetCriteria.spec = "/Shadow/"
    elseif(id == "DI") then
        targetCriteria.class = "Priest"
        targetCriteria.spec = "/Discipline/"
    elseif(id == "TH") then
        targetCriteria.class = "Priest"
        targetCriteria.spec = "/Holy/"
    elseif(id == "AF") then
        targetCriteria.class = "Warlock"
        targetCriteria.spec = "/Affliction/"
    elseif(id == "DG") then
        targetCriteria.class = "Warlock"
        targetCriteria.spec = "/Demonology/"
    elseif(id == "DN") then
        targetCriteria.class = "Warlock"
        targetCriteria.spec = "/Destruction/"

    else
        return "Target criteria could not be identified."
    end return targetCriteria
end

-- TODO: Condense these reused blocks of code?
function mac.IdentifyTargets()
    mac.MissingTargets = {}

    if(mac.Procs.current == "PVP") then
        for raw, data in pairs(mac.Procs.PvP) do
            local matches = ns.Core.PollGroup(data.keyword.group, data.targetCriteria)

            if(table.getn(matches) == 1) then
                mac.Sub[raw] = matches[1]

            elseif(table.getn(matches) > 1) then
                mac.MissingTargets[raw] = {
                    keyword = data.keyword,
                    criteria = data.targetCriteria,
                    matches = matches
                }
            end
        end

    elseif(mac.Procs.current == "PVE") then
        for raw, data in pairs(mac.Procs.PvE) do
            local matches = ns.Core.PollGroup(data.keyword.group, data.targetCriteria)

            if(table.getn(matches) == 1) then
                mac.Sub[raw] = matches[1]

            elseif(table.getn(matches) > 1) then
                table.insert(mac.MissingTargets, {
                    raw = raw,
                    keyword = data.keyword,
                    criteria = data.targetCriteria,
                    matches = matches
                })
            end
        end
    end

    while(table.getn(mac.MissingTargets) > 0) do
        local t = mac.MissingTargets[table.getn(mac.MissingTargets)]

        ns.UI.Frames.ChooseTarget(t)
        ns.UI.Frames.WaitForTargetChoice()

        table.remove(t)
    end
end

function mac.BuildMacros()
    mac.Modified = {}

	for macro in mac.Clean do
        local modifiedMacro = table.clone(macro)
		local keywords = mac.GetKeywords(macro)
        local seenKeywords = {}

        for keyword in keywords do
            if(not seenKeywords[keyword]) then
                modifiedMacro.body = string.gsub(modifiedMacro.body, keyword, mac.Sub[keyword])
                seenKeywords[keyword] = true
            end
        end

        table.insert(mac.Modified, modifiedMacro)
	end
end

function mac.Inject()
    mac.EditMacros(mac.Modified)
end

function mac.Restore()
    mac.EditMacros(mac.Clean)
end

function mac.EditMacros(macros)
    mac.locked = true

    for macro in macros do
        EditMacro(macro.number, macro.name, macro.icon, macro.body, macro.isLocal, 1)
    end

    mac.locked = false
end