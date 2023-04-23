# DisplayTextToPlayer-position

Shows how each x,y specified position is displayed as text.

The text is always printed left-aligned (additional characters continue to the right). Additional lines continue upwards (bottom-aligned).

Screenshot: see file `overlayed-screenshot.png` ([link](overlayed-screenshot.png))

```lua
DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 3, "@BOTTOM-LEFT")
DisplayTimedTextToPlayer(GetLocalPlayer(), 1, 0, 3, "@BOTTOM-RIGHT")
DisplayTimedTextToPlayer(GetLocalPlayer(), 1, 1, 3, "@TOP-RIGHT")
DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 1, 3, "@TOP-LEFT")
DisplayTimedTextToPlayer(GetLocalPlayer(), 0.5, 0.5, 3, "@CENTER")
```

## Notes

```lua
-- prints the message in white (right of the chat, above the unit avatar)
-- 
-- 60 FPS OBS Recording. I counted frames thereafter
DisplayTextToPlayer(GetLocalPlayer(), 0, 0, "Hello")
	--begins: frame 536
	--begins to fade: 761
	--gone: ~913
	
	--got: 6258

DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 3, "Hello")	
	--begins: frame 67
	--begins to fade: ~268
	--gone: 421
	
	--got: 5876ms lifetime, probably 3s life, 3s fade
	
DisplayTextToPlayer(GetLocalPlayer(), 0, 0, "@DEFAULT")
DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 4, "@3SEC")

DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 20, "xxxx")
DisplayTimedTextToPlayer(GetLocalPlayer(), .9, 0, 20, "xxxx")
DisplayTimedTextToPlayer(GetLocalPlayer(), 1, 0, 20, "xxxx")
DisplayTimedTextToPlayer(GetLocalPlayer(), 1.1, 0, 20, "xxxx")

DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0.5, 20, "xxxx")
DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0.9, 20, "xxxx")
DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 1, 20, "xxxx")
DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 1.1, 20, "xxxx")

-- positive x: max 1.0, value of 1.0 makes the text start almost in the middle of the screen
-- positive y: max 1.0, makes the text start in the upper-left half of the screen

DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 3, "@BOTTOM-LEFT")
DisplayTimedTextToPlayer(GetLocalPlayer(), 1, 0, 3, "@BOTTOM-RIGHT")
DisplayTimedTextToPlayer(GetLocalPlayer(), 1, 1, 3, "@TOP-RIGHT")
DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 1, 3, "@TOP-LEFT")
DisplayTimedTextToPlayer(GetLocalPlayer(), 0.5, 0.5, 3, "@CENTER")
```