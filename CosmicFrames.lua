local _, ns = ...

local frm = ns.UI.Frames

frm.isChoosingTarget = false

local function initializeTargetChoiceFrame()
    local f = CreateFrame("Frame", "KnapTargetChoiceFrame")
    f:SetPoint("CENTER")
    f:SetSize(600, 300)

    f.text = f:CreateFontString(nil, "")

    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeSize = 16,
        insets = { left = 8, right = 6, top = 8, bottom = 8 }
    }) f:SetBackdropBorderColor(0.576, 0.914, 0.745, 0.5) -- half-opaque seafoam green

    f:SetMovable(true)
    f:SetClampedToScreen(true)
    f:SetScript("OnMouseDown", function(self, button)
        if(button == "LeftButton") then
            self:StartMoving()
        end
    end) f:SetScript("OnMouseUp", f.StopMovingOrSizing)

    for(i=1, 40) do
        local b = CreateFrame("Button", "KnapTargetChoiceButton"..i, KnapTargetChoiceFrame)
        b:SetText("")
        b:SetScript("OnClick", nil)
        b:Hide()
    end
end

function frm.ChooseTarget(targetData)
    frm.isChoosingTarget = true

    if(~KnapTargetChoiceFrame) then
        initializeTargetChoiceFrame()
    end

    local className = targetData.criteria.class
    local specName = targetData.criteria.spec

    local text = "Which "

    if(targetData.keyword.target == "TNK") then
        text = text .. "|c0000ffTank| "

    elseif(targetData.keyword.target == "HLR") then
        text = text .. "|c00ff00Healer| "

    elseif(targetData.keyword.target == "DPS") then
        text = text .. "|c00ff00DPS| "

    elseif(className) then
        if(specName) then
            text = text .. "|c" .. RAID_CLASS_COLORS[string.upper(className)].colorStr
                .. specName .. " "
        end

        text = text .. className .. "| "
    end 
    
    text = text .. "would you prefer?"
    KnapTargetChoiceFrame.text:SetText(text)

    -- TODO: Set size based on how many targetData.matches there are (space
    -- buttons would take up).

    for(i=1, table.getn(targetData.matches)) do
        local b = _G["KnapTargetChoiceButton" .. i]

        b:SetText(matches[i])
        b:SetScript("OnClick", function(self)
            ns.Macros.Sub[targetData.raw] = self:GetText()
            frm.isChoosingTarget = false
            KnapTargetChoiceFrame:Hide()
        end)
    end

    KnapTargetChoiceFrame:Show()
end

function frm.WaitForTargetChoice()
    while(frm.isChoosingTarget) do
        KNAP_wait(0.5)
    end
end