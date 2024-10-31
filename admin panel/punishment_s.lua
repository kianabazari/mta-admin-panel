------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--  RIGHTS:      All rights reserved by developer
--  FILE:        adminPanel/punishment_s.lua
--  DEVELOPER:   Kian
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

local rulesTime =
{
	-- this is for calculating the time automatically
	-- ["Reason"] = time in seconds,
	["Deathmatching"] = 250,
	["Revenge Killing"] = 250,
	["Trolling"] = 250,
	["Exploiting/Cheating"] = 250,
	["Non English"] = 250,
	["Spamming/Flooding"] = 250,
	["Advertising"] = 250,
	["Evading"] = 250,
}

local jailPos = 
{
	-- for jail locations
	-- {x, y, z, int}
	{196.89841, 175.17732, 1003.02344, 3},
	{193.41698, 175.17732, 1003.02344, 3},
}

--=========================================Don't edit anything below this or you might break it=========================================--

local muteTable = {}
local muteTimer = {}
local jailTable = {}
local jailTimer = {}

function getDate()
	local time = getRealTime()
	local year = time.year + 1900
	local month = time.month + 1
	local day = time.monthday
	local hour = time.hour
	local minute = time.minute
	return ("["..day.."/"..month.."/"..year.."]["..hour..":"..minute.."]")
end

function kickPlr(plr, reason)
	local message = getPlayerName(source).." has kicked "..getPlayerName(plr).." ("..reason..")"
	addPunishment(plr, source, "Kick", reason, "", message)
	kickPlayer(plr, source, reason)
end

function mutePlr(plr, reason, time)
	if (reason == "Removing Punishment") then
			muteTable[plr] = 5000
			local message = getPlayerName(source).." has muted "..getPlayerName(plr).." for "..reason.." ("..(muteTable[plr]/1000).." seconds)"
			addPunishment(plr, source, "Mute", reason, muteTable[plr]/1000, message)
		return
	end
	if (time) then
		if (isPlayerMuted(plr)) then 
			muteTable[plr] = muteTable[plr] + time*1000
			local message = getPlayerName(source).." has muted "..getPlayerName(plr).." for "..reason.." ("..time.." seconds)"
			addPunishment(plr, source, "Mute", reason, time, message)
		else
			mutePlayer(plr, time)
			local message = getPlayerName(source).." has muted "..getPlayerName(plr).." for "..reason.." ("..time.." seconds)"
			addPunishment(plr, source, "Mute", reason, time, message)
		end
	else
		if (rulesTime[reason] == nil) then
			outputChatBox("Couldn't find time for this reason", source, 225, 0, 0)
			return
		end
		local time, count = getPunishment(plr, "Mute", reason)
		if (time) then
			if (isPlayerMuted(plr)) then 
				muteTable[plr] = muteTable[plr] + time*1000
				local message = getPlayerName(source).." has muted "..getPlayerName(plr).." for "..reason.." ("..time.." seconds) (x"..count..")"
				addPunishment(plr, source, "Mute", reason, time, message)
			else
				mutePlayer(plr, time)
				local message = getPlayerName(source).." has muted "..getPlayerName(plr).." for "..reason.." ("..time.." seconds) (x"..count..")"
				addPunishment(plr, source, "Mute", reason, time, message)
			end
		end
	end
end

