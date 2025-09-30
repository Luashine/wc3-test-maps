# Frame API returned handles behavior

All other code examples did fit inside jassdoc...

## BlzGetOriginFrame

```lua
-- all fallback origin frame types are --> 17
worldFrame = BlzGetOriginFrame(ConvertOriginFrameType (17), 0 )
for i = 0, 300 do
	if i ~= 17 then
		if worldFrame == BlzGetOriginFrame(ConvertOriginFrameType(i), 0 ) then
			print("Invalid Origin Frame starts at index: ", i)
			break
		end
	end
end

-- all fallback frame indeces are --> worldFrame again
for i = -1, 5 do
	print(i, BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP_BUTTON, i))
end
```
