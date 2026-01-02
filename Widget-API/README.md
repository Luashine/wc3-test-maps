# Widget API and TriggerRegisterDeathEvent + GetTriggerWidget()

Lua, code snippet.
Used this as a test for the limited Widget API through `TriggerRegisterDeathEvent`, e.g. `GetTriggerWidget()`.
It has been included as an example in
[jassdoc for TriggerRegisterDeathEvent](https://lep.nrw/jassbot/doc/TriggerRegisterDeathEvent)

```lua
-- Create necessary widgets
u = CreateUnit(Player(0), FourCC("Hamg"), -30, 0, 90)
d = CreateDestructable(FourCC("ZTg1"), 256, 0, 90, 1, 0)
item = CreateItem(FourCC("war2"), 256, 384)

-- This is our trigger action
hasht = InitHashtable() -- for type-casting
function widgetDied()
	local w,u,d,i
	w,u,d = GetTriggerWidget(),GetTriggerUnit(),GetTriggerDestructable()
	if not u and not d then -- the widget is an item
		-- Downcasting (explicit type casting from widget to a child type)
		SaveWidgetHandle(hasht, 1, 1, w) -- put as widget
		i = LoadItemHandle(hasht, 1, 1) -- retrieve as item
	end
	print("died object (widget, unit, destr, item):", w, u, d, i)
	
	local wXpos, uXpos, dXpos, iXpos
	wXpos = GetWidgetX(w)
	if u then uXpos = GetUnitX(u) end
	if d then dXpos = GetDestructableX(d) end
	if i then iXpos = GetItemX(i) end
	print("died obj x pos (widget, unit, destr, item):", wXpos, uXpos, dXpos, iXpos)
end

-- Create and register widgets to this trigger
trig = CreateTrigger()
TriggerAddAction(trig, widgetDied)
for k,widg in pairs({u,d,item}) do TriggerRegisterDeathEvent(trig, widg) end

-- Kill widgets and observe what happens
SetWidgetLife(u, 0)
SetWidgetLife(d, 0)
SetWidgetLife(item, 0)


function unitDied()
	local w,u = GetTriggerWidget(),GetTriggerUnit()
	print("died unit (widget, unit):", w, u)
end
trigUnit = CreateTrigger()
TriggerAddAction(trigUnit, unitDied)
TriggerRegisterUnitEvent(trigUnit, u, EVENT_UNIT_DEATH)
```
