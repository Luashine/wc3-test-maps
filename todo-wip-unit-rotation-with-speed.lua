function printFacing2(uf1, uf2)
	print(GetUnitFacing(uf1), GetUnitFacing(uf2))
end

uf1 = CreateUnit(Player(0), FourCC("hfoo"), -128, 0, 90)
uf2 = CreateUnit(Player(0), FourCC("hfoo"), 128, 0, 90)

printFacing2(uf1, uf2) --> 89.99999, 89.99999
SetUnitFacing(uf1, -90);BlzSetUnitFacingEx(uf2,-90);printFacing2(uf1, uf2)
--> 
-- delayed:
printFacing2(uf1, uf2)



printFacing2(uf1, uf2)
SetUnitFacing(uf1, -90)
SetUnitFacingTimed(uf1, 0, -GetUnitFacing(uf1));printFacing2(uf1, uf2)

SetUnitFacing(uf1, 90)
SetUnitFacingTimed(uf2, 90, 1) --> final angle = 96.91184 (expected 90)

SetUnitFacingTimed(uf2, 90, math.pi)

SetUnitFacing(uf1, 90)
SetUnitFacingTimed(uf2, 90, 0.5)


do
	local unit = CreateUnit(Player(0), FourCC("hfoo"), -128, 0, 90)
	local t = CreateTimer()
	local trig = CreateTrigger()
	
	local dataAngle = {[1] = {time=0, angle=GetUnitFacing(unit)}}
	local timerCountLimit = 110 -- stop if angle didnt change in N ticks
	local timerCount = 0
	
	local func = function()
		local lastAngle = dataAngle[#dataAngle].angle
		local curAngle = GetUnitFacing(unit)
		if curAngle == lastAngle then
			timerCount = timerCount+1
		else
			timerCount = 0
			dataAngle[#dataAngle+1] = {time = os.clock(), angle=curAngle}
		end
		if timerCount > timerCountLimit then
			-- destroy timer and log everything
		end
	end
end