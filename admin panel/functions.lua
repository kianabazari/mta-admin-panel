------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--  RIGHTS:      All rights reserved by developer
--  FILE:        adminPanel/functions.lua
--  DEVELOPER:   Kian
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

local panelBind = "0"

--=========================================Don't edit anything below this or you might break it=========================================--
function openAdminPanel()	
	if (getElementData(localPlayer, "isPlayerStaff")) then
		if (guiGetVisible(adminWindow[1])) then  
			--closes the window
			for i=1, 5 do 
				guiSetVisible(adminWindow[i], false)
			end
			showCursor(false)
		else  
			--opens the window
			guiSetVisible(adminWindow[1], true)
			showCursor(true)
		end
	end
end
addCommandHandler("adminp", openAdminPanel)
bindKey(panelBind, "down", "adminp")

function getGridlistPlayer()
	--Get selected player
	local plr = getPlayerFromName(guiGridListGetItemText(adminGrid[1], guiGridListGetSelectedItem(adminGrid[1]), 1))
	if (plr) then
		return plr
	end
end

function onGridClick()
	--When you click on a player
	local plr = getGridlistPlayer()
	if (plr == "" or plr == nil) then
		return
	else
		triggerServerEvent("AdminPanel.onGridClick", localPlayer, plr)
	end
end

addEvent("AdminPanel.setPlayerDetails", true)
function setPlayerDetails(plr, IP, account, aclGroup, serial)
	--Sets player details
	local x, y, z = getElementPosition (plr)
	local weaponPlr = getPedWeapon(plr)
	local vehPlr = getPedOccupiedVehicle(plr)
	if (weaponPlr) then
		weapon = getWeaponNameFromID(weaponPlr).." (ID : "..weaponPlr..")"
	else
		weapon = "No weapon in hand"
	end
	if (vehPlr) then
		veh = getVehicleName(vehPlr)
		vehHealth = math.floor(getElementHealth(vehPlr)).."%"
	else
		veh = " Foot"
		vehHealth = " N/A"
	end
	if (isElementFrozen(plr)) then
		guiSetText(adminButton[4], "Unfreeze")
	else
		guiSetText(adminButton[4], "Freeze")
	end
	guiSetText(adminLabel[1], "Name : "..getPlayerName(plr))
	guiSetText(adminLabel[2], "IP : "..IP)
	guiSetText(adminLabel[3], "Serial : "..serial)
	guiSetText(adminLabel[4], "Account : "..account)
	guiSetText(adminLabel[5], "ACL Group : "..aclGroup)
	guiSetText(adminLabel[6], "Health : "..getElementHealth(plr))
	guiSetText(adminLabel[7], "Armour : "..getPedArmor(plr))
	guiSetText(adminLabel[8], "Skin : "..getElementModel(plr))
	if (getPlayerTeam(plr))then
		guiSetText(adminLabel[9], "Team : "..getTeamName(getPlayerTeam(plr)))
	else
		guiSetText(adminLabel[9], "Team : None")
	end
	guiSetText(adminLabel[10], "Occupation : "..(getElementData(plr, "Occupation") or "None"))
	guiSetText(adminLabel[11], "Weapon : "..weapon)
	guiSetText(adminLabel[12], "Ping : "..getPlayerPing(plr))
	guiSetText(adminLabel[13], "Location : "..getZoneName(x, y, z).." ("..getZoneName(x, y, z, true)..")")
	guiSetText(adminLabel[14], "X : "..x)
	guiSetText(adminLabel[15], "Y : "..y)
	guiSetText(adminLabel[16], "Z : "..z)
	guiSetText(adminLabel[17], "Dimension : "..getElementDimension(plr))
	guiSetText(adminLabel[18], "Interior : "..getElementInterior(plr))
	guiSetText(adminLabel[19], "Vehicle : "..veh)
	guiSetText(adminLabel[20], "Vehicle Health : "..vehHealth)
	guiSetText(adminLabel[21], "Group : "..(getElementData(plr, "groupName") or "None").." ("..(getElementData(plr, "groupRank") or "None")..")")
	guiSetText(adminLabel[22], "Account created on : "..(getElementData(plr, "accountCreation") or "N/A"))
	guiSetText(adminLabel[23], "Playtime : "..(getElementData(plr, "PlayTime") or "None"))
	guiSetText(adminLabel[24], "Money : "..getPlayerMoney(plr))