function jailPlr(plr, reason, time)
	if (reason == "Removing Punishment") then
		jailTable[plr] = 5000
		local message = getPlayerName(source).." has jailed "..getPlayerName(plr).." for "..reason.." ("..(jailTable[plr]/1000).." seconds)"
		addPunishment(plr, source, "Jail", reason, jailTable[plr]/1000, message)
		return
	end
	if (time) then
		if (jailTable[plr]) then
			jailTable[plr] = jailTable[plr] + time*1000
			local message = getPlayerName(source).." has jailed "..getPlayerName(plr).." for "..reason.." ("..time.." seconds)"
			addPunishment(plr, source, "Jail", reason, time, message)
		else
			jailPlayer(plr, time)
			local message = getPlayerName(source).." has jailed "..getPlayerName(plr).." for "..reason.." ("..time.." seconds)"
			addPunishment(plr, source, "Jail", reason, time, message)
		end
	else
		if (rulesTime[reason] == nil) then
			outputChatBox("Couldn't find time for this reason", source, 225, 0, 0)
			return
		end
		local time, count = getPunishment(plr, "Jail", reason)
		if (time) then
			if (jailTable[plr]) then
				jailTable[plr] = jailTable[plr] + time*1000
				local message = getPlayerName(source).." has jailed "..getPlayerName(plr).." for "..reason.." ("..time.." seconds) (x"..count..")"
				addPunishment(plr, source, "Jail", reason, time, message)
			else
				jailPlayer(plr, time)
				local message = getPlayerName(source).." has jailed "..getPlayerName(plr).." for "..reason.." ("..time.." seconds) (x"..count..")"
				addPunishment(plr, source, "Jail", reason, time, message)
			end
		end
	end
end

function banPlr(plr,  reason, time)
	if (time) then
		local message = getPlayerName(source).." has banned "..getPlayerName(plr).." for "..reason.." ("..time.." seconds)"
		addPunishment(plr, source, "Ban", reason, time, message)
		banPlayer(plr, true, true, true, source, reason, time*1000)
	else
		outputChatBox("Specify time", source, 225, 0, 0)
	end
end

addEvent("AdminPanel.punishPlayer", true)
function punishPlayer(plr, punishment, reason, time)
	if (punishment == "Kick Player") then
		kickPlr(plr, reason)
	elseif (punishment == "Mute Player") then
		mutePlr(plr, reason, time)
	elseif (punishment == "Jail Player") then
		jailPlr(plr, reason, time)
	elseif (punishment == "Ban Player") then
		banPlr(plr, reason, time)
	end
end
addEventHandler("AdminPanel.punishPlayer", root, punishPlayer)

