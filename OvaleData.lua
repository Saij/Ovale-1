﻿--[[--------------------------------------------------------------------
    Ovale Spell Priority
    Copyright (C) 2012 Sidoine, Johnny C. Lam

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License in the LICENSE
    file accompanying this program.
----------------------------------------------------------------------]]

OvaleData = LibStub("AceAddon-3.0"):NewAddon("OvaleData", "AceEvent-3.0")

--<private-static-properties>
local pairs, tonumber, tostring = pairs, tonumber, tostring
local GetShapeshiftForm, GetSpellBookItemInfo, GetSpellBookItemName = GetShapeshiftForm, GetSpellBookItemInfo, GetSpellBookItemName
local GetSpellInfo, GetSpellTabInfo, GetTalentInfo = GetSpellInfo, GetSpellTabInfo, GetTalentInfo
local HasPetSpells, UnitBuff, UnitClass = HasPetSpells, UnitBuff, UnitClass
local BOOKTYPE_SPELL, BOOKTYPE_PET = BOOKTYPE_SPELL, BOOKTYPE_PET
--</private-static-properties>

--<public-static-properties>
OvaleData.spellList = {}
OvaleData.missingSpellList = {}
OvaleData.firstInit = false
OvaleData.className = nil
OvaleData.level = nil
--allows to fill the player talent tables on first use
OvaleData.listeTalentsRemplie = false
--key: talentId / value: points in this talent
OvaleData.pointsTalent = {}
--key: talentId / value: talent name (not used)
OvaleData.talentIdToName = {}
--key: talent name / value: talent id
OvaleData.talentNameToId = {}
--spell info from the current script (by spellId)
OvaleData.spellInfo = {}
--spells that count for scoring
OvaleData.scoreSpell = {}
--spells that should be tracked
OvaleData.spellFilter = { any = {}, mine = {} }

OvaleData.power =
{
	mana = {id=0, mini=0},
	rage = {id=1, mini=0, maxi=100},
	focus ={id=2, mini=0, maxi=100},
	energy = {id=3, mini=0, maxi=100},
	runicpower = {id=6, mini=0, maxi=100},
	shards = {id=7, mini=0, maxi=3},
	eclipse = {id=8, mini=-100, maxi=100},
	holy = {id=9, mini=0, maxi=5},
	chi = {id=12, mini=0, maxi=4 }, 
	shadoworbs = {id=13, mini=0, maxi=3},
	burningembers = {id=14, mini=0},
	demonicfury = {id=15, mini=0}
}
OvaleData.secondaryPower = {"rage", "focus", "shards", "holy", "chi", "shadoworbs", "burningembers", "demonicfury"}
OvaleData.powerType = {}

-- List haste buff that does not appear in the character sheet and that are not raid wide buffs
OvaleData.selfHasteBuff =
{
	[13750] = 20, -- Adrenaline Rush (rogue)
	[49016] = 20, -- Unholy Frenzy (death knight)
	[53657] = 9, -- Judgement of the Pure (paladin)
}

-- List temporary damage multiplier
OvaleData.selfDamageBuff =
{
	[5217] = 1.15, -- Tiger's Fury (druid)
	[31665] = 1.1, -- Master of Subtlety (rogue)
	[52610] = 1.3, -- Savage Roar, glyphed (druid)
	[57933] = 1.15, -- Tricks of the Trade (rogue)
	[84745] = 1.1, -- Shallow Insight (rogue)
	[84746] = 1.2, -- Moderate Insight (rogue)
	[84747] = 1.3, -- Deep Insight (rogue)
	[124974] = 1.2, -- Nature's Vigil (druid)
	[127538] = 1.3, -- Savage Roar (druid)
}

