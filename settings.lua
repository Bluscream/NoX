nox = {
	info = {
		name = "No X Module",
		prefix = "NoX",
		folder = "NoX",
		ext = "lua",
		ver = "1.1",
		author = "CHRiiS,Bluscream",
	},
	setting = {
		active = true,
		debug = true,
		failsave = false,
		slowmode = true,
		capture_profile = "",
		channelswitch = true,
		auto_slowmode = false,
		IDPrefix = "New identity_",
		AmountOfIDs = 508,
		BanGroups = { 12, 16 }, 
		SpamGroups = { 13, 14 },
		antikick = {
			channel = false,
			server = true,
		},
	},
	var = {
		lastID = 0,
		bancount = 0,
		variables_Requested = "false",
		checkForServerKick = false,
		backup = {
			clid = 0,
			chid = 0,
			ip = "127.0.0.1:9987",
			nickname = "TeamspeakUser",
			channelname = "Default Channel",
		},
	},
	func = {
		checkForSwitch = false,
	},
}
ScriptLog("settings.lua loaded...")