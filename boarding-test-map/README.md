# Shared control AI crash (unload order flood)


Version tested: v2.0.4.23556

Both issues are related and I decided to put them under one thread.

## Shared control AI crash (unload order flood)

The Transport ship Spams unloadall order and then crashes the game:

1. you are allies with a blue AI player and share full (advanced) control
2. this AI has a building(s) and AI script is not started (I think so)
3. you control blue AI's Transport ship 'nbot' (with passenger slots)
4. load at least one passenger
5. Issue a move order to have it pass close to a nearby cliff
5. you direct it to unload all passengers while in deep water to a nearby location at the edge of a cliff (see lightning effect)
6. the ship moves on deep water as close as possible to the cliff
7. once there, it keeps spamming "unloadall" order and crashes the game within seconds

I once managed to see it abort the action spam, just when the night turned to day at 6am. Can't replicate this one anymore.

If it were your own ship, it'd have said "Cannot disembark here" and stop movement.

-----

## AI Player tries to board its own building once you order its ship to be too close to a coast line

1. you are allies with a blue AI player and share full (advanced) control
2. this AI has a building(s) and AI script is not started (I think so)
3. you control AI's Transport ship 'nbot' (with passenger slots)
4. you direct it to move/smart order/patrol to an unreachable ground location
5. the ship moves on deep water as close as possible to the clicked location
6. when it stops moving, it attempts to board a building. The following orders are issued:

1. Manual: Smart move towards a ground location
2. Once at coast automatic: 851974 order for Transport ship
3. Boarding sequence begins:
4. Auto: order for Transport ship 851986 ("move") with Lumber Mill as target
5. Auto: 851974 order for Transport ship
6. Auto: order for Transport ship 851986 ("move") with Lumber Mill as target
7. Auto: order for Transport ship 852043 ("board") with Transport ship as target

Even if it were possible to issue a board order of a building (UI prevents you from doing so), the last two orders have units mixed up. If a passenger wishes to be boarded ("smart" move) **and** is reachable by water, "board" target order is issued to the passenger with Ship as target. If the passenger is not reachable by water and boarding is issued from PoV of the Ship, then two orders are emitted: "load" & "board".

A similar behavior can be reproduced with Goblin Zeppelin owned by blue AI player. After unloading a unit, it will move towards a building and issue 851974 once there.

-----

# Allied transport units don't work as rally target

Version tested: v2.0.4.23556

Allied transport units don't work as rally target

Expected: with shared control, allied transport to automatically load your newly trained units

Actual: allied transport does not react at all. The boarding only works if trained unit owner == transport owner

Reproduction:

- Prerequisite: transport ship set as rally unit

Order sequence if `trained unit owner == transport owner`

1. Unit training finished
2. Order for trained unit 851970 ("") with Transport Ship as target
3. Order for Transport Ship 852046 ("load") with trained unit as target
4. Order for trained unit 852043 ("board") with Transport Ship as target
	- both units meet in the middle and embark (1. ship goes to closest ground ramp 2. unit only then goes to ship to board)

Order sequence if `trained unit owner != allied transport owner`

1. Unit training finished
2. Order for trained unit 851970 ("") with Transport Ship as target
	- trained unit runs up to transport and nothing else happens

----

# Issued Ordeer debug code

