------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--  RIGHTS:      All rights reserved by developer
--  FILE:        adminPanel/punishment_c.lua
--  DEVELOPER:   Kian
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

function onAdminPunish()
	local reason
	local time
	local plr = getGridlistPlayer()
	local punishment = guiGridListGetItemText(adminGrid[6], guiGridListGetSelectedItem(adminGrid[6]), 1)
	local reasonCombo = guiComboBoxGetItemText(adminCombo[1], guiComboBoxGetSelected(adminCombo[1]))
	local reasonEdit = guiGetText(adminEdit[13])
	local timeEdit = tonumber(guiGetText(adminEdit[14]))
	if (punishment == nil or punishment == "") then
		outputChatBox("Select a punishment", 225, 0, 0) 
		return
	end
	if (reasonEdit == "") then
		if (reasonCombo == "") then
			outputChatBox("No reason found", 225, 0, 0) 
			return
		else
			reason = reasonCombo
		end
	else
		reason = reasonEdit
	end
	if (guiCheckBoxGetSelected(adminCheckBox[1])) then
		if (timeEdit == "") then
			time = false
		else
			time = timeEdit
		end	
	else
		if (timeEdit == "") then
			outputChatBox("No time found", 225, 0, 0) 
			return
		else
			time = timeEdit
		end
	end
	triggerServerEvent("AdminPanel.punishPlayer", localPlayer, plr, punishment, reason, time)
	guiSetVisible(adminWindow[4], false)
	guiSetText(adminEdit[13], "")
	guiSetText(adminEdit[14], "")
end
