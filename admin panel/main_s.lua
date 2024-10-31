------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--  RIGHTS:      All rights reserved by developer
--  FILE:        adminPanel/main_s.lua
--  DEVELOPER:   Kian
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

adminDB = dbConnect("sqlite", "admin.db")

addEvent("AdminPanel.onGridClick", true)
function onGridClick(plr)
	if (not isElement(plr)) then return end
	local IP = getPlayerIP(plr)
	local account = getAccountName(getPlayerAccount(plr))
	local aclGroup = "None"
	local serial = getPlayerSerial(plr)
	triggerClientEvent(source, "AdminPanel.setPlayerDetails", source, plr, IP, account, aclGroup, serial)
end
addEventHandler("AdminPanel.onGridClick", root, onGridClick)

addEvent("AdminPanel.getBanList", true)
function getBanList()
	for i, v in pairs(getBans()) do
		local name = getBanNick(v) or "N/A"
		local account = getBanUsername(v) or "N/A"
		local reason = getBanReason(v) or "N/A"
		local unBanDate = getUnbanTime(v) or "N/A"
		local banDate = getBanTime(v) or "N/A"
		local admin = getBanAdmin(v) or "N/A"
		local serial = getBanSerial(v) or "N/A"
		local ip = getBanIP(v) or "N/A"
		triggerClientEvent(source, "AdminPanel.setBanList", source, reason, name, ip, serial, banDate, unBanDate, admin, account)
	end
end
addEventHandler("AdminPanel.getBanList", root, getBanList)

addEvent("AdminPanel.adminUnban", true)
function adminUnban(banData, type)
	if (type == "Serial Ban") then
		for i, ban in pairs(getBans())do
			if (getBanSerial(ban) == banData) then
				outputChatBox(getPlayerName(source).." has removed ban on serial "..banData, root, 225, 225, 0)
				removeBan(ban, source)
			end
		end
	elseif (type == "IP Ban") then
		for i, ban in pairs(getBans())do
			if (getBanIP(ban) == banData) then
				outputChatBox(getPlayerName(source).." has removed ban on IP "..banData, root, 225, 225, 0)
				removeBan(ban, source)
			end
		end
	elseif (type == "Account Ban") then
		for i, ban in pairs(getBans())do
			if (getBanUsername(ban) == banData) then
				outputChatBox(getPlayerName(source).." has removed ban on account "..banData, root, 225, 225, 0)
				removeBan(ban, source)
			else
			end
		end
	end
	
	triggerClientEvent(source, "AdminPanel.openBanWindow", source)
end
addEventHandler("AdminPanel.adminUnban", root, adminUnban)

addEvent("AdminPanel.adminAddBan", true)
function adminAddBan(getText1, getText2, getText3, getComboText)
	if (getComboText == "Serial Ban") then
		addBan(nil, nil, getText1, source, getText2, getText3)
		outputChatBox(getPlayerName(source).." has added ban on serial "..getText1.." for "..getText2.." ("..getText3.." seconds)", root, 225, 225, 0)
	elseif (getComboText == "IP Ban") then
		addBan(getText1, nil, nil, source, getText2, getText3)
		outputChatBox(getPlayerName(source).." has added ban on IP "..getText1.." for "..getText2.." ("..getText3.." seconds)", root, 225, 225, 0)
	elseif (getComboText == "Account Ban") then
		addBan(nil, getText1, nil, source, getText2, getText3)
		outputChatBox(getPlayerName(source).." has added ban on account "..getText1.." for "..getText2.." ("..getText3.." seconds)", root, 225, 225, 0)
	end
	triggerClientEvent(source, "AdminPanel.openBanWindow", source)
end
addEventHandler("AdminPanel.adminAddBan", root, adminAddBan)

-- warp
addEvent("AdminPanel.warpToPlayer", true)
function warpToPlayer(plr)
	if (not isElement(plr)) then return end
	local x, y, z = getElementPosition(plr)
	local int = getElementInterior(plr)
	local dim = getElementDimension(plr)
	setElementPosition(source, x, y + 2, z + 2)
	setElementInterior(plr, int)
	setElementDimension(plr, dim)
	outputChatBox(getPlayerName(source).." has warped to you", plr, 0, 225, 0)
	outputChatBox("You have warped to "..getPlayerName(plr), source, 0, 225, 0)
