------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--  RIGHTS:      All rights reserved by developer
--  FILE:        adminPanel/resource_s.lua
--  DEVELOPER:   Kian
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

addEvent("AdminPanel.getResource", true)
function getResource()
	local resources = {}
	local res = getResources()
	for i=1, #res do
		resources[i] = {getResourceName(res[i]), getResourceState(res[i])}
	end
	triggerClientEvent("AdminPanel.setResources", source, resources)
	resources = {}
end
addEventHandler("AdminPanel.getResource", root, getResource)

addEvent("AdminPanel.resourceStart", true)
function resourceStart(resourceName)
	local resourceName1 = getResourceFromName(resourceName)
	local resourceStarted = startResource(resourceName1)
	refreshResources(true)
	getResource()
	if (resourceStarted) then
		outputChatBox(resourceName .. " was started successfully.", source, 0, 225, 0)
	end
end
addEventHandler("AdminPanel.resourceStart", root, resourceStart)

addEvent("AdminPanel.resourceStop", true)
function resourceStop(resourceName)
	local resourceName1 = getResourceFromName(resourceName)
	local resourceStop = stopResource(resourceName1)
	refreshResources(true)
	getResource()
	if (resourceStop) then
		outputChatBox(resourceName .. " was stoped successfully.", source, 0, 225, 0)
	end
end
addEventHandler("AdminPanel.resourceStop", root, resourceStop)

addEvent("AdminPanel.resourceRestart", true)
function resourceRestart(resourceName)
	local resourceName1 = getResourceFromName(resourceName)
	local resourceRestart = restartResource(resourceName1)
	refreshResources(true)
	getResource()
	if (resourceRestart) then
		outputChatBox(resourceName .. " was restarted successfully.", source, 0, 225, 0)
	end
end
addEventHandler("AdminPanel.resourceRestart", root, resourceRestart)
