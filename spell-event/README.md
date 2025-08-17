# Full testing code for casted spell events

v2.0.3.23038-PTR / v2.0.3 retail

Complete testing code with targets and heroes and registered events.
To test targeting items/destructables, you'll need to modify the assassin's poison dart ability to target items & debris too.

- EVENT_UNIT_SPELL_CHANNEL
- EVENT_UNIT_SPELL_CAST
- EVENT_UNIT_SPELL_EFFECT
- EVENT_UNIT_SPELL_FINISH
- EVENT_UNIT_SPELL_ENDCAST
- EVENT_PLAYER_UNIT_SPELL_CHANNEL
- EVENT_PLAYER_UNIT_SPELL_CAST
- EVENT_PLAYER_UNIT_SPELL_EFFECT
- EVENT_PLAYER_UNIT_SPELL_FINISH
- EVENT_PLAYER_UNIT_SPELL_ENDCAST

```lua
-- Complete testing code with targets and heroes and registered events
tree1 = CreateDestructable(FourCC("LTlt"), 384, 384, 180, 1, 0)
tree2 = CreateDestructable(FourCC("LTlt"), 384, 512, 180, 1, 0)
tree3 = CreateDestructable(FourCC("LTlt"), 384, 768, 180, 1, 0)
barrel1 = CreateDestructable(FourCC("LTbr"), 128, 384, 180, 1, 0)
barrel2 = CreateDestructable(FourCC("LTbr"), 128, 512, 180, 1, 0)
item1 = CreateItem(FourCC("war2"), 0, 384)
item2 = CreateItem(FourCC("war2"), 0, 512)
hero1 = CreateUnit(Player(0), FourCC"Hamg", 256, 0, 270.0)
hero2 = CreateUnit(Player(0), FourCC"Ewar", 384, 0, 270.0)
SetHeroInt(hero1, 200, true)
SetHeroInt(hero2, 200, true)

-- 1. ward ability - target loc 'AIsw' sight ward from item
-- 2. paladin heal - target unit 'AHhb'
-- 3. water elemental - untargetted summon 'AHwe'
-- 4. thunder clap aoe - active of what type? 'AHtc'
print(UnitAddAbility(hero1, FourCC'AIsw'))
print(UnitAddAbility(hero1, FourCC'AHhb'))
print(UnitAddAbility(hero1, FourCC'AHwe'))
print(UnitAddAbility(hero1, FourCC'AHtc'))

-- 5. immolation - demon hunter burn toggle 'AEim'
-- 6. night elf sentinel - tree target 'Aesr'
-- 7. item and ward targets - 'Alit' lightning auto-attack (no icon)
print(UnitAddAbility(hero2, FourCC'AEim'))
print(UnitAddAbility(hero2, FourCC'Aesr'))
print(UnitAddAbility(hero2, FourCC'Alit'))

spellEvents = {
"EVENT_UNIT_SPELL_CHANNEL",
"EVENT_UNIT_SPELL_CAST",
"EVENT_UNIT_SPELL_EFFECT",
"EVENT_UNIT_SPELL_FINISH",
"EVENT_UNIT_SPELL_ENDCAST",}
-- for each of the unit heroes
for _, unit in pairs({hero1, hero2}) do
	-- register each event
	for _, eventName in pairs(spellEvents) do
		local UNITEVENT = _G[eventName] -- fetch global by name
		local trig = CreateTrigger() -- new trigger per hero+event
		local regEvent = TriggerRegisterUnitEvent(trig, unit, UNITEVENT)
		-- also separate action generated per hero+event to capture eventName as upvalue
		-- you will not need all this, so just register the needed trigger+event+action once
		local trigAction = TriggerAddAction(trig, function()
			local trigPlayer = GetTriggerPlayer()
			local trigUnit = GetTriggerUnit()
			
			local abilityUnit = GetSpellAbilityUnit()
			local abilityUnitName = GetUnitName(abilityUnit)
			
			local ability = GetSpellAbility()
			local abilityId = ability and BlzGetAbilityId(ability)
			local abilityName = abilityId and GetAbilityName(abilityId)
			
			local targetLoc = GetSpellTargetLoc()
			local locX, locY, locZ
			if targetLoc then
				locX, locY, locZ = GetLocationX(targetLoc), GetLocationY(targetLoc), GetLocationZ(targetLoc)
			end
			
			local targetDestr = GetSpellTargetDestructable()
			local targetDestrName = targetDestr and GetDestructableName(targetDestr)
			
			local targetItem = GetSpellTargetItem()
			local targetItemName = targetItem and GetItemName(targetItem)
			
			local targetUnit = GetSpellTargetUnit()
			local targetUnitName = targetUnit and GetUnitName(targetUnit)
			
			print(string.format("\x25s abilUnit='\x25s' abilName='\x25s' targetLoc=\x25s,\x25s,\x25s",
				(eventName:gsub("EVENT_UNIT_", "")), abilityUnitName, abilityName, locX, locY, locZ
			))
			
			local unitSame = GetSpellAbilityUnit()==GetSpellAbilityUnit()
			local targetDestrSame =  GetSpellTargetDestructable()== GetSpellTargetDestructable()
			local targetItemSame =  GetSpellTargetItem()==GetSpellTargetItem()
			local targetUnitSame =  GetSpellTargetUnit()==GetSpellTargetUnit()
			print("...spell", trigPlayer, trigUnit, 
				tostring(targetDestrName), tostring(targetItemName), tostring(targetUnitName))
		end)
	end
end
print("Spell unit event registration complete.")
```
