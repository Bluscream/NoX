require("ts3init")
function ScriptLog(logMSG)
	if nox.setting.debug == true then
		local tsCol = { 'Green', 'Black', 'Red', 'Blue' }
		local RANDCOL = ( tsCol[ math.random( #tsCol ) ] )
		local scriptTimestamp = os.date("%x %X")
		ts3.printMessageToCurrentTab("[color=Black][[/color][color="..RANDCOL.."]"..scriptTimestamp.."[/color][color=Black]][/color]> ".. nox.info.prefix ..": "..logMSG)
	end
end
ts3.printMessageToCurrentTab("Loading NoX...")
require("NoX/settings")
if nox.setting.active == false then
	ts3.printMessageToCurrentTab("NoX deactivated in settings.lua. Shutting down...")
	return
end
require("NoX/functions")
require("NoX/events")
local registeredEvents = {
	onClientChannelGroupChangedEvent = antiX_events.onClientChannelGroupChangedEvent,
	onServerUpdatedEvent = antiX_events.onServerUpdatedEvent,
	onConnectStatusChangeEvent = antiX_events.onConnectStatusChangeEvent,
	onClientKickFromServerEvent = antiX_events.onClientKickFromServerEvent,
	onClientKickFromChannelEvent = antiX_events.onClientKickFromChannelEvent,
	onClientMoveEvent = antiX_events.onClientMoveEvent,
	onClientMoveMovedEvent = antiX_events.onClientMoveMovedEvent,
	onClientSelfVariableUpdateEvent = antiX_events.onClientSelfVariableUpdateEvent
}
ScriptLog("init.lua loaded...")
-- require("NoX/startup")
ts3.printMessageToCurrentTab(nox.info.name.." v"..nox.info.ver.." by "..nox.info.author.." loaded successfully!")
ts3RegisterModule(nox.info.MODULE, registeredEvents)