end
addEventHandler("AdminPanel.setPlayerDetails", root, setPlayerDetails)

function warpToPlayer()
	--Funtion to warp to slected player
	local plr = getGridlistPlayer()
	if (plr == "") then 
		return
	else
		triggerServerEvent("AdminPanel.warpToPlayer", localPlayer, plr)
	end
end

function freezePlayer()
	--Funtion to freeze slected player
	local plr = getGridlistPlayer()
	if (plr == "") then 
		return
	else
		triggerServerEvent("AdminPanel.freezePlayer", localPlayer, plr)
		onGridClick()
	end
end

function spectatePlayer()
	--Funtion to spectate slected player
	local plr = getGridlistPlayer()
	if (plr == "") then 
		return
	else
		triggerServerEvent("AdminPanel.spectatePlayer", localPlayer, plr)
	end
end

function renamePlayer()
	--Funtion to rename slected player
	local plr = getGridlistPlayer()
	local getText = guiGetText(adminEdit[2])
	if (plr == "" or getText == "") then 
		return
	else
		triggerServerEvent("AdminPanel.renamePlayer", localPlayer, plr, getText)
		onGridClick()
	end
end

function slapPlayer()
	--Funtion to slap slected player
	local plr = getGridlistPlayer()
	local getText = guiGetText(adminEdit[3])
	if (plr == "" or getText == "") then 
		return
	else
		triggerServerEvent("AdminPanel.slapPlayer", localPlayer, plr, getText)
		onGridClick()
	end
end

function giveArmor()
	--Funtion to set slected player' armor
	local plr = getGridlistPlayer()
	local getText = guiGetText(adminEdit[4])
	if (plr == "" or getText == "") then 
		return
	else
		triggerServerEvent("AdminPanel.giveArmor", localPlayer, plr, getText)
		onGridClick()
	end
end

function giveHealth()
	--Funtion to set slected player' health
	local plr = getGridlistPlayer()
	local getText = guiGetText(adminEdit[5])
	if (plr == "" or getText == "") then 
		return
	else
		triggerServerEvent("AdminPanel.giveHealth", localPlayer, plr, getText)
		onGridClick()
	end
end

function setSkin()
	--Funtion to set slected player's skin
	local plr = getGridlistPlayer()
	local getText = guiGetText(adminEdit[6])
	if (plr == "" or getText == "") then 
		return
	else
		triggerServerEvent("AdminPanel.setSkin", localPlayer, plr, getText)
		onGridClick()
	end
end

function setDimension()
	--Funtion to set slected player's dimension
	local plr = getGridlistPlayer()
	local getText = guiGetText(adminEdit[7])
	if (plr == "" or getText == "") then 
		return
	else
		triggerServerEvent("AdminPanel.setDimension", localPlayer, plr, getText)
		onGridClick()
	end
end

function setInterior()
	--Funtion to set slected player's interior
	local plr = getGridlistPlayer()
	local getText = guiGetText(adminEdit[8])
	if (plr == "" or getText == "") then 
		return
	else
		triggerServerEvent("AdminPanel.setInterior", localPlayer, plr, getText)
		onGridClick()
	end
end

function setTeam()
	--Funtion to set slected player' team
	local plr = getGridlistPlayer()
	local getText = guiGetText(adminEdit[9])
	if (plr == "" or getText == "") then 
		return
	else
		triggerServerEvent("AdminPanel.setTeam", localPlayer, plr, getText)
		onGridClick()
	end
end

function giveVehicle()
	--Funtion to give slected player a vehicle
	local plr = getGridlistPlayer()
	local getText = guiGetText(adminEdit[10])
	if (plr == "" or getText == "") then 
		return
	else
		triggerServerEvent("AdminPanel.giveVehicle", localPlayer, plr, getText)
		onGridClick()
	end
end

function giveWeap()
	--Funtion to give slected player a weapon
	local plr = getGridlistPlayer()
	local getText = guiGetText(adminEdit[11])
	if (plr == "" or getText == "") then 
		return
	else
		triggerServerEvent("AdminPanel.giveWeap", localPlayer, plr, getText)
		onGridClick()
	end
end

