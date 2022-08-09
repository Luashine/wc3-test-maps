# Test maps for Warcraft 3

I will use this repository to create small test maps for various pieces of Warcraft 3. I'll mostly use it for working on the jassdoc:

1. Jassdoc by lep: https://github.com/lep/jassdoc/
2. Jassdoc by moyack: https://wc3modding.info/pages/jass-documentation-database/

For code snippets in Lua, use [Debug Console](https://www.hiveworkshop.com/threads/lua-debug-utils-ingame-console-etc.330758/) by Eikonium.

## AddResourceAmount 

(Jass, 1.27)

Creates multiple mines to test Add/Set|ResourceAmount functions. Includes: 0, set negative, add big negative.

## SetUnitColor (no map)

Sets a unit's player color accent.

```lua
u1 = CreateUnit(Player(0), FourCC("hfoo"), -200, 0, 90)
u2 = CreateUnit(Player(0), FourCC("hfoo"), 0, 0, 90)

SetUnitColor(u1, PLAYER_COLOR_PINK)
```

## SetUnitVertexColor (no map)

```lua
u1 = CreateUnit(Player(0), FourCC("hfoo"), -200, 0, 90)
u2 = CreateUnit(Player(0), FourCC("hfoo"), 0, 0, 90)

-- will make a unit 50% transparent with dark green-blue color
SetUnitVertexColor(u1, 0, 255, 127, 127)
```

## Set/GetUnitAbilityLevel, SelectHeroSkill, SetHeroLevel etc.

SetHeroLevel, SelectHeroSkill, GetUnitAbilityLevel, SetUnitAbilityLevel, ReviveHero, ReviveHeroLoc, UnitAddAbility, UnitRemoveAbility

```lua
u = CreateUnit(Player(0), FourCC("Hamg"), -30, 0, 90)
-- AHwe - Arch-Human-water-elemental summon
GetUnitAbilityLevel(u, FourCC'AHwe')
SetUnitAbilityLevel(u, FourCC'AHwe', 3)

UnitAddAbility(u, FourCC'AHwe')
UnitRemoveAbility(u, FourCC'AHwe')
	
SelectHeroSkill(u, FourCC'AHwe')

SetHeroLevel(u, 9, true)
```
