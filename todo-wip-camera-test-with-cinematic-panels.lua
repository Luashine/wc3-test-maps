print("Camera Eye X/Y/Z: ", GetCameraEyePositionX(), GetCameraEyePositionY(), GetCameraEyePositionZ())

print("Camera Target X/Y/Z: ", GetCameraTargetPositionX(), GetCameraTargetPositionY(), GetCameraTargetPositionZ())

print("Camera Bound MinX,Y / MaxX,Y: ", GetCameraBoundMinX(), GetCameraBoundMinY(), GetCameraBoundMaxX(), GetCameraBoundMaxY())


BlzHideCinematicPanels(true)

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
-----------------------------

uf = CreateUnit(Player(0), FourCC("hfoo"), -30, 0, 90)
uh = CreateUnit(Player(0), FourCC("Hamg"), -30, 0, 90)

