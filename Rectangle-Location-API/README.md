

For: Rect, RectFromLoc, RemoveRect, SetRect, SetRectFromLoc, MoveRectTo, MoveRectToLoc, GetRectCenterX, GetRectCenterY, GetRectMinX, GetRectMinY, GetRectMaxX, GetRectMaxY, GetWorldBounds

```lua
function showRect(r) print(r,GetRectMinX(r),GetRectMinY(r),GetRectMaxX(r),GetRectMaxY(r)) end
function checkRectCenter(r) print(GetRectCenterX(r), GetRectCenterY(r)) end


rectAll = Rect(-1000000,-1000000,1000000,1000000)
rectMin = Rect(-1000000,-1000000,-1000000,-1000000)
rectMax = Rect(1000000,1000000,1000000,1000000)
rectZero = Rect(0,0,0,0)

showRect(GetWorldBounds()) --> -4096,-4096, 4096,4096
showRect(rectAll) --> -4096,-4096, 4064,4064
showRect(rectMin) --> -4096,-4096, -4096,-4096
showRect(rectMax) --> 4064,4064, 4064,4064
showRect(rectZero) --> all 0

checkRectCenter(GetWorldBounds()) --> 0,0
checkRectCenter(rectAll) --> -16,-16
checkRectCenter(rectMin) --> -4096,-4096
checkRectCenter(rectMax) --> 4064,4064
checkRectCenter(rectZero) --> 0,0



function showLoc(l) print(l,GetLocationX(l),GetLocationY(l)) end

locMin = Location(-1000000,-1000000)
locMax = Location(1000000,1000000)
locZero = Location(0,0)
locFraction = Location(0.1337,0.42)


showLoc(locMin) --> -1000000,-1000000 etc
showLoc(locMax)
showLoc(locZero)
showLoc(locFraction)

showRect(RectFromLoc(locMin, locMax))

rectSet = Rect(-1,-1,1,1)
SetRect(rectSet, -1e5,-1e5, 1e5, 1e5)
showRect(rectSet) --> capped to map bounds and maxX/maxY are off by 32

rectSetLoc = Rect(-1,-1,1,1)
rectSetLoc_locMin = Location(-1e5, -1e5)
rectSetLoc_locMax = Location(1e5, 1e5)
SetRectFromLoc(rectSetLoc, rectSetLoc_locMin, rectSetLoc_locMax)
showRect(rectSetLoc) --> capped to map bounds and maxX/maxY are off by 32

SetRectFromLoc(rectSet, locFraction, locMax)
showRect(rectSet) --> 0.1337,0.42, 4064,4064

-- MoveRectTo
rectMove = Rect(-2,-2, 4,4)
checkRectCenter(rectMove)
MoveRectTo(rectMove, 0, 0)
checkRectCenter(rectMove)
showRect(rectMove)

-- MoveRectTo bypasses map bounds checks/restrictions
rectMoveBypass = Rect(-2,-2, 4,4)
showRect(rectMoveBypass)
MoveRectTo(rectMoveBypass, 1e6, 1e6)
showRect(rectMoveBypass)

-- Bypasses similar to above
MoveRectToLoc(rectMoveBypass, locMin)
showRect(rectMoveBypass)

-- RemoveRect
rectRemove = Rect(-1,-2, 3,4)
RemoveRect(rectRemove)
showRect(rectRemove)
```
