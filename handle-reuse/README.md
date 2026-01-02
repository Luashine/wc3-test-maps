# Test reuse of handles in Lua

Use in Eikonium's Debug Console

Purpose: compare previously created handles against handles created just now.
This is why the checks are delayed by timers.

What actually happened in Lua VM:

- handles are passed to Lua world as "userdata" objects/references
- internal handle IDs (uint32) aren't exactly the same

However this still lets us infer a couple properties:

- is a userdata reused? --> definitely points to the same internal object
- is it a new userdata? --> very likely a new internal object

Note that throughout I've been comparing only the userdata pointers.
I was either not interested or forgot to also include GetHandleId(obj).
Ideally, you'd do both side by side.

## Generic code (simple)

```lua
if not t1 then t1 = CreateTimer() end
if not t2 then t2 = CreateTimer() end

function fn()
	return ConvertAllianceType(1)
end
function show()
	print(string.format("globals: reused=\x25s, \x25s, \x25s", a==b, tostring(a),tostring(b)))
	print(string.format("locals: reused=\x25s, \x25s, \x25s", fn()==fn(), fn(),fn()))
end
TimerStart(t1, 0.1, false, function() a = fn(); end); TimerStart(t1, 0.3, false, function() b = fn() end)
TimerStart(t1, 0.5, false, show)
```

## Generic code v5 (manual & advanced)

This is condensed into just few lines to update and run. This is especially handy with copy-pasting to console <https://github.com/Luashine/wc3-debug-console-paste-helper/>

### Manual testing

If you want to change the testing function, just change the body of `fn()` and call `q()` to retest.

### Advanced testing

You can test many functions with multiple values at once. Also tests globals & locals at once.
Globals are temporarily stored and retrieved to test their persistence behavior.

1. Change used functions in `funcList`
2. Change supplied arguments in `valueList`.
	- If you are gonna have `nil` values, you need to update length manually.
Although it seems to work fine automatically now for up to `valueListParamCount`.
4. call `runAdvanced()`

**Note:** The timers are shared, so the code is not made for concurrency (aka not "MUI").
Do not attempt anything that runs in parallel.

#### Cool stuff

**diffptr(obj1, obj2)** returns a formatted message
with equal/different parts color-coded in green/red respectively.

#### Code

```lua
-- INITIALIZATION PHASE. the first three lines may shout about accessing a nil global
if not t1 then t1 = CreateTimer() end
if not t2 then t2 = CreateTimer() end
if not t3 then t3 = CreateTimer() end

function formatptr(obj)
	return (string.format("\x25s", obj):gsub(": 0+", ": "))
end
function diffptr(obj1, obj2)
	local red, green, r = "\x7CcFFff7777", "\x7CcFF77ff77", "\x7Cr"
	if obj1 == obj2 then
		local str = green .. formatptr(obj1) .. "\x7Cr"
		return str, str
	end
	
	local str1, str2 = formatptr(obj1), formatptr(obj2)
	local diffStart
	for i = 1, #str1 do
		if str1:sub(i,i) == str2:sub(i,i) then
			diffStart = i
		else
			break
		end
	end
	if diffStart then
		str1 = green .. str1:sub(1, diffStart) .. red .. str1:sub(diffStart+1) .. r
		str2 = green .. str2:sub(1, diffStart) .. red .. str2:sub(diffStart+1) .. r
	end
	return str1, str2
end --print(diffptr(math.sin, math.cos))

function show(func)
	local funct = func or fn -- fn is supposed to be globally defined
	print(string.format("globals: reused=\x25s, \x25s, \x25s", a==b, tostring(a), tostring(b)))
	local la, lb = funct(), funct()
	print(string.format("locals: reused=\x25s, \x25s, \x25s", la==lb, diffptr(la, lb)))
end
function showNonce(thisNonce, func) -- avoid mangling of global by other functions
	return function()
		if globalNonceA ~= thisNonce or globalNonceB ~= thisNonce then
			print("concurrent modification! nonce mismatch!")
		end
		show(func)
		globalNonceA, globalNonceB = nil, nil
	end	
end

-- FOR MANUAL TESTING
function setA()
	a = fn()
end
function setB()
	b = fn()
end
function q() -- queue test
	TimerStart(t1, 0.11, false, setA); TimerStart(t2, 0.22, false, setB); TimerStart(t3, 0.33, false, show)
end
-- END OF INIT
function fn()
	return Location(0,0)
end; q();
-- END OF MANUAL TEST



-- ADVANCED TESTING
function runAdvanced()
	for i = 1, #funcList do
		local speed = 15
		local blzFunc, tOffset = funcList[i]  ,  (i * valueListLength)/speed
		for iv = 1, valueListLength do
			tOffset = tOffset + iv/(speed*0.85) -- caution, timer order must be staggered to avoid global overwrites!
			local val, nonce,   t1, t2, t3 = valueList[iv], math.random(),    CreateTimer(),CreateTimer(),CreateTimer()
			local func = function()
				if type(val) == "table" then return blzFunc(table.unpack(val, 1, valueListParamCount))
				else return blzFunc(val) end
			end
			TimerStart(t1, (0.0/speed)+tOffset, false, function() globalNonceA=nonce; a=func(); end)
			TimerStart(t2, (0.1/speed)+tOffset, false, function() globalNonceB=nonce; b=func(); end)
			TimerStart(t3, (0.2/speed)+tOffset, false, showNonce(nonce, func))
		end
	end;
end
function returner(...) return ... end
funcList = {
GetStartLocPrio
}
valueList = { -- an element may contain a table with multiple arguments to unpack
{0,0},
{0,1},
{1,0},
{1,1},
};  valueListLength = math.max(1, #valueList) -- overcome nil holes
valueListParamCount = math.max(10, (type(valueList[1]) == "table" and #valueList or (1))) -- overcome nil holes
runAdvanced()
```

