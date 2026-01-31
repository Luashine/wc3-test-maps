# DestroyTrigger / TriggerClearActions leak

Blizzard forums: <https://us.forums.blizzard.com/en/warcraft3/t/destroytrigger-triggerclearactions-leak/37169>

The game (allegedly since forever) does not clean up any trigger actions when a trigger is destroyed using `DestroyTrigger` or when `TriggerClearActions` is called.

> bug (v1.26a, newer versions too afaik) This leaks internally, because the game does not free the handle
> Unlike `TriggerRemoveAction`, `TriggerRemoveCondition`, `TriggerClearConditions`, which do call "CAgent::Remove".

> You can use `TriggerRemoveAction` instead.

> Source: Unryze

Tested in 2.0.3.23101. This affects both Jass and Lua.

The test code to showcase is only possible in Lua (you can remove the TimerStart and wrapper func if it confuses you).
The following code will show when the upvalue-d table is collected by Lua's garbage collector.
This can only happen if the actionFunc is actually destroyed.

**How to:** copy-paste this code and wait 30-120s in a map (`/time`, don't Alt-TAB) until the overly slowed down GC decides to wake up.

**Expected: all to work**

- DestroyTrigger (under the hood as TriggerClearActions): "table is being collected: relying on trigger destruction"
- TriggerRemoveAction: "table is being collected: manual trigger remove action"

**Actual: only manual TriggerRemoveAction shows up**

This means neither the trigger action nor the upvalues were removed and collected.

Variations of GC pressure
---

`createGarbageTimer` to create Lua objects as garbage (a table) and a higher iteration count (works in retail/ptr 2.0.4):

## 0.1s delay, 30 locs/timer and 30*6 tables per timer

- first GC at 12k?
- second GC at 24k, also removed TriggerAction
- third GC at 30k
- fourth GC at 30k
- fifth GC at 30.5k
- sixth GC at 30.5k
- seventh GC at 30.5k
- eigth GC at 31k
- etc., no runaway observed

```lua
createGarbageTimer = CreateTimer()
TimerStart(createGarbageTimer, 0.1, true, function()
	local max = 30
	for i = 1, max do
		local loc = Location(13, 37)
		if i == max then
			local text = "Current handle ID watermark (max): ".. tostring(getHandleIdWatermark(loc))
			BlzDisplayChatMessage(GetLocalPlayer(), 0, text)
		end
		local foo = {"Table"}
		foo = nil -- unnecessary in Lua, but lets do it early
		RemoveLocation(loc)
	end
end)
```

## 0.1 delay, 50 locs/timer and zero tables per timer

1. v2.0.3.23175-retail: goes up to 60k occasionally, but goes down.
2. v2.0.4.23452-retail: at too high object creation speeds, it starts to run away and allows too many uncollected objects

- first GC at 17k
- second GC at ~65k, also removed TriggerAction (2.0.3 still cleared that handle much earlier)
- third GC at 124k (down to zero as before)
- ...
- 262k down to 133k
- ... ~180k down to 84k
- ... ~100k down to 10k
- over 605k down to ~100k
- ... down to 60k
- ~120k to 8k
- ~680k down to 140k
- ... down to ~15k
- ~1300k to ~420k
- ... down to 140k
- ... down to 80k
- ... down to 50k
- ....
- 1.52M handle IDs after 2h43m
- 2.50M handle IDs after 3h15m
- down to 795k at 3h20m, now keeps increasing again

```lua
createGarbageTimer = CreateTimer()
TimerStart(createGarbageTimer, 0.1, true, function()
	local max = 50
	for i = 1, max do
		local loc = Location(13, 37)
		if i == max then
			local text = "Current handle ID watermark (max): ".. tostring(getHandleIdWatermark(loc))
			BlzDisplayChatMessage(GetLocalPlayer(), 0, text)
		end
		--local foo = {"Table"}
		--foo = nil -- unnecessary in Lua, but lets do it early
		RemoveLocation(loc)
	end
end)
```

---

Below is the reproduction code that works well for 2.0.3 and older.

**Note:** Garbage creation was not required prior to 2.0.4 and was not part of original repro.

```lua
function getHandleIdWatermark(handle)
    if handle then
        return GetHandleId(handle)-0x100000
    end
    
    local loc = Location(1,2)
    local watermark = GetHandleId(loc)-0x100000
    RemoveLocation(loc)
    return watermark
end

createGarbageTimer = CreateTimer()
TimerStart(createGarbageTimer, 1.0, true, function()
	local max = 5
	for i = 1, max do
		local loc = Location(13, 37)
		if i == max then
			local text = "Current handle ID watermark (max): ".. tostring(getHandleIdWatermark(loc))
			BlzDisplayChatMessage(GetLocalPlayer(), 0, text)
		end
		RemoveLocation(loc)
	end
end)

reproTimer = CreateTimer()
TimerStart(reproTimer, 0.3, false, function()
	do -- does completely gc the upvalues
		local myTable = {"hello from table"}
		setmetatable(myTable, {
			__gc = function()
				local text = "table is being collected: manual trigger remove action"
				DisplayTimedTextToPlayer(GetLocalPlayer(), 0,0, 120, text)
			end
		})
		local myTrig = CreateTrigger()
		local trigAct -- create a referenceable upvalue var, avoids chicken-and-egg problem
		trigAct = TriggerAddAction(myTrig, function()
			print("Action: ".. myTable[1])
			print(trigAct)
			TriggerRemoveAction(myTrig, trigAct)
		end)
		TriggerExecute(myTrig)
		print(GetTriggerExecCount(myTrig))
		DestroyTrigger(myTrig)
		print(GetTriggerExecCount(myTrig))
	end


	do -- NEVER collects the upvalues
		local myTable = {"hello from table"}
		setmetatable(myTable, {
			__gc = function()
				local text = "table is being collected: relying on trigger destruction"
				DisplayTimedTextToPlayer(GetLocalPlayer(), 0,0, 120, text)
			end
		})
		local myTrig = CreateTrigger()
		local trigAct -- create a referenceable upvalue var, avoids chicken-and-egg problem
		trigAct = TriggerAddAction(myTrig, function()
			print("Action: ".. myTable[1])
			print(trigAct)
			-- removed line
		end)
		TriggerExecute(myTrig)
		print(GetTriggerExecCount(myTrig))
		DestroyTrigger(myTrig)
		print(GetTriggerExecCount(myTrig))
	end
	for i = 1, 30 do
		local loc = Location(13, 37)
		RemoveLocation(loc)
	end

end)
```
