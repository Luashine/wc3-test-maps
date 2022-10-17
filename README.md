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

## Attack and Gamespeed (map, Lua)

- Worker training: records wall clock time spent on training the human worker. Set to 10s in WE

- OnAttack: Hero and Arrow tower are tracked and written to multiboard. First value is attackCount, second value is attacks/second

- Change game speed: `-gs <number>`
   - Currently only 0, 1, 2 exist in the game

- TriggerSleepAction benchmark: `-sleep <seconds>`

- PolledWait benchmark: `-polledwait <seconds>`

- Wait based on a single Timer (unlike PolledWait): `-timerwait <seconds>`

## Unit Item/Inventory API (no map)

```lua
AddPlayerTechResearched(Player(0), FourCC'Rhpm', 1)
SetPlayerTechResearched(Player(0), FourCC'Rhpm', 0)

UnitInventorySize(u)
---------
u = CreateUnit(Player(0), FourCC("hfoo"), -30, 0, 90)

-- Add Human backpack research, allows to carry items
AddPlayerTechResearched(Player(0), FourCC'Rhpm', 1)

-- quelthalas boots: belv
UnitAddItemById(u, FourCC'belv')

-- UnitItemInSlot / UnitItemInSlotBJ
for i = -1, 7 do print(i, UnitItemInSlot(u, i), UnitItemInSlotBJ(u, i+1)) end

uItem = UnitItemInSlot(u, 0)

-- UnitHasItem
print(UnitHasItem(u, uItem))

-- UnitRemoveItemFromSlot
UnitRemoveItemFromSlot(u, uItem)

-- UnitRemoveItem
UnitRemoveItem(u, uItem)

-- UnitDropItemPoint
UnitDropItemPoint(u, uItem, 0, 0)

-- UnitDropItemSlot
-- move item from slot 0 to slot 1
UnitDropItemSlot(u, uItem, 1)

-- Create castle
castle = CreateUnit(Player(0), FourCC("hcas"), -30, 0, 90)

-- UnitDropItemTarget
u2 = CreateUnit(Player(0), FourCC("hfoo"), -30, 0, 90)
SetUnitColor(u2, PLAYER_COLOR_PINK)
UnitDropItemTarget(u, uItem, u2)

-- UnitAddItem
UnitAddItem(u, uItem)

-- add claws of attack +12
UnitAddItemById(u, FourCC'ratc')
UnitAddItemToSlotById(u, FourCC'ratc', 1)


hero = CreateUnit(Player(0), FourCC("Hamg"), -30, 0, 90)
heroItemHp = UnitAddItemById(hero, FourCC'phea')

-- Attempt to use heal pot at 100% hp
UnitUseItem(hero, heroItemHp)
--> false, cannot use at 100% hp

-- Set 50% HP
SetUnitState(hero, UNIT_STATE_LIFE, 200.0)
UnitUseItem(hero, heroItemHp)
--> true, with visual effect

heroDagger = UnitAddItemById(hero, FourCC'desc')
-- use dagger to 0,0 map coords
UnitUseItemPoint(hero, heroDagger, 0, 0)

heroInferno = UnitAddItemById(hero, FourCC'infs')
UnitUseItemPoint(hero, heroInferno, 0, 0)

heroWandTeleport = UnitAddItemById(hero, FourCC'stel')
UnitUseItemTarget(hero, heroWandTeleport, castle)

heroTownScroll = UnitAddItemById(hero, FourCC'stwp')
UnitUseItemTarget(hero, heroTownScroll, castle)

-- try on non-hero
uWandTeleport = UnitAddItemById(u, FourCC'stel')
UnitUseItemTarget(u, uWandTeleport, castle)

-- Use hero dagger from far away targeted at castle
UnitUseItemTarget(hero, heroDagger, castle)
--> does not cast, v1.32.10

-- Use spawn inferno targeted at unit
heroInferno = UnitAddItemById(hero, FourCC'infs')
UnitUseItemTarget(hero, heroInferno, castle)
--> does not cast, like dagger above

-- Use item without a target/pos
UnitUseItem(hero, uWandTeleport)
--> false, probably because no target specified
UnitUseItem(hero, heroDagger)
--> true, but does nothing, no cooldown
UnitUseItem(hero, heroInferno)
--> true, but does nothing, no cooldown
```

## UnitAddItemById, EnumItems on map (code)

