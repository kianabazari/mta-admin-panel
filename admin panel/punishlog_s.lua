------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--  RIGHTS:      All rights reserved by developer
--  FILE:        adminPanel/punishlog_s.lua
--  DEVELOPER:   Kian
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

addEvent("AdminPanel.showPunishlogs", true)
function showPunishlogs(plr)
	local punishTable = {}
	local punish = dbPoll(dbQuery(adminDB, "SELECT * FROM punishments WHERE serial=?", getPlayerSerial(plr)), -1)
	for i=1, #punish do
		punishTable[i] = punish[i].log
	end
	triggerClientEvent(source, "AdminPanel.setPunishlogs", source, punishTable)
	punishTable = {}
end
addEventHandler("AdminPanel.showPunishlogs", root, showPunishlogs)

addEvent("AdminPanel.removePunishLog", true)
function removePunishLog(plr, log)
	if (log) then
		dbExec(adminDB, "DELETE FROM punishments WHERE log=?", log)
		showPunishlogs(plr)
	end
end
addEventHandler("AdminPanel.removePunishLog", root, removePunishLog)