```lua
function printOrderInfo()
	local orderId = GetIssuedOrderId()
	local unit = GetTriggerUnit()
	local unitName = GetUnitName(unit)
	assert(GetOrderedUnit() == GetTriggerUnit(), "GetOrderedUnit() expected to equal GetTriggerUnit()")
	print(string.format("-> For: \x25s, Order: \x25d, oName:\x25s, owned by: \x25s",
		unitName, orderId, OrderId2String(orderId), GetPlayerName(GetOwningPlayer(unit))))
end
function printIssuedOrder()
	print("Next is an Issued Order:")
	printOrderInfo()
end
function printIssuedTargetOrder()
	local widget = GetOrderTarget()
	local destr = GetOrderTargetDestructable()
	local item = GetOrderTargetItem()
	local unit = GetOrderTargetUnit()

	local targetIsText = "-> Target is a '"
	if widget then targetIsText = targetIsText .. "widget," end
	if destr then targetIsText = targetIsText .. "destructable=" .. GetDestructableName(destr) end
	if item then targetIsText = targetIsText .. "item=" .. GetItemName(item) end
	if unit then targetIsText = targetIsText .. "unit=" .. GetUnitName(unit) end
	targetIsText = targetIsText .."'"
	
	if unit then targetIsText = targetIsText .." owned by: ".. GetPlayerName(GetOwningPlayer(unit)) end

	print("Next is an Issued Target Order:")
	printOrderInfo()
	print(targetIsText)
end
function printIssuedPointOrder()
	local loc = GetOrderPointLoc()
	local x,y,z = GetLocationX(loc),GetLocationY(loc),GetLocationZ(loc)
	-- GetOrderPointX(),GetOrderPointY() is identical to location...
	-- if you only wanted (x,y)
	print(string.format("Next is an Issued Point Order at: \x25.1f    \x25.1f    \x25.1f", x,y,z))
	printOrderInfo()
end

-- Note: in Lua root you cannot create units before the game starts (Map Initialization). 
-- You may use a timer to delay.
footman = CreateUnit(Player(0), FourCC("hfoo"), -30, 0, 90)
peasant = CreateUnit(Player(0), FourCC("hpea"), 30, 0, 90)
item = CreateItem(FourCC("war2"), 64, 128)
destructable = CreateDestructable(FourCC("LTbr"), 96, 0, 180, 1, 0)

whichIssuedOrderTrig = CreateTrigger()
whichIssuedTargetOrderTrig = CreateTrigger()
whichIssuedPointOrderTrig = CreateTrigger()

-- Only register one unit for order events:
--[==[ -- disabled via multiline comment
whichOrderTrigEvent = 
	TriggerRegisterUnitEvent(whichIssuedOrderTrig,       footman, EVENT_UNIT_ISSUED_ORDER)

whichIssuedTargetOrderTrigEvent =
	TriggerRegisterUnitEvent(whichIssuedTargetOrderTrig, footman, EVENT_UNIT_ISSUED_TARGET_ORDER)

whichIssuedPointOrderTrigEvent =
	TriggerRegisterUnitEvent(whichIssuedPointOrderTrig,  footman, EVENT_UNIT_ISSUED_POINT_ORDER)
]==]

-- Register as many players for order events as you want
whichOrderTrigEvents = {}
whichIssuedTargetOrderTrigEvents = {}
whichIssuedPointOrderTrigEvents = {}
for _, playerPair in ipairs({ {0, "red"}, {1, "blue"}, {3, "purple"} }) do
	local id, colorName = table.unpack(playerPair)
	
	local orderEv = 
		TriggerRegisterPlayerUnitEvent(whichIssuedOrderTrig,       Player(id), EVENT_PLAYER_UNIT_ISSUED_ORDER, nil)
	local targetOrderEv = 
		TriggerRegisterPlayerUnitEvent(whichIssuedTargetOrderTrig, Player(id), EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, nil)
	local pointOrderEv = 
		TriggerRegisterPlayerUnitEvent(whichIssuedPointOrderTrig,  Player(id), EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER, nil)
	
	table.insert(whichOrderTrigEvents,             {id, colorName, orderEv})
	table.insert(whichIssuedTargetOrderTrigEvents, {id, colorName, targetOrderEv})
	table.insert(whichIssuedPointOrderTrigEvents,  {id, colorName, pointOrderEv})
end

whichIssuedOrderTrigAct =       TriggerAddAction(whichIssuedOrderTrig,       printIssuedOrder)
whichIssuedTargetOrderTrigAct = TriggerAddAction(whichIssuedTargetOrderTrig, printIssuedTargetOrder)
whichIssuedPointOrderTrigAct =  TriggerAddAction(whichIssuedPointOrderTrig,  printIssuedPointOrder)
```
