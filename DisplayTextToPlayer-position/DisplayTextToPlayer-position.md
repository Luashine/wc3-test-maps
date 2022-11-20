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