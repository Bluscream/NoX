nox = {
	info = {
		name = "No X Module", -- 
		prefix = "NoX",
		folder = "NoX",
		ext = "lua",
		ver = "1.1",
		author = "CHRiiS,Bluscream",
	},
	setting = { -- Edit below this line! --
		active = true, -- Enable the script.
		debug = false, -- The script show debug messages.
		archivebuilds = {
			enabled = false, -- will create files that contain all client versions that you have ever seen.
			path = "D:\\Coding\\Projekte\\Teamspeak-Plugins\\builds\\client\\unsorted\\",
		},
		failsave = false, -- If the antichannelban is not working as intended set this to true and try again.
		slowmode = true, -- If this is enabled the script will not instantly reconnect when you get a channel ban group, only after you also got kicked. (Enable only this or auto_slowmode)
		capture_profile = "", -- You can reconnect with a non-default Capture Profile when channel banned, usefull for screaming.
		channelswitch = true, -- Checks if the client is really in the channel where it got banned from and if not auto-switchs to that channel.
		auto_slowmode = false, -- A Timer based detection if you reconnected to much in a to short time. [BETA] (Enable only this or auto_slowmode)
		IDPrefix = "New identity_", -- The Prefix of created UID's. For example in german its "Neue Identität_".
		AmountOfIDs = 508, -- The amount of Unique Identities you created for the Anti-Channel-Ban.
		BanGroups = { 12, 16 }, -- Channel Group ID's that should be detected as "Channel-Ban" groups.
		SpamGroups = { 13, 14 }, -- Channel Group ID's that should be detected as "Channel-Anti-Spam" groups.
		antimove = true, -- Auto switch back when moved.
		antikick = {
			channel = true, -- Auto rejoin when you get kicked from a channel.
			server = true, -- Auto reconnect when you get kicked from the server.
		},
		server = {
			GommeHD = {
				UID = "FI9+KF1c/BKx5dlFejAs8OJpnO0=",
				BadChannelGroups = { 12, 13 },
				BadServerGroups = { 13, 14 },
			},
			mtG = {
				UID = "LpfWDi8tO9blye3wZXZZ76uPAM8=",
				BadChannelGroups = { 12, 13 },
				BadServerGroups = { 13, 12 },
			},
		},
	}, -- Edit above this line! --
	var = {
		lastID = 0,
		bancount = 0,
		variables_Requested = false,
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
