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

---

Variation of `createGarbageTimer` to create Lua objects as garbage (a table) and a higher iteration count (works in retail/ptr 2.0.4):

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

---

Reproduction code that works well for 2.0.3 and below:

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
