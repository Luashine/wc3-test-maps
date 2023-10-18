# Boolean Expression API

## Boolean Expressions returns same handles



## Filter(func someFunction) returns same handles

### Lua

**No.**

- Exception to this rule: `Filter(nil) == Filter(nil)` is true, always returns same handle
- `Filter(print) ~= Filter(print)` is true, always returns different handles

### Jass

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