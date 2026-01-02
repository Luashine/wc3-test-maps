### Timerdialog API tests

Code I had used (incrementally) to test the timerdialog API for jassdoc.

```
timer = CreateTimer()
tdialog = CreateTimerDialog(timer)
TimerDialogSetTitle(tdialog, "Timer1 Dialog")
TimerDialogDisplay(tdialog, true)

timer2 = CreateTimer()
tdialog2 = CreateTimerDialog(timer2)
TimerDialogDisplay(tdialog2, true)

timer3 = CreateTimer()
tdialog3 = CreateTimerDialog(timer3)
TimerDialogDisplay(tdialog3, true)

--
tdialogEmpty = CreateTimerDialog()
TimerDialogSetTitle(tdialogEmpty, "No Timer")
TimerDialogDisplay(tdialogEmpty, true)
--
-- how many characters fit?
--> 14 full-size characters like "@" (at), followed by three dots "..."
TimerDialogSetTitle(tdialog2, ("@"):rep(30))
---

TimerStart(timer, 5.0, true, function() BJDebugMsg("Tick ".. os.date() .. " and ".. os.clock()) end)
TimerStart(timer, 5.0, false, function() end)


TimerDialogSetSpeed(tdialog, 16)
TimerDialogSetRealTimeRemaining(tdialogEmpty, 30)

-- How do colors behave?
--> Answer: their value is normalized with modulo or similar
TimerDialogSetTitleColor(tdialog, 0, 255, 0, 0) -- 100% green
TimerDialogSetTitleColor(tdialog, 0, 382, 0, 0) -- 50% green
TimerDialogSetTitleColor(tdialog, 0, 510, 0, 0) -- 100% green

TimerDialogSetTitleColor(tdialog, 0, -1, 0, 0) -- 100%
TimerDialogSetTitleColor(tdialog, 0, -240, 0, 0) -- very dark
TimerDialogSetTitleColor(tdialog, 0, -255, 0, 0) -- black
TimerDialogSetTitleColor(tdialog, 0, -256, 0, 0) -- black
TimerDialogSetTitleColor(tdialog, 0, -257, 0, 0) -- 100%
TimerDialogSetTitleColor(tdialog, -257, -257, -257, 0) -- 100%
--
-- Ultrawide timer bug (SD, 1.32.10)
-- The second timer renders incorrectly if you use an ultrawide
-- 22.11.15_21-08-08__Warcraft III.png
--

-- Local player visibility:
plocal = plocal or GetLocalPlayer()
p0 = p0 or Player(0)
if p0 == plocal then TimerDialogDisplay(tdialog, true) end
--

-- @bug tdialogEmpty is shown above tdialog
tdialog = CreateTimerDialog(CreateTimer())
TimerDialogSetTitle(tdialog, "Timer1 Dialog __ 1")
TimerDialogDisplay(tdialog, true)
tdialog2 = CreateTimerDialog(CreateTimer())
TimerDialogSetTitle(tdialog2, "Timer2 Dialog")
TimerDialogDisplay(tdialog2, true)
-- Correct up to this point:
-- This is buggy:
TimerDialogDisplay(tdialog, false)
TimerDialogDisplay(tdialog2, true)
TimerDialogDisplay(tdialog, true)
-- Now tdialog will appear beneath tdialog2.
-- To correctly toggle display of all timers, toggle all off then
-- toggle them on
TimerDialogDisplay(tdialog, false)
TimerDialogDisplay(tdialogEmpty, false)
TimerDialogDisplay(tdialog, true)
TimerDialogDisplay(tdialogEmpty, true)
-- This does not trigger at all, neither for regular timers,
-- nor for timerdialog internal timers
trg_gameEvTimer = CreateTrigger()
TriggerAddAction(trg_gameEvTimer, function() print(tostring("hm")) end)
TriggerRegisterGameEvent(trg_gameEvTimer, EVENT_GAME_TIMER_EXPIRED)
```
