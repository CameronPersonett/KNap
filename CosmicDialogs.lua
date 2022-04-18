local _, ns = ...

local dlg = ns.Dialogs

function dlg.ChooseClassTarget(className, target1, target2, target3)
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