function blowVeh()
	--Funtion to blow slected player's vehicle
	local plr = getGridlistPlayer()
	if (plr == "") then 
		return
	else
		triggerServerEvent("AdminPanel.blowVeh", localPlayer, plr)
		onGridClick()
	end
end

function destroyVeh()
	--Funtion to destroy slected player's vehicle
	local plr = getGridlistPlayer()
	if (plr == "") then 
		return
	else
		triggerServerEvent("AdminPanel.destroyVeh", localPlayer, plr)
	end
end

function fixVeh()
	--Funtion to fix slected player's vehicle
	local plr = getGridlistPlayer()
	if (plr == "") then 
		return
	else
		triggerServerEvent("AdminPanel.fixVeh", localPlayer, plr)
		onGridClick()
	end
end

addEvent("AdminPanel.openBanWindow", true)
function openBanWindow()
	guiGridListClear(adminGrid[5])
	if (not guiGetVisible(adminWindow[3])) then
		guiSetVisible(adminWindow[3], true) 
		guiBringToFront(adminWindow[3]) 
	end
	guiSetText(adminEdit[15], "IP/Serial/Username")
	guiSetText(adminEdit[16], "Ban Reason")
	guiSetText(adminEdit[17], "Ban Time")
	triggerServerEvent("AdminPanel.getBanList", localPlayer)
end
addEventHandler("AdminPanel.openBanWindow", root, openBanWindow)

function adminUnban()
	local ban, type = checkBanColumn()
	if (ban) then
		triggerServerEvent("AdminPanel.adminUnban", localPlayer, ban, type)
	end
end

function checkBanColumn()
	local getText1 = guiGridListGetItemText(adminGrid[5], guiGridListGetSelectedItem(adminGrid[5]), 2)
	local getText2 = guiGridListGetItemText(adminGrid[5], guiGridListGetSelectedItem(adminGrid[5]), 5)
	local getText3 = guiGridListGetItemText(adminGrid[5], guiGridListGetSelectedItem(adminGrid[5]), 6)
	if (not (getText1 == "N/A")) then
		return getText1, "Account Ban"
	elseif (not (getText2 == "N/A")) then
		return getText2, "IP Ban"
	elseif (not (getText3 == "N/A")) then
		return getText3, "Serial Ban"
	elseif (getText1 == nil or getText2 == nil or getText3 == nil) then
		return false, false
	end
end

function adminManualBan()
	local getText1 = guiGetText(adminEdit[15])
	local getText2 = guiGetText(adminEdit[16])
	local getText3 = tonumber(guiGetText(adminEdit[17]))
	local getComboText = guiComboBoxGetItemText(adminCombo[2], guiComboBoxGetSelected(adminCombo[2]))
	if (getText1 == "" or getText2 == "" or getText3 == "" or getComboText == "") then
		return
	else
		triggerServerEvent("AdminPanel.adminAddBan", localPlayer, getText1, getText2, getText3, getComboText)
	end
end

addEvent("AdminPanel.setBanList", true)
function setBanList(reason, nick, ip, serial, banDate, unBanDate, admin, account)
	--sets the ban list
	local row = guiGridListAddRow(adminGrid[5])
	if (unBanDate == 0) then
		unBanDate = "Permanent"
	end
	guiGridListSetItemText(adminGrid[5], row, adminColumn[8], nick or "N/A", false, false)
	guiGridListSetItemText(adminGrid[5], row, adminColumn[9], account or "N/A", false, false)
	guiGridListSetItemText(adminGrid[5], row, adminColumn[10], tostring(admin) or "N/A", false, false)
	guiGridListSetItemText(adminGrid[5], row, adminColumn[11], reason or "N/A", false, false)
	guiGridListSetItemText(adminGrid[5], row, adminColumn[12], tostring(banDate) or "N/A", false, false)
	guiGridListSetItemText(adminGrid[5], row, adminColumn[13], tostring(unBanDate) or "N/A", false, false)
	guiGridListSetItemText(adminGrid[5], row, adminColumn[14], tostring(ip) or "N/A", false, false)
	guiGridListSetItemText(adminGrid[5], row, adminColumn[15], tostring(serial) or "N/A", false, false)
end
addEventHandler("AdminPanel.setBanList", root, setBanList)