-- SS_settingsSearch
--
-- Main Driver for SS_settingsSearch.
-- Owns callbacks for hotkeys and events
--

SS_settingsSearch = {}
SS_settingsSearch.dir = g_currentModDirectory
SS_settingsSearch.modName = g_currentModName

SS_settingsSearch.query = ""
SS_settingsSearch.settingsFrame = nil

function SS_settingsSearch:loadMap()
    InGameMenuSettingsFrame.onFrameOpen = Utils.appendedFunction(InGameMenuSettingsFrame.onFrameOpen, SS_settingsSearch.onFrameOpen)
    InGameMenuSettingsFrame.onFrameClose = Utils.appendedFunction(InGameMenuSettingsFrame.onFrameClose, SS_settingsSearch.onFrameClose)
    SS_clearSearchHotkey.onPressed = SS_settingsSearch.onClearSearch
    SS_toggleSearchHotkey.onPressed = SS_settingsSearch.onToggleSearch
end

function SS_settingsSearch.onFrameOpen(settingsFrame)
    SS_settingsSearch.settingsFrame = settingsFrame
    SS_settingsSearch.query = ""
end

function SS_settingsSearch.onFrameClose(settingsFrame)
    SS_settingsFilter.clearAllFilters(settingsFrame)
    SS_settingsSearch.query = ""
    SS_settingsSearch.settingsFrame = nil
end

-- SS_TOGGLE_SEARCH callback
function SS_settingsSearch.onToggleSearch()
    TextInputDialog.show(
        SS_settingsSearch.onSearchTextEntered,
        SS_settingsSearch,
        SS_settingsSearch.query,
        g_i18n:getText("ui_search_dialogTitle"),
        nil,
        32
    )
end

-- SS_CLEAR_SEARCH callback
function SS_settingsSearch.onClearSearch()
    SS_settingsSearch.query = ""

    if SS_settingsSearch.settingsFrame ~= nil then
        SS_settingsFilter.clearActiveFilter(SS_settingsSearch.settingsFrame)
    end
end

-- TextInputDialog callback
function SS_settingsSearch:onSearchTextEntered(text, clickOk)
    if not clickOk then
        return
    end

    SS_settingsSearch.query = text or ""

    if SS_settingsSearch.settingsFrame ~= nil then
        SS_settingsFilter.applyFilter(SS_settingsSearch.settingsFrame, SS_settingsSearch.query)
    end
end

addModEventListener(SS_settingsSearch)
