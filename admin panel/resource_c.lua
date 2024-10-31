------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--  RIGHTS:      All rights reserved by developer
--  FILE:        adminPanel/resource_c.lua
--  DEVELOPER:   Kian
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
local serverResources = {}

addEvent("AdminPanel.setResources", true)
function setResources(resources)
	serverResources = resources
	guiGridListClear(adminGrid[2])
	for i=1, #serverResources do
		local row = guiGridListAddRow(adminGrid[2])
		guiGridListSetItemText(adminGrid[2], row, adminColumn[2], serverResources[i][1], false, false)
		guiGridListSetItemText(adminGrid[2], row, adminColumn[3],  serverResources[i][2], false, false)
	end
end
addEventHandler("AdminPanel.setResources", root, setResources)

function searchResources()
	guiGridListClear(adminGrid[2])
	local getText = guiGetText(adminEdit[12])
	if ((getText == "") and (getText == "Search...")) then
		setResources(serverResources)
	else
		for i=1, #serverResources do
			local name = string.lower(getText)
			local nameRes = string.lower(serverResources[i][1])
			if (string.find(nameRes, name)) then
				local row = guiGridListAddRow(adminGrid[2])
				guiGridListSetItemText(adminGrid[2], row, adminColumn[2], serverResources[i][1], false, false)
				guiGridListSetItemText(adminGrid[2], row, adminColumn[3],  serverResources[i][2], false, false)
			end
		end
	end
end

function resourceStart()
	resourceName = guiGridListGetItemText(adminGrid[2], guiGridListGetSelectedItem(adminGrid[2]), 1)
	triggerServerEvent("AdminPanel.resourceStart", localPlayer, resourceName)
end

function resourceStop()
	resourceName = guiGridListGetItemText(adminGrid[2], guiGridListGetSelectedItem(adminGrid[2]), 1)
	triggerServerEvent("AdminPanel.resourceStop", localPlayer, resourceName)
end

function resourceRestart()
	resourceName = guiGridListGetItemText(adminGrid[2], guiGridListGetSelectedItem(adminGrid[2]), 1)
	triggerServerEvent("AdminPanel.resourceRestart", localPlayer, resourceName)
end

function resourceRefresh()
	triggerServerEvent("AdminPanel.getResource", localPlayer)
end