OvaleData.buffSpellList =
{
	fear =
	{
		5782, -- Fear
		5484, -- Howl of terror
		5246, -- Intimidating Shout 
		8122, -- Psychic scream
	},
	root =
	{
		23694, -- Improved Hamstring
		339, -- Entangling Roots
		122, -- Frost Nova
		47168, -- Improved Wing Clip
	},
	incapacitate = 
	{
		6770, -- Sap
		12540, -- Gouge
		20066, -- Repentance
	},
	stun = 
	{
		5211, -- Bash
		44415, -- Blackout
		6409, -- Cheap Shot
		22427, -- Concussion Blow
		853, -- Hammer of Justice
		408, -- Kidney Shot
		46968, -- Shockwave
	},
	
	str_agi_int =
	{
		1126, -- Mark of the Wild (druid)
		20217, -- Blessing of Kings (paladin)
		90363, -- Embrace of the Shale Spider (shale spider)
		117666, -- Legacy of the Emporer (monk)
	},
	stamina =
	{
		469, -- Commanding Shout (warrior)
		6307, -- Blood Pact (imp)
		21562, -- Power Word: Fortitude (priest)
		90364, -- Qiraji Fortitude (silithid)
	},
	attack_power_multiplier=
	{
		6673, -- Battle Shout (warrior)
		19506, -- Trueshot Aura (hunter)
		57330, -- Horn of Winter (death knight)
	},
	spell_power_multiplier = 
	{
		1459, -- Arcane Brillance
		61316, -- Dalaran Brilliance (mage)
		77747, -- Burning Wrath (shaman)
		109773,  -- Dark Intent (warlock)
		126309, -- Still Water (waterstrider)
	},
	melee_haste =
	{
		30809, -- Unleashed Rage (enhancement shaman)
		55610, -- Unholy Aura (frost & unholy death knights)
		113742, -- Swiftblade's Cunning (rogue)
		128432, -- Cackling Howl (hyena)
		128433, -- Serpent's Swiftness (serpent)
	},
	spell_haste = 
	{
		24907, -- Moonkin aura (balance druid)
		49868, -- Mind Quickening (shadow priest, sporebat)
		51470, -- Elemental Oath (elemental shaman)
	},
	critical_strike =
	{
		--Guardian and Feral druids, any hunter, any mage
		1459, -- Arcane Brillance (mage)
		24604, -- Furious Howl (wolf)
		24932, -- Leader of the Pack (feral & guardian druids)
		61316, -- Dalaran Brilliance (mage)
		90309, -- Terrifying Roar (devilsaur)
		97229, -- Bellowing Roar (hydra)
		116781, -- Legacy of the White Tiger (windwalker monk)
		126309, -- Still Water (waterstrider)
		126373, -- Fearless Roar (quilen)
	},
	mastery =
	{
		19740, -- Blessing of Might (paladin)
		93435, -- Roar of Courage (cat)
		116956, -- Grace of Air (shaman)
		128997, -- Spirit Beast Blessing (spirit beast)
	},
	-- weakened_armor
	physical_vulnerability=
	{
		35290, -- Gore (boar)
		50518, -- Ravage (ravager)
		55749, -- Acid Spit (worm)
		57386, -- Stampede (rhino)
		81326, -- Physical Vulnerability (frost & unholy death knights, retribution paladin, arms & fury warriors)
	},
	magic_vulnerability=
	{
		1490, -- Curse of the Elements (warlock)
		24844, -- Lightning Breath (wind serpent)
		34889, -- Fire Breath (dragonhawk)
		93068, -- Master Poisoner (rogue)
	},
	lower_physical_damage=
	{
		24423, -- Demoralizing Screech (carrion bird)
		50256, -- Demoralizing Roar (bear)
		115798, -- Weakened Blows (all tank specs, feral druid, retribution paladin, shaman, warlock, warrior)
	},
	cast_slow =
	{
		5760, -- Mind-numbing Poison (rogue)
		31589, -- Slow (arcane mage)
		50274, -- Spore Cloud (sporebat)
		58604, -- Lava Breath (core hound)
		73975, -- Necrotic Strike (death knight)
		90315, -- Tailspin (fox)
		109466, -- Curse of Enfeeblement (warlock)
		126406, -- Trample (goat)
	},
	healing_reduced =
	{
		8680, -- Wound Poison (rogue)
		54680, -- Monstrous Bite (devilsaur)
		82654, -- Widow Venom (hunter)
		115804, -- Mortal Wounds (arms & fury warriors, windwalker monk)
	},
	burst_haste =
	{
		2825, --Bloodlust (Horde shaman)
		32182, --Heroism (Alliance shaman)
		80353, --Time Warp (mage)
		90355, -- Ancient Hysteria (core hound)
	},
	enrage =
	{
		--TODO update
		49016, -- Unholy Frenzy
		18499, -- Berserker Rage
		12292, -- Death Wish
		12880, -- Enrage (rank 1)
		14201, -- Enrage (rank 2)
		14202, -- Enrage (rank 3)
		5229, -- Enrage (Bear)
        52610, -- Savage Roar (Cat)
        76691, -- Vengeance (All Tank Specs)
	},
	ranged_vulnerability =
	{
		1130, -- Hunter's Mark
	},
}
OvaleData.buffSpellList.bloodlust_aura = OvaleData.buffSpellList.burst_haste
OvaleData.buffSpellList.bloodlust = OvaleData.buffSpellList.burst_haste
OvaleData.buffSpellList.heroism_aura = OvaleData.buffSpellList.burst_haste
OvaleData.buffSpellList.heroism = OvaleData.buffSpellList.burst_haste
--</public-static-properties>

