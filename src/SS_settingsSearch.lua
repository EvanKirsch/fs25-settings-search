-- SS_settingsSearch
--
-- Main Driver for SS_settingsSearch

SS_settingsSearch = {}
SS_settingsSearch.dir = g_currentModDirectory
SS_settingsSearch.modName = g_currentModName

SS_settingsSearch.query = ""
SS_settingsSearch.settingsFrame = nil

SS_settingsSearch.conditionalRowVisibility = {
    multiVoiceModeBox = function() return g_currentMission.missionDynamicInfo.isMultiplayer end,
    multiVolumeVoiceBox = function() return g_currentMission.missionDynamicInfo.isMultiplayer end,
    multiVolumeVoiceInputBox = function() return g_currentMission.missionDynamicInfo.isMultiplayer end,
    checkShowMultiplayerNamesBox = function() return g_currentMission.missionDynamicInfo.isMultiplayer end,
    multiVoiceInputSensitivityBox = function() return g_currentMission.missionDynamicInfo.isMultiplayer end,
    multiRealBeaconLightBrightnessBox = function() return g_beaconLightManager:getNumOfLights() > 0 end,
    checkCameraCheckCollisionBox = function() return g_modIsLoaded.FS25_disableVehicleCameraCollision or g_isDevelopmentVersion end,
}

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
    SS_settingsSearch.clearFilter(settingsFrame)
    SS_settingsSearch.settingsFrame = nil
    SS_settingsSearch.query = ""
end

-- SS_TOGGLE_SEARCH callback: opens the vanilla text input dialog.
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

-- SS_CLEAR_SEARCH callback: resets the query and re-shows every row without
-- opening the search dialog.
function SS_settingsSearch.onClearSearch()
    SS_settingsSearch.query = ""

    if SS_settingsSearch.settingsFrame ~= nil then
        SS_settingsSearch.clearFilter(SS_settingsSearch.settingsFrame)
    end
end

-- TextInputDialog callback: called as target:onSearchTextEntered(text, clickOk, args).
function SS_settingsSearch:onSearchTextEntered(text, clickOk)
    if not clickOk then
        return
    end

    SS_settingsSearch.query = text or ""

    if SS_settingsSearch.settingsFrame ~= nil then
        SS_settingsSearch.applyFilter(SS_settingsSearch.settingsFrame)
    end
end

-- The settings frame has one row layout per subcategory (General, Game,
-- Graphics, ...); only one is visible at a time, so search that one.
function SS_settingsSearch.getActiveLayout(settingsFrame)
    local candidates = {
        settingsFrame.generalSettingsLayout,
        settingsFrame.gameSettingsLayout,
        settingsFrame.graphicSettingsLayout,
    }

    for _, layout in ipairs(candidates) do
        if layout ~= nil and layout:getIsVisible() then
            return layout
        end
    end

    return nil
end

-- True unless this row has a conditional-visibility rule (see
-- conditionalRowVisibility above) and that rule currently says no.
function SS_settingsSearch.isAllowedForCurrentState(settingsFrame, row)
    for fieldName, isVisible in pairs(SS_settingsSearch.conditionalRowVisibility) do
        if settingsFrame[fieldName] == row then
            return isVisible()
        end
    end

    return true
end

-- Hides every row whose title text does not contain the current query, and
-- keeps conditionally-hidden rows (see conditionalRowVisibility) hidden
-- regardless of query.
function SS_settingsSearch.applyFilter(settingsFrame)
    local layout = SS_settingsSearch.getActiveLayout(settingsFrame)
    if layout == nil then
        return
    end

    local query = SS_settingsSearch.query:lower()

    for _, row in pairs(layout.elements) do
        if row.name ~= "sectionHeader" then
            local matchesQuery = query == "" or SS_settingsSearch.rowMatches(row, query)
            local allowedForCurrentState = SS_settingsSearch.isAllowedForCurrentState(settingsFrame, row)
            row:setVisible(matchesQuery and allowedForCurrentState)
        end
    end

    layout:invalidateLayout()
end

-- Re-shows rows, still respecting each row's conditional-visibility rule.
function SS_settingsSearch.clearFilter(settingsFrame)
    local layout = SS_settingsSearch.getActiveLayout(settingsFrame)
    if layout == nil then
        return
    end

    for _, row in pairs(layout.elements) do
        if row.name ~= "sectionHeader" then
            row:setVisible(SS_settingsSearch.isAllowedForCurrentState(settingsFrame, row))
        end
    end

    layout:invalidateLayout()
end

function SS_settingsSearch.rowMatches(row, query)
    local title = SS_settingsSearch.findRowTitle(row)
    if title == nil then
        return true
    end

    return title:lower():find(query, 1, true) ~= nil
end

-- Row titles live on different child indices depending on the control type
-- (MultiTextOption, Slider, Button, etc.), so search recursively for the
-- first TextElement with non-empty text.
function SS_settingsSearch.findRowTitle(element)
    if element.getText ~= nil then
        local ok, text = pcall(element.getText, element)
        if ok and text ~= nil and text ~= "" then
            return text
        end
    end

    if element.elements ~= nil then
        for _, child in pairs(element.elements) do
            local found = SS_settingsSearch.findRowTitle(child)
            if found ~= nil then
                return found
            end
        end
    end

    return nil
end

addModEventListener(SS_settingsSearch)
