# Fake item handles returned by some getters in item events

Tested in version: 2.0.3.23101, 2.0.3.23150-PTR

Blizzard bug report: <https://us.forums.blizzard.com/en/warcraft3/t/fake-item-handles-returned-by-getters-in-item-events/37224> 

Download test map: https://github.com/Luashine/wc3-test-maps/raw/refs/heads/master/ItemEvents-GetterFakeHandle/evu-manipulatedItem-2.0.3.23101.w3m

Context: none of the items spawned by the script are at `0; 0` to avoid confusion with the fallback value returned by positional getters.

<img width="1414" height="835" alt="Debug console output" src="https://github.com/user-attachments/assets/77d06a96-178d-401b-a9b8-df2ccdabc739" />

## Problem 1: BlzGetAbsorbingItem returns garbage

It may sometimes return an item handle that's invalid. In other words, any item-specific getter returns default values for this handle.
The handle pointer is always the same.

**Hypothesis:** it's either undefined behavior or a dangling pointer somehow. It may not reproduce after a map restart. -> hidden desync cause?

You may need to start the map directly via `-loadfile` without game/map restarts to get it to return the garbage handle. See screenshot.

**Reproduction:** pick up the first item with an empty inventory. `EVENT_UNIT_PICKUP_ITEM` will have `BlzGetAbsorbingItem` with garbage.

## Problem 2: BlzGetStackingItemSource sometimes returns garbage

