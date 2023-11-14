# variable-length-crash

## Too long variable name

In Jass, variable length of exactly `3959` or above will crash old versions of the game when loading "war3map.j". This is true for locals and globals.

Appears to have been fixed in Reforged (1.33.0.19203). I didn't check which version.

Both war3map.j and the map are included here.

```
---------------------------
War3
---------------------------
This application has encountered a critical error:

FATAL ERROR!


Program:	C:\Playable\v1.27\war3.exe
Exception:	0xC0000005 (ACCESS_VIOLATION) at 0023:6944B104

The instruction at '0x6944B104' referenced memory at '0x0EB81000'.
The memory could not be 'written'.

Press OK to terminate the application.
---------------------------
OK   
---------------------------
```

## Other length-related tests

Looks like all of these were fixed in Reforged or have higher limits (I didn't test the upper limits again for Reforged).

Classic version used: 1.27.0.52240

```
local max OK len: 3958 
global max OK len: 3958 
function max OK len: 3958

comment length:
	v1.27: the entire line must be <=3958 in length (also counting // and Carriage-Return as characters) or it will crash
	1.32.10: all OK

extends type (v1.27):
	3958 LF ok
	3958 CRLF ok
	3959 LF crash
	3960 LF crash
	
	1.32.10: all OK
	
funcname
	3958 CRLF OK
	3958 LF OK
	3959 LF crash
	3959 CRLF crash
	
func argument name length (v1.27)
	3958 LF OK
	3959 LF crash
	
	Reforged: OK
	
Return string inline length (v1.27)
	750 OK
	1000 OK
	1020 OK
	1023 OK
	1024 other
	1025 other
	1200 other
	
	1500 other
	3000 other crash
	3950 LF other crash
	3958 LF crash
	3959 LF crash
	
	v1.32.10: 3959 LF length: OK!

Local string length inline (v1.27)
	1023 OK
	1024 Crash
	
	v1.32.10: All OK
	
Long type name and long var name:
	both var type and local variable name can be at their respective max length

Extend types (v1.27):
	code NO
	handle YES
	boolean NO
	real NO
	integer NO
	string NO
	"nothing" NO
	"void" NO
	"function" NO
```
