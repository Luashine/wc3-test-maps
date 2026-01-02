# Test maps for Warcraft 3

I will use this repository to create small test maps for various pieces of Warcraft 3. I'll mostly use it for working on the jassdoc:

1. Jassdoc by lep: https://github.com/lep/jassdoc/
2. Jassdoc by moyack: https://wc3modding.info/pages/jass-documentation-database/

For code snippets in Lua, use [Debug Console](https://www.hiveworkshop.com/threads/lua-debug-utils-ingame-console-etc.330758/) by Eikonium.

To paste code into the game for live execution, use my [Debug Console Paste Helper](https://github.com/Luashine/wc3-debug-console-paste-helper).


## List of organized topics/subfolders

### Ability-Destructor

Lua. PoC that abilities are automatically collected by the game when the unit holding them is removed &amp; recycled.

**Specialty:** The code can track the lifecycle of an arbitrary object handle. Very useful! Must be changed to become a generic solution.


### AddResourceAmount 

Jass (1.27): Creates multiple mines to test `{Add,Set}ResourceAmount` functions. Includes: 0, set negative, add big negative.


### Attack-and-Gamespeed 

Has a map, Lua. Test how different in-game timers work against wall clock time.

- Worker training: records wall clock time spent on training the human worker. Set to 10s in WE

- OnAttack: Hero and Arrow tower are tracked and written to multiboard. First value is attackCount, second value is attacks/second

- Change game speed: `-gs <number>`
   - Currently only 0, 1, 2 exist in the game

- TriggerSleepAction benchmark: `-sleep <seconds>`

- PolledWait benchmark: `-polledwait <seconds>`

- Wait based on a single Timer (unlike PolledWait): `-timerwait <seconds>`


### Boolean Expression API

Jass and Lua. [Link to text](Boolean-expression-API/README.md)

How do boolexpr, Condition, Filter behave? Do they return new objects every time? (spoiler: it depends on the VM)


### (Bug) BlzHideCinematicPanels shifts camera

See file: [BlzHideCinematicPanels.md](BlzHideCinematicPanels.md)


### DisplayTextToPlayer-position

No map. Shows how Display text box position works. Go to [DisplayTextToPlayer-position.md](DisplayTextToPlayer-position/README.md)


### Early Timer Desyncs (Lua)

Reported, PoC: Even the simplest timers made with Trigger GUI can cause a desync. [Go to](EarlyTimerDesyncsLua/README.md)


### Force API

Lua, tiny code snippets to test player presence in Force. [Link to readme](Force-API/README.md)


### GetSummonedUnit

Map, Lua, obsolete testing code: test which getters apply to what event. [Read more](GetSummonedUnit/README.md)

Events: EVENT_PLAYER_UNIT_SUMMON, EVENT_UNIT_SUMMON.
Functions: GetSummonedUnit GetSummoningUnit GetTriggerUnit.


### Inexplicable Timer Difference

** Unresolved.** No map, major problem, wrote an explanation.

The in-game timers oscillate and deviate. Timers behavior changed between 1.29 and Reforged and they now accumulate the arithmetical error differently.Go to [readme](inexplicable-timer-difference/README.md).


### Multilanguage

Scripted copy/generation of war3map.wts for Classic & Reforged. Has a test map. [Read more](multilanguage-map/README.md).


### Nested-error-in-blizzardj

No action needed. PoC, Lua: [A map](Nested-error-in-blizzardj/lua-error-in-blizzardj-v1.w3m)
that causes a function call inside `Blizzard.j` to fail (`Blizzard.j` is auto-transpiled to Lua)

Summary: `QuestSetEnabledBJ` cannot be called with wrong arguments in Jass (type checking), but it's possible in Lua.
The function is a simple alias for `QuestSetEnabled`.

```
	-- this will throw an error in 1.32.10 Lua
	-- however if you call ("str", nil) then it'll fail silently
	QuestSetEnabledBJ("ignored", "causesErr")
```

### ROC-vs-TFT-vs-Reforged

ROC v1.07 does not exist. And it does exist. It's a frankenstein. [Read more](roc-vs-tft-vs-reforged/README.md)


### SetBlight and Shift key

It was wrongly claimed that it's affected by whether player is currently pressing the Shift key.

Instead its the NOTH SetTerrain type. (TODO: Confirm and report)

[Read more and test map](SetBlight-depends-on-shift-key/README.md)

### ShowInterface(false, 0) crash with DestroyMultiboard

Code only. Fixed in 1.33. Multiboard crashes in 1.30.x-1.32.10 (maybe earlier). Go to [ShowInterface-crash](ShowInterface-crash/README.md).


### SuggestedPlayerInW3I

Has all test maps, properly written down.

Tests the String reader in W3I which has a built-in length limit. Blow past all limits with this PoC.
The value shows up in the game menu.

**Specialty:** The game does not gracefully handle this (TODO: report as bug)

### Variable Length Crash

Using too long variable names crashed old versions (pre-Reforged). [read more](variable-length-crash/README.md)

I also added other "too long" stuff that crashes WC3. Like function names, inline strings etc.


## The rest are my random snippets

etc.

### Unit Item/Inventory API (snippets)

Lua, No map. Code I had used (incrementally) to test the item API and unit inventory. [Link](Inventory-API/README.md)

### Rect / Rectangle / Region / Location (snippets)

Lua, No map. Code I had used (incrementally) to test the rect, location and region APIs. [Link](Rectangle-Location-API/README.md)

### Generate string to test max length

Lua code. **Specialty:** Generates a string that tracks its own length for max length checks.
Really useful to see the cut-off length.

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

### MaxStringLength

I had been testing what special characters are understood by DisplayText, e.g. `\r` or `|n`.

StringLength-And-Special.w3m - [Link](MaxStringLength/)

### global_constants_to_string.lua

This function can be used to generate a function to compare predefined strings
and output as a fancy string. Useful to compare custom types such as playerstate etc.

### Dialog API testing snippet

```lua
dlog = DialogCreate()

DialogSetMessage(dlog, ("setMessage123"):rep(5))
DialogAddQuitButton(dlog, true, "quit with score (hotkey Y)", ("Y"):byte())
DialogAddQuitButton(dlog, false, "quit without score (hotkey Z)", ("Z"):byte())
DialogAddButton(dlog, "Just the U Button", ("U"):byte())
DialogAddButton(dlog, "lower-case p hotkey shouldnt work", ("p"):byte())
DialogAddButton(dlog, "The hotkey is @ (at)", ("@"):byte())
DialogDisplay(Player(12), dlog, true)

DialogClear(dlog)
DialogDestroy(dlog)
```

### Widget API and TriggerRegisterDeathEvent + GetTriggerWidget()

```lua
-- Create necessary widgets
u = CreateUnit(Player(0), FourCC("Hamg"), -30, 0, 90)
d = CreateDestructable(FourCC("ZTg1"), 256, 0, 90, 1, 0)
item = CreateItem(FourCC("war2"), 256, 384)

-- This is our trigger action
hasht = InitHashtable() -- for type-casting
function widgetDied()
	local w,u,d,i
	w,u,d = GetTriggerWidget(),GetTriggerUnit(),GetTriggerDestructable()
	if not u and not d then -- the widget is an item
		-- Downcasting (explicit type casting from widget to a child type)
		SaveWidgetHandle(hasht, 1, 1, w) -- put as widget
		i = LoadItemHandle(hasht, 1, 1) -- retrieve as item
	end
	print("died object (widget, unit, destr, item):", w, u, d, i)
	
	local wXpos, uXpos, dXpos, iXpos
	wXpos = GetWidgetX(w)
	if u then uXpos = GetUnitX(u) end
	if d then dXpos = GetDestructableX(d) end
	if i then iXpos = GetItemX(i) end
	print("died obj x pos (widget, unit, destr, item):", wXpos, uXpos, dXpos, iXpos)
end

-- Create and register widgets to this trigger
trig = CreateTrigger()
TriggerAddAction(trig, widgetDied)
for k,widg in pairs({u,d,item}) do TriggerRegisterDeathEvent(trig, widg) end

-- Kill widgets and observe what happens
SetWidgetLife(u, 0)
SetWidgetLife(d, 0)
SetWidgetLife(item, 0)


function unitDied()
	local w,u = GetTriggerWidget(),GetTriggerUnit()
	print("died unit (widget, unit):", w, u)
end
trigUnit = CreateTrigger()
TriggerAddAction(trigUnit, unitDied)
TriggerRegisterUnitEvent(trigUnit, u, EVENT_UNIT_DEATH)
```

### Timerdialog API tests

```
timer = CreateTimer()
tdialog = CreateTimerDialog(timer)
TimerDialogSetTitle(tdialog, "Timer1 Dialog")
TimerDialogDisplay(tdialog, true)

timer2 = CreateTimer()
tdialog2 = CreateTimerDialog(timer2)
TimerDialogDisplay(tdialog2, true)

timer3 = CreateTimer()
tdialog3 = CreateTimerDialog(timer3)
TimerDialogDisplay(tdialog3, true)

--
tdialogEmpty = CreateTimerDialog()
TimerDialogSetTitle(tdialogEmpty, "No Timer")
TimerDialogDisplay(tdialogEmpty, true)
--
-- how many characters fit?
--> 14 full-size characters like "@" (at), followed by three dots "..."
TimerDialogSetTitle(tdialog2, ("@"):rep(30))
---

TimerStart(timer, 5.0, true, function() BJDebugMsg("Tick ".. os.date() .. " and ".. os.clock()) end)
TimerStart(timer, 5.0, false, function() end)


TimerDialogSetSpeed(tdialog, 16)
TimerDialogSetRealTimeRemaining(tdialogEmpty, 30)

-- How do colors behave?
--> Answer: their value is normalized with modulo or similar
TimerDialogSetTitleColor(tdialog, 0, 255, 0, 0) -- 100% green
TimerDialogSetTitleColor(tdialog, 0, 382, 0, 0) -- 50% green
TimerDialogSetTitleColor(tdialog, 0, 510, 0, 0) -- 100% green

TimerDialogSetTitleColor(tdialog, 0, -1, 0, 0) -- 100%
TimerDialogSetTitleColor(tdialog, 0, -240, 0, 0) -- very dark
TimerDialogSetTitleColor(tdialog, 0, -255, 0, 0) -- black
TimerDialogSetTitleColor(tdialog, 0, -256, 0, 0) -- black
TimerDialogSetTitleColor(tdialog, 0, -257, 0, 0) -- 100%
TimerDialogSetTitleColor(tdialog, -257, -257, -257, 0) -- 100%
--
-- Ultrawide timer bug (SD, 1.32.10)
-- The second timer renders incorrectly if you use an ultrawide
-- 22.11.15_21-08-08__Warcraft III.png
--

-- Local player visibility:
plocal = plocal or GetLocalPlayer()
p0 = p0 or Player(0)
if p0 == plocal then TimerDialogDisplay(tdialog, true) end
--

-- @bug tdialogEmpty is shown above tdialog
tdialog = CreateTimerDialog(CreateTimer())
TimerDialogSetTitle(tdialog, "Timer1 Dialog __ 1")
TimerDialogDisplay(tdialog, true)
tdialog2 = CreateTimerDialog(CreateTimer())
TimerDialogSetTitle(tdialog2, "Timer2 Dialog")
TimerDialogDisplay(tdialog2, true)
-- Correct up to this point:
-- This is buggy:
TimerDialogDisplay(tdialog, false)
TimerDialogDisplay(tdialog2, true)
TimerDialogDisplay(tdialog, true)
-- Now tdialog will appear beneath tdialog2.
-- To correctly toggle display of all timers, toggle all off then
-- toggle them on
TimerDialogDisplay(tdialog, false)
TimerDialogDisplay(tdialogEmpty, false)
TimerDialogDisplay(tdialog, true)
TimerDialogDisplay(tdialogEmpty, true)
-- This does not trigger at all, neither for regular timers,
-- nor for timerdialog internal timers
trg_gameEvTimer = CreateTrigger()
TriggerAddAction(trg_gameEvTimer, function() print(tostring("hm")) end)
TriggerRegisterGameEvent(trg_gameEvTimer, EVENT_GAME_TIMER_EXPIRED)
```

