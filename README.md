# Test maps for Warcraft 3

I will use this repository to create small test maps for various pieces of Warcraft 3. I'll mostly use it for working on the jassdoc:

1. Jassdoc by lep: https://github.com/lep/jassdoc/
2. Jassdoc by moyack: https://wc3modding.info/pages/jass-documentation-database/

For code snippets in Lua, use [Debug Console](https://www.hiveworkshop.com/threads/lua-debug-utils-ingame-console-etc.330758/) by Eikonium.

To paste code into the game for live execution, use my [Debug Console Paste Helper](https://github.com/Luashine/wc3-debug-console-paste-helper).


## Highlights (Cool stuff comes first)


### Ability-Destructor

Lua. PoC that abilities are automatically collected by the game when the unit holding them is removed & recycled.

**Specialty:** The code can track the lifecycle of an arbitrary object handle. Very useful! Must be changed to become a generic solution.


### Desync due to Lua objects and GC (init phase)

Repro [Map link (other repo)](https://github.com/Luashine/wc3-lua-global-desync)
and bug report: <https://us.forums.blizzard.com/en/warcraft3/t/desync-due-to-lua-objects-and-gc-init-phase/36996>

### Early Timer Desyncs (Lua)

Reported, PoC: Even the simplest timers made with Trigger GUI can cause a desync. [Go to](EarlyTimerDesyncsLua/README.md)


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


### Handle reuse

Lua, quality code snippets. Purpose: test handle behavior and reuse of previous handles by the game.
[Link](handle-reuse/README.md)

**Specialty:** tests userdata references returned by the game for reuse/static.


### Multilanguage

Scripted copy/generation of war3map.wts for Classic & Reforged. Has a test map. [Read more](multilanguage-map/README.md).


### ROC-vs-TFT-vs-Reforged

ROC v1.07 does not exist. And it does exist. It's a frankenstein. [Read more](roc-vs-tft-vs-reforged/README.md)


### Spell Event test

Lua, self-contained quality snippet. Used to test all spell event types for jassdoc. [Link](spell-event/README.md)

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


## List of organized topics/subfolders

Other stuff, alphabetically sorted.

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

### Boarding Test Map (debug for bug and crash)

[Link to folder](boarding-test-map) v2.0.4.23556

1. Shared control AI crash (unload order flood)
2. AI Player tries to board its own building once you order its ship to be too close to a coast line
3. Allied transport units don't work as rally target

### Boolean Expression API

Jass and Lua. [Link to text](Boolean-expression-API/README.md)

How do boolexpr, Condition, Filter behave? Do they return new objects every time? (spoiler: it depends on the VM)


### (Bug) BlzHideCinematicPanels shifts camera

TODO: Report it officially. A note is already included in jassdoc. See file: [BlzHideCinematicPanels.md](BlzHideCinematicPanels.md)


### Crash CreateUnit in globals

[Read more](crash-CreateUnit-in-globals)

### DisplayTextToPlayer-position

No map. Shows how Display text box position works. Go to [DisplayTextToPlayer-position.md](DisplayTextToPlayer-position/README.md)


### Force API

Lua, tiny code snippets to test player presence in Force. [Link to readme](Force-API/README.md)


### GetSummonedUnit

Map, Lua, obsolete testing code: test which getters apply to what event. [Read more](GetSummonedUnit/README.md)

Events: EVENT_PLAYER_UNIT_SUMMON, EVENT_UNIT_SUMMON.
Functions: GetSummonedUnit GetSummoningUnit GetTriggerUnit.


### Image API

Lua, [code snippets](image-api/README.md). I used this to test the Image API:

1. Create an image grid overlayed on top of terrain
2. A snippet for 3 images for manual testing


### Inexplicable Timer Difference

** Unresolved.** No map, major problem, wrote an explanation.

The in-game timers oscillate and deviate. Timers behavior changed between 1.29 and Reforged and they now accumulate the arithmetical error differently.Go to [readme](inexplicable-timer-difference/README.md).


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


### Unit Item/Inventory API (snippets)

Lua, No map. Code I had used (incrementally) to test the item API and unit inventory. [Link](Inventory-API/README.md)

### Rect / Rectangle / Region / Location (snippets)

Lua, No map. Code I had used (incrementally) to test the rect, location and region APIs. [Link](Rectangle-Location-API/README.md)


### MaxStringLength

I had been testing what special characters are understood by DisplayText, e.g. `\r` or `|n`.

StringLength-And-Special.w3m - [Link](MaxStringLength/)


### global_constants_to_string.lua

Superceded by Eikonium's Name Caching in
[Debug Utils](https://www.hiveworkshop.com/threads/lua-debug-utils-incl-ingame-console.353720/).

This is used to pretty-print a global object.
Given a registered object (namespace aka matching prefix), it'll return it's `_G` **key** name.
[Link - global_constants_to_string.lua](global_constants_to_string.lua)

Example: `print(prettyStringGameType( GetGameTypeSelected() ))`


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

### Widget API and TriggerRegisterDeathEvent

Lua, code snippet. [Link](Widget-API/README.md).
Used this as a test for the limited Widget API through `TriggerRegisterDeathEvent`, e.g. `GetTriggerWidget()`.
It has been included as an example in
[jassdoc for TriggerRegisterDeathEvent](https://lep.nrw/jassbot/doc/TriggerRegisterDeathEvent)

### Timerdialog API

Lua, No map. Code I had used (incrementally) to test the timerdialog API. [Link](TimerDialog-API/README.md)
