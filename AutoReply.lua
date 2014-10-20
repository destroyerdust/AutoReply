AutoReply = LibStub("AceAddon-3.0"):NewAddon("AutoReply", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("AutoReply")

--local AceGUI = LibStub("AceGUI-3.0")

------------------------
-- Configuration Options
------------------------
AutoReply.options = {
    name = "AutoReply",
    handler = AutoReply,
    type = "group",
    args = {
        afkMsg = {
            type = "input",
            name = L["AFK Message"],
            desc = L["The message to be displayed when you are AFK."],
            usage = L["<Your AFK message>"],
            get = function() return AutoReply.db.profile.AFKMessage end,
            set = function(_, value) AutoReply.db.profile.AFKMessage = value end,
            width = "double",
            order = 1,
        },
        enableAFKMsg = {
            type = "toggle",
            name = L["Enable/Disable AFK Message"],
            desc = L["Enables or Disables the AFK Message"],
            get = function() return AutoReply.db.profile.enableAFK end,
            set = function(_, value) AutoReply.db.profile.enableAFK = value end,
            order = 2,
        },
        dndMsg = {
        	type = "input",
            name = L["DND Message"],
            desc = L["The message to be displayed when you are DND."],
            usage = L["<Your DND message>"],
            get = function() return AutoReply.db.profile.DNDMessage end,
            set = function(_, value) AutoReply.db.profile.DNDMessage = value end,
            width = "double",
            order = 3,
		},
        enableDNDMsg = {
            type = "toggle",
            name = L["Enable/Disable DND message"],
            desc = L["Enables or Disables the DND Message"],
            get = function() return AutoReply.db.profile.enableDND end,
            set = function(_, value) AutoReply.db.profile.enableDND = value end,
            order = 4,
        },
        guildAchiveMsg = {
        	type = "input",
        	name = L["Guild Achievement Message"],
        	desc = L["The message to be displayed when a guild member gets an Achievement"],
        	usage = L["<Your Guild Achievement message>"],
        	get = function() return AutoReply.db.profile.GuildAchivMessage end,
        	set = function(_, value) AutoReply.db.profile.GuildAchivMessage = value end,
        	width = "double",
        	order = 5,
    	},
    	enableGuildAchivMsg = {
            type = "toggle",
            name = L["Enable/Disable Guild Achievement message"],
            desc = L["Enables or Disables the Guild Achievement Message"],
            get = function() return AutoReply.db.profile.enableGuildAchiv end,
            set = function(_, value) AutoReply.db.profile.enableGuildAchiv = value end,
            order = 6,
        },
    },
}

AutoReply.defaults = {
	profile = {
		AFKMessage = L["I'm afk!"],
		enableAFK = true,
		DNDMessage = L["Do Not Disturb!"],
		enableDND = true,
		GuildAchivMessage = L["Grats on Achievement!"],
		enableGuildAchiv = true,
	},
}

--local mainFrame = AceGUI:Create("Frame")
--mainFrame:SetTitle("Auto Reply")
--mainFrame:SetStatusText("Welcome to main frame version 1.0")

function AutoReply:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("AutoReplyDB", self.defaults, true)

	LibStub("AceConfig-3.0"):RegisterOptionsTable("AutoReply", self.options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AutoReply", "AutoReply")
    self:RegisterChatCommand("ar", "ChatCommand")
    self:RegisterChatCommand("AutoReply", "ChatCommand")

    self:Print("AutoReply Initialized")
end

function AutoReply:OnEnable()
	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")

	self:Print("AutoReply Enabled")
end

function AutoReply:OnDisable()
	self:UnregisterEvent("CHAT_MSG_WHISPER")
	self:UnregisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
	self:UnregisterEvent("CHAT_MSG_BN_WHISPER")
end

function AutoReply:CHAT_MSG_WHISPER(_, msg, sender)
	self:WhisperHandler(msg, sender)
end

function AutoReply:CHAT_MSG_BN_WHISPER(_, msg, ...)
	local BNpresenceId = select(12, ...)
	self:WhisperHandler(msg, BNpresenceId)
end

function AutoReply:WhisperHandler(msg, sender)
	-- Debug
	self:Print("Msg: '"..msg.."'") -- Not used but testing it's useful
	self:Print("Sender: '"..sender.."'")
	--

	if type(sender) == "number" and select(7, BNGetFriendInfoByID(sender)) then
		if UnitIsAFK("player") and AutoReply.db.profile.enableAFK == true then
			BNSendWhisper(sender, AutoReply.db.profile.AFKMessage)
		elseif UnitIsDND("player") and AutoReply.db.profile.enableDND == true then
			BNSendWhisper(sender, AutoReply.db.profile.DNDMessage)
		end
	elseif type(sender) == "string" then
		sender = sender:gsub(" ", "") -- Removes spaces if any
		if UnitIsAFK("player") and AutoReply.db.profile.enableAFK == true then
			SendChatMessage(AutoReply.db.profile.AFKMessage, "WHISPER", nil, sender)
		elseif UnitIsDND("player") and AutoReply.db.profile.enableDND == true then
			SendChatMessage(AutoReply.db.profile.DNDMessage, "WHISPER", nil, sender)
		end
	end
end

function AutoReply:CHAT_MSG_GUILD_ACHIEVEMENT()
	if AutoReply.db.profile.enableGuildAchiv == true then
		SendChatMessage(self.db.profile.GuildAchivMessage, string.upper("guild"))
	end
end

function AutoReply:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("ar", "AutoReply", input)
    end
end