--<private-static-properties>
local fearSpellList = nil
local stunSpellList = nil
local incapacitateSpellList = nil
local rootSpellList = nil
--</private-static-properties>

--<public-static-methods>
function OvaleData:OnEnable()
	for k,v in pairs(self.power) do
		self.powerType[v.id] = k
	end
	
	self:FirstInit()
	self:RegisterEvent("CHARACTER_POINTS_CHANGED")
	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("PLAYER_TALENT_UPDATE")
	self:RegisterEvent("SPELLS_CHANGED")
	self:RegisterEvent("UNIT_PET")
end

function OvaleData:OnDisable()
	self:UnregisterEvent("UNIT_PET")
	self:UnregisterEvent("SPELLS_CHANGED")
	self:UnregisterEvent("PLAYER_TALENT_UPDATE")
	self:UnregisterEvent("PLAYER_LEVEL_UP")
	self:UnregisterEvent("CHARACTER_POINTS_CHANGED")
end

function OvaleData:CHARACTER_POINTS_CHANGED()
	self:RemplirListeTalents()
--	Ovale:Print("CHARACTER_POINTS_CHANGED")
end

function OvaleData:PLAYER_LEVEL_UP(event, level, ...)
	level = tonumber(level)
	if level then
		self.level = level
	else
		self.level = self.level + 1
	end
end

function OvaleData:PLAYER_TALENT_UPDATE(event)
	Ovale:debugPrint("compile", event)
	self:RemplirListeTalents()
	Ovale.needCompile = true
end

function OvaleData:UNIT_PET()
	self:FillPetSpellList()
end

--The user learnt a new spell
function OvaleData:SPELLS_CHANGED(event)
	Ovale:debugPrint("compile", event)
	self:FillSpellList()
	Ovale.needCompile = true
end

function OvaleData:GetRootSpellList()
	if rootSpellList then
		return rootSpellList
	end
	rootSpellList = {}
	for k, v in pairs(self.buffSpellList.fear) do
		rootSpellList[v] = true
	end
	return rootSpellList
end

function OvaleData:GetStunSpellList()
	if stunSpellList then
		return stunSpellList
	end
	stunSpellList = {}
	for k, v in pairs(self.buffSpellList.stun) do
		stunListList[v] = true
	end
	return stunSpellList
end

function OvaleData:GetIncapacitateSpellList()
	if incapacitateSpellList then
		return incapacitateSpellList
	end
	incapacitateSpellList = {}
	for k, v in pairs(self.buffSpellList.incapacitate) do
		incapacitateSpellList[v] = true
	end
	return incapacitateSpellList
