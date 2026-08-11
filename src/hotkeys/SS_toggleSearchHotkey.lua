-- SS_toggleSearchHotkey
--
-- Adds the SS_TOGGLE_SEARCH button
-- the settings menu's bottom button row.

SS_toggleSearchHotkey = {}
SS_toggleSearchHotkey.onPressed = function() end -- stub defined on map load by mods main driver: SS_settingsSearch

function SS_toggleSearchHotkey:loadMap()
    InGameMenuSettingsFrame.updateButtons = Utils.appendedFunction(InGameMenuSettingsFrame.updateButtons, SS_toggleSearchHotkey.addButton)
end

function SS_toggleSearchHotkey.addButton(settingsFrame)
    SS_toggleSearchHotkey.buttonInfo.text = g_i18n:getText("input_SS_TOGGLE_SEARCH")
    table.insert(settingsFrame.menuButtonInfo, SS_toggleSearchHotkey.buttonInfo)
    settingsFrame:setMenuButtonInfoDirty()
end

function SS_toggleSearchHotkey.onButtonClicked()
    SS_toggleSearchHotkey.onPressed()
end

SS_toggleSearchHotkey.buttonInfo = {
    inputAction = InputAction.SS_TOGGLE_SEARCH,
    callback = SS_toggleSearchHotkey.onButtonClicked,
}

addModEventListener(SS_toggleSearchHotkey)
