require("NoX/settings")
require("NoX/functions")
function onClientChannelGroupChangedEvent(serverConnectionHandlerID, channelGroupID, channelID, clientID, invokerClientID, invokerName, invokerUniqueIdentity)
	if nox.setting.active then
		local clientIDown = ts3.getClientID(serverConnectionHandlerID)
		if clientIDown == clientID then
			for i=1, #nox.setting.BanGroups do
				if nox.setting.BanGroups[i] == channelGroupID then
					KickedChannelID = channelID
					KickedChannelNAME = ts3.getChannelVariableAsString(serverConnectionHandlerID, channelID, 0)
					ScriptLog("Saved Last Channel as \"".. KickedChannelNAME .. "\" ".."#"..KickedChannelID)
					setID(serverConnectionHandlerID)
				end
			end
			for i=1, #nox.setting.SpamGroups do
				if nox.setting.SpamGroups[i] == channelGroupID then
					KickedChannelID = channelID
					KickedChannelNAME = ts3.getChannelVariableAsString(serverConnectionHandlerID, channelID, 0)
					ScriptLog("Saved Last Channel as \"".. KickedChannelNAME .. "\" ".."#"..KickedChannelID)
					setID(serverConnectionHandlerID)
				end
			end
		end
	end
end
function onClientKickFromChannelEvent(serverConnectionHandlerID, clientID, oldChannelID, newChannelID, visibility, kickerID, kickerName, kickerUniqueIdentifier, kickMessage)
	if nox.setting.active then
		if nox.setting.antikick.server then
			if clientID == ts3.getClientID(serverConnectionHandlerID) then
				nox.var.backup.chid = newChannelID
				nox.var.backup.channelname = ts3.getChannelVariableAsString(serverConnectionHandlerID, newChannelID, 0)
				ScriptLog("Backed up: "..nox.var.backup.channelname)
			end
		end
		if nox.setting.antikick.channel then
			if clientID == ts3.getClientID(serverConnectionHandlerID) then
				ts3.requestClientMove(serverConnectionHandlerID, clientID, oldChannelID, "")
			end
		end
		if nox.var.checkForKick == true then
			local clientIDown = ts3.getClientID(serverConnectionHandlerID)
			-- ScriptLog(oldChannelID .. " " .. KickedChannelID)
			-- ScriptLog(clientID .. " " .. clientIDown)
			if oldChannelID == KickedChannelID and clientID == clientIDown then
				if isempty(nox.setting.capture_profile) then
					reJoin(serverConnectionHandlerID)
				else
					reJoin(serverConnectionHandlerID, nox.setting.capture_profile)
				end
				nox.var.checkForKick = false
			end	
		end
	end
end
function onClientKickFromServerEvent(serverConnectionHandlerID, clientID, oldChannelID, newChannelID, visibility, kickerID, kickerName, kickerUniqueIdentifier, kickMessage)
	if nox.setting.active then
		-- nox.var.checkForServerKick = true
		if clientID == nox.var.backup.clid then
			if not isempty(nox.var.backup.channelname) and not string.find(nox.var.backup.channelname, "/") then
				local channelname = string.gsub(nox.var.backup.channelname, '%/', '%\\/')
				ScriptLog("Re-Connecting to "..nox.var.backup.ip.." as "..nox.var.backup.nickname.." in "..channelname)
				ts3.guiConnect(1, "NoX AntiKick",nox.var.backup.ip, "", nox.var.backup.nickname,channelname,"","","","","","","","")
				nox.var.checkChannel_server = true
			else
				ScriptLog("Re-Connecting to "..nox.var.backup.ip.." as "..nox.var.backup.nickname.." in "..nox.var.backup.channelname)
				ts3.guiConnect(1, "NoX AntiKick",nox.var.backup.ip, "", nox.var.backup.nickname,nox.var.backup.channelname,"","","","","","","","")
				nox.var.checkChannel_server = true
			end
		end
	end
end
function onServerUpdatedEvent(serverConnectionHandlerID)
	if nox.setting.active then
		if nox.var.variables_Requested == true then
			reJoin(serverConnectionHandlerID)
			nox.var.variables_Requested = false
		end
	end
end
function onClientSelfVariableUpdateEvent(serverConnectionHandlerID, flag, oldValue, newValue)
	if nox.setting.active then
		if nox.setting.antikick.server then
			if flag == 1 then
				nox.var.backup.nickname = newValue
				-- ScriptLog("Backed Up: "..nox.var.backup.nickname)
			end
		end
	end
end

function onConnectStatusChangeEvent(serverConnectionHandlerID, status, errorNumber)
	if nox.setting.active then
		if status == ts3defs.ConnectStatus.STATUS_DISCONNECTED then
			if nox.setting.debug then
				ScriptLog("Connect Status of tab "..serverConnectionHandlerID.." changed. New status: STATUS_DISCONNECTED with error "..errorNumber)
			end
		elseif status == ts3defs.ConnectStatus.STATUS_CONNECTING then
			if nox.setting.debug then
				ScriptLog("Connect Status of tab "..serverConnectionHandlerID.." changed. New status: STATUS_CONNECTING with error "..errorNumber)
			end
		elseif status == ts3defs.ConnectStatus.STATUS_CONNECTED then
			if nox.setting.debug then
				ScriptLog("Connect Status of tab "..serverConnectionHandlerID.." changed. New status: STATUS_CONNECTED with error "..errorNumber)
			end
		elseif status == ts3defs.ConnectStatus.STATUS_CONNECTION_ESTABLISHING then
			if nox.setting.debug then
				ScriptLog("Connect Status of tab "..serverConnectionHandlerID.." changed. New status: STATUS_CONNECTION_ESTABLISHING with error "..errorNumber)
			end
		elseif status == ts3defs.ConnectStatus.STATUS_CONNECTION_ESTABLISHED then
			if nox.setting.channelswitch == true then
				if nox.var.checkChannel == true then
					local ownID = ts3.getClientID(serverConnectionHandlerID)
					local ownCID = ts3.getChannelOfClient(serverConnectionHandlerID, ownID)
					if KickedChannelID ~= ownCID then
						ts3.requestClientMove(serverConnectionHandlerID, ownID, KickedChannelID, "")
						ScriptLog("[Flood] Requested Client Move.")
						KickedChannelID = nil
						KickedChannelNAME = nil
					end
					nox.var.checkChannel = false
				end
			end
			if nox.setting.antikick.server == true then
				nox.var.backup.clid = ts3.getClientID(serverConnectionHandlerID)
				local ip = ts3.getConnectionVariableAsString(serverConnectionHandlerID, nox.var.backup.clid, 6)
				local port = ts3.getConnectionVariableAsUInt64(serverConnectionHandlerID, nox.var.backup.clid, 7)
				nox.var.backup.ip = ip .. ":" ..port
				nox.var.backup.nickname = ts3.getClientSelfVariableAsString(serverConnectionHandlerID, 1)
				local chid = ts3.getChannelOfClient(serverConnectionHandlerID, nox.var.backup.clid)
				nox.var.backup.channelname = ts3.getChannelVariableAsString(serverConnectionHandlerID, chid, 0)
				ScriptLog("[Anti Server Kick] Backed up: "..nox.var.backup.ip.." | "..nox.var.backup.nickname.." | "..nox.var.backup.channelname.." #"..chid)
				
				if nox.var.checkChannel_server == true then
					if nox.var.backup.chid ~= chid then
						ts3.requestClientMove(serverConnectionHandlerID, nox.var.backup.clid, nox.var.backup.chid, "")
						ScriptLog("[Flood] Requested Client Move.")
					end
					nox.var.checkChannel_server = false
				end
				nox.var.backup.chid = ts3.getChannelOfClient(serverConnectionHandlerID, nox.var.backup.clid)
			end
			if nox.setting.debug then
				ScriptLog("Connect Status of tab "..serverConnectionHandlerID.." changed. New status: STATUS_CONNECTION_ESTABLISHED with error "..errorNumber)
			end
		end
	end
end
function onClientMoveEvent(serverConnectionHandlerID, clientID, oldChannelID, newChannelID, visibility, moveMessage)
	if nox.setting.active then
		if nox.setting.antikick.server then
			if clientID == ts3.getClientID(serverConnectionHandlerID) then
				nox.var.backup.chid = newChannelID
				nox.var.backup.channelname = ts3.getChannelVariableAsString(serverConnectionHandlerID, newChannelID, 0)
				ScriptLog("Backed up: "..nox.var.backup.channelname.." #"..nox.var.backup.chid)
			end
		end
		if nox.func.checkForSwitch == true then
			local clientIDown = ts3.getClientID(serverConnectionHandlerID)
			if clientID == clientIDown then
				if nox.setting.auto_slowmode == true then
					nox.setting.slowmode = false
				end
				nox.var.bancount = 0
				nox.func.checkForSwitch = false
				local channelGroupID = ts3defs.ClientProperties.CLIENT_CHANNEL_GROUP_ID
				for i=1, #nox.setting.BanGroups do
					if nox.setting.BanGroups[i] == channelGroupID then
						setID(serverConnectionHandlerID)
					end
				end
				for i=1, #nox.setting.SpamGroups do
					if nox.setting.SpamGroups[i] == channelGroupID then
						setID(serverConnectionHandlerID)
					end
				end
			end
		end
	end
	if nox.setting.archivebuilds.enabled then
		if oldChannelID == 0 then
			requestedclientvars = true
			requestedclientvarsclid = clientID
			ts3.requestClientVariables(serverConnectionHandlerID, clientID)
		end
	end
end
function onClientMoveMovedEvent(serverConnectionHandlerID, clientID, oldChannelID, newChannelID, visibility, moverID, moverName, moverUniqueIdentifier, moveMessage)
	if nox.setting.active then
		if nox.setting.antimove then
			if clientID == ts3.getClientID(serverConnectionHandlerID) and moverID ~= 0 then
				ts3.requestClientMove(serverConnectionHandlerID, clientID, oldChannelID, "")
			end
		end
	end
end
function onUpdateClientEvent(serverConnectionHandlerID, clientID, invokerID, invokerName, invokerUniqueIdentifier)
	if nox.setting.archivebuilds.enabled then
		if requestedclientvars and requestedclientvarsclid == clientID then
			local platform = ts3.getClientVariableAsString(serverConnectionHandlerID,clientID,ts3defs.ClientProperties.CLIENT_PLATFORM)
			local version = ts3.getClientVariableAsString(serverConnectionHandlerID,clientID,ts3defs.ClientProperties.CLIENT_VERSION)
			appendtofile(platform, version)
			requestedclientvars = false
			requestedclientvarsclid = nil
		end
	end
end
antiX_events = {
	onClientChannelGroupChangedEvent = onClientChannelGroupChangedEvent,
	onServerUpdatedEvent = onServerUpdatedEvent,
	onConnectStatusChangeEvent = onConnectStatusChangeEvent,
	onClientKickFromServerEvent = onClientKickFromServerEvent,
	onClientKickFromChannelEvent = onClientKickFromChannelEvent,
	onClientMoveEvent = onClientMoveEvent,
	onClientMoveMovedEvent = onClientMoveMovedEvent,
	onClientSelfVariableUpdateEvent = onClientSelfVariableUpdateEvent,
	onUpdateClientEvent = onUpdateClientEvent
}
ScriptLog("events.lua loaded...")