end
addEventHandler("AdminPanel.warpToPlayer", root, warpToPlayer)

addEvent("AdminPanel.warpPlayerTo", true)
function warpPlayerTo(plr, toPlr)
	if (not isElement(plr)) then return end
	local x, y, z = getElementPosition(toPlr)
	local dim = getElementDimension(toPlr)
	local int = getElementInterior(toPlr)
	setElementPosition(plr, x, y + 1, z + 2)
	setElementInterior(plr, dim)
	setElementDimension(plr, int)
	outputChatBox("You warped "..getPlayerName(plr).." to "..getPlayerName(toPlr), source, 0, 225, 0)
end
addEventHandler("AdminPanel.warpPlayerTo", root, warpPlayerTo)

--freeze
addEvent("AdminPanel.freezePlayer", true)
function freezePlayer(plr)
	if (not isElement(plr)) then return end
	if (isElementFrozen(plr)) then
		setElementFrozen(plr, false)
		toggleAllControls(plr, true)
		outputChatBox(getPlayerName(source).." has unfrozen to you", plr, 0, 225, 0)
		outputChatBox("You unfroze "..getPlayerName(plr), source, 0, 225, 0)
		local plrVeh = getPedOccupiedVehicle(plr)
		if (plrVeh) then
			setElementFrozen(plrVeh, false)
		end
	else
		setElementFrozen(plr, true)
		toggleAllControls(plr, false)
		outputChatBox(getPlayerName(source).." has frozen to you", plr, 0, 225, 0)
		outputChatBox("You froze "..getPlayerName(plr), source, 0, 225, 0)
		local plrVeh = getPedOccupiedVehicle(plr)
		if (plrVeh) then
			setElementFrozen(plrVeh, true)
		end
	end
end
addEventHandler("AdminPanel.freezePlayer", root, freezePlayer)

--spectate
local sourceDim = {}
local sourceINT = {} 
local sourcePos = {}

addEvent("AdminPanel.spectatePlayer", true)
function spectatePlayer(plr)
	if (not isElement(plr)) then return end
	local target = getCameraTarget(source)
	if (target == source) then
		local x, y, z = getElementPosition(source)
		sourcePos[source] = {x, y, z}
		sourceDim[source] = getElementInterior(source)
		sourceINT[source] = getElementDimension(source)
		setCameraTarget(source, plr)
		setElementInterior(source, getElementInterior(plr))
		setElementDimension(source, getElementDimension(plr))
		outputChatBox("Spectating "..getPlayerName(plr), source, 0, 225, 0)
	elseif (not (target == source)) then
		setCameraTarget(source)
		outputChatBox("Removed spectating", source, 0, 225, 0)
		setElementPosition(source, sourcePos[source][1], sourcePos[source][2], sourcePos[source][3])
		setElementInterior(source, sourceDim[source])
		setElementDimension(source, sourceINT[source])
		sourcePos[source] = nil
		sourceDim[source] = nil
		sourceINT[source] = nil
	end
end
addEventHandler("AdminPanel.spectatePlayer", root, spectatePlayer)

--renamePlayer
addEvent("AdminPanel.renamePlayer", true)
function renamePlayer(plr, getText)
	if (not isElement(plr)) then return end
	if (getPlayerName(plr) == getText) then
		outputChatBox("Already with the name "..getText, plr, 0, 225, 0)
	else
		setPlayerName(plr, getText)
		outputChatBox(getPlayerName(source).." has renamed you to "..getText, plr, 0, 225, 0)
		outputChatBox("You renamed "..getPlayerName(plr).." to "..getText, source, 0, 225, 0)
	end
end
addEventHandler("AdminPanel.renamePlayer", root, renamePlayer)

--slapPlayer
addEvent("AdminPanel.slapPlayer", true)
function slapPlayer(plr, getText)
	if (not isElement(plr)) then return end
	local plrHealth = getElementHealth(plr)
	setElementHealth(plr, (plrHealth - getText))
	outputChatBox(getPlayerName(source).." has slaped you "..getText.." HP", plr, 0, 225, 0)
	outputChatBox("You slaped "..getPlayerName(plr).." "..getText.." HP", source, 0, 225, 0)
end
addEventHandler("AdminPanel.slapPlayer", root, slapPlayer)

