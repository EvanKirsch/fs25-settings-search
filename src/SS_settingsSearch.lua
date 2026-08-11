-- SS_settingsSearch
--

SS_settingsSearch = {}
SS_settingsSearch.dir = g_currentModDirectory
SS_settingsSearch.modName = g_currentModName

function SS_settingsSearch:loadMap()
    InGameMenuSettingsFrame.updateButtons = Utils.appendedFunction(InGameMenuSettingsFrame.updateButtons, SS_settingsSearch.addSearchButton)
end

-- SS_TOGGLE_SEARCH callback. Not implemented yet.
function SS_settingsSearch.onToggleSearch()
    print("SS_TOGGLE_SEARCH pressed")
end

SS_settingsSearch.searchButtonInfo = {
    inputAction = InputAction.SS_TOGGLE_SEARCH,
    callback = SS_settingsSearch.onToggleSearch,
}

function SS_settingsSearch.addSearchButton(settingsFrame)
    SS_settingsSearch.searchButtonInfo.text = g_i18n:getText("input_SS_TOGGLE_SEARCH")
    table.insert(settingsFrame.menuButtonInfo, SS_settingsSearch.searchButtonInfo)
    settingsFrame:setMenuButtonInfoDirty()
end

addModEventListener(SS_settingsSearch)
