# Testing W3I String Parser

The W3I reads strings with a fixed length limit. This is the test.

**Methodology:**

Change the "Suggested Players" field in the .w3i file directly in the editor.
Why this one? Because it's the shortest and can be tested across all client versions.

**Steps:**

1. Extract the w3i file with MPQEditor
2. Modify it in Notepad++ / hex editor (depends on the step, verification)
3. Put the modified w3i file back in
4. Save

The base map is an official map from ROC 1.0 release.

Classic/Reforged: The Suggested Players field is shown in preview and in lobby.

**Tested in:**

- German Warcraft v1.27
- English Reforged v1.35

## 1. Control, 18 total

Test String: `SuggRegularLength`

- What: a safe short string (17 + NULL)
- Result:
	- Reforged: OK
	- Classic (v1.27): OK

## 2. Too long, 52 total

Test String: `Sugg_PlayersFieldExtraLongHowWouldYouKnow1234567890`

- What: Longer than 49 characters (51 + NULL)
- Result:
	- Reforged: Shows up as 0 player in preview, thumbnail shown, the "Suggested Players" field is completely empty. **Breaks once you try to create singleplayer lobby** (timeout). Menu breaks, cannot create lobbies or click the back to main menu button.
	- Classic (v1.27): **Crashes** at WEPlayerData once you click on the map to preview.
	
```
---------------------------
War3
---------------------------
This application has encountered a critical error:

Not enough storage is available to process this command.


Program:	X:\WC3\Playable\v1.27-de\war3.exe
Object:	WEPlayerData (.?AUWEPlayerData@@)
```


## 3. Too long, 50 total

Test String: `Sugg_PlayersFieldExtraLongHowWouldYouKnow12345678`

- What: Longer than 49 characters (49 + NULL)
- Result:
	- Reforged: Same as number 2
	- Classic (v1.27): 	Same as number 2
	
## 4. Exact fit, 49 total

Test String: `Sugg_PlayersFieldExtraLongHowWouldYouKnow1234567`

What: exactly 49 characters (48 + NULL)
Result:
	- Reforged: A blue scrollbar appears in preview to scroll the line (does not fit). Lobby creation works, **all good.**
	- Classic (v1.27): The text is cut off in lobby, but it loads correctly. **All good.**

## 5. 8-bit Codepage (Windows-1251), foreign to classic Warcraft

- Windows set to Windows-1251 for legacy applications.
- Reminder: German Warcraft v1.27

Test String: `SuggБаняFDSA1` -> `C1E0 EDFF` in a hex editor

- What: UTF-8
- Result:
	- Reforged: If you try to open the folder with this map, parsing **completely breaks** due to cyrillic 8-bit characters. The map browsing menu becomes inoperable, multiplayer list unusable (all grayed out). Must restart the game. No logs in `War3Log.txt`.
	- Classic (v1.27): The text cuts off after "Sugg" with the typical three dots "..." but it loads fine. Just the UTF-8 and other characters **not rendered**.
	
## 6. UTF-8, German

- Windows set to Windows-1251 for legacy applications.
- Reminder: German Warcraft v1.27

Test String: `SuggGähnFDSA1` -> `47C3 A468 6E` in a hex editor

- What: UTF-8
- Result:
	- Reforged: **Displayed correctly**
	- Classic (v1.27): **Displayed correctly**
