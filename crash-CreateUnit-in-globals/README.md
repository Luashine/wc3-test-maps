# crash-CreateUnit-in-globals

Tested in: 2.0.4.23556 retail, v1.21

Test map: uploaded to github here

Crash on map restart and CreateUnit in globals block

1. Launch map for the first time: OK
2. Restart mission: Crash

Culprit:
```
globals
	unit u = CreateUnit(Player(0), 'hfoo', -30, 0, 90)
endglobals
```

Only tested in Jass.

Reported by: Mimbres