function jailPlayer(plr, time)
	if (isPedInVehicle(plr)) then
		removePedFromVehicle(plr)
	end
	local jailNo = math.random(1,#jailPos)
	setElementInterior(plr, jailPos[jailNo][4])
	setElementPosition(plr, jailPos[jailNo][1], jailPos[jailNo][2], jailPos[jailNo][3])
	unJailTimer(plr, time*1000)
end

function mutePlayer(plr, time)
	setPlayerMuted(plr, true)
	unMuteTimer(plr, time*1000)
end

function unMuteTimer(plr, time)
	muteTable[plr] = time
	muteTimer[plr] = setTimer(
						function ()
							muteTable[plr] = tonumber(muteTable[plr]) - 1000 
							if (muteTable[plr] == 0 and isPlayerMuted(plr)) then
								setPlayerMuted(plr, false)
								outputChatBox("You have been unmuted", plr, 0, 225, 0) 
								muteTable[plr] = nil
								if (isTimer(muteTimer[plr])) then
									killTimer(muteTimer[plr])
								end
							end
						end
						, 1000
						,0
					)
end

function unJailTimer(plr, time)
	jailTable[plr] = time
	jailTimer[plr] = setTimer(
						function ()
							jailTable[plr] = tonumber(jailTable[plr]) - 1000
							if (jailTable[plr] == 0) then
								jailTable[plr] = nil
								setElementInterior(plr, 0)
								setElementPosition(plr, 1553.33386, -1675.62659, 16.19531)
								outputChatBox("You have been released", plr, 0, 225, 0) 
								if (isTimer(jailTimer[plr])) then
									killTimer(jailTimer[plr])
								end
							end
						end
						, 1000
						,0
					)
end

function addPunishment(plr, by, type, reason, time, message)
	local date = getDate()
	local log = date.." "..message
	local punishTable = dbPoll(dbQuery(adminDB, "SELECT * FROM punishments"), -1)
	dbExec(adminDB, "INSERT INTO punishments(id, player, admin, type, reason, log, serial) VALUES(?,?,?,?,?,?,?)", #punishTable + 1, getPlayerName(plr), getPlayerName(by), type, reason, log, getPlayerSerial(plr))
	outputChatBox(message, root, 225, 225, 0)
	if (type == "Jail") then
		outputChatBox(getPlayerName(by).." has jailed you for "..reason.." ("..time.." seconds)", plr, 225, 0, 0)
	elseif (type == "Mute") then
		outputChatBox(getPlayerName(by).." has muted you for "..reason.." ("..time.." seconds)", plr, 225, 0, 0)
	end
end

function getPunishment(plr, type, reason)
	local punishTable = dbPoll(dbQuery(adminDB, "SELECT * FROM punishments WHERE type=? and reason=? and serial=?", type, reason, getPlayerSerial(plr)), -1)
	local count = #punishTable + 1
	if (count) then
		return (count * rulesTime[reason]), count
	end 
end

addEventHandler("onPlayerLogin", root,
	function()
		local time = dbPoll(dbQuery(adminDB, "SELECT * FROM punishmentEvaders WHERE serial=?", getPlayerSerial(source)), -1)
		if (#time > 0) then
			if (time[1].jailTime and time[1].muteTime) then
				jailPlayer(source, tonumber(time[1].jailTime))
				mutePlayer(source, tonumber(time[1].muteTime))		
				dbExec(adminDB,"DELETE FROM punishmentEvaders WHERE serial=?", getPlayerSerial(source))
				outputChatBox("You have been jailed for "..time[1].jailTime, source, 225, 0, 0)	
				outputChatBox("You have been muted for "..time[1].muteTime, source, 225, 0, 0)
			elseif (time[1].jailTime) then
				jailPlayer(source, tonumber(time[1].jailTime))
				dbExec(adminDB,"DELETE FROM punishmentEvaders WHERE serial=?", getPlayerSerial(source))
				outputChatBox("You have been jailed for "..time[1].jailTime, source, 225, 0, 0)
			elseif (time[1].muteTime) then
				mutePlayer(source, tonumber(time[1].muteTime))				
				dbExec(adminDB,"DELETE FROM punishmentEvaders WHERE serial=?", getPlayerSerial(source))
				outputChatBox("You have been muted for "..time[1].muteTime, source, 225, 0, 0)
			end
		end
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		if (jailTable[source] and muteTable[source]) then
			dbExec(adminDB, "INSERT INTO punishmentEvaders(name, serial, muteTime, jailTime) VALUES(?,?,?,?)",getPlayerName(source), getPlayerSerial(source), muteTable[source]/1000, jailTable[source]/1000)
			jailTable[source] = nil
			muteTable[source] = nil
			killTimer(jailTimer[source])
			killTimer(muteTimer[source])
		elseif (jailTable[source]) then
			dbExec(adminDB, "INSERT INTO punishmentEvaders(name, serial, jailTime) VALUES(?,?,?)",getPlayerName(source), getPlayerSerial(source), jailTable[source]/1000)
			jailTable[source] = nil
			killTimer(jailTimer[source])
		elseif (muteTable[source]) then
			dbExec(adminDB, "INSERT INTO punishmentEvaders(name, serial, muteTime) VALUES(?,?,?)",getPlayerName(source), getPlayerSerial(source), muteTable[source]/1000)
			muteTable[source] = nil
			killTimer(muteTimer[source])
		end
	end
)

addCommandHandler("jailtime",
	function (plr)
		if (jailTable[plr]) then
			outputChatBox((tonumber(jailTable[plr]/1000)).." seconds remaining", plr, 0, 225, 0)
		end
	end
)

addCommandHandler("mutetime",
	function (plr)
		if (muteTable[plr]) then
			outputChatBox((tonumber(muteTable[plr]/1000)).." seconds remaining", plr, 0, 225, 0)
		end
	end
)