```lua
u = CreateUnit(Player(0), FourCC("hfoo"), -30, 0, 90)

-- Kelthas boots
-- will be dropped to the ground because cannot carry items
UnitAddItemById(u, FourCC'belv')

-- Should spawn no items, both invalid
UnitAddItemById(u, 0)
UnitAddItemById(nil, FourCC'belv')

EnumItemsInRect(GetWorldBounds(), nil, function() local it=GetEnumItem();print(GetItemX(it),GetItemY(it),GetItemName(it)) end)
```

## Rect / Rectangle / Region / Location (code)

For: Rect, RectFromLoc, RemoveRect, SetRect, SetRectFromLoc, MoveRectTo, MoveRectToLoc, GetRectCenterX, GetRectCenterY, GetRectMinX, GetRectMinY, GetRectMaxX, GetRectMaxY, GetWorldBounds

```lua
function showRect(r) print(r,GetRectMinX(r),GetRectMinY(r),GetRectMaxX(r),GetRectMaxY(r)) end
function checkRectCenter(r) print(GetRectCenterX(r), GetRectCenterY(r)) end


rectAll = Rect(-1000000,-1000000,1000000,1000000)
rectMin = Rect(-1000000,-1000000,-1000000,-1000000)
rectMax = Rect(1000000,1000000,1000000,1000000)
rectZero = Rect(0,0,0,0)

showRect(GetWorldBounds()) --> -4096,-4096, 4096,4096
showRect(rectAll) --> -4096,-4096, 4064,4064
showRect(rectMin) --> -4096,-4096, -4096,-4096
showRect(rectMax) --> 4064,4064, 4064,4064
showRect(rectZero) --> all 0

checkRectCenter(GetWorldBounds()) --> 0,0
checkRectCenter(rectAll) --> -16,-16
checkRectCenter(rectMin) --> -4096,-4096
checkRectCenter(rectMax) --> 4064,4064
checkRectCenter(rectZero) --> 0,0



function showLoc(l) print(l,GetLocationX(l),GetLocationY(l)) end

locMin = Location(-1000000,-1000000)
locMax = Location(1000000,1000000)
locZero = Location(0,0)
locFraction = Location(0.1337,0.42)


showLoc(locMin) --> -1000000,-1000000 etc
showLoc(locMax)
showLoc(locZero)
showLoc(locFraction)

showRect(RectFromLoc(locMin, locMax))

rectSet = Rect(-1,-1,1,1)
SetRect(rectSet, -1e5,-1e5, 1e5, 1e5)
showRect(rectSet) --> capped to map bounds and maxX/maxY are off by 16

SetRectFromLoc(rectSet, locFraction, locMax)
showRect(rectSet) --> 0.1337,0.42, 4064,4064

-- MoveRectTo
rectMove = Rect(-2,-2, 4,4)
checkRectCenter(rectMove)
MoveRectTo(rectMove, 0, 0)
checkRectCenter(rectMove)
showRect(rectMove)

-- MoveRectTo bypasses map bounds checks/restrictions
rectMoveBypass = Rect(-2,-2, 4,4)
showRect(rectMoveBypass)
MoveRectTo(rectMoveBypass, 1e6, 1e6)
showRect(rectMoveBypass)

-- Bypasses similar to above
MoveRectToLoc(rectMoveBypass, locMin)
showRect(rectMoveBypass)

-- RemoveRect
rectRemove = Rect(-1,-2, 3,4)
RemoveRect(rectRemove)
showRect(rectRemove)
```

# Generate string to test max length

Generates a string that tracks its own length for max length checks (Lua code):

```lua
local s = ""
local maxLength = 5000

while #s < maxLength do
	s = s .. (#s .. ".")
end
print(s)
```

Example output: `0.2.4.6.8.10.13.`

This must be read as "13." means that the dot character following "10" was the 13th character in the string. Thus we only need to sum up 13 + the three characters of the last number you can see: 13+3 = 16 characters total generated and visible.

Graphic:

```
Visible string:
0.2.4.6.8.10.13.
 ^ ^ ^ ^ ^  ^  ^
 2 | 6 | 10 |  16 (you can see 3 more characters after the last number)
   4   8    13 (last number points to this)
```

# StringLength-And-Special.w3m

Test map for string length and special character handling.

# Nested-error-in-blizzardj (lua-error-in-blizzardj-v1.w3m)

Lua: A map that causes a function call inside `Blizzard.j` to fail (`Blizzard.j` is auto-transpiled to Lua) 