## ConvertXXX type API

v2.0.3.22988 Result: yes, each and every handle is reused if still exists (did not test garbage collection).

```lua
funcList = {
"ConvertRace",
"ConvertAllianceType",
"ConvertRacePref",
"ConvertIGameState",
"ConvertFGameState",
"ConvertPlayerState",
"ConvertPlayerScore",
"ConvertPlayerGameResult",
"ConvertUnitState",
"ConvertAIDifficulty",
"ConvertGameEvent",
"ConvertPlayerEvent",
"ConvertPlayerUnitEvent",
"ConvertWidgetEvent",
"ConvertDialogEvent",
"ConvertUnitEvent",
"ConvertLimitOp",
"ConvertUnitType",
"ConvertGameSpeed",
"ConvertPlacement",
"ConvertStartLocPrio",
"ConvertGameDifficulty",
"ConvertGameType",
"ConvertMapFlag",
"ConvertMapVisibility",
"ConvertMapSetting",
"ConvertMapDensity",
"ConvertMapControl",
"ConvertPlayerColor",
"ConvertPlayerSlotState",
"ConvertVolumeGroup",
"ConvertCameraField",
"ConvertBlendMode",
"ConvertRarityControl",
"ConvertTexMapFlags",
"ConvertFogState",
"ConvertEffectType",
"ConvertVersion",
"ConvertItemType",
"ConvertAttackType",
"ConvertDamageType",
"ConvertWeaponType",
"ConvertSoundType",
"ConvertPathingType",
"ConvertMouseButtonType",
"ConvertAnimType",
"ConvertSubAnimType",
"ConvertOriginFrameType",
"ConvertFramePointType",
"ConvertTextAlignType",
"ConvertFrameEventType",
"ConvertOsKeyType",
"ConvertAbilityIntegerField",
"ConvertAbilityRealField",
"ConvertAbilityBooleanField",
"ConvertAbilityStringField",
"ConvertAbilityIntegerLevelField",
"ConvertAbilityRealLevelField",
"ConvertAbilityBooleanLevelField",
"ConvertAbilityStringLevelField",
"ConvertAbilityIntegerLevelArrayField",
"ConvertAbilityRealLevelArrayField",
"ConvertAbilityBooleanLevelArrayField",
"ConvertAbilityStringLevelArrayField",
"ConvertUnitIntegerField",
"ConvertUnitRealField",
"ConvertUnitBooleanField",
"ConvertUnitStringField",
"ConvertUnitWeaponIntegerField",
"ConvertUnitWeaponRealField",
"ConvertUnitWeaponBooleanField",
"ConvertUnitWeaponStringField",
"ConvertItemIntegerField",
"ConvertItemRealField",
"ConvertItemBooleanField",
"ConvertItemStringField",
"ConvertMoveType",
"ConvertTargetFlag",
"ConvertArmorType",
"ConvertHeroAttribute",
"ConvertDefenseType",
"ConvertRegenType",
"ConvertUnitCategory",
"ConvertPathingFlag",
}
for i = 1, #funcList do
	local tOffset = i/2
	local t1, t2, t3 = CreateTimer(),CreateTimer(),CreateTimer()
	local blzFunc = _G[funcList[i]]
	local fn = function()
		return blzFunc(1)
	end
	TimerStart(t1, 0.1+tOffset, false, function()a=fn();end);TimerStart(t2, 0.2+tOffset, false, function()b=fn()end)
	TimerStart(t3, 0.3+tOffset, false, show)
end
```

## next

