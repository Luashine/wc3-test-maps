# Force API Tests

## DestroyForce

```lua
function test_DestroyForce()
	local f = CreateForce()
	local p0, p1 = Player(0), Player(1)
	
	ForceAddPlayer(f, p0)
	assert(BlzForceHasPlayer(f, p0), "expected player 0 to be in force")
	assert(BlzForceHasPlayer(f, p1) == false, "expected player 1 to NOT be in force")
	
	print("Destroying force...")
	DestroyForce(f)
	assert(BlzForceHasPlayer(f, p0) == false, "expected player 0 to NOT be in destroyed force")
	assert(BlzForceHasPlayer(f, p1) == false, "expected player 1 to NOT be in destroyed force")
	
	print("OK")
end
test_DestroyForce()
```

## ForceEnumPlayers

```lua
function test_ForForce_enumsEveryone()
	local f = CreateForce()
	local p0, p1 = Player(0), Player(1)
	local enumFilter = Filter(function()
		local p=GetFilterPlayer()
		local pId=GetPlayerId(p)
		--error()
		print(GetPlayerName(p) .." ".. tostring(pId) .." ".. tostring(pId%2))
		return pId%2==0 
	end)
	local enumFunc = function() print(GetPlayerName(GetEnumPlayer())) end
	
	ForceAddPlayer(f, p0)
	
	print("ForceEnumPlayers:")
	ForceEnumPlayers(f, enumFilter)
	
	print("ForForce:")
	ForForce(f, enumFunc)
	
	print("OK")
end
test_ForForce_enumsEveryone()
```