May return the exact same garbage pointer as previously returned by `BlzGetAbsorbingItem`. See `EVENT_UNIT_STACK_ITEM` output.
This is why you see `item: gAbsorbing` (`gAbsorbing` is the pointers's global variable name, pretty-printed).

**Reproduction:** pick up the second item while having an incomplete item stack in inventory. `EVENT_UNIT_STACK_ITEM` will have `BlzGetStackingItemSource` with garbage.

## Problem 3: Getters not populated inside EVENT_UNIT_STACK_ITEM / EVENT_PLAYER_UNIT_STACK_ITEM

### a) GetManipulatingUnit & GetManipulatedItem are null

The more generalized getters `GetTriggerPlayer`, `GetTriggerUnit`, `GetUnitName` are populated for the same event.
It seems to be an oversight that the both getters were forgotten here. In my opinion, unit and item should both be populated.
Unit is obviously the item holder (unless it's possible to stack items on the ground somehow??) and the item is either the target or the source item.

### b) BlzGetStackingItemSource/Target are not properly populated

`BlzGetStackingItemSource` returns garbage (see Problem 2), `BlzGetStackingItemTarget` is null.

## Test code

Remember to modify the map accordingly.

```lua
-- Create an item in Object Editor:
-- 1. Items -> Charged -> 'wswd' aka Invisible Warden
-- 2. New name: "Stackable wards"
-- 3. New ID: 'iswa'
-- 4. Set 'ista' aka stackMax to 8
-- 5. Set 'iuse' aka uses to 2
-- 6. Change map's game constant: "ItemStackingEnabled" set to true (it's 70% scrolled down, under XPFactor)
spawnedItems = {}
do
	local x, y = 130, -140
	for i, rawcode in ipairs({"iswa","iswa","iswa","iswa"}) do
		for i = 1, 8 do
			tempItem = CreateItem(FourCC(rawcode), x, y)
			table.insert(spawnedItems, tempItem)
			y = y - 64
		end
		x = x + 128
		y = -140
	end
end
myPlayer = Player(0)
archmage = CreateUnit(myPlayer, FourCC"Hamg", 0, 128, 270.0)

do
	local regPlayer = GetOwningPlayer(archmage)
	local regUnit = archmage
	assert(regUnit)
	
	for i, eventName in ipairs({
		"EVENT_PLAYER_UNIT_STACK_ITEM",  "EVENT_UNIT_STACK_ITEM",
		"EVENT_PLAYER_UNIT_DROP_ITEM",   "EVENT_UNIT_DROP_ITEM",
		"EVENT_PLAYER_UNIT_PICKUP_ITEM", "EVENT_UNIT_PICKUP_ITEM",
		"EVENT_PLAYER_UNIT_USE_ITEM",    "EVENT_UNIT_USE_ITEM"
	}) do
		local eventType = _G[eventName]
		local isPlayerEvent = eventName:find("EVENT_PLAYER") and true or false
		local eventNameShort = eventName:gsub("EVENT_PLAYER_UNIT_", "evPU_"):gsub("EVENT_UNIT_", "evU_")
		trigTemp = CreateTrigger()
		actTemp = TriggerAddAction(trigTemp, function()
			local trigPlayer = GetTriggerPlayer()
			local trigUnit = GetTriggerUnit()
			local trigUnitName = GetUnitName(trigUnit)
			
			local manipulatingUnit = GetManipulatingUnit()
			local manipulatingUnitName = GetUnitName(manipulatingUnit)
			
			local manipulatedItem = GetManipulatedItem()
			local manipulatedItemName = GetItemName(manipulatedItem)
			
			local absorbingItem = BlzGetAbsorbingItem()
			local absorbingItemName = GetItemName(absorbingItem)
			
			local stackingSource = BlzGetStackingItemSource()
			local stackingSourceName = GetItemName(stackingSource)
			
			local stackingTarget = BlzGetStackingItemTarget()
			local stackingTargetName = GetItemName(stackingTarget)
			
			local unitItemsCharges = {}
			for s = 0, UnitInventorySize(regUnit)-1, 1 do
				local item = UnitItemInSlot(regUnit, s)
				local charges = item and GetItemCharges(item) or "-"
				table.insert(unitItemsCharges, charges)
			end
			
			print(string.format("\x25s: trigPlayer/Unit: '\x25s'/'\x25s', charges: \x25s",
				eventNameShort, GetPlayerName(trigPlayer), trigUnitName, table.concat(unitItemsCharges, "/")))
			print(string.format("manipulatingUnit='\x25s'; manipulatedItem='\x25s';x,y=(\x25.1f, \x25.1f)",
				manipulatingUnitName, manipulatedItemName, GetItemX(manipulatedItem), GetItemY(manipulatedItem)))
			
			if manipulatingUnit == nil and manipulatedItem == nil then
				print("GetManipulatingUnit and GetManipulatedItem are both null!")
			else
				print("GetManipulatingUnit", tostring(manipulatingUnit), GetManipulatingUnit()==GetManipulatingUnit())
				print("GetManipulatedItem", tostring(manipulatedItem), GetManipulatedItem()==GetManipulatedItem())
			end
			
			if absorbingItem then
				gAbsorbing = absorbingItem
				print(string.format("absorbingItem='\x25s';x,y=(\x25.1f, \x25.1f)",
					absorbingItem, GetItemX(absorbingItem), GetItemY(absorbingItem)))
				print("BlzGetAbsorbingItem", tostring(absorbingItem), BlzGetAbsorbingItem()==BlzGetAbsorbingItem())
			end
			if stackingSource then
				print(string.format("stackingSource='\x25s';x,y=(\x25.1f, \x25.1f)",
					stackingSource, GetItemX(stackingSource), GetItemY(stackingSource)))
				print("StackingSource", tostring(stackingSource), BlzGetStackingItemSource()==BlzGetStackingItemSource())
			end
			if stackingTarget then
				print(string.format("stackingTarget='\x25s';x,y=(\x25.1f, \x25.1f)",
					stackingTarget, GetItemX(stackingTarget), GetItemY(stackingTarget)))
				print("StackingTarget", tostring(stackingTarget), BlzGetStackingItemTarget()==BlzGetStackingItemTarget())
			end
		end)
		if isPlayerEvent then
			tempEvent = TriggerRegisterPlayerUnitEvent(trigTemp, regPlayer, eventType, nil)
		else
			tempEvent = TriggerRegisterUnitEvent(trigTemp, regUnit, eventType)
		end
	end
end
```
