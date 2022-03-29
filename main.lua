
local Ace = LibStub("AceAddon-3.0")
local AceDb = LibStub("AceDB-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDbOpts = LibStub("AceDBOptions-3.0")

AquaEterna = Ace:NewAddon("AquaEterna", "AceConsole-3.0", "AceEvent-3.0")

function AquaEterna:OnInitialize()
	local defaults = self:LoadDefaultProfile()
	self.db = AceDb:New("AquaDb", defaults, true)

	AceConfig:RegisterOptionsTable("settings", self:LoadOptions())
	self.optionsFrame = AceConfigDialog:AddToBlizOptions("settings", "AquaEterna")

	local profiles = AceDbOpts:GetOptionsTable(self.db)
	AceConfig:RegisterOptionsTable("profiles", profiles)
	AceConfigDialog:AddToBlizOptions("profiles", "Profiles", "AquaEterna")

	self:RegisterChatCommand("ae", "CommandHandler")
	self:RegisterChatCommand("aqua", "CommandHandler")
end

function AquaEterna:OnEnable()
	self:Enable()
end

function AquaEterna:OnDisable()
	self:Disable()
end

function AquaEterna:Enable()
	self:RegisterLootFilter()
end

function AquaEterna:Disable()
	self:UnregisterLootFilter()
end

function AquaEterna:CommandHandler(input)
	if not input or input:trim() == "" then
		-- https://github.com/Stanzilla/WoWUIBugs/issues/89
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	end
end

function AquaEterna:DisplayIcon(IconId)
    local Icon = IconClass(IconId)
    return Icon:GetIconString()
end