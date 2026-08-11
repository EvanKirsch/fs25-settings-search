# :mag: SS - Farming Simulator 25 Settings Search
Adds a search box to the settings menu so you can filter down to a setting - or a key binding - by name instead of scrolling through the whole list.

![screenshot 1](https://github.com/EvanKirsch/fs25-settings-search/blob/master/screenshots/Screenshot_1.png)

## :spiral_notepad: Implementation Details
Adds a search hotkey to the settings menu.

- **S** : Opens a search box. Type a name and confirm to filter the current tab's list down to matching rows.
- **R** : Clears the current search and shows every row again.

Both hotkeys are rebindable in the game's settings.

Search works on the **General**, **Game**, and **Graphics** tabs (filters by setting name) and the **Controls** tab (filters by action name). The **Server Settings** and **Devices** tabs aren't searchable yet.

## :gear: Manual Install Instructions
1. Download `FS25_SettingsSearch.zip` from the latest release on the [releases page](https://github.com/EvanKirsch/fs25-settings-search/releases)
2. Move your downloaded copy of `FS25_SettingsSearch.zip` to `Documents\My Games\Farming Simulator 2025\mods`

## :hammer_and_wrench: Manual Build Instructions
`git archive -o FS25_SettingsSearch.zip HEAD`

## :rocket: Release
Create and push a tag on the desired release commit following the pattern `[0-9]+.[0-9]+.[0-9]+.[0-9]+`

```bash
git tag <tagname>
git push origin <tagname>
```
