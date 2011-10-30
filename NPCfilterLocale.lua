--[[
File Author: Erik L. Vonderscheer
File Revision: 43e55df
File Date: 2010-10-19T06:46:25Z
]]--
local debug = false
--[===[@debug@
debug = true
--@end-debug@]===]

local L =  LibStub("AceLocale-3.0"):NewLocale("NPCfilter", "enUS", true)
if L then
L["Filter NPCs"] = true
L["Filter NPC Chat and/or Yelling"] = true
L["NPC Chat"] = true
L["Filter normal NPC Chat"] = true
L["NPC Yelling"] = true
L["Filter NPC Yells"] = true
L["When Resting"] = true
L["Filter in cities or inns"] = true
L["In Instance"] = true
L["Filter in instances/dungeons"] = true
L["In Wild"] = true
L["Filter while in the wild"] = true
L["When & Where"] = true
L["DISABLED"] = "|cffff8080Disabled|r"
L["Debug"] = true
L["DebugDesc"] = "Enable Debugging output to DEBUG frame"
L["ENABLED"] = "|cff00ff00Enabled|r"
L["General"] = true
L["LOADED"] = "|cff00ff00Loaded!|r"
L["NJAOF"] = "Filter those fools!"
L["NPCF"] = "NPCfilter"
L["Profiles"] = true
L["Trade"] = true
L["TurnOn"] = "Turn On"
L["TurnOnDesc"] = "Enable NPC Filter."
L["debugFrame"] = "DEBUG"
L[ [=[|cffeda55fRight Click|r to open config GUI.
|cffeda55fLeft Click|r reset filtered count.]=] ] = true
L[ [=[|cffeda55fRight Click|r to open config GUI.
|cffeda55fLeft Click|r reset repeat count.]=] ] = true

if GetLocale() == "enUS" then return end
end
