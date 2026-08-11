-- SS_clearSearchHotkey
--
-- Adds the SS_CLEAR_SEARCH button
--

SS_clearSearchHotkey = {}
SS_clearSearchHotkey.onPressed = function() end -- stub defined on map load by mods main driver: SS_settingsSearch

function SS_clearSearchHotkey:loadMap()
    InGameMenuSettingsFrame.updateButtons = Utils.appendedFunction(InGameMenuSettingsFrame.updateButtons, SS_clearSearchHotkey.addButton)
end

function SS_clearSearchHotkey.addButton(settingsFrame)
    SS_clearSearchHotkey.buttonInfo.text = g_i18n:getText("input_SS_CLEAR_SEARCH")
    table.insert(settingsFrame.menuButtonInfo, SS_clearSearchHotkey.buttonInfo)
    settingsFrame:setMenuButtonInfoDirty()
end

function SS_clearSearchHotkey.onButtonClicked()
    SS_clearSearchHotkey.onPressed()
end

SS_clearSearchHotkey.buttonInfo = {
    inputAction = InputAction.SS_CLEAR_SEARCH,
    callback = SS_clearSearchHotkey.onButtonClicked,
}

addModEventListener(SS_clearSearchHotkey)
