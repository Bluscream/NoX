nox = {
	info = {
		name = "No X Module", -- 
		prefix = "NoX",
		folder = "NoX",
		ext = "lua",
		ver = "1.2.1",
		author = "CHRiiS,Bluscream",
	},
	setting = { -- Edit below this line! --
		active = true, -- Enable the script.
		debug = false, -- The script show debug messages.
		archivebuilds = {
			enabled = false, -- Will create files that contain all client versions that you have ever seen.
			path = "D:\\Coding\\Projekte\\Teamspeak-Plugins\\builds",
			path_linux = "/media/bluscream/Win7Ultimate/Coding/Projekte/Teamspeak-Plugins/builds",
		},
		password = {
			server = "123", -- Serverpassword that will be used as default.
			channel = "123", -- Channelpassword that will be used as default.
		},
		ownchat = false, -- Opens a chat with yourself as notepad.
		failsave = false, -- If the antichannelban is not working as intended set this to true and try again.
		slowmode = true, -- If this is enabled the script will not instantly reconnect when you get a channel ban group, only after you also got kicked. (Enable only this or auto_slowmode)
		capture_profile = "", -- You can reconnect with a non-default Capture Profile when channel banned, usefull for screaming.
		channelswitch = false, -- Checks if the client is really in the channel where it got banned from and if not auto-switchs to that channel.
		auto_slowmode = false, -- A Timer based detection if you reconnected to much in a to short time. [BETA] (Enable only this or auto_slowmode)
		IDPrefix = "New identity_", -- The Prefix of created UID's. For example in german its "Neue Identität_".
		use_all_ids = false, -- If true, uses all IDs that you have, even your default one. If false, only the ones starting with "IDPrefix" will be used.
		BanGroups = { 12, 16, 11, 25 }, -- Channel Group ID's that should be detected as "Channel-Ban" groups.
		SpamGroups = { 13, 14 }, -- Channel Group ID's that should be detected as "Channel-Anti-Spam" groups.
		antimove = {
			enabled = false, -- Auto switch back when moved.
			filter = {
				enabled = true,
				uids = { 'serveradmin', 'serverquery' },
			},
		},
		antidelete = {
			channel = true,
		},
		antikick = {
			channel = true, -- Auto rejoin when you get kicked from a channel.
			server = {
				enabled = true, -- Auto reconnect when you get kicked from the server.
				script = {
					windows = "java -jar D:\\Downloaders\\JDownloader\\JDownloader.jar -r", -- Program to execute to get a new IP
					linux = "java -jar /opt/jd2/JDownloader.jar -r",
				},
				scriptbonustime = 15, -- The time in seconds that the reconnect script needs to get you a new IP.
				adapter = "enp6s0", -- The name of your network adapter if you are using linux.
			},
		},
		antiban = {
			channel = {
				enabled = true, -- Auto rejoin when you get banned from a channel.
			},
			server = true, -- Auto reconnect when you get banned from a server.
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
