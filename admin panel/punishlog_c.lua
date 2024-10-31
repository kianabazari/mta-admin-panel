------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--  RIGHTS:      All rights reserved by developer
--  FILE:        adminPanel/punishlog_c.lua
--  DEVELOPER:   Kian
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

function openPunishlog()	
	if (guiGetVisible(adminWindow[5])) then  
		guiSetVisible(adminWindow[5], false)
		guiSetVisible(adminButton[39], false)
		if (not guiGetVisible(adminWindow[1])) then  
			showCursor(false)
		end
	else  
		guiSetVisible(adminWindow[5], true)
		guiBringToFront(adminWindow[5])
		showCursor(true)
		showPunishlogs(localPlayer)
	end
end
addCommandHandler("punishlog", openPunishlog) -- if you want to change the command to open the panel

function showPunishlogs(plr)
	if (plr) then
		if (not guiGetVisible(adminWindow[5])) then   
			guiSetVisible(adminWindow[5], true)
			guiBringToFront(adminWindow[5])
			showCursor(true)
		end
		triggerServerEvent("AdminPanel.showPunishlogs", localPlayer, plr)
	end
end

addEvent("AdminPanel.setPunishlogs", true)
function setPunishlogs(punishTable)
	guiGridListClear(adminGrid[7])
	for i=#punishTable, 1, -1 do
		local row = guiGridListAddRow(adminGrid[7])
		guiGridListSetItemText(adminGrid[7], row, adminColumn[17], punishTable[i], false, false)
	end
end
addEventHandler("AdminPanel.setPunishlogs", root, setPunishlogs)

function removePunishLog()
	local plr = getGridlistPlayer()
	local log = guiGridListGetItemText(adminGrid[7], guiGridListGetSelectedItem(adminGrid[7]), 1)
	if (log) then
		triggerServerEvent("AdminPanel.removePunishLog", localPlayer, plr, log)
	end
end