--giveArmor
addEvent("AdminPanel.giveArmor", true)
function giveArmor(plr, getText)
	if (not isElement(plr)) then return end
	setPedArmor(plr, getText)
	outputChatBox(getPlayerName(source).." gave you "..getText.." armor", plr, 0, 225, 0)
	outputChatBox("You gave "..getPlayerName(plr).." "..getText.." armor", source, 0, 225, 0)
end
addEventHandler("AdminPanel.giveArmor", root, giveArmor)

--giveHealth
addEvent("AdminPanel.giveHealth", true)
function giveHealth(plr, getText)
	if (not isElement(plr)) then return end
	setElementHealth(plr, getText)
	outputChatBox(getPlayerName(source).." gave you "..getText.." heath", plr, 0, 225, 0)
	outputChatBox("You gave "..getPlayerName(plr).." "..getText.." heath", source, 0, 225, 0)
end
addEventHandler("AdminPanel.giveHealth", root, giveHealth)

--setSkin
addEvent("AdminPanel.setSkin", true)
function setSkin(plr, getText)
	if (not isElement(plr)) then return end
	setElementModel(plr, getText)
	outputChatBox(getPlayerName(source).." has set your skin to "..getText, plr, 0, 225, 0)
	outputChatBox("You set "..getPlayerName(plr).."'s skin to "..getText, source, 0, 225, 0)
end
addEventHandler("AdminPanel.setSkin", root, setSkin)

--setDimension
addEvent("AdminPanel.setDimension", true)
function setDimension(plr, getText)
	if (not isElement(plr)) then return end
	setElementDimension(plr, getText)
	outputChatBox(getPlayerName(source).." has set your dimension to "..getText, plr, 0, 225, 0)
	outputChatBox("You set "..getPlayerName(plr).."'s dimension to "..getText, source, 0, 225, 0)
end
addEventHandler("AdminPanel.setDimension", root, setDimension)

--setInterior
addEvent("AdminPanel.setInterior", true)
function setInterior(plr, getText)
	if (not isElement(plr)) then return end
	setElementInterior(plr, getText)
	outputChatBox(getPlayerName(source).." has set your interior to "..getText, plr, 0, 225, 0)
	outputChatBox("You set "..getPlayerName(plr).."'s interior to "..getText, source, 0, 225, 0)
end
addEventHandler("AdminPanel.setInterior", root, setInterior)

--setTeam
addEvent("AdminPanel.setTeam", true)
function setTeam(plr, getText)
	if (not isElement(plr)) then return end
	local team = getTeamFromName(getText)
	if (team) then                         
		setPlayerTeam(plr, team)    
	else
		local team = createTeam(getText)
		setPlayerTeam(plr, team)   
	end
	outputChatBox(getPlayerName(source).." has set your team to "..getText, plr, 0, 225, 0)
	outputChatBox("You set "..getPlayerName(plr).."'s team to "..getText, source, 0, 225, 0)
end
addEventHandler("AdminPanel.setTeam", root, setTeam)

--giveVehicle
addEvent("AdminPanel.giveVehicle", true)
function giveVehicle(plr, getText)
	if (not isElement(plr)) then return end
	if (isPedInVehicle(plr)) then
		outputChatBox("Already in a vehicle", source, 225, 0, 0)
	else
		local veh
		local x, y, z = getElementPosition(plr)
		local rx, ry, rz = getElementRotation(plr)
		if (getVehicleModelFromName(getText)) then
			veh = createVehicle(getVehicleModelFromName(getText), x, y, z + 3)
		else
			veh = createVehicle(getText, x, y, z + 3)
		end
		if (veh) then
			warpPedIntoVehicle(plr, veh)
			setElementRotation(veh, 0, 0, rz)
		end
	end
end
addEventHandler("AdminPanel.giveVehicle", root, giveVehicle)

--giveWeap
addEvent("AdminPanel.giveWeap", true)
function giveWeap(plr, getText)
	if (not isElement(plr)) then return end
	local wepID = getWeaponIDFromName(getText)
	local wepName = getWeaponNameFromID(getText)
	if (wepID) then
		giveWeapon(plr, wepID, 200, true)
	end
	if (wepName) then
		giveWeapon(plr, wepName, 200, true)
	end
