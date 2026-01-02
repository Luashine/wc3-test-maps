# Unit Item/Inventory API

Code I had used (incrementally) to test the item API and unit inventory.

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
