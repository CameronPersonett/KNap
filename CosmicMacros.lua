local _, ns = ...

ns.Macros.Clean = {}
ns.Macros.Modified = {}

-- TODO: Build a procedure for PvE/PvP that will be used to 
-- request information from the user and edit the macros when 
-- the right events fire. This should be better than the current 
-- logic of building up the modified macro objects for injection.
ns.Macros.Proc = {}
ns.Macros.Proc.PvE = {}
ns.Macros.Proc.PvP = {}

ns.Macros.locked = false

function ns.Macros:Import()
	for i=1, 54 do
		local macroName, macroTex, macroBody, isLocal = GetMacroInfo(i)
		
		local curMacro = {
            number = i,
            name = macroName,
            texture = macroTex,
            body = macroBody,
            isLocal = isLocal -- Maybe not needed?
        } table.insert(ns.Macros.Clean, curMacro)
	end
end

function ns.Macros:Filter()
    for(i=table.getn(ns.Macros.Clean), 1, -1) do
        local curMacro = ns.Macros.Clean[i]

        curMacro.Keywords = ns.Macros:GetKeywords(curMacro)

        if(table.getn(curMacro.Keywords) == 0) then
            table.remove(ns.Macros.Clean)
        end
    end
end

[[--return
    keywords:
        keyword:
            start  - the starting position of the keyword in the macro body
            finish - the ending position of the keyword in the macro body
            target - the boss/role/class/spec that the keyword refers to
            number - the index of the target if there are more than one of the same type
            group  - optional - the group identifier (party/raid/opponent)
        ...
--]]
function ns.Macros:GetKeywords(macro)
    local keywords = {}

    local bodySub = macro.body

    while(bodySub.find("KNAP[_](%a+%d*)[_](?P?R?O?)")) do
        local keyword = {}
        keyword.start, keyword.finish, keyword.contentType, keyword.target, keyword.number keyword.group = bodySub.find("KNAP[_](%a+)(%d*)[_]?(P?R?O?)")
        keyword.raw = string.sub(bodySub, keyword.start, keyword.finish)

        table.insert(keywords, table.clone(keyword))
        bodySub = string.sub(bodySub, keyword.finish+1, bodySub:len())
    end return keywords
end

function ns.Macros:BuildProfile()
    for(macro in ns.Macros.Clean) do
        local seenKeywords = {}

        for(keyword in macro.Keywords) do
            -- No longer necessary?
            if(~seenKeywords[keyword]) then
                table.insert(modifiedMacro.targetCriteria, ns.Macros:GetTargetCriteriaByID(keyword.target))
                table.insert(seenKeywords, keyword)
            end

            if(string.sub(modifiedMacro.name, 1, 3) == "PVP" & ~ns.Macros.Proc.PVP[keyword.raw]) then
                ns.Macros.Proc.PVP[keyword.raw] = {
                    keyword = keyword,
                    targetCriteria = modifiedMacro.targetCriteria
                }
            elseif(string.sub(modifiedMacro.name, 1, 3) == "PVE" & ~ns.Macros.Proc.PVE[keyword.raw])) then
                ns.Macros.Proc.PVE[keyword.raw] = {
                    keyword = keyword,
                    targetCriteria = modifiedMacro.targetCriteria
                }
            else
                if(~ns.Macros.Proc.PVP[keyword.raw]) then
                    ns.Macros.Proc.PVP[keyword.raw] = {
                        keyword = keyword,
                        targetCriteria = modifiedMacro.targetCriteria
                    }
                elseif(~ns.Macros.Proc.PVE[keyword.raw]) then
                    ns.Macros.Proc.PVE[keyword.raw] = {
                        keyword = keyword,
                        targetCriteria = modifiedMacro.targetCriteria
                    }
                end
            end
        end

        -- No longer necessary?
        table.insert(ns.Macros.Modified, modifiedMacro)
    end
end

function ns.Macros:GetTargetCriteriaByID(id)
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

function ns.Macros:BuildMacros()
	local editedMacros = {}
	local keywords = {}

	for(macro in ns.Macros.Clean) do
        local modifiedMacro = table.clone(macro)
        
		keywords = ns.Core:GetKeywords(macro)

	end
end

function ns.Macros:Inject()
    ns.Macros:EditMacros(ns.Macros.Modified)
end

function ns.Macros:Restore()
    ns:Macros:EditMacros(ns.Macros.Clean)
end

function ns.Macros:EditMacros(macros)
    ns.Macros.locked = true

    for(macro in macros) do
        EditMacro(macro.number, macro.name, macro.icon, macro.body, macro.isLocal, 1)
    end

    ns.Macros.locked = false
end

function ns.Macros:TranslateKeywords(keywords)
	for(keyword in keywords) then
		if(keyword == "KNAP_TNK")
	end
end