end
addEventHandler("AdminPanel.giveWeap", root, giveWeap)

--fixVeh
addEvent("AdminPanel.fixVeh", true)
function fixVeh(plr)
	if (not isElement(plr)) then return end
	if (isPedInVehicle(plr)) then
		local veh = getPedOccupiedVehicle(plr)
		setElementHealth(veh, 1000)
		fixVehicle(veh)
		outputChatBox(getPlayerName(source).." has fixed your vehcile", plr, 0, 225, 0)
		outputChatBox("You fixed "..getPlayerName(plr).."'s vehicle", source, 0, 225, 0)
	end
end
addEventHandler("AdminPanel.fixVeh", root, fixVeh)

addEvent("AdminPanel.destroyVeh", true)
function destroyVeh(plr)
	if (not isElement(plr)) then return end
	if (isPedInVehicle(plr)) then
		local veh = getPedOccupiedVehicle(plr)
		destroyElement(veh)
		outputChatBox(getPlayerName(source).." has destroyed your vehcile", plr, 0, 225, 0)
		outputChatBox("You destroyed "..getPlayerName(plr).."'s vehicle", source, 0, 225, 0)
	end
end
addEventHandler("AdminPanel.destroyVeh", root, destroyVeh)

addEvent("AdminPanel.blowVeh", true)
function blowVeh(plr)
	if (not isElement(plr)) then return end
	if (isPedInVehicle(plr)) then
		local veh = getPedOccupiedVehicle(plr)
		blowVehicle(veh)
		outputChatBox(getPlayerName(source).." blew your vehcile", plr, 0, 225, 0)
		outputChatBox("You blew "..getPlayerName(plr).."'s vehicle", source, 0, 225, 0)
	end
end
addEventHandler("AdminPanel.blowVeh", root, blowVeh)

addEventHandler("onUnban", root,
	function (ban, by)
		if (getPlayerName(by)) then
			return
		else
			outputChatBox("Console unbanned "..(getBanSerial(ban) or getBanIP(ban) or getBanUsername(ban)).." (Ban has expired)", root, 225, 225, 0)
		end
	end
)

addEvent("AdminPanel.giveAdminRights", true)
function giveAdminRights(plr)
	if (not isElement(plr)) then return end
	local isStaff = dbPoll(dbQuery(adminDB, "SELECT * FROM staffList WHERE staff=?", getAccountName(getPlayerAccount(plr))), -1)
	if (#isStaff == 0) then
		setElementData(plr, "isPlayerStaff", true)
		dbExec(adminDB, "INSERT INTO staffList(staff) VALUES(?)", getAccountName(getPlayerAccount(plr)))
		outputChatBox("Congratulations you have been given admin rights by"..getPlayerName(source), plr, 225, 225, 225)
		outputChatBox("You gave admin rights to"..getPlayerName(plr), source, 225, 225, 225)
	else
		outputChatBox("Already an admin", plr, 225, 225, 225)
	end
end
addEventHandler("AdminPanel.giveAdminRights", root, giveAdminRights)

addEvent("AdminPanel.removeAdminRights", true)
function removeAdminRights(plr)
	if (not isElement(plr)) then return end
	local isStaff = dbPoll(dbQuery(adminDB, "SELECT * FROM staffList WHERE staff=?", getAccountName(getPlayerAccount(plr))), -1)
	if (#isStaff == 1) then
		setElementData(plr, "isPlayerStaff", false)
		dbExec(adminDB, "DELETE FROM staffList WHERE staff=?", getAccountName(getPlayerAccount(plr)))
		outputChatBox("Your rights have been remove by "..getPlayerName(source), plr, 225, 225, 225)
		outputChatBox("You removed admin rights of "..getPlayerName(plr), source, 225, 225, 225)
	end
end
addEventHandler("AdminPanel.removeAdminRights", root, removeAdminRights)

function staffNote(plr,_,...)
	if (getElementData(plr, "isPlayerStaff")) then
		for i, v in pairs (getElementsByType("player")) do	
				local message = string.gsub(..., "#%x%x%x%x%x%x", "")
				if (message == "") then
					return
				else
					outputChatBox("(NOTE) "..getPlayerName(plr)..": "..message, v,  225, 0, 0, true)
				end
			end
		end
	end
addCommandHandler("note", staffNote)