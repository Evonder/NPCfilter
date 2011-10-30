--[[
File Author: @file-author@
File Revision: @file-abbreviated-hash@
File Date: @file-date-iso@
]]--

local NPCfilter = LibStub("AceAddon-3.0"):GetAddon("NPCfilter")
local L = LibStub("AceLocale-3.0"):GetLocale("NPCfilter")
local NPCf = NPCfilter

--[[ Locals ]]--
local ipairs = ipairs
local pairs = pairs
local format = string.format
local insert = table.insert
local sort = table.sort
local sub = string.sub
local version = GetAddOnMetadata("NPCfilter", "Version")
local buildDate = GetAddOnMetadata("NPCfilter", "X-Date")
local tocTitle = GetAddOnMetadata("NPCfilter", "Title")

--[[ Options Table ]]--
local options
function NPCf:getOptions()
	if not options then
		options = {
			type="group",
			name = NPCf.name,
			handler = NPCf,
			childGroups = "tab",
			args = {
				NPCfgeneralGroup = {
					type = "group",
					name = NPCf.name,
					args = {
						mainHeader = {
							type = "description",
							name = "  " .. L["NJAOF"] .. "\n  " .. version .. "\n  " .. buildDate,
							order = 1,
							image = "Interface\\Icons\\Ability_Warrior_Rampage",
							imageWidth = 32, imageHeight = 32,
						},
						turnOn = {
							type = 'toggle',
							order = 2,
							width = "double",
							name = L["TurnOn"],
							desc = L["TurnOnDesc"],
							get = function() return NPCf.db.profile.turnOn end,
							set = function()
								if (NPCf.db.profile.turnOn == false) then
									print(tocTitle .. " " .. version .. " " .. L["ENABLED"])
									NPCf.db.profile.turnOn = not NPCf.db.profile.turnOn
								else
									print(tocTitle .. " " .. version .. " " .. L["DISABLED"])
									NPCf.db.profile.turnOn = not NPCf.db.profile.turnOn
								end
							end,
						},
						npcGroup = {
							type = "group",
							handler = NPCf,
							order = 5,
							disabled = function()
								return not NPCf.db.profile.turnOn
							end,
							name = L["Filter NPCs"],
							desc = L["Filter NPC Chat and/or Yelling"],
							args = {
								filterNPC = {
									type = 'toggle',
									order = 1,
									width = "full",
									name = L["Filter NPCs"],
									desc = L["Filter NPC Chat and/or Yelling"],
									get = function() return NPCf.db.profile.filterNPC end,
									set = function() NPCf.db.profile.filterNPC = not NPCf.db.profile.filterNPC end,
								},							
								optionsHeader4 = {
									type	= "header",
									order	= 2,
									name	= L["When & Where"],
								},
								filterNPC_say = {
									type = 'toggle',
									order = 3,
									name = L["NPC Chat"],
									desc = L["Filter normal NPC Chat"],
									get = function() return NPCf.db.profile.filterNPC_say end,
									set = function() NPCf.db.profile.filterNPC_say = not NPCf.db.profile.filterNPC_say end,
								},
								filterNPC_yell = {
									type = 'toggle',
									order = 4,
									name = L["NPC Yelling"],
									desc = L["Filter NPC Yells"],
									get = function() return NPCf.db.profile.filterNPC_yell end,
									set = function() NPCf.db.profile.filterNPC_yell = not NPCf.db.profile.filterNPC_yell end,
								},
								filterNPC_resting = {
									type = 'toggle',
									order = 5,
									name = L["When Resting"],
									desc = L["Filter in cities or inns"],
									get = function() return NPCf.db.profile.filterNPC_resting end,
									set = function() NPCf.db.profile.filterNPC_resting = not NPCf.db.profile.filterNPC_resting end,
								},
								filterNPC_instance = {
									type = 'toggle',
									order = 6,
									name = L["In Instance"],
									desc = L["Filter in instances/dungeons"],
									get = function() return NPCf.db.profile.filterNPC_instance end,
									set = function() NPCf.db.profile.filterNPC_instance = not NPCf.db.profile.filterNPC_instance end,
								},
								filterNPC_wild = {
									type = 'toggle',
									order = 7,
									name = L["In Wild"],
									desc = L["Filter while in the wild"],
									get = function() return NPCf.db.profile.filterNPC_wild end,
									set = function() NPCf.db.profile.filterNPC_wild = not NPCf.db.profile.filterNPC_wild end,
								},
								debug = {
									type = 'toggle',
									order = 8,
									width = "full",
									disabled = false,
									hidden = false,
									name = L["Debug"],
									desc = L["DebugDesc"],
									get = function() return NPCf.db.profile.debug end,
									set = function() NPCf.db.profile.debug = not NPCf.db.profile.debug end,
								},
							},
						},
						Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(NPCf.db),
					},
				},
			},
		}
		end
	return options
end
