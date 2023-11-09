# variable-length-crash

In Jass, variable length of exactly `3959` or above will crash old versions of the game when loading "war3map.j". This is true for locals and globals.

Appears to have been fixed in Reforged (1.33.0.19203). I didn't check which version.

Both war3map.j and the map are included here.

```
---------------------------
War3
---------------------------
This application has encountered a critical error:

FATAL ERROR!


Program:	C:\WC3\v1.27-de\war3.exe
Exception:	0xC0000005 (ACCESS_VIOLATION) at 0023:6944B104

The instruction at '0x6944B104' referenced memory at '0x0EB81000'.
The memory could not be 'written'.

Press OK to terminate the application.
---------------------------
OK   
---------------------------
```