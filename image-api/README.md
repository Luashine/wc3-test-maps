# Image API

v2.0.3.22988

## Create an image grid

```lua
do -- covers map in AoE indicators
	math.randomseed(42)
	local counter = 0
	local posZ = 0
	for x = -2048, 2048, 256 do
		for y = -2048, 2048, 256 do
			counter = counter + 1
			--posZ = posZ + 8
			local key = "img_".. counter
			if _G[key] then
				DestroyImage(_G[key])
			end
			--goto cont -- uncomment to destroy images instead
			local img = CreateImage([[ReplaceableTextures\Selection\SpellAreaOfEffect.blp]], 256,256,0, x,y,posZ, 0,0,0, 1)
			_G[key] = img
			SetImageRenderAlways(img, true)
			--SetImageConstantHeight(img, math.random(1,10) <= 3 and true or false, 64)
			SetImageColor(img, 255,255,255,255)
			SetImageAboveWater(img, true, true)
			print(counter, key, GetHandleId(img), img)
			::cont::
		end
	end
end
```

## Manual testing with 3 images

```lua
imgX, imgY = 0,0
myTempLoc = Location(imgX, imgY)
imgZ = GetLocationZ(myTempLoc)
RemoveLocation(myTempLoc)

imgAbove = CreateImage([[ReplaceableTextures\Selection\SpellAreaOfEffect.blp]],  192,192,0, imgX-100,imgY,imgZ, 0,0,0, 2)
imgGround = CreateImage([[ReplaceableTextures\Selection\SpellAreaOfEffect.blp]], 192,192,0, imgX,    imgY,imgZ, 0,0,0, 2)
imgBelow = CreateImage([[ReplaceableTextures\Selection\SpellAreaOfEffect.blp]],  192,192,0, imgX+100,imgY,imgZ, 0,0,0, 2)

SetImageColor(imgAbove, 255,64,64, 255)
SetImageColor(imgGround, 64,255,64, 255)
SetImageColor(imgBelow, 64,64,255, 255)

SetImageRenderAlways(imgAbove, true)
SetImageRenderAlways(imgGround, true)
SetImageRenderAlways(imgBelow, true)

SetImageConstantHeight(imgAbove, true, 128)
SetImageConstantHeight(imgGround, false, 0)
SetImageConstantHeight(imgBelow, true, -128)
-- Use this to show the image below terrain level
BlzShowTerrain(false)

-- Run this later to destroy all images
DestroyImage(imgAbove)
DestroyImage(imgGround)
DestroyImage(imgBelow)
```
