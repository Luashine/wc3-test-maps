# Test reuse of handles

Use in Eikonium's Debug Console

## Generic code (simple)

```lua
if not t1 then t1 = CreateTimer() end
if not t2 then t2 = CreateTimer() end

function fn()
	return ConvertAllianceType(1)
end
function show()
	print(string.format("globals: reused=%s, %s, %s", a==b, tostring(a),tostring(b)))
	print(string.format("locals: reused=%s, %s, %s", fn()==fn(), fn(),fn()))
end
TimerStart(t1, 0.1, false, function() a = fn(); end); TimerStart(t1, 0.3, false, function() b = fn() end)
TimerStart(t1, 0.5, false, show)
```

## Generic code 2 

This variant is condensed into just 4 changing lines (or 3). If you want to change the testing function,
just change the body of `fn()` and call `q()` to retest.

This is especially handy with copy-pasting to console <https://github.com/Luashine/wc3-debug-console-paste-helper/>

```lua
-- initialization phase. the first three lines may shout about accessing a nil global
if not t1 then t1 = CreateTimer() end
if not t2 then t2 = CreateTimer() end
if not t3 then t3 = CreateTimer() end

function show()
	print(string.format("globals: reused=%s, %s, %s", a==b, tostring(a),tostring(b)))
	print(string.format("locals: reused=%s, %s, %s", fn()==fn(), fn(),fn()))
end
function setA()
	a = fn()
end
function setB()
	b = fn()
end
function q() -- queue test
	TimerStart(t1, 0.1, false, setA); TimerStart(t2, 0.3, false, setB); TimerStart(t3, 0.5, false, show)
end
-- end of init
function fn()
	return GetStartLocPrio(0,1)
end
q()
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

