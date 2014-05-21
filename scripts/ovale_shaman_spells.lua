local _, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "ovale_shaman_spells"
	local desc = "[5.4.7] Ovale: Shaman spells"
	local code = [[
# Shaman spells and functions.

Define(ancestral_guidance 108281)
	SpellInfo(ancestral_guidance cd=120)
Define(ancestral_guidance_talent 14)
Define(ancestral_swiftness 16188)
	SpellInfo(ancestral_swiftness cd=90)
	SpellAddBuff(ancestral_swiftness ancestral_swiftness_buff=1)
Define(ancestral_swiftness_buff 16188)
Define(ancestral_swiftness_talent 11)
Define(ascendance_caster 114050)
	SpellInfo(ascendance_caster cd=180)
	SpellAddBuff(ascendance_caster ascendance_caster_buff=1)
Define(ascendance_caster_buff 114050)
	SpellInfo(ascendance_caster_buff duration=15)
Define(ascendance_heal 114052)
	SpellInfo(ascendance_heal cd=180)
	SpellAddBuff(ascendance_heal ascendance_heal_buff=1)
Define(ascendance_heal_buff 114052)
	SpellInfo(ascendance_heal_buff duration=15)
Define(ascendance_melee 114051)
	SpellInfo(ascendance_melee cd=180)
	SpellInfo(ascendance_melee buff_cdr=cooldown_reduction_agility_buff)
	SpellAddBuff(ascendance_melee ascendance_melee_buff=1)
Define(ascendance_melee_buff 114051)
	SpellInfo(ascendance_melee_buff duration=15)
Define(astral_shift 108271)
	SpellInfo(astral_shift cd=90)
Define(astral_shift_talent 3)
Define(bloodlust 2825)
	SpellInfo(bloodlust cd=300)
Define(call_of_the_elements 108285)
	SpellInfo(call_of_the_elements cd=180)
Define(call_of_the_elements_talent 7)
Define(chain_heal 1064)
	SpellInfo(chain_heal cd=2 glyph=glyph_of_chaining)
	SpellAddBuff(chain_heal ancestral_swiftness_buff=0 if_talent=ancestral_swiftness_talent)
Define(chain_lightning 421)
	SpellInfo(chain_lightning cd=3)
	SpellInfo(chain_lightning cd=0 mastery=elemental)
	SpellAddBuff(chain_lightning ancestral_swiftness_buff=0 if_talent=ancestral_swiftness_talent)
Define(earth_elemental_totem 2062)
	SpellInfo(earth_elemental_totem cd=300)
	SpellInfo(earth_elemental_totem buff_cdr=cooldown_reduction_agility_buff mastery=enhancement)
Define(earth_shield 974)
	SpellAddTargetBuff(earth_shield earth_shield_buff=1)
Define(earth_shield_buff 974)
	SpellInfo(earth_shield_buff duration=600)
Define(earth_shock 8042)
	SpellInfo(earth_shock cd=6 sharedcd=shock)
	SpellInfo(earth_shock addcd=-1 mastery=elemental)
Define(earthbind_totem 2484)
	SpellInfo(earthbind_totem cd=30)
Define(earthgrab_totem 51485)
	SpellInfo(earthgrab_totem cd=30)
Define(earthgrab_totem_talent 5)
Define(earthliving_weapon 51730)
Define(earthquake 61882)
	SpellInfo(earthquake cd=10)
Define(elemental_blast 117014)
	SpellInfo(elemental_blast cd=12)
Define(elemental_blast_talent 18)
Define(elemental_mastery 16166)
	SpellInfo(elemental_mastery cd=90)
	SpellAddBuff(elemental_mastery elemental_mastery_buff=1)
Define(elemental_mastery_buff 16166)
	SpellInfo(elemental_mastery_buff duration=20)
Define(elemental_mastery_talent 10)
Define(feral_spirit 51533)
	SpellInfo(feral_spirit cd=120)
	SpellInfo(feral_spirit buff_cdr=cooldown_reduction_agility_buff)
Define(fire_elemental_totem 2894)
	SpellInfo(fire_elemental_totem cd=300)
	SpellInfo(fire_elemental_totem cd=150 glyph=glyph_of_fire_elemental_totem)
	SpellInfo(fire_elemental_totem buff_cdr=cooldown_reduction_agility_buff mastery=enhancement)
Define(fire_nova 1535)
	SpellInfo(fire_nova cd=4)
Define(flame_shock 8050)
	SpellInfo(flame_shock cd=6 sharedcd=shock)
	SpellInfo(flame_shock addcd=-1 mastery=elemental)
	SpellAddBuff(flame_shock unleash_flame_buff=0 if_spell=unleash_elements)
	SpellAddTargetDebuff(flame_shock flame_shock_debuff=1)
Define(flame_shock_debuff 8050)
	SpellInfo(flame_shock_debuff duration=30 haste=spell tick=3)
Define(flametongue_weapon 8024)
Define(frost_shock 8050)
	SpellInfo(frost_shock cd=6 sharedcd=shock)
	SpellInfo(frost_shock addcd=-2 glyph=glyph_of_frost_shock)
Define(glyph_of_chaining 55452)
Define(glyph_of_fire_elemental_totem 55455)
Define(glyph_of_frost_shock 55443)
Define(glyph_of_riptide 63273)
Define(glyph_of_spirit_walk 55454)
Define(glyph_of_totemic_recall 55438)
Define(glyph_of_thunder 63270)
Define(glyph_of_wind_shear 55451)
Define(greater_healing_wave 77472)
	SpellAddBuff(greater_healing_wave ancestral_swiftness_buff=0 if_talent=ancestral_swiftness_talent)
Define(healing_rain 73920)
	SpellInfo(healing_rain cd=10)
	SpellAddBuff(healing_rain ancestral_swiftness_buff=0 if_talent=ancestral_swiftness_talent)
Define(healing_stream_totem 5394)
	SpellInfo(healing_stream_totem cd=30)
Define(healing_surge 8004)
	SpellAddBuff(healing_surge ancestral_swiftness_buff=0 if_talent=ancestral_swiftness_talent)
Define(healing_tide_totem 108280)
	SpellInfo(healing_tide_totem cd=180)
Define(healing_wave 331)
	SpellAddBuff(healing_wave ancestral_swiftness_buff=0 if_talent=ancestral_swiftness_talent)
Define(heroism 32182)
	SpellInfo(heroism duration=40)
Define(lava_beam 114074)
Define(lava_burst 51505)
	SpellInfo(lava_burst buffnocd=ascendance_caster_buff cd=8)
	SpellAddBuff(lava_burst lava_surge_buff=0)
Define(lava_lash 60103)
	SpellInfo(lava_lash cd=10)
Define(lava_surge_buff 77762)
	SpellInfo(lava_surge_buff duration=6)
Define(lightning_bolt 403)
	SpellAddBuff(lightning_bolt ancestral_swiftness_buff=0 if_talent=ancestral_swiftness_talent))
Define(lightning_shield 324)
	SpellAddBuff(lightning_shield lightning_shield_buff=1)
Define(lightning_shield_buff 324)
	SpellInfo(lightning_shield duration=3600)
Define(maelstrom_weapon_buff 53817)
	SpellInfo(maelstrom_weapon_buff duration=30)
Define(magma_totem 8187)
Define(mana_tide_totem 16190)
	SpellInfo(mana_tide_totem cd=180)
Define(primal_elementalist_talent 17)
Define(riptide 61295)
	SpellInfo(riptide cd=6)
	SpellInfo(riptide cd=0 glyph=glyph_of_riptide)
	SpellAddTargetBuff(riptide riptide_buff=1)
Define(riptide_buff 61295)
	SpellInfo(riptide_buff duration=18 haste=spell tick=3)
Define(searing_totem 3599)
Define(shamanistic_rage 30823)
	SpellInfo(shamanistic_rage cd=60)
	SpellInfo(shamanistic_rage buff_cdr=cooldown_reduction_agility_buff mastery=enhancement)
Define(spirit_link_totem 98008)
	SpellInfo(spirit_link_totem cd=180)
Define(spirit_walk 58875)
	SpellInfo(spirit_walk cd=60)
	SpellInfo(spirit_walk addcd=-15 glyph=glyph_of_spirit_walk)
Define(spiritwalkers_grace 79206)
	SpellInfo(spiritwalkers_grace cd=120)
	SpellInfo(spiritwalkers_grace buff_cdr=cooldown_reduction_agility_buff mastery=enhancement)
Define(stone_bulwark_totem 108270)
	SpellInfo(stone_bulwark_totem cd=10)
Define(stone_bulwark_totem_talent 2)
Define(stormblast 115356)
	SpellInfo(stormblast cd=8 sharedcd=strike)
Define(stormlash_buff 120676)
	SpellInfo(stormlash_buff duration=10)
Define(stormlash_totem 120668)
	SpellInfo(stormlash_totem cd=300)
	SpellAddBuff(stormlash_totem stormlash_buff=1)
Define(stormstrike 17364)
	SpellInfo(stormstrike cd=8 sharedcd=strike)
Define(thunderstorm 51490)
	SpellInfo(thunderstorm cd=45)
	SpellInfo(thunderstorm addcd=-10 glyph=glyph_of_thunder)
Define(totemic_recall 36936)
Define(tremor_totem 8143)
	SpellInfo(tremor_totem cd=60)
Define(unleash_elements 73680)
	SpellInfo(unleash_elements cd=15)
Define(unleash_flame_buff 73683)
	SpellInfo(unleash_flame_buff duration=8)
Define(unleashed_fury_talent 16)
Define(water_shield 52127)
	SpellAddBuff(water_shield water_shield_buff=1)
Define(water_shield_buff 52127)
	SpellInfo(water_shield duration=3600)
Define(wind_shear 57994)
	SpellInfo(wind_shear cd=12)
	SpellInfo(wind_shear addcd=3 glyph=glyph_of_wind_shear)
Define(windfury_weapon 8232)
Define(windwalk_totem 108273)
	SpellInfo(windwalk_totem cd=60)
Define(windwalk_totem_talent 6)

# Pet spells (Primal Elementalist Talent)
Define(pet_empower 118350)
	SpellAddBuff(pet_empower pet_empower_buff=1)
Define(pet_empower_buff 118350)
	SpellInfo(pet_empower_buff duration=60)
Define(pet_reinforce 118347)
	SpellAddBuff(pet_reinforce pet_reinforce_buff=1)
Define(pet_reinforce_buff 118347)
	SpellInfo(pet_reinforce_buff duration=60)

AddFunction Bloodlust
{
	if DebuffExpires(burst_haste_debuff any=1)
	{
		Spell(bloodlust)
		Spell(heroism)
	}
}

AddFunction Interrupt
{
	if target.IsFriend(no) and target.IsInterruptible() Spell(wind_shear)
}
]]

	OvaleScripts:RegisterScript("SHAMAN", name, desc, code, "include")
end
