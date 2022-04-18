local _, ns = ...

local mac = ns.Macros

mac.Clean = {}
mac.Modified = {}

mac.Proc = {}
mac.Proc.current = "NONE"
mac.Proc.PvE = {}
mac.Proc.PvP = {}

-- The Sub table contains the keyword/substitution strings for each target denoted by a particular keyword
mac.Sub

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
    for(i=table.getn(mac.Clean), 1, -1) do
        local curMacro = mac.Clean[i]

        curMacro.Keywords = mac.GetKeywords(curMacro)

        if(table.getn(curMacro.Keywords) == 0) then
            table.remove(mac.Clean)
        end
    end
end

[[--return
    keywords:
        keyword:
            target - the boss/role/class/spec that the keyword refers to
            number - the index of the target if there are more than one of the same type
            group  - optional - the group identifier (party/raid/opponent)
        ...
--]]
function mac.GetKeywords(macro)
    local keywords = {}

    local bodySub = macro.body

    while(bodySub.find("KNAP[_](%a+)(%d*)[_]?(P?R?O?)")) do
        local keyword = {}
        local start, finish = -1, -1

        --keyword.start, keyword.finish, keyword.contentType, keyword.target, keyword.number keyword.group = bodySub.find("KNAP[_](%a+)(%d*)[_]?(P?R?O?)")
        start, finish, keyword.target, keyword.number keyword.group = bodySub.find("KNAP[_](%a+)(%d*)[_]?(P?R?O?)")
        keyword.raw = string.sub(bodySub, start, finish)

        table.insert(keywords, table.clone(keyword))
        bodySub = string.sub(bodySub, keyword.finish+1, bodySub:len())
    end return keywords
end

function mac.BuildProfile()
    for(macro in mac.Clean) do
        local seenKeywords = {}

        for(keyword in macro.Keywords) do
            if(string.sub(modifiedMacro.name, 1, 3) == "PVP" and ~mac.Proc.PVP[keyword.raw]) then
                mac.Proc.PVP[keyword.raw] = {
                    keyword = keyword,
                    targetCriteria = mac.GetTargetCriteriaByID(keyword.target)
                }
            elseif(string.sub(modifiedMacro.name, 1, 3) == "PVE" and ~mac.Proc.PVE[keyword.raw])) then
                mac.Proc.PVE[keyword.raw] = {
                    keyword = keyword,
                    targetCriteria = mac.GetTargetCriteriaByID(keyword.target)
                }
            else
                if(~mac.Proc.PVP[keyword.raw]) then
                    mac.Proc.PVP[keyword.raw] = {
                        keyword = keyword,
                        targetCriteria = mac.GetTargetCriteriaByID(keyword.target)
                    }
                elseif(~mac.Proc.PVE[keyword.raw]) then
                    mac.Proc.PVE[keyword.raw] = {
                        keyword = keyword,
                        targetCriteria = mac.GetTargetCriteriaByID(keyword.target)
                    }
                end
            end
        end

        -- No longer necessary?
        table.insert(mac.Modified, modifiedMacro)
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
        targetCriteria.spec = "Arms"
    elseif(id == "FR") then
        targetCriteria.spec = "Fury"
    elseif(id == "WP") then
        targetCriteria.class = "Warrior"
        targetCriteria.spec = "Protection"
    elseif(id == "RN") then
        targetCriteria.spec = "Retribution"
    elseif(id == "NH") then
        targetCriteria.class = "Paladin"
        targetCriteria.spec = "Holy"
    elseif(id == "PP") then
        targetCriteria.class = "Paladin"
        targetCriteria.spec = "Protection"
    elseif(id == "DF") then
        targetCriteria.class = "Death Knight"
        targetCriteria.spec = "Frost"
    elseif(id == "UL") then
        targetCriteria.spec = "Unholy"
    elseif(id == "BD") then
        targetCriteria.spec = "Blood"
    elseif(id == "MP") then
        targetCriteria.spec = "Marksmanship"
    elseif(id == "BM") then
        targetCriteria.spec = "Beast Mastery"
    elseif(id == "SL") then
        targetCriteria.spec = "Survival"
    elseif(id == "ET") then
        targetCriteria.spec = "Enhancement"
    elseif(id == "EL") then
        targetCriteria.spec = "Elemental"
    elseif(id == "SR") then
        targetCriteria.class = "Shaman"
        targetCriteria.spec = "Restoration"
    elseif(id == "FL") then
        targetCriteria.spec = "Feral"
    elseif(id == "BC") then
        targetCriteria.spec = "Balance"
    elseif(id == "DR") then
        targetCriteria.class = "Druid"
        targetCriteria.spec = "Restoration"
    elseif(id == "GN") then
        targetCriteria.spec = "Guardian"
    elseif(id == "ST") then
        targetCriteria.spec = "Subtlety"
    elseif(id == "AS") then
        targetCriteria.spec = "Assassination"
    elseif(id == "OW") then
        targetCriteria.spec = "Outlaw"
    elseif(id == "WI") then
        targetCriteria.spec = "Windwalker"
    elseif(id == "MR") then
        targetCriteria.spec = "Mistweaver"
    elseif(id == "BR") then
        targetCriteria.spec = "Brewmaster"
    elseif(id == "HC") then
        targetCriteria.spec = "Havoc"
    elseif(id == "VC") then
        targetCriteria.spec = "Vengeance"
    elseif(id == "FI") then
        targetCriteria.spec = "Fire"
    elseif(id == "MF") then
        targetCriteria.class = "Mage"
        targetCriteria.spec = "Frost"
    elseif(id == "AR") then
        targetCriteria.spec = "Arcane"
    elseif(id == "SW") then
        targetCriteria.spec = "Shadow"
    elseif(id == "DI") then
        targetCriteria.spec = "Discipline"
    elseif(id == "TH") then
        targetCriteria.class = "Priest"
        targetCriteria.spec = "Holy"
    elseif(id == "AF") then
        targetCriteria.spec = "Affliction"
    elseif(id == "DG") then
        targetCriteria.spec = "Demonology"
    elseif(id == "DN") then
        targetCriteria.spec = "Destruction"

    else
        return "Target criteria could not be identified."
    end return targetCriteria
end

function mac.IdentifyTargets()
    if(mac.Proc.current == "PVP" or mac.Proc.current == "BOTH") then
        for(raw, data in pairs(mac.Proc.PVP)) do
            
        end
    end
end

function mac.BuildMacros()
    mac.Modified = {}

	for(macro in mac.Clean) do
        local modifiedMacro = table.clone(macro)
		local keywords = mac.GetKeywords(macro)
        local seenKeywords = {}

        for(keyword in keywords) do
            if(~seenKeywords[keyword]) then
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

    for(macro in macros) do
        EditMacro(macro.number, macro.name, macro.icon, macro.body, macro.isLocal, 1)
    end

    mac.locked = false
end