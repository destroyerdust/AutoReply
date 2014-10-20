---------------------------------------------
-- Local Ace3 Declarations
---------------------------------------------
AutoReply = LibStub("AceAddon-3.0"):NewAddon("AutoReply", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("AutoReply")

local AceGUI = LibStub("AceGUI-3.0")

---------------------------------------------
-- Configuration Options
---------------------------------------------
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
        reEnableInitScreen = {
            type = "toggle",
            name = "Enable/Disable Init Screen",
            desc = "Dat Screen",
            get = function() return AutoReply.db.profile.initScreen end,
            set = function(_, value) AutoReply.db.profile.initScreen = value end,
            order = 7,
        },
    },
}

---------------------------------------------
-- Message and enable option defaults
---------------------------------------------
AutoReply.defaults = {
	profile = {
		AFKMessage = L["I'm afk!"],
		enableAFK = true,
		DNDMessage = L["Do Not Disturb!"],
		enableDND = true,
		GuildAchivMessage = L["Grats on Achievement!"],
		enableGuildAchiv = true,
        initScreen = true,
	},
}



---------------------------------------------
-- Initilize Database, Options, Chat Commands
---------------------------------------------
function AutoReply:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("AutoReplyDB", self.defaults, true)

	LibStub("AceConfig-3.0"):RegisterOptionsTable("AutoReply", self.options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AutoReply", "AutoReply")
    self:RegisterChatCommand("ar", "ChatCommand")
    self:RegisterChatCommand("AutoReply", "ChatCommand")


    if AutoReply.db.profile.initScreen == true then
        ---------------------------------------------
        -- Initial Welcome Frame
        --
        -- TODO
        ---------------------------------------------

        local frame = AceGUI:Create("Frame")
        frame:SetTitle("AutoReply Initial Setup")
        frame:SetStatusText("AutoReply initialization screen. All settings can be changed in the addon options area.")
        frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) AutoReply.db.profile.initScreen = false end)
        frame:SetLayout("Flow")

        local initText = AceGUI:Create("Label")
        initText:SetText("Welcome to the AutoReply initilization window. This is the one time window to create custom messages, else the defaults will be used. These are changeable in the Addon Options area of the interface options.")
        initText:SetFullWidth(frame)
        frame:AddChild(initText)

        local AFKEditbox = AceGUI:Create("EditBox")
        AFKEditbox:SetLabel("Insert Custom AFK Message:")
        AFKEditbox:SetText(AutoReply.db.profile.AFKMessage)
        AFKEditbox:SetWidth(300)
        AFKEditbox:SetCallback("OnEnterPressed", function(widget, event, text) AutoReply.db.profile.AFKMessage = text end)
        frame:AddChild(AFKEditbox)

        local AFKEnableDisable = AceGUI:Create("CheckBox")
        AFKEnableDisable:SetLabel("Enable/Disable AFK Message Reply")
        AFKEnableDisable:SetValue(AutoReply.db.profile.enableAFK)
        AFKEnableDisable:SetCallback("OnValueChanged", function(widget, event, value) AutoReply.db.profile.enableAFK = value end)
        frame:AddChild(AFKEnableDisable)

        local DNDEditbox = AceGUI:Create("EditBox")
        DNDEditbox:SetLabel("Insert Custom DND Message:")
        DNDEditbox:SetText(AutoReply.db.profile.DNDMessage)
        DNDEditbox:SetWidth(300)
        DNDEditbox:SetCallback("OnEnterPressed", function(widget, event, text) AutoReply.db.profile.DNDMessage = text end)
        frame:AddChild(DNDEditbox)

        local DNDEnableDisable = AceGUI:Create("CheckBox")
        DNDEnableDisable:SetLabel("Enable/Disable DND Message Reply")
        DNDEnableDisable:SetValue(AutoReply.db.profile.enableDND)
        DNDEnableDisable:SetCallback("OnValueChanged", function(widget, event, value) AutoReply.db.profile.enableDND = value end)
        frame:AddChild(DNDEnableDisable)

        local GuilAchivEditbox = AceGUI:Create("EditBox")
        GuilAchivEditbox:SetLabel("Insert Custom Guild Achievement Message:")
        GuilAchivEditbox:SetText(AutoReply.db.profile.GuildAchivMessage)
        GuilAchivEditbox:SetWidth(300)
        GuilAchivEditbox:SetCallback("OnEnterPressed", function(widget, event, text) AutoReply.db.profile.GuildAchivMessage = text end)
        frame:AddChild(GuilAchivEditbox)

        local GuildAchivEnableDisable = AceGUI:Create("CheckBox")
        GuildAchivEnableDisable:SetLabel("Enable/Disable Guild Achievement Message Reply")
        GuildAchivEnableDisable:SetValue(AutoReply.db.profile.enableGuildAchiv)
        GuildAchivEnableDisable:SetCallback("OnValueChanged", function(widget, event, value) AutoReply.db.profile.enableGuildAchiv = value end)
        frame:AddChild(GuildAchivEnableDisable)

    end


    self:Print("AutoReply Initialized")
end

---------------------------------------------
-- Enable Event Registration
---------------------------------------------
function AutoReply:OnEnable()
	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")

	self:Print("AutoReply Enabled")
end

---------------------------------------------
-- Unregister Events
---------------------------------------------
function AutoReply:OnDisable()
	self:UnregisterEvent("CHAT_MSG_WHISPER")
	self:UnregisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
	self:UnregisterEvent("CHAT_MSG_BN_WHISPER")
end

---------------------------------------------
-- CHAT_MSG_WHISPER Event Handler
--
-- When a whisper comes from a character
-- handle it
---------------------------------------------
function AutoReply:CHAT_MSG_WHISPER(_, msg, sender,_,_,_,_,_,_,_,_,_,guid)
    --self:Print("GUID: '"..guid.."'")
    if guid ~= UnitGUID("player") then
	   self:WhisperHandler(msg, sender)
        --self:Print("Message Sent - Not self")
    else
        --self:Print("Don't want to send messages to self cause bad")
    end
end

---------------------------------------------
-- CHAT_MSG_BN_WHISPER Event Handler
--
-- When a whisper comes from Battle.net
-- handle it.
---------------------------------------------
function AutoReply:CHAT_MSG_BN_WHISPER(_, msg, ...)
	local BNpresenceId = select(12, ...)
	self:WhisperHandler(msg, BNpresenceId)
end

---------------------------------------------
-- Logic to whisper depending on BNet or
-- whisper and if the user is AFK or DND
-- and if the whisper back is enabled for each
---------------------------------------------
function AutoReply:WhisperHandler(msg, sender)
	-- Debug
	--self:Print("Msg: '"..msg.."'") -- Not used but testing it's useful
	--self:Print("Sender: '"..sender.."'")
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

---------------------------------------------
-- CHAT_MSG_GUILD_ACHIVEMENT Event Handler
--
-- If a guild member get's an achievement,
-- display the GuildAchivMessage if
-- the option is enabled.
---------------------------------------------
function AutoReply:CHAT_MSG_GUILD_ACHIEVEMENT()
	if AutoReply.db.profile.enableGuildAchiv == true then
		SendChatMessage(self.db.profile.GuildAchivMessage, string.upper("guild")) 
	end
end

---------------------------------------------
-- Open options off slash commands
---------------------------------------------
function AutoReply:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("ar", "AutoReply", input)
    end
end