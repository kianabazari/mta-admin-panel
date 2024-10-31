------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--  RIGHTS:      All rights reserved by developer
--  FILE:        adminPanel/reports_s.lua
--  DEVELOPER:   Kian
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

function sendReport(plr, command, reason)
	if (reason) then
		outputChatBox("Uploading screenshot", plr, 0, 255, 0) 
		takePlayerScreenShot(plr, 760, 580, reason, 65, 50000)
	else
		outputChatBox("Correct syntax is /report <reason>", plr, 225, 0, 0) 
	end
end
addCommandHandler("report", sendReport)

addEventHandler("onPlayerScreenShot", root,
    function (theResource, status, imageData, timestamp, tag)
		local time = getRealTime(timeStamp)
		local year = time.year + 1900
		local month = time.month + 1
		local day = time.monthday
		local hour = time.hour
		local minute = time.minute
		
		local id = dbPoll(dbQuery(adminDB, "SELECT * FROM reports"), -1)
		local filepath = ("Reports/%s/[%s][%s][%s]/[%s][%s][%s](%d).jpg"):format(getAccountName(getPlayerAccount(source)), day, month, year, hour, minute, tag, #id + 1)
		local file = fileCreate(filepath) or fileOpen(filepath) 
		fileWrite(file, imageData)
		fileClose(file)
		local reportPath = ("Reports/%s/[%s][%s][%s]/[%s][%s][%s](%d)"):format(getAccountName(getPlayerAccount(source)), day, month, year, hour, minute, tag, #id + 1)
		
		if (reportPath) then
			dbExec(adminDB, "INSERT INTO reports(id, reportFrom, reportReason, reportTime, reportImagePath, status) VALUES(?,?,?,?,?,?)", #id + 1, getPlayerName(source), tag, "("..day.."/"..month.."/"..year..") ("..hour..":"..minute..")", reportPath, "Active")
			outputChatBox("Screenshot has been uploaded", source, 0, 255, 0) 
			for i, v in pairs(getPlayersInTeam(getTeamFromName("Staff"))) do
				outputChatBox("New report arrived from "..getPlayerName(source).." ("..tag..") ", v, 0, 255, 0)
			end
		else
			outputChatBox("Error uploading screenshot", source, 225, 0, 0) 
		end
	end
)

addEvent("AdminPanel.getReports", true)
function getReports()
	local reportData = dbPoll(dbQuery(adminDB, "SELECT * FROM reports WHERE status=?", "Active"), -1)
	triggerClientEvent(source, "setReportData", source, reportData)
end
addEventHandler("AdminPanel.getReports", root, getReports)

addEvent("AdminPanel.validReport", true)
function validReport(path, plr)
	if (path and plr) then
		dbExec(adminDB, "UPDATE reports SET status=? WHERE reportImagePath = ?", "Valid",  path)
		outputChatBox("Player will be punished (Valid report)", getPlayerFromName(plr), 225, 0, 0) 
		getReports()
	end
end
addEventHandler("AdminPanel.validReport", root, validReport)

addEvent("AdminPanel.inValidReport", true)
function inValidReport(path, plr)
	if (path and plr) then
		dbExec(adminDB, "UPDATE reports SET status=? WHERE reportImagePath = ?", "Invalid",  path)
		outputChatBox("Your report was deleted (Invalid report)", getPlayerFromName(plr), 0, 225, 0) 
		getReports()
	end
end
addEventHandler("AdminPanel.inValidReport", root, inValidReport)

addEvent("AdminPanel.getReportedImage", true )
function getReportedImage(path)
	local img1 = fileOpen(path..".jpg")
	local img = fileRead(img1, fileGetSize(img1))
	triggerClientEvent(source, "showImage", source, img)
	fileClose(img1)
end
addEventHandler( "AdminPanel.getReportedImage", root, getReportedImage)