end

function OvaleData:GetFearSpellList()
	if fearSpellList then
		return fearSpellList
	end
	fearSpellList = {}
	for k, v in pairs(self.buffSpellList.fear) do
		fearSpellList[v] = true
	end
	return fearSpellList
end


function OvaleData:GetSpellInfoOrNil(spell)
	if (spell) then
		return GetSpellInfo(spell)
	else
		return nil
	end
end

function OvaleData:FillPetSpellList()
	--TODO pas moyen d'avoir le nombre de skills pour le pet
	local book=BOOKTYPE_PET
	local numSpells, _ = HasPetSpells()
	if not numSpells then return end
	local i=1
	while i <= numSpells do
		local skillType, spellId = GetSpellBookItemInfo(i, book)
		if skillType~="FUTURESPELL" and spellId then
			local spellName = GetSpellBookItemName(i, book)
			self.spellList[spellId] = spellName
		end
		i = i + 1
	end
end

function OvaleData:FillMissingSpells()
	for k, v in pairs(self.missingSpellList) do
		self.spellList[k] = v
	end
end

function OvaleData:FillSpellList()
	self.spellList = {}
	
	--TODO pas moyen d'avoir le nombre de skills pour le pet
	local book=BOOKTYPE_SPELL
	local name, texture, offset, numSpells, isGuild = GetSpellTabInfo(2)
	
	numSpells = numSpells + offset
	
	local i=1
	while i <= numSpells do
		local skillType, spellId = GetSpellBookItemInfo(i, book)
		if skillType~="FUTURESPELL" and spellId then
			local spellName = GetSpellBookItemName(i, book)
			self.spellList[spellId] = spellName
		end
		i = i + 1
	end
	self:FillMissingSpells()
	self:FillPetSpellList()
end

function OvaleData:RemplirListeTalents()
	local talentId = 1
	local needCompile = false
	while true do
		local name, texture, tier, column, selected, available = GetTalentInfo(talentId)
		if not name then
			break
		end
		talentId = tonumber(talentId)
		self.talentIdToName[talentId] = name
		self.talentNameToId[name] = talentId
		if selected then
			self.pointsTalent[talentId] = 1
		else
			self.pointsTalent[talentId] = 0
		end		
		self.listeTalentsRemplie = true
		needCompile = true
		talentId = talentId + 1
	end
	if needCompile then
		Ovale:debugPrint("compile", "filling talent list")
		Ovale.needCompile = needCompile
	end
end

function OvaleData:FirstInit()
	if self.firstInit then
		return
	end
	
	self.firstInit = true

	local playerClass, englishClass = UnitClass("player")
	self.className = englishClass
	self.level = UnitLevel("player")
	
	self:RemplirListeTalents()
	self:FillSpellList()
end

function OvaleData:GetTalentPoints(talentId)
	if not self.listeTalentsRemplie then
		self:RemplirListeTalents()
	end
	return self.pointsTalent[talentId]
end

function OvaleData:GetSpellInfo(spellId)
	if (not self.spellInfo[spellId]) then
		self.spellInfo[spellId] =
		{
			aura = {player = {}, target = {}},
			damageAura = {},
		}
	end
	return self.spellInfo[spellId]
end

function OvaleData:ResetSpellInfo()
	self.spellInfo = {}
end

function OvaleData:ResetSpellFilter()
	self.spellFilter.any = {}
	self.spellFilter.mine = {}
end

function OvaleData:AddSpellToFilter(spellId, mine)
	if mine then
		if not self.spellFilter.mine[spellId] then
			self.spellFilter.mine[spellId] = GetSpellInfo(spellId)
		end
	elseif not self.spellFilter.any[spellId] then
		self.spellFilter.any[spellId] = GetSpellInfo(spellId)
	end
end

