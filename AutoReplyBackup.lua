AutoReply = LibStub("AceAddon-3.0"):NewAddon("AutoReply", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("AutoReply")

local AceGUI = LibStub("AceGUI-3.0")

local defaults = {
	AFKMessage = L["I'm afk!"],
	DNDMessage = L["Do Not Disturb!"]
	enableAFK = true,
	enableDND = true
}

local mainFrame = AceGUI:Create("Frame")
mainFrame:SetTitle("Auto Reply")
mainFrame:SetStatusText("Welcome to main frame version 1.0")

function AutoReply:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("AutoReplyDB", defaults, true)

	LibStub("AceConfig-3.0"):RegisterOptionsTable("AutoReply", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AutoReply", "AutoReply")
    self:RegisterChatCommand("ar", "ChatCommand")
    self:RegisterChatCommand("AutoReply", "ChatCommand")

    Print("AutoReply Initialized")
end

function AutoReply:OnEnable()
end

function AutoReply:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("ar", "AutoReply", input)
    end
end

function AutoReply:GetAFKMessage(info)
	return self.db.AFKMessage
end

function AutoReply:SetAFKMessage(info, newValue)
	self.db.AFKMessage = newValue
end

function AutoReply:GetDNDMessage(info)
	return self.db.DNDMessage
end

function AutoReply:SetDNDMessage(info, newValue)
	self.db.DNDMessage = newValue
end

function AutoReply:EnabledAFK( info )
	return self.db.enableAFK
end

function AutoReply:ToggleEnabledDND( info, value )
	self.db.enableDND = value
end

function AutoReply:EnabledDND( info )
	return self.db.enableDND
end

function AutoReply:ToggleEnabledDND( info, value )
	self.db.enableDND = value
end