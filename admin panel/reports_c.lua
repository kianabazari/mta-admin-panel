------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--  RIGHTS:      All rights reserved by developer
--  FILE:        adminPanel/report_c.lua
--  DEVELOPER:   Kian
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

local resX,resY = guiGetScreenSize()
local X, Y, width, height = resX*0.37890625, resY*0.02473958, resX*0.6171875, resY*0.89583333

function showReports()
	local id = guiGridListGetItemData(adminGrid[3], guiGridListGetSelectedItem(adminGrid[3]), 1)
	if (id) then
		removeEventHandler("onClientRender", root, render)
		triggerServerEvent("AdminPanel.getReportedImage", localPlayer, id)
	end
end

function render()
	if (image) then
        dxDrawImage(X, Y, width, height, image)
    end
end

function showImage(img)
	image = dxCreateTexture(img)  
	addEventHandler("onClientRender", root, render)
	addCommandHandler("closereport", closeImage)
end
addEvent("showImage", true)
addEventHandler("showImage", root, showImage)

function closeImage()
	if (image == nil) then
		return
	else
        destroyElement(image)
		removeEventHandler("onClientRender", root, render)
		removeCommandHandler("closereport", closeImage)
    end
end
bindKey("space", "down", "closereport")

function setReportData(reportData)
	guiGridListClear(adminGrid[3])
	for i, v in pairs (reportData) do
		local row = guiGridListAddRow(adminGrid[3])
		guiGridListSetItemText(adminGrid[3], row, adminColumn[16], v.id, false, false)
		guiGridListSetItemText(adminGrid[3], row, adminColumn[4], v.reportTime, false, false)
		guiGridListSetItemText(adminGrid[3], row, adminColumn[5], v.reportFrom, false, false)
		guiGridListSetItemText(adminGrid[3], row, adminColumn[6], v.reportReason, false, false)
		guiGridListSetItemData(adminGrid[3], row, adminColumn[16], v.reportImagePath)
	end
end
addEvent("setReportData", true)
addEventHandler("setReportData", root, setReportData)

function validReport()
	local path = guiGridListGetItemData(adminGrid[3], guiGridListGetSelectedItem(adminGrid[3]), 1)
	local plr = guiGridListGetItemText(adminGrid[3], guiGridListGetSelectedItem(adminGrid[3]), 3)
	if (path and plr) then
		triggerServerEvent("AdminPanel.validReport", localPlayer, path, plr)
	end
end

function inValidReport()
	local path = guiGridListGetItemData(adminGrid[3], guiGridListGetSelectedItem(adminGrid[3]), 1)
	local plr = guiGridListGetItemText(adminGrid[3], guiGridListGetSelectedItem(adminGrid[3]), 3)
	if (path and plr) then
		triggerServerEvent("AdminPanel.inValidReport", localPlayer, path, plr)
	end
end