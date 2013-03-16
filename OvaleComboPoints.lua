--[[--------------------------------------------------------------------
    Ovale Spell Priority
    Copyright (C) 2012 Sidoine, Johnny C. Lam

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License in the LICENSE
    file accompanying this program.
--]]--------------------------------------------------------------------

-- This addon tracks the number of combo points by the player on the current target.

local _, Ovale = ...
local OvaleComboPoints = Ovale:NewModule("OvaleComboPoints", "AceEvent-3.0")

--<private-static-properties>
local OvaleData = Ovale:GetModule("OvaleData")
local OvaleGUID = Ovale:GetModule("OvaleGUID")
local OvalePaperDoll = Ovale:GetModule("OvalePaperDoll")

local GetComboPoints = GetComboPoints
local UnitGUID = UnitGUID
local MAX_COMBO_POINTS = MAX_COMBO_POINTS

local playerGUID = nil
local targetGUID = nil
--</private-static-properties>

--<public-static-properties>
OvaleComboPoints.combo = 0
--</public-static-properties>

--<public-static-methods>
function OvaleComboPoints:OnEnable()
	playerGUID = OvaleGUID.player
	if OvalePaperDoll.class == "ROGUE" or OvalePaperDoll.class == "DRUID" then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("UNIT_COMBO_POINTS")
	end
end

function OvaleComboPoints:OnDisable()
	if OvalePaperDoll.class == "ROGUE" or OvalePaperDoll.class == "DRUID" then
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("UNIT_COMBO_POINTS")
	end
end

--[[
A rogue's Seal Fate or a druid's Primal Fury are passive abilities that grant an
extra combo point when a combo-point generator critically strikes the target.

Workaround the "combo point delay" after a generator critically strikes the target
by catching the critical strike damage event and adding the given number of extra
combo points.  The delay MUST be less than the GCD.

An ability that generates extra combo points after it critically strikes the target
should have a "critcombo=N" parameter in its SpellInfo() description, where N is
the number of extra combo points to add, e.g., critcombo=1.
--]]
function OvaleComboPoints:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local _, event, _, sourceGUID, _, _, _,	destGUID = ...
	if sourceGUID == playerGUID and destGUID == targetGUID then
		if event == "SPELL_DAMAGE" then
			local spellId, _, _, _, _, _, _, _, _, critical = select(12, ...)
			local si = OvaleData.spellInfo[spellId]
			if critical and si and si.critcombo then
				self.combo = self.combo + si.critcombo
				if self.combo > MAX_COMBO_POINTS then
					self.combo = MAX_COMBO_POINTS
				end
			end
		end
	end
end

function OvaleComboPoints:PLAYER_ENTERING_WORLD(event)
	self:PLAYER_TARGET_CHANGED(event)
end

function OvaleComboPoints:PLAYER_TARGET_CHANGED(event)
	targetGUID = UnitGUID("target")
	self:Refresh()
end

function OvaleComboPoints:UNIT_COMBO_POINTS(event, ...)
	local unitId = ...
	if unitId == "player" then
		self:Refresh()
	end
end

function OvaleComboPoints:Refresh()
	self.combo = GetComboPoints("player") or 0
end

function OvaleComboPoints:Debug()
	Ovale:Print("Player has " .. self.combo .. " combo points on target " ..targetGUID.. ".")
end
--</public-static-methods>
