dummyLocations = dummyLocations or {}
function removeDummyLocations()
	if not dummyLocations then return end
	for i = 1, #dummyLocations do
		RemoveLocation(dummyLocations[i])
	end
end

function createDummyLocations(count, lookingForHandleId)
	assert(dummyLocations)
	for i = #dummyLocations + 1, #dummyLocations + count do
		local loc = Location(13, 37)
		dummyLocations[i] = loc
		if lookingForHandleId and lookingForHandleId == GetHandleId(loc) then
			error("Found the target handle ID! Current iteration index:".. i)
		end
	end
end
function getCurrentHandleId()
	local loc = Location(13, 37)
	local id = GetHandleId(loc)
	RemoveLocation(loc)
	return id
end

function showCurrentHandleId()
	print(getCurrentHandleId())
end

function makeAbility(index)
	local unit = CreateUnit(Player(0), FourCC("Hamg"), -1536, 0, 60)
	assert(UnitAddAbility(unit, FourCC"AHwe"))
	local ability = BlzGetUnitAbility(unit, FourCC"AHwe")
	
	makeAssertType(ability, "ability")
	
	return ability, unit
end

function makeAssertType(handle, typ)
	if type(handle) == "userdata"
	and string.format("\x25s", handle):find(typ, 1, true) then
		
		return
	else
		local errorMsg = string.format("expected type '\x25s', got type '\x25s' for handle '\x25s'",
			typ, type(handle), handle
		)
		error(errorMsg)
	end
end

function makeFormatHandle(handle)
	return string.format("\x25d=\x25s", GetHandleId(handle), handle)
end

function createEphemeronTable()
	assert(unitAbilityHolder == nil, "unitAbilityHolder still exists, remove the unit first")
	
	local mt__gc = {__gc =
		function(obj)
			local currentFreeHandle = getCurrentHandleId()
			
			print("gc says goodbye:" .. obj.text)
			print("--> Current free handle ID:" .. currentFreeHandle)
			
			step2_removeAbilityHolder()
		end
	}
	local ability, unit = makeAbility()
	local formattedHandle = makeFormatHandle(ability)
	local canaryTable = setmetatable({text=formattedHandle}, mt__gc)
	-- initially this table was a global, but I guess this makes no difference
	local ephemeronTable = {[ability] = canaryTable}
	setmetatable(ephemeronTable, {__mode = "k"})
	
	-- note: print itself may have side effects and create handles
	print("Created ability handle: ".. formattedHandle)
	unitAbilityHolder = unit
	abilityHandleId = GetHandleId(ability)
end

function removeAbilityHolder()
	assert(unitAbilityHolder, "unitAbilityHolder does not exist, you must create it")
	
	RemoveUnit(unitAbilityHolder)
	unitAbilityHolder = nil
end

function getUnitsAbilityHandle()
	local unit = unitAbilityHolder or BlzGetMouseFocusUnit()
	assert(unit, "the mouse cursor doesn't point at any unit!")
	local ability = BlzGetUnitAbility(unit, FourCC"AHwe")
	assert(ability, "unit does NOT have the 'AHwe' ability")
	print("retrieved ability handle:".. makeFormatHandle(ability))
end

function step1_startAbilityHandleTest()
	if #dummyLocations ~= 0 then	
		print("There are remaining dummy locations (".. #dummyLocations .."). The results may be skewed!")
	end
	
	removeDummyLocations()
	createDummyLocations(1000)
	
	createEphemeronTable()
	print("Waiting for the GC to kick in, please wait...")
end

function step2_removeAbilityHolder()
	removeAbilityHolder()
	removeDummyLocations()
	
	step3_deferredHandleIdSearch()
end

function step3_deferredHandleIdSearch(searchCount, when)
	searchFunction = function()
		local currentFreeHandleId = getCurrentHandleId()
		-- explanation: we had created a bunch of dummy Location handles earlier
		-- when we free them, we expect the handle IDs to be freed and reusable,
		-- thus the current handle ID watermark should be way lower than ability's handle ID
		-- v2.0.3.23101
		assert(currentFreeHandleId < abilityHandleId,
			string.format(
				"expected new handle IDs (\x25d) to be less than older ability handle ID (\x25d).",
				currentFreeHandleId, abilityHandleId
			)
		)
		local handleIdSpread = abilityHandleId - currentFreeHandleId
		local searchCount = searchCount or 5000
		assert(handleIdSpread < searchCount, string.format(
			"the handle ID spread is too high (\x25d), weird. Restart step3 yourself using a higher search count.",
			handleIdSpread
		))
		createDummyLocations(searchCount, abilityHandleId) -- this will error on purpose
		
		print("Did not find abilityHandleId. Current handle ID:".. getCurrentHandleId())
		return false
	end
	
	local delay1_sec = when or 32
	local delay2_sec = delay1_sec + 33
	
	print("Scheduling reused handle ID search in ".. delay1_sec .." seconds")
	
	TimerStart(CreateTimer(), delay1_sec, false, function()
		
		if not searchFunction() then
			print("Scheduling a final search attempt in ".. delay2_sec .." seconds")
			TimerStart(CreateTimer(), delay2_sec, false, function()
				searchFunction()
				DestroyTimer(GetExpiredTimer())
			end)
		end
		
		DestroyTimer(GetExpiredTimer())
	end)
end

--[[
to start, manually run `step1_startAbilityHandleTest()`

or to queue after game start:

reproTimer = CreateTimer()
TimerStart(reproTimer, 0.3, false, step1_startAbilityHandleTest)

]]