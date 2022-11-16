# (Bug) BlzHideCinematicPanels shifts camera

Version: 1.32.10, Lua

```lua
function printCurrentCamera()
	print("Target dist: ".. GetCameraField(CAMERA_FIELD_TARGET_DISTANCE))
	print("FARZ: ".. GetCameraField(CAMERA_FIELD_FARZ))
	print("ZOFFSET: ".. GetCameraField(CAMERA_FIELD_ZOFFSET))
	print("Angle of Attack: ".. bj_RADTODEG * GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK))
	print("ROLL: ".. bj_RADTODEG * GetCameraField(CAMERA_FIELD_ROLL))
	print("Rotation: ".. bj_RADTODEG * GetCameraField(CAMERA_FIELD_ROTATION))
	print("Local Pitch/Yaw/Roll: "
	.. bj_RADTODEG * GetCameraField(CAMERA_FIELD_LOCAL_PITCH) .. " / " 
	.. bj_RADTODEG * GetCameraField(CAMERA_FIELD_LOCAL_YAW) .." / "
	.. bj_RADTODEG * GetCameraField(CAMERA_FIELD_LOCAL_ROLL))
	print("Target pos X/Y : ".. GetCameraTargetPositionX(), GetCameraTargetPositionY())
end

-- enter these separately
printCurrentCamera()
BlzHideCinematicPanels(true)
printCurrentCamera()
-- Now the rendered view has moved, but the camera pos is still the same!
-- turn off:
BlzHideCinematicPanels(false)
```
