# :mag: SS - Farming Simulator 25 Settings Search
Adds a live search box to the in-game settings menu so you can filter down to a setting by name instead of scrolling through the whole list.

## :spiral_notepad: Implementation Details
Adds a "Search: ..." field to the top of the general settings list (`InGameMenuSettingsFrame`).

- Type while the settings menu is open to filter; matching rows stay visible, everything else is hidden
- Clearing the query shows every setting again

## :gear: Manual Install Instructions
1. Download `FS25_SettingsSearch_update.zip` from the latest release on the [releases page](https://github.com/EvanKirsch/fs25-settings-search/releases)
2. Move your downloaded copy of `FS25_SettingsSearch.zip` to `Documents\My Games\Farming Simulator 2025\mods`

## :hammer_and_wrench: Manual Build Instructions
`git archive -o FS25_SettingsSearch.zip HEAD`

## :rocket: Release
Create and push a tag on the desired release commit following the pattern `[0-9]+.[0-9]+.[0-9]+.[0-9]+`

```bash
git tag <tagname>
git push origin <tagname>
```
