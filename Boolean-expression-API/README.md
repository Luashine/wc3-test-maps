# Boolean Expression API

## Boolean Expressions returns same handles

Map: "Condition-and-Operators-new-v1.32.10.w3m"

Mixed results, v1.32.10:

- Condition-s are: equal
- Condition-s constant are: equal
- And-s are: not equal
- And-s swapped are: not equal
- Or-s are: not equal
- Or-s swapped are: not equal
- Not-s are: not equal

**Summary:** `Condition` and `Filter` (see below) behave the same, return old handle for a given func.
`And`, `Or`, `Not` behave the same, always new handle.

```jass
function SimpleJassFunc takes nothing returns boolean
	return true
endfunction

constant function SimpleJassFunc_constant takes nothing returns boolean
	return true
endfunction

function SimpleJassFunc_False takes nothing returns boolean
	return false
endfunction


///////////
function CompareShowCondition takes nothing returns nothing
	if Condition(function SimpleJassFunc) == Condition(function SimpleJassFunc) then
		call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"Condition-s are: equal")
	else
		call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"Condition-s are: not equal")
	endif
	
	if Condition(function SimpleJassFunc_constant) == Condition(function SimpleJassFunc_constant) then
		call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"Condition-s constant are: equal")
	else
		call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"Condition-s constant are: not equal")
	endif
endfunction

function CompareShowAnd takes nothing returns nothing
	local conditionfunc cond1 = Condition(function SimpleJassFunc)
	local conditionfunc cond2 = Condition(function SimpleJassFunc_False)
	if And(cond1, cond2) == And(cond1, cond2) then
		call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"And-s are: equal")
	else
		call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"And-s are: not equal")
	endif
	
	if And(cond1, cond2) == And(cond2, cond1) then
		call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"And-s swapped are: equal")
	else
		call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"And-s swapped are: not equal")
	endif
endfunction

function CompareShowOr takes nothing returns nothing
	local conditionfunc cond1 = Condition(function SimpleJassFunc)
	local conditionfunc cond2 = Condition(function SimpleJassFunc_False)
	if Or(cond1, cond2) == Or(cond1, cond2) then
		call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"Or-s are: equal")
	else
		call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"Or-s are: not equal")
	endif
	
	if Or(cond1, cond2) == Or(cond2, cond1) then
		call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"Or-s swapped are: equal")
	else
		call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"Or-s swapped are: not equal")
	endif
endfunction

function CompareShowNot takes nothing returns nothing
	local conditionfunc cond1 = Condition(function SimpleJassFunc)
	if Not(cond1) == Not(cond1) then
		call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"Not-s are: equal")
	else
		call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"Not-s are: not equal")
	endif
endfunction
```

## Filter(func someFunction) returns same handles

### Lua

**No.**

- Exception to this rule: `Filter(nil) == Filter(nil)` is true, always returns same handle
- `Filter(print) ~= Filter(print)` is true, always returns different handles

### Jass

Map: "Filter-new-v1.32.10.w3m"

**Yes.**

This is true for `constant function someFunction` and ``

This code snippet is primary source, the map in this dir is just for quick tests.

```jass
function SimpleJassFunc takes nothing returns boolean
	return true
endfunction

constant function SimpleJassFunc_constant takes nothing returns boolean
	return true
endfunction

/////////
function areFiltersEqual takes nothing returns boolean
	local filterfunc f1 = Filter(function SimpleJassFunc)
	local filterfunc f2 = Filter(function SimpleJassFunc)
	local boolean retVal
	if f1 == f2 then
		set retVal = true
	else
		set retVal = false
	endif
	// no cleanup, no local variable nulling = leaks

	return retVal
endfunction
function areFiltersEqual_constant takes nothing returns boolean
	local filterfunc f1 = Filter(function SimpleJassFunc_constant )
	local filterfunc f2 = Filter(function SimpleJassFunc_constant )
	local boolean retVal
	if f1 == f2 then
		set retVal = true
	else
		set retVal = false
	endif
	// no cleanup, no local variable nulling = leaks

	return retVal
endfunction
///////////


///////////
function CompareShowFilters takes nothing returns nothing
	local string result = "default"
	if areFiltersEqual() then
		set result = "equal"
	else
		set result = "not equal"
	endif
	call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"Filters are: " + result)
endfunction

function CompareShowFilters_constant takes nothing returns nothing
	local string result = "default"
	if areFiltersEqual_constant() then
		set result = "equal"
	else
		set result = "not equal"
	endif
	call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1,"Constant Func Filters are: " + result)
endfunction
///////////
```