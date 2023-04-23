### DestroyMultiboard + ShowInterface(false, 0) crash

Fixed in 1.33. *Multiboard does crash in 1.30.x-1.32.10 (maybe earlier)*

**What:** Multiboard + ShowInterface crash bug.
Leaderboard and Timer Window do not crash, tested.

**Setup:** Players red and dark red in LAN. Lua code:

#### Multiboard

	mb = CreateMultiboard()
	MultiboardSetRowCount(mb, 2)
	MultiboardSetColumnCount(mb,2)
	mbi = MultiboardGetItem(mb, 0,0)
	MultiboardSetItemValue(mb11, "hey")
	MultiboardDisplay(mb)
	if GetLocalPlayer() == Player(12) then ShowInterface(false, 0.5) end
	DestroyMultiboard(mb) -- OK
	ShowInterface(true, 0) -- Player(12) crashes

#### Leaderboard

	// Does not crash in 1.32.10
	lb = CreateLeaderboard()
	LeaderboardAddItem(lb, "label", 123, Player(0))
	PlayerSetLeaderboard(Player(0), lb)
	PlayerSetLeaderboard(Player(12), lb)
	LeaderboardDisplay(lb,true)
	if GetLocalPlayer() == Player(12) then ShowInterface(false, 0.5) end
	DestroyLeaderboard(lb)
	ShowInterface(true, 0)

#### Timer Window

	// Timer Window: 
	t = CreateTimer()
	TimerStart(t, 30, true, function() print("hello from timer") end)
	tdialog = CreateTimerDialog(t)
	TimerDialogSetTitle(tdialog, "insane title")
	TimerDialogDisplay(tdialog, true)
	if GetLocalPlayer() == Player(12) then ShowInterface(false, 0.5) end
	DestroyTimerDialog(tdialog)
	ShowInterface(true, 0)

