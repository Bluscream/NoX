require("NoX/settings")

	if nox.setting.antikick.server then
		nox.var.backup.clid = ts3.getClientID(serverConnectionHandlerID)
		local ip = ts3.getConnectionVariableAsString(serverConnectionHandlerID, nox.var.backup.clid, 6)
		local port = ts3.getConnectionVariableAsUInt64(serverConnectionHandlerID, nox.var.backup.clid, 7)
		nox.var.backup.ip = ip .. ":" ..port
		nox.var.backup.nickname = ts3.getClientSelfVariableAsString(serverConnectionHandlerID, 1)
		nox.var.backup.chid = ts3.getChannelOfClient(serverConnectionHandlerID, nox.var.backup.clid)
		nox.var.backup.channelname = ts3.getChannelVariableAsString(serverConnectionHandlerID, chid, 0)
		ScriptLog("[Anti Server Kick] Backed up: "..nox.var.backup.ip.." | "..nox.var.backup.nickname.." | "..nox.var.backup.channelname.." #"..chid)
	end

ScriptLog("startup.lua loaded...")