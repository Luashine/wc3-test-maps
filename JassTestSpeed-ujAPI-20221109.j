// This is a basic benchmark that measures the time
// to execute a function call of the new APIs in ujAPI.

// You need UjAPI to run this

// Results (by Unryze):

// FOR 10000 ITERATIONS:

// 10k Default function "call" in JASS: 3ms (300ns/call)
// 10k Default function call in Lua: 0.07ms (6.9ns/call)
// ==> Lua is approx. 43.5x faster

// 10k "ExecuteFunc" in Jass takes ~50ms (Lua is 724x faster)

globals
	integer execFuncCount = 0
endglobals

function IterateFuncCount takes nothing returns nothing
    set execFuncCount = execFuncCount + 1
endfunction

function TestCodeExec takes nothing returns nothing
    local integer i = 0
    local integer j = 0
    local integer timeMS = 0
    
    set someCode = function IterateFuncCount
    
    set timeMS = GetSystemTime( TIME_TYPE_MILISECOND ) // GetSystemTime -> UjAPI function | TIME_TYPE_MILISECOND UjAPI global
    loop
        exitwhen i > 10000
        call ExecuteFuncEx( "IterateFuncCount" ) // use ExecuteFunc instead, ExecuteFuncEx is the faster version of UjAPI
        set i = i + 1
    endloop
    set timeMS = GetSystemTime( TIME_TYPE_MILISECOND ) - timeMS // GetSystemTime -> UjAPI function | TIME_TYPE_MILISECOND UjAPI global
    
    call BJDebugMsg( "exec time 1: " + I2S( timeMS ) + "ms" )
    
    set timeMS = GetSystemTime( TIME_TYPE_MILISECOND  // GetSystemTime -> UjAPI function | TIME_TYPE_MILISECOND UjAPI global
    loop
        exitwhen j > 10000
        call ExecuteCode( someCode ) // use call IterateFuncCount( ) instead, ExecuteCode is a new function to execute functions via code handle.
        set j = j + 1
    endloop
    set timeMS = GetSystemTime( TIME_TYPE_MILISECOND ) - timeMS // GetSystemTime -> UjAPI function | TIME_TYPE_MILISECOND UjAPI global
    
    call BJDebugMsg( "exec time 2: " + I2S( timeMS ) + "ms" )
    
    call BJDebugMsg( "execFuncCount = " + I2S( execFuncCount ) )
endfunction