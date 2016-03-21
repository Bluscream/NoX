require("NoX/settings")
require("NoX/functions")
local function onClientChannelGroupChangedEvent(sCHID, channelGroupID, channelID, clientID, invokerClientID, invokerName, invokerUniqueIdentity)
	if nox.setting.active then
		local clientIDown = ts3.getClientID(sCHID)
		if clientIDown == clientID then
			for i=1, #nox.setting.BanGroups do
				if nox.setting.BanGroups[i] == channelGroupID then
					KickedChannelID = channelID
					KickedChannelNAME = ts3.getChannelVariableAsString(sCHID, channelID, 0)
					ScriptLog("Saved Last Channel as \"".. KickedChannelNAME .. "\" ".."#"..KickedChannelID)
					setID(sCHID)
				end
			end
			for i=1, #nox.setting.SpamGroups do
				if nox.setting.SpamGroups[i] == channelGroupID then
					KickedChannelID = channelID
					KickedChannelNAME = ts3.getChannelVariableAsString(sCHID, channelID, 0)
					ScriptLog("Saved Last Channel as \"".. KickedChannelNAME .. "\" ".."#"..KickedChannelID)
					setID(sCHID)
				end
			end
		end
	end
end
local function onServerGroupClientAddedEvent(serverConnectionHandlerID, clientID, clientName, clientUniqueIdentity, serverGroupID, invokerClientID, invokerName, invokerUniqueIdentity)
	if nox.setting.active then
		if nox.setting.antiservergroup then
			local clientIDown = ts3.getClientID(sCHID)
			if clientIDown == clientID then
				local clientServerGroups = ts3.getClientVariableAsString(sCHID, clientID, ts3defs.ClientProperties.CLIENT_SERVERGROUPS)
				local clientServerGroups = str_split(clientServerGroups,",")
				for i=1, #clientServerGroups do
					for i=1, #nox.setting.BadServerGroups do
						if nox.setting.BadServerGroups[i] == clientServerGroups[i] then
							if oldChannelID == KickedChannelID and clientID == clientIDown then
								if isempty(nox.setting.capture_profile) then
									reJoin(sCHID)
								else
									reJoin(sCHID, nox.setting.capture_profile)
								end
							end	
						end
					end
				end
			end
		end
	end
end
local function onClientKickFromChannelEvent(sCHID, clientID, oldChannelID, newChannelID, visibility, kickerID, kickerName, kickerUniqueIdentifier, kickMessage)
	if nox.setting.active then
		if nox.setting.antikick.server.enabled or nox.setting.antiban.server.enabled then
			if clientID == ts3.getClientID(sCHID) then
				nox.var.backup.chid = newChannelID
				nox.var.backup.channelname = ts3.getChannelVariableAsString(sCHID, newChannelID, 0)
				ScriptLog("Backed up: "..nox.var.backup.channelname)
			end
		end
		if nox.setting.antikick.channel then
			if clientID == ts3.getClientID(sCHID) then
				ts3.requestClientMove(sCHID, clientID, oldChannelID, "")
			end
		end
		if nox.var.checkForKick == true then
			local clientIDown = ts3.getClientID(sCHID)
			-- ScriptLog(oldChannelID .. " " .. KickedChannelID)
			-- ScriptLog(clientID .. " " .. clientIDown)
			if oldChannelID == KickedChannelID and clientID == clientIDown then
				if isempty(nox.setting.capture_profile) then
					reJoin(sCHID)
				else
					reJoin(sCHID, nox.setting.capture_profile)
				end
				nox.var.checkForKick = false
			end	
		end
		if nox.setting.antidelete.channel then
			if clientID == ts3.getClientID(sCHID) and kickMessage == "channel deleted" then
				restore(sCHID)
				create(sCHID)
			end
		end
	end
end
local function onClientKickFromServerEvent(sCHID, clientID, oldChannelID, newChannelID, visibility, kickerID, kickerName, kickerUniqueIdentifier, kickMessage)
	if nox.setting.active and nox.setting.antikick.server.enabled then
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
local function onClientBanFromServerEvent(sCHID, clientID, oldChannelID, newChannelID, visibility, kickerID, kickerName, kickerUniqueIdentifier, kickTime, kickMessage)
	if nox.setting.active and nox.setting.antiban.server.enabled then
		if clientID == nox.var.backup.clid then
			os.execute(nox.setting.script)
			sleep(nox.setting.scripttime)
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
local function onServerErrorEvent(sCHID, errorMessage, errorCode, extraMessage)
	if nox.setting.active and nox.setting.antiban.server then
		if errorMessage == "connection failed, you are banned" or errorCode == 3329 then
			-- os.execute(nox.setting.script)
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
local function onServerUpdatedEvent(sCHID)
	if nox.setting.active then
		if nox.var.variables_Requested == true then
			reJoin(sCHID)
			nox.var.variables_Requested = false
		end
	end
end
local function onClientSelfVariableUpdateEvent(sCHID, flag, oldValue, newValue)
	if nox.setting.active then
		if nox.setting.antikick.server.enabled or nox.setting.antiban.server then
			if flag == 1 then
				nox.var.backup.nickname = newValue
				-- ScriptLog("Backed Up: "..nox.var.backup.nickname)
			end
		end
	end
end
local function onConnectStatusChangeEvent(sCHID, status, errorNumber)
	if nox.setting.active then
		if status == ts3defs.ConnectStatus.STATUS_DISCONNECTED then
		elseif status == ts3defs.ConnectStatus.STATUS_CONNECTING then
		elseif status == ts3defs.ConnectStatus.STATUS_CONNECTED then
			if nox.setting.antikick.server.enabled then
				nox.var.backup.clid = ts3.getClientID(sCHID)
				local ip = ts3.getConnectionVariableAsString(sCHID, nox.var.backup.clid, 6)
				local port = ts3.getConnectionVariableAsUInt64(sCHID, nox.var.backup.clid, 7)
				nox.var.backup.ip = ip .. ":" ..port
				nox.var.backup.nickname = ts3.getClientSelfVariableAsString(sCHID, 1)
			end
		elseif status == ts3defs.ConnectStatus.STATUS_CONNECTION_ESTABLISHING then
		elseif status == ts3defs.ConnectStatus.STATUS_CONNECTION_ESTABLISHED then
			if nox.setting.channelswitch == true then
				if nox.var.checkChannel == true then
					local ownID = ts3.getClientID(sCHID)
					local ownCID = ts3.getChannelOfClient(sCHID, ownID)
					if KickedChannelID ~= ownCID then
						ts3.requestClientMove(sCHID, ownID, KickedChannelID, "")
						ScriptLog("[Flood] Requested Client Move.")
						KickedChannelID = nil
						KickedChannelNAME = nil
					end
					nox.var.checkChannel = false
				end
			end
			if nox.setting.antikick.server.enabled then
				
				local chid = ts3.getChannelOfClient(sCHID, nox.var.backup.clid)
				nox.var.backup.channelname = ts3.getChannelVariableAsString(sCHID, chid, 0)
				ScriptLog("[Anti Server Kick] Backed up: "..nox.var.backup.ip.." | "..nox.var.backup.nickname.." | "..nox.var.backup.channelname.." #"..chid)
				
				if nox.var.checkChannel_server == true then
					if nox.var.backup.chid ~= chid then
						ts3.requestClientMove(sCHID, nox.var.backup.clid, nox.var.backup.chid, "")
						ScriptLog("[Flood] Requested Client Move.")
					end
					nox.var.checkChannel_server = false
				end
				nox.var.backup.chid = ts3.getChannelOfClient(sCHID, nox.var.backup.clid)
			end
			if nox.setting.ownchat then
				ts3.requestSendPrivateTextMsg(sCHID, "⁢⁢⁢⁢", ts3.getClientID(sCHID))
			end
			if nox.setting.archivebuilds.enabled then
				local platform = ts3.getServerVariableAsString(sCHID,ts3defs.VirtualServerProperties.VIRTUALSERVER_PLATFORM)
				local version = ts3.getServerVariableAsString(sCHID,ts3defs.VirtualServerProperties.VIRTUALSERVER_VERSION)
				appendtofile(sCHID, "server", platform, version)
			end
		end
	end
end
local function onClientMoveEvent(sCHID, clientID, oldChannelID, newChannelID, visibility, moveMessage)
	if nox.setting.active then
		if nox.setting.antikick.server.enabled then
			if clientID == ts3.getClientID(sCHID) then
				nox.var.backup.chid = newChannelID
				nox.var.backup.channelname = ts3.getChannelVariableAsString(sCHID, newChannelID, 0)
				ScriptLog("Backed up: "..nox.var.backup.channelname.." #"..nox.var.backup.chid)
			end
		end
		if nox.func.checkForSwitch == true then
			if clientID == ts3.getClientID(sCHID) then
				if nox.setting.auto_slowmode == true then
					nox.setting.slowmode = false
				end
				nox.var.bancount = 0
				nox.func.checkForSwitch = false
				local channelGroupID = ts3.getClientVariableAsInt(sCHID, clientID, ts3defs.ClientProperties.CLIENT_CHANNEL_GROUP_ID)
				for i=1, #nox.setting.BanGroups do
					if nox.setting.BanGroups[i] == channelGroupID then
						setID(sCHID)
					end
				end
				for i=1, #nox.setting.SpamGroups do
					if nox.setting.SpamGroups[i] == channelGroupID then
						setID(sCHID)
					end
				end
			end
		end
	end
	if nox.setting.archivebuilds.enabled then
		if oldChannelID == 0 then
			requestedclientvars = true
			requestedclientvarsclid = clientID
			ts3.requestClientVariables(sCHID, clientID)
		end
	end
	if nox.setting.antidelete.channel then
		if clientID == ts3.getClientID(sCHID) then
			resetChannelVARS(sCHID)
			backup(sCHID, newChannelID)
			ScriptLog("Backed up "..backup_channelName.." for antidelete.")
		end
	end
end
local function onClientMoveMovedEvent(sCHID, clientID, oldChannelID, newChannelID, visibility, moverID, moverName, moverUniqueIdentifier, moveMessage)
	if nox.setting.active then
		if nox.setting.antimove.enabled then
			if clientID == ts3.getClientID(sCHID) and moverID ~= 0 then
				if nox.setting.antimove.filter.enabled then
					if not isempty(nox.setting.antimove.filter.uids) then
						for i=1, #nox.setting.antimove.filter.uids do
							if nox.setting.antimove.filter.uids[i] == moverUniqueIdentifier then
								ScriptLog("\""..moverName.."\" tried to move you but he is not allowed to. Switching back to \""..nox.var.backup.channelname.."\"")
								ts3.requestClientMove(sCHID, clientID, oldChannelID, nox.setting.password.channel)
							end
						end
					end
					if not isempty(nox.setting.antimove.filter.allowedservergroups) then
						local clientServerGroups = ts3.getClientVariableAsString(sCHID, moverID, ts3defs.ClientProperties.CLIENT_SERVERGROUPS)
						ts3.printMessageToCurrentTab(clientServerGroups)
						local clientServerGroups = str_split(clientServerGroups,",")
						local move = true
						for k=1, #nox.setting.antimove.filter.allowedservergroups do
							for i=1, #clientServerGroups do
								log = log+1;ts3.printMessageToCurrentTab(log..": "..nox.setting.antimove.filter.allowedservergroups[k].."("..k..") "..clientServerGroups[i].."("..i..")")
								if nox.setting.antimove.filter.allowedservergroups[k] == clientServerGroups[i] then
									move = false
								end
							end
						end
						if move == true then
							ScriptLog("\""..moverName.."\" tried to move you but he is not allowed to. Switching back to \""..nox.var.backup.channelname.."\"")
							ts3.requestClientMove(sCHID, clientID, oldChannelID, nox.setting.password.channel)
							move = false
						else ts3.printMessageToCurrentTab("Allowed to move") end
					end
				else
					ScriptLog("\""..moverName.."\" tried to move you but you don't want to get moved. Switching back to \""..nox.var.backup.channelname.."\"")
					ts3.requestClientMove(sCHID, clientID, oldChannelID, nox.setting.password.channel)
				end
			end
		end
		if nox.setting.antidelete.channel then
			if clientID == ts3.getClientID(sCHID) then
				resetChannelVARS(sCHID)
				backup(sCHID, newChannelID)
				ScriptLog("Backed up "..backup_channelName.." for antidelete.")
			end
		end
	end
end
local function onUpdateClientEvent(sCHID, clientID, invokerID, invokerName, invokerUniqueIdentifier)
	if nox.setting.archivebuilds.enabled then
		if requestedclientvars and requestedclientvarsclid == clientID then
			local platform = ts3.getClientVariableAsString(sCHID,clientID,ts3defs.ClientProperties.CLIENT_PLATFORM)
			local version = ts3.getClientVariableAsString(sCHID,clientID,ts3defs.ClientProperties.CLIENT_VERSION)
			if platform == "Windows" or platform == "Linux" or platform == "OS X" then
				appendtofile(sCHID, "client" ,"Desktop", version)
			else
				appendtofile(sCHID, "client", platform, version)
			end
			requestedclientvars = false
			requestedclientvarsclid = nil
		end
	end
end
antiX_events = {
	onClientChannelGroupChangedEvent = onClientChannelGroupChangedEvent,
	onServerGroupClientAddedEvent = onServerGroupClientAddedEvent,
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