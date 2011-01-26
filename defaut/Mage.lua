Ovale.defaut["MAGE"]=
[[
#Contributed by Hinalover
#Spells
Define(ARCANEBARRAGE 44425) #arcane instant
    SpellAddDebuff(ARCANEBARRAGE ARCANEBLASTDEBUFF=0)
Define(ARCANEBLAST 30451) #arcane stacks*4 cost increased
    SpellAddDebuff(ARCANEBLAST ARCANEBLASTDEBUFF=10)
Define(ARCANEMISSILES 5143) #arcane channel
    SpellAddDebuff(ARCANEMISSILES ARCANEBLASTDEBUFF=0 ARCANEMISSILEBUFF=0)
Define(ARCANEPOWER 12042) #arcane cd
    SpellInfo(ARCANEPOWER cd=84)
Define(COLDSNAP 11958) #frost reset cd
    SpellInfo(COLDSNAP cd=384)
Define(COMBUSTION 11129) #fire cd consume dot
    SpellInfo(COMBUSTION cd=180)
Define(COUNTERSPELL 2139)
    SpellInfo(COUNTERSPELL cd=24)
Define(DEEPFREEZE 44572) #frost instant
    SpellAddBuff(DEEPFREEZE FINGERSOFFROST=-1)
Define(EVOCATION 12051)
    SpellInfo(EVOCATION cd=240)
Define(FIREBLAST 2136) #fire instant
Define(FIREBALL 133) #fire 2.5
Define(FLAMEORB 82731)
    SpellInfo(FLAMEORB cd=60)
Define(FROSTBOLT 116) #frost
Define(FROSTFIREBOLT 44614) #frost+fire
    SpellAddBuff(FROSTFIREBOLT BRAINFREEZE=-1 FINGERSOFFROST=-1)
Define(ICEARMOR 7302)
Define(ICELANCE 30455) #frost instant
    SpellAddBuff(ICELANCE FINGERSOFFROST=-1)
Define(ICYVEINS 12472) #frost cd
    SpellInfo(ICYVEINS cd=144)
Define(LIVINGBOMB 44457) #fire dot
    SpellAddTargetDebuff(LIVINGBOMB LIVINGBOMB=12)
Define(MAGEARMOR 6117)
Define(MIRRORIMAGE 55342)
    SpellInfo(MIRRORIMAGE cd=180)
Define(MOLTENARMOR 30482)
Define(PYROBLAST 11366) #fire dot
    SpellAddTargetDebuff(PYROBLAST PYROBLAST=12)
    SpellAddBuff(PYROBLAST HOTSTREAK=0)
Define(SCORCH 2948) #fire 1.5 (cast while moving with firestarter talent)
Define(SPELLSTEAL 30449)
Define(SUMMONWATERELEMENTAL 31687) #frost pet
    SpellInfo(SUMMONWATERELEMENTAL cd=180)

Define(PETFREEZE 33395) #Frost pet freeze ability
    SpellInfo(PETFREEZE cd=25)

#Buff
Define(BRAINFREEZE 57761) #frost (instant fireball/frostfire bolt)
Define(FINGERSOFFROST 44544) #frost boost ice lance/deep freeze
Define(HOTSTREAK 48108) #fire instant pyroblast
Define(ARCANEBLASTDEBUFF 36032)
Define(ARCANEMISSILEBUFF 79683)
Define(PRESENCEOFMIND 12043) #arcane next spell instant
Define(CLEARCASTING 12536)

#Item
Define(MANAGEMITEM 36799)
Define(VOLCANICPOTION 58091)

#Debuff
Define(IGNITE 12654)
Define(CRITICALMASS 22959)
Define(SHADOWANDFLAME 17800)

#Talent
Define(FIRESTARTERTALENT 11431)
Define(CRITICALMASSTALENT 10541)
Define(IMPROVEDSCORCH 10547)

#CheckBoxes
AddListItem(fb fb SpellName(FIREBALL) default)
AddListItem(fb ffb SpellName(FROSTFIREBOLT) mastery=2)
AddListItem(frb frb SpellName(FROSTBOLT) default)
AddListItem(frb ffb SpellName(FROSTFIREBOLT) mastery=3)

ScoreSpells(SCORCH PYROBLAST LIVINGBOMB FROSTFIREBOLT FIREBALL SUMMONWATERELEMENTAL PETFREEZE FROSTBOLT ARCANEBLAST ARCANEMISSILES ARCANEBARRAGE
            DEEPFREEZE ICELANCE)

AddIcon help=main mastery=1
{
    unless InCombat() if BuffExpires(MAGEARMOR 400) and BuffExpires(MOLTENARMOR 400) and BuffExpires(ICEARMOR 400) Spell(MAGEARMOR)
    
    if BuffPresent(PRESENCEOFMIND) Spell(ARCANEBLAST)
    if TargetDeadIn(less 34) and ManaPercent(more 5) Spell(ARCANEBLAST)
    if BuffPresent(CLEARCASTING) and DebuffPresent(ARCANEBLASTDEBUFF stacks=2) Spell(ARCANEBLAST)

    if 26s before Spell(EVOCATION) and ManaPercent(more 26) Spell(ARCANEBLAST)
    if ManaPercent(more 94) Spell(ARCANEBLAST)
    if DebuffPresent(ARCANEBLASTDEBUFF) unless DebuffPresent(ARCANEBLASTDEBUFF stacks=4) or BuffPresent(heroism) 
		Spell(ARCANEBLAST)
    
	if DebuffPresent(ARCANEBLASTDEBUFF) and BuffPresent(heroism) unless DebuffPresent(ARCANEBLASTDEBUFF stacks=3)
        Spell(ARCANEBLAST)
    
	if TargetDeadIn(more 31) Spell(EVOCATION)
    Spell(ARCANEMISSILES)
    Spell(ARCANEBARRAGE)
    if Speed(more 0) Spell(FIREBLAST)
    if Speed(more 0) Spell(ICELANCE)
}

AddIcon help=main mastery=2
{
    unless InCombat() if BuffExpires(MAGEARMOR 400) and BuffExpires(MOLTENARMOR 400) and BuffExpires(ICEARMOR 400) Spell(MOLTENARMOR)

    if TalentPoints(CRITICALMASSTALENT more 0) and TargetDebuffExpires(CRITICALMASS) and TargetDebuffExpires(SHADOWANDFLAME) Spell(SCORCH)
    if TargetDebuffPresent(LIVINGBOMB mine=1) and TargetDebuffPresent(IGNITE mine=1)
            and TargetDebuffPresent(PYROBLAST mine=1)
        Spell(COMBUSTION)
    if TargetDebuffExpires(LIVINGBOMB 0 mine=1) and TargetDeadIn(more 12) Spell(LIVINGBOMB)
    if BuffPresent(HOTSTREAK) Spell(PYROBLAST)
    if TalentPoints(FIRESTARTERTALENT more 0) and Speed(more 0) Spell(SCORCH)
    if ManaPercent(less 5) Spell(SCORCH)
    if List(fb fb) and TargetDeadIn(less 60) Spell(FIREBALL)
    if List(fb ffb) and TargetDeadIn(less 60) Spell(FROSTFIREBOLT)
    if List(fb fb) and ManaPercent(more 39) Spell(FIREBALL)
    if List(fb ffb) and ManaPercent(more 39) Spell(FROSTFIREBOLT)
    if ManaPercent(less 95) and TalentPoints(IMPROVEDSCORCH more 0)
    {
           unless 60s before Spell(EVOCATION) Spell(SCORCH)
    }
    Spell(EVOCATION)
    if TalentPoints(IMPROVEDSCORCH more 0) Spell(SCORCH)
}

AddIcon help=main mastery=3
{
    unless InCombat() if BuffExpires(MAGEARMOR 400) and BuffExpires(MOLTENARMOR 400) and BuffExpires(ICEARMOR 400) Spell(MOLTENARMOR)

    if PetPresent(no) Spell(SUMMONWATERELEMENTAL)
    if BuffPresent(FINGERSOFFROST stacks=1)  Spell(DEEPFREEZE)
    if BuffPresent(BRAINFREEZE) and BuffPresent(FINGERSOFFROST) Spell(FROSTFIREBOLT)
    if BuffPresent(FINGERSOFFROST stacks=2) Spell(ICELANCE)
    Spell(PETFREEZE)
    if BuffPresent(FINGERSOFFROST stacks=2) Spell(ICELANCE)
    if BuffPresent(MOLTENARMOR) and {{manaPercent()*8} < target.timeToDie()} Spell(MAGEARMOR)
    if ManaPercent(less 5) and TargetDeadIn(less 60) Spell(EVOCATION)
    if List(frb frb) Spell(FROSTBOLT)
    if List(frb ffb) Spell(FROSTFIREBOLT)
    if Speed(more 0) Spell(ICELANCE)
    if Speed(more 0) Spell(FIREBLAST)
}

AddIcon help=cd mastery=1
{
    if BuffPresent(heroism) or TargetDeadIn(less 40) Item(VOLCANICPOTION)
    if TargetBuffStealable(yes) Spell(SPELLSTEAL)
    if TargetIsInterruptible(yes) Spell(COUNTERSPELL)
    if TargetDeadIn(more 29) Spell(MIRRORIMAGE)
    if TargetDeadIn(less 34) Spell(ARCANEPOWER)
    if 26s before Spell(EVOCATION)
    {
          if DebuffPresent(ARCANEBLAST stacks=3) or DebuffPresent(ARCANEBLAST stacks=4) Spell(ARCANEPOWER)
    }
    if TargetDeadIn(less 35) Item(MANAGEMITEM)
    if 26s before Spell(EVOCATION)
    {
          if DebuffPresent(ARCANEBLASTDEBUFF stacks=3) Item(MANAGEMITEM)
    }
    if TargetDeadIn(more 14) Spell(FLAMEORB)
    Spell(PRESENCEOFMIND)
    Item(Trinket0Slot usable=1)
    Item(Trinket1Slot usable=1)
}

AddIcon help=cd mastery=2
{
    if BuffPresent(heroism) or TargetDeadIn(less 40) Item(VOLCANICPOTION)
    if TargetBuffStealable(yes) Spell(SPELLSTEAL)
    if TargetIsInterruptible(yes) Spell(COUNTERSPELL)
    if ManaPercent(less 85) Item(MANAGEMITEM)
    if TargetDeadIn(more 24) Spell(MIRRORIMAGE)
    if TargetDeadIn(more 11) Spell(FLAMEORB)
    Item(Trinket0Slot usable=1)
    Item(Trinket1Slot usable=1)
}

AddIcon help=cd mastery=3
{
    if BuffPresent(heroism) or TargetDeadIn(less 40) Item(VOLCANICPOTION)
    if TargetBuffStealable(yes) Spell(SPELLSTEAL)
    if TargetIsInterruptible(yes) Spell(COUNTERSPELL)
    if ManaPercent(less 85) Item(MANAGEMITEM)
    unless 15s before Spell(DEEPFREEZE)
    {
          unless 30s before Spell(FLAMEORB)
          {
               unless 30s before Spell(ICYVEINS)  Spell(COLDSNAP)
          }
    }
    if TargetDeadIn(more 11) Spell(FLAMEORB)
    if TargetDeadIn(more 24) Spell(MIRRORIMAGE)
    Spell(ICYVEINS)
    Item(Trinket0Slot usable=1)
    Item(Trinket1Slot usable=1)
}

]]