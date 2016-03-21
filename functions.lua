require("NoX/settings")
function isempty(s)
  return s == nil or s == '' or s == {}
end
function antix(sCHID, arg, value)
	if not isempty(arg) then
		arg = string.lower(arg)
	end
	
	if not isempty(value) then
		value = string.lower(value)
	end

	if arg == "bc" then
		if isempty(value) then
			ts3.printMessageToCurrentTab("NoX: Ban count = "..nox.var.bancount)
		elseif value == "reset" then
			ts3.printMessageToCurrentTab("NoX: Resetted ban count")
			nox.var.bancount = 0
		else
			ts3.printMessageToCurrentTab("NoX: Setting ban count from "..nox.var.bancount.." to "..value)
			nox.var.bancount = value
		end
	end
end
function getIDList()
	local open = io.open
	local filnam = ts3.getConfigPath().."ts3clientui_qt.secrets.conf"
	local filnam = string.gsub(filnam, "\\", "\\\\")
    local file = open(filnam, "r")
	id_list = {}
	newid_list = {}
	 for line in file:lines() do
		if string.find(line, '/id=') then
			local line = ""..string.gsub(line, "%d+/id=", "")
			local line = ""..string.gsub(line, "%%20", " ")
			table.insert(id_list, line)
			if string.find(line, nox.setting.IDPrefix) then
				table.insert(newid_list, line)
			end
		end
	 end
    file:close()
	ts3.printMessageToCurrentTab("Got List of ID's with a Length of "..#id_list.." and a total of "..#newid_list.." "..nox.setting.IDPrefix.."'s and "..#id_list-#newid_list.." others.")
end

function printID(scHID, id)
	getIDList()
	ts3.printMessageToCurrentTab("General: "..id_list[id])
	ts3.printMessageToCurrentTab(nox.setting.IDPrefix..": "..newid_list[id])
end

function printIDs()
	getIDList()
	str = ""
	for i=1, #id_list do
		str = str..id_list[i]..", "
	end
	ts3.printMessageToCurrentTab(str)
	str = nil;
end

function appendtofile(sCHID, typ, platform, version)
	if nox.setting.archivebuilds.path ~= "" then
		if typ == "server" then
			path = nox.setting.archivebuilds.path.."\\"..typ.."\\unsorted.csv"
		else
			path = nox.setting.archivebuilds.path.."\\"..typ.."\\unsorted\\"..platform..".csv"
		end
	else
		path = string.gsub(os.getenv("UserProfile"), "\\", "\\\\")
		if typ == "server" then
			path = path.."\\Desktop\\builds_"..typ..".csv"
		else
			path = path.."\\Desktop\\builds_"..typ.."_"..platform..".csv"
		end
	end
	local file = io.open(path, "a")
	for line in io.lines(path) do
		if line == version then
			skipLine = true
		end
	end
	if not skipLine then
		-- local build = string.gsub(version, " ^\\[Build:", ",")
		-- local str = string.gsub(str, "%s", ",")
		-- os.date("%x", build)
		-- ts3.printMessageToCurrentTab(str)
		-- local build = tonumber(string.match(version, "%d+"))
		-- file:write(build..","..version..","..bd..","..bt..",?,?,\n")
		file:write(version.."\n")
		file:close()
		ts3.printMessageToCurrentTab("Printed "..version.." to "..path)
	end
	skipLine = false
	path = nil
end

function getPlatform()
	if os.getenv("APPDATA") then
		if os.getenv("HOME") then
			return "cygwin";
		else
			return "windows";
		end
	elseif os.getenv("HOME") then
		return "unix";
	else
		return "unknown";
	end
end

function str_split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function sleep(s)
  local ntime = os.time() + s
  repeat until os.time() > ntime
end

function reConnect(sCHID)
	var_i = math.random(0,nox.setting.AmountOfIDs)
	if var_i == nox.var.lastID then
		var_i = math.random(0,nox.setting.AmountOfIDs)
		return
	end
	local clientIDown = ts3.getClientID(sCHID)
	local channelIDown = ts3.getChannelOfClient(sCHID, clientIDown)
	KickedChannelID = channelIDown
	KickedChannelNAME = ts3.getChannelVariableAsString(sCHID, channelIDown, 0)
	ScriptLog("Triggered manual rejoin in channel \"".. KickedChannelNAME .."\" #"..KickedChannelID)
	reJoin(sCHID)
end
function setID(sCHID)
	var_i = math.random(0,nox.setting.AmountOfIDs)
	if var_i == nox.var.lastID then
		setID(sCHID)
		return
	end
	if nox.setting.slowmode == true then
		nox.var.checkForKick = true
		nox.func.checkForSwitch = true
	else
		if nox.setting.failsave == true then
			nox.var.variables_Requested = true
			ts3.requestServerVariables(sCHID)
			ScriptLog("[Flood] Requested Server Variables.")
		else
			if isempty(nox.setting.capture_profile) then
				reJoin(sCHID)
			else
				reJoin(sCHID, nox.setting.capture_profile)
			end
		end
	end
end
function reJoin(sCHID, mode)
	local clientIDown = ts3.getClientID(sCHID)
	local ip = ts3.getConnectionVariableAsString(sCHID, clientIDown, 6)
	local port = ts3.getConnectionVariableAsUInt64(sCHID, clientIDown, 7)
	local ip = ip .. ":" ..port
	local nickName = ts3.getClientSelfVariableAsString(sCHID, 1)
	local channelPassworded = ts3.getChannelVariableAsInt(sCHID, KickedChannelID, ts3defs.ChannelProperties.CHANNEL_FLAG_PASSWORD)
	if channelPassworded == 0 then
		if not isempty(nox.var.lastbanned) then
			if os.time() > nox.var.lastbanned + 5 then
				nox.var.bancount = nox.var.bancount
			elseif os.time() > nox.var.lastbanned + 10 then
				nox.var.bancount = nox.var.bancount - 1
			else
				nox.var.bancount = nox.var.bancount + 1
			end
		end
		nox.var.lastbanned = os.time()
		ScriptLog("Last Banned: "..nox.var.lastbanned)
		ScriptLog("Bancount: "..nox.var.bancount)
		if not isempty(mode) then
			ScriptLog("Capture Profile: "..mode)
		end
		if not isempty(KickedChannelNAME) and not string.find(KickedChannelNAME, "/") then
			local TempKickedChannelNAME = string.gsub(KickedChannelNAME, '%/', '%\\/')
			if not isempty(mode) then
				ts3.guiConnect(1, "NoX #" .. var_i,ip, "", nickName,TempKickedChannelNAME,"",mode,"","","",nox.setting.IDPrefix .. var_i,"","")
			else
				ts3.guiConnect(1, "NoX #" .. var_i,ip, "", nickName,TempKickedChannelNAME,"","","","","",nox.setting.IDPrefix .. var_i,"","")
			end
		else
			if not isempty(mode) then
				ts3.guiConnect(1, "NoX #" .. var_i,ip, "", nickName,KickedChannelNAME,"",mode,"","","",nox.setting.IDPrefix .. var_i,"","")
			else
				ts3.guiConnect(1, "NoX #" .. var_i,ip, "", nickName,KickedChannelNAME,"","","","","",nox.setting.IDPrefix .. var_i,"","")
			end
		end
		nox.var.lastID = var_i
		ScriptLog("Saved last ID as #" .. nox.var.lastID )
		nox.var.checkChannel = true
		if nox.setting.auto_slowmode == true then
			if nox.var.bancount >= 3 then
				nox.setting.slowmode = true
				nox.func.checkForSwitch = true
			end
		end
	end
end
local function resetChannelVARS(sCHID)
	backup_channelName = nil
	backup_channelNamePhonetic = nil
	backup_channelPassword = nil
	backup_channelTopic = nil
	backup_channelDescription = nil
	backup_channelMaxClients = nil
	backup_channelMaxFamilyClients = nil
	backup_channelNeededTP = nil
	backup_channelIconID = nil
	backup_channelIsSemi = nil
	backup_channelIsPerma = nil
	backup_channelIsDefault = nil
	backup_channelCodec = nil
	backup_channelCodecQuality = nil
end
function reCreate(sCHID)
	resetChannelVARS(sCHID)
	local clientID, error = ts3.getClientID(sCHID)
	if error ~= ts3errors.ERROR_ok then
		ts3.printMessageToCurrentTab("Failed to get ClientID: " .. error)
	end
	local channelID, error = ts3.getChannelOfClient(
		sCHID, clientID)
	if error ~= ts3errors.ERROR_ok then
		ts3.printMessageToCurrentTab("Error getting ChannelID: "  .. error)
	end
	backup(sCHID,channelID)
	restore(sCHID)
	create(sCHID)
end
function backup(sCHID,channelID)
	ts3.printMessageToCurrentTab('beckup')
	backup_channelName = ts3.getChannelVariableAsString(sCHID, channelID, ts3defs.ChannelProperties.CHANNEL_NAME)
	backup_channelNamePhonetic = ts3.getChannelVariableAsString(sCHID, channelID, ts3defs.ChannelProperties.CHANNEL_NAME_PHONETIC)
	backup_channelTopic = ts3.getChannelVariableAsString(sCHID, channelID, ts3defs.ChannelProperties.CHANNEL_TOPIC)
	backup_channelDescription = ts3.getChannelVariableAsString(sCHID, channelID, ts3defs.ChannelProperties.CHANNEL_DESCRIPTION)
	backup_channelMaxClients = ts3.getChannelVariableAsString(sCHID, channelID, ts3defs.ChannelProperties.CHANNEL_MAXCLIENTS)
	backup_channelMaxFamilyClients = ts3.getChannelVariableAsString(sCHID, channelID, ts3defs.ChannelProperties.CHANNEL_MAXFAMILYCLIENTS)
	backup_channelNeededTP = ts3.getChannelVariableAsInt(sCHID, channelID, ts3defs.ChannelProperties.CHANNEL_NEEDED_TALK_POWER)
	backup_channelIconID = ts3.getChannelVariableAsInt(sCHID, channelID, ts3defs.ChannelProperties.CHANNEL_ICON_ID)
	backup_channelIsSemi = ts3.getChannelVariableAsInt(sCHID, channelID, ts3defs.ChannelProperties.CHANNEL_FLAG_SEMI_PERMANENT)
	backup_channelIsPerma = ts3.getChannelVariableAsInt(sCHID, channelID, ts3defs.ChannelProperties.CHANNEL_FLAG_PERMANENT)
	backup_channelIsDefault = ts3.getChannelVariableAsInt(sCHID, channelID, ts3defs.ChannelProperties.CHANNEL_FLAG_DEFAULT)
	backup_channelCodec = ts3.getChannelVariableAsString(sCHID, channelID, ts3defs.ChannelProperties.CHANNEL_CODEC)
	backup_channelCodecQuality = ts3.getChannelVariableAsInt(sCHID, channelID, ts3defs.ChannelProperties.CHANNEL_CODEC_QUALITY)
end
function restore(sCHID)
	if not isempty(backup_channelName) then
		ts3.setChannelVariableAsString(sCHID, 0,ts3defs.ChannelProperties.CHANNEL_NAME,backup_channelName.."⁢⁢⁢⁢")
	end
	if not isempty(backup_channelNamePhonetic) then
		ts3.setChannelVariableAsString(sCHID, 0,ts3defs.ChannelProperties.CHANNEL_NAME_PHONETIC,backup_channelNamePhonetic)
	end
	if not isempty(backup_channelTopic) then
		ts3.setChannelVariableAsString(sCHID, 0,ts3defs.ChannelProperties.CHANNEL_TOPIC,backup_channelTopic)
	end
	if not isempty(backup_channelDescription) then
		ts3.setChannelVariableAsString(sCHID, 0,ts3defs.ChannelProperties.CHANNEL_DESCRIPTION,backup_channelDescription)
	end
	if not isempty(backup_channelMaxClients) and backup_channelMaxClients ~= "-1" then
		ts3.printMessageToCurrentTab("Orignal Channel Max Clients: [color=red]"..backup_channelMaxClients)
		ts3.setChannelVariableAsString(sCHID, 0,ts3defs.ChannelProperties.CHANNEL_MAXCLIENTS,backup_channelMaxClients)
	end
	if not isempty(backup_channelMaxFamilyClients) and backup_channelMaxFamilyClients ~= "-1" then
		ts3.printMessageToCurrentTab("Orignal Channel Max Family Clients: [color=orange]"..backup_channelMaxFamilyClients)
		ts3.setChannelVariableAsString(sCHID, 0,ts3defs.ChannelProperties.CHANNEL_MAXFAMILYCLIENTS,backup_channelMaxFamilyClients)
	end
	if not isempty(backup_channelNeededTP) then
		ts3.setChannelVariableAsInt(sCHID, 0,ts3defs.ChannelProperties.CHANNEL_NEEDED_TALK_POWER,backup_channelNeededTP)
	end
	if not isempty(backup_channelIconID) then
		ts3.setChannelVariableAsInt(sCHID, 0,ts3defs.ChannelProperties.CHANNEL_ICON_ID,backup_channelIconID)
	end
	if not isempty(backup_channelIsSemi) then
		ts3.setChannelVariableAsInt(sCHID, 0,ts3defs.ChannelProperties.CHANNEL_FLAG_SEMI_PERMANENT,backup_channelIsSemi)
	end
	if not isempty(backup_channelCodec) then
		ts3.setChannelVariableAsString(sCHID, 0,ts3defs.ChannelProperties.CHANNEL_CODEC,backup_channelCodec)
	end
	if not isempty(backup_channelCodecQuality) then
		ts3.setChannelVariableAsInt(sCHID, 0,ts3defs.ChannelProperties.CHANNEL_CODEC_QUALITY,backup_channelCodecQuality)
	end	
end
function create(sCHID)
	local channelparentPath = {"User Channels", ""}
	local parentChannelID = ts3.getChannelIDFromChannelNames(sCHID, channelparentPath)
	local channelFlush, error = ts3.flushChannelCreation(sCHID, parentChannelID)
	if not isempty(error) then
		ts3.printMessageToCurrentTab("Error: "..error)
	end
	-- if error == 0 then
		-- local clientIDown  = ts3.getClientID(sCHID)
		-- local channelIDs = {}
		-- channelIDs[1] = channelName
		-- local UsedCID = ts3.getChannelIDFromChannelNames(sCHID, channelIDs)
		-- ts3.requestClientMove(sCHID, clientIDown, UsedCID, channelPassword)
		-- return
	-- elseif error ~= ts3errors.ERROR_ok then
		-- ts3.printMessageToCurrentTab("Error Creating Channel: "  .. error". Retrying...")
		-- create(sCHID)
		-- return
	-- end
	-- if error ~= ts3errors.ERROR_ok then
		-- if not isempty(channelName) then
			-- ts3.printMessageToCurrentTab("Error creating channel: " .. channelName .. " " .. error)
			-- return
		-- else
			-- ts3.printMessageToCurrentTab("Error creating channel. Error ID: "  .. error)
			-- return
		-- end
	-- end
end
ScriptLog("functions.lua loaded...")