function OvaleData:GetGCD(spellId)
	if spellId and self.spellInfo[spellId] then
		if self.spellInfo[spellId].haste == "spell" then
			local cd = self.spellInfo[spellId].gcd
			if not cd then
				cd = 1.5
			end
			cd = cd / OvaleAura.spellHaste
			if (cd<1) then
				cd = 1
			end
			return cd
		elseif self.spellInfo[spellId].gcd then
			return self.spellInfo[spellId].gcd
		end			
	end
	
	-- Default value
	if self.className == "ROGUE" or (self.className == "DRUID" and GetShapeshiftForm(true) == 3) then
		return 1.0
	elseif self.className == "MAGE" or self.className == "WARLOCK" or self.className == "PRIEST" or
			(self.className == "DRUID" and GetShapeshiftForm(true) ~= 1) then
		local cd = 1.5 / OvaleAura.spellHaste
		if (cd<1) then
			cd = 1
		end
		return cd
	else
		return 1.5
	end
end


--Compute the spell Cooldown
function OvaleData:GetComputedSpellCD(spellId)
	local actionCooldownStart, actionCooldownDuration, actionEnable
	local cd = OvaleState:GetCD(spellId)
	if cd and cd.start then
		actionCooldownStart = cd.start
		actionCooldownDuration = cd.duration
		actionEnable = cd.enable
	else
		actionCooldownStart, actionCooldownDuration, actionEnable = GetSpellCooldown(spellId)
		-- Les chevaliers de la mort ont des infos fausses sur le CD quand ils n'ont plus les runes
		-- On force à 1,5s ou 1s en présence impie
		-- TODO: is it still the case in MoP?
		if self.className=="DEATHKNIGHT" and actionCooldownDuration==10 and
				(not self.spellInfo[spellId] or self.spellInfo[spellId].cd~=10) then
			local impie = GetSpellInfo(48265)
			if impie and UnitBuff("player", impie) then
				actionCooldownDuration=1
			else
				actionCooldownDuration=1.5
			end
		end
		if self.spellInfo[spellId] and self.spellInfo[spellId].forcecd then
			actionCooldownStart, actionCooldownDuration = GetSpellCooldown(self.spellInfo[spellId].forcecd)
		end
	end
	return actionCooldownStart, actionCooldownDuration, actionEnable
end

--Compute the damage of the given spell.
function OvaleData:GetDamage(spellId, attackpower, spellpower, combo)
	local si = self.spellInfo[spellId]
	if not si then
		return nil
	end
	local damage = si.base or 0
	combo = combo or 0
	attackpower = attackpower or 0
	spellpower = spellpower or 0
	if si.bonuscp then
		damage = damage + si.bonuscp * combo
	end
	if si.bonusap then
		damage = damage + si.bonusap * attackpower
	end
	if si.bonusapcp then
		damage = damage + si.bonusapcp * attackpower * combo
	end
	if si.bonussp then
		damage = damage + si.bonussp * spellpower
	end
	return damage
end

function OvaleData:GetDuration(spellId, spellHaste, combo, holy)
	local si = self.spellInfo[spellId]
	if si and si.duration then
		local duration = si.duration
		spellHaste = spellHaste or 1
		combo = combo or 0
		holy = holy or 1
		if si.adddurationcp then
			duration = duration + si.adddurationcp * combo
		end
		if si.adddurationholy then
			duration = duration + si.adddurationholy * (holy - 1)
		end
		if si.tick then	-- DoT
			--DoT duration is tickLength * numberOfTicks.
			local tickLength = self:GetTickLength(spellId, spellHaste)
			local numTicks = floor(duration / tickLength + 0.5)
			duration = tickLength * numTicks
			return duration, tickLength
		end
		return duration
	else
		return nil
	end
end

function OvaleData:GetTickLength(spellId, spellHaste)
	local si = self.spellInfo[spellId]
	if si then
		if si.haste ~= "spell" then
			return si.tick or 3
		else
			return (si.tick or 3) / (spellHaste or 1)
		end
	else
		return nil
	end
end
--</public-static-methods>