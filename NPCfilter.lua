--[[
NPCfilter
		Filter that shit!

File Author: @file-author@
File Revision: @file-abbreviated-hash@
File Date: @file-date-iso@

* Copyright (c) 2008-10, @file-author@
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the <organization> nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY @file-author@ ''AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL @file-author@ BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]

NPCfilter = LibStub("AceAddon-3.0"):NewAddon("NPCfilter", "AceEvent-3.0")
local L =  LibStub("AceLocale-3.0"):GetLocale("NPCfilter", true)
local LDB = LibStub("LibDataBroker-1.1", true)
local NPCf = NPCfilter

--[[ Locals ]]--
local ipairs = ipairs
local pairs = pairs
local find = string.find
local sub = string.sub
local gsub = string.gsub
local lower = string.lower
local format = string.format
local insert = table.insert
local remove = table.remove
local sort = table.sort
local floor = math.floor
local power = math.pow
local debugFrame = L["debugFrame"]

--[[ Database Defaults ]]--
defaults = {
	profile = {
		turnOn = true,
		filterNPC = true,
		filterNPC_say = true,
		filterNPC_yell = false,
		filterNPC_resting = true,
		filterNPC_instance = false,
		filterNPC_wild = false,
	},
}

function NPCf:OnInitialize()
	--[[ Libraries ]]--
	local ACD = LibStub("AceConfigDialog-3.0")
	local LAP = LibStub("LibAboutPanel")

	self.db = LibStub("AceDB-3.0"):New("NPCfilterDB", defaults);

	local AC = LibStub("AceConsole-3.0")
	AC:RegisterChatCommand("npcf", function() NPCf:OpenOptions() end)
	AC:RegisterChatCommand("npcfilter", function() NPCf:OpenOptions() end)

	local ACfg = LibStub("AceConfig-3.0")
	ACfg:RegisterOptionsTable("NPCfilter", NPCf:getOptions())

	-- Set up options panels.
	self.OptionsPanel = ACD:AddToBlizOptions(self.name, L["NPCF"], nil, "NPCfgeneralGroup")
	self.OptionsPanel.about = LAP.new(self.name, self.name)
	
	if IsLoggedIn() then
		self:IsLoggedIn()
	else
		self:RegisterEvent("PLAYER_LOGIN", "IsLoggedIn")
	end
end

-- :OpenOptions(): Opens the options window.
function NPCf:OpenOptions()
	InterfaceOptionsFrame_OpenToCategory(self.OptionsPanel)
end

function NPCf:IsLoggedIn()
	self:UnregisterEvent("PLAYER_LOGIN")

	--[[ LibDataBroker object ]]--
	if (LDB) then
		NPCfFrame = CreateFrame("Frame", "LDB_NPCfilter")
		NPCfFrame.obj = LDB:NewDataObject(L["NPCF"], {
			type = "launcher",
			icon = "Interface\\Icons\\Ability_Warrior_Rampage",
			text = L["NPCF"],
			OnClick = function(self, button)
					NPCf:OpenOptions()
			end,
		})
	end
end

--[[ Window and Chat Functions ]]--
function NPCf:FindFrame(toFrame, msg)
	for i=1,FCF_GetNumActiveChatFrames() do
		local name = GetChatWindowInfo(i)
		if (toFrame == name) then
			local msgFrame = _G["ChatFrame" .. i]
			msgFrame:AddMessage(msg)
			return
		end
	end
	NPCf:CreateFrame(toFrame, msg)
end

function NPCf:CreateFrame(newFrame, msg)
  local newFrame = FCF_OpenNewWindow(newFrame)
	newFrame:AddMessage(msg)
end

--[[ NPC filtration - Idea from CorkIt currently not working ]]--
--[[ Check for NPC chatter and User setting ]]--
local function FilterFunc_NPC(self, event, ...)
	local filtered = false
	local msg = arg1 or select(1, ...)
	local npcname = arg2 or select(2, ...)
	local isResting = IsResting()
	local inInstance = IsInInstance()
	local ORIG_ChatFrame_MessageEventHandler = ChatFrame_MessageEventHandler
  if (NPCf.db.profile.filterNPC) then
		if((event == "CHAT_MSG_MONSTER_SAY" and NPCf.db.profile.filterNPC_say) or (event == "CHAT_MSG_MONSTER_YELL" and NPCf.db.profile.filterNPC_yell)) then
			if ((NPCf.db.profile.filterNPC_resting and isResting) or (NPCf.db.profile.filterNPC_instance and inInstance) or (NPCf.db.profile.filterNPC_wild and not (isResting or inInstance))) then
				if (NPCf.db.profile.debug) then
					NPCf:FindFrame(debugFrame, "|cFFFFFF00 Filtering: [" .. npcname .. "] " .. msg .. "'|r")
				end
				filtered = true
			end
		if find(msg, UnitName("player")) then
			if (NPCf.db.profile.debug) then
				NPCf:FindFrame(debugFrame, "|cFFFFFF00 ORIG_ChatFrame_MessageEventHandler(self, " .. event .. "," .. msg .. ", ...)|r")
			end
			filtered = ORIG_ChatFrame_MessageEventHandler(self, event, msg, ...)
		end
		end
	end
	return filtered
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_SAY", FilterFunc_NPC)
ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", FilterFunc_NPC)
