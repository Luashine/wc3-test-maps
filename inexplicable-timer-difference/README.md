# Inexplicable Timer Difference

Read the notes below. Here's the mentioned screenshot [timerdiff__Warcraft](timerdiff__Warcraft.png).

The 1 million dollar question: how on Earth does the game compute the timers that I managed to get
that weird value once and could not repeat it?

This is an ongoing problem between Classic versions and Reforged. The way timers tick changed
in one of the patches, breaking some maps that relied on long-running timers with a known passed real-time.

TODO: Add links / explain

1. The Petri Balans map (Петросянщина) relies on two details:
	- Some timer code that's supposed to finish at exactly 45 minute mark
		- well it's off by about 10-15 seconds between v1.29 and v1.32
	- The hero ought to have zero-delay attacks when positioned correctly on the penultimate arena (easy) and last (very hard).
		- People figured out this only works on certain nights -> a sign that the game's accumulated error deviates

This issue is still not resolved, the map author doesn't care and simply introduced manual offsets to work around this.
		
2. There was a forum thread on the Hiveworkshop not too long ago (Autumn 2022 - January 2023) about Get timer's elapsed time
or something being off. I replied there, his PoC consisted of clicking an ability. Seems to be the same root cause, because
testing at a high base game speed through my WGC utility, I've got totally different results and they were oscillating.


```lua
-- callback 1
cb1 = function()local t=GetExpiredTimer();print("tick, timeout:",TimerGetTimeout(t));PauseTimer(t)end
-- callback 2
cb2 = function()local t=GetExpiredTimer();print(("big rem %.18f"):format(TimerGetRemaining(T1)));PauseTimer(t)end
-- destroy timers before next run
function d()DestroyTimer(T1);DestroyTimer(T2)end

d();T2=CreateTimer(); TimerStart(T2, (2^-13), true, cb2);T1=CreateTimer(); TimerStart(T1, 1, true, cb1)


--[[
Lua in float32 mode (WC3):
print(string.format("%.16f", 2^-3*8)) -> 1.0000003576278687
print(string.format("%.16f", 1/(2^3)*8)) -> exactly 1.0

--> Prefer the "1/(2^n)" form
--> No difference in timer frequency between 2^-10 and 1/(2^10) (~1000 per sec)



Timeout 1/(2^15) = doesn't catch other remaining timer's time
Timeout 1/(2^14) = doesn't catch other remaining timer's time
Timeout 1/(2^13) = remaining as 0.9998779296875
	-> float32 exponent bits = 01111110, significand bits (1 .)11111111111100000000000
	-> can't repeat this result anymore, have it on screenshot: 22.08.21_18-55-10__Warcraft III

Timeout 1/(2^12) = remaining as 0.999755859375


Timeout 2^-12 = catches remaining as 0,999755859375 (step = 0,000244140625)
	-> float32 exponent = 01110011 (significand = 1.0)



0.0009765625 = 1/1024
0.0004882813 = 1/2048
]]
```

Warcraft 3 Reforged, timer, accuracy, inaccurate, deviation