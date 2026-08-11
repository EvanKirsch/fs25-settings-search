-- SS_settingsSearch
--

SS_settingsSearch = {}
SS_settingsSearch.dir = g_currentModDirectory
SS_settingsSearch.modName = g_currentModName

SS_settingsSearch.query = ""
SS_settingsSearch.settingsFrame = nil

function SS_settingsSearch:loadMap()
    InGameMenuSettingsFrame.updateButtons = Utils.appendedFunction(InGameMenuSettingsFrame.updateButtons, SS_settingsSearch.addSearchButton)
    InGameMenuSettingsFrame.onFrameOpen = Utils.appendedFunction(InGameMenuSettingsFrame.onFrameOpen, SS_settingsSearch.onFrameOpen)
    InGameMenuSettingsFrame.onFrameClose = Utils.appendedFunction(InGameMenuSettingsFrame.onFrameClose, SS_settingsSearch.onFrameClose)
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

function SS_settingsSearch.addSearchButton(settingsFrame)
    SS_settingsSearch.searchButtonInfo.text = g_i18n:getText("input_SS_TOGGLE_SEARCH")
    table.insert(settingsFrame.menuButtonInfo, SS_settingsSearch.searchButtonInfo)
    settingsFrame:setMenuButtonInfoDirty()
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

SS_settingsSearch.searchButtonInfo = {
    inputAction = InputAction.SS_TOGGLE_SEARCH,
    callback = SS_settingsSearch.onToggleSearch,
}

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

-- Hides every row whose title text does not contain the current query
-- (case-insensitive). An empty query shows everything again.
function SS_settingsSearch.applyFilter(settingsFrame)
    local layout = SS_settingsSearch.getActiveLayout(settingsFrame)
    if layout == nil then
        return
    end

    local query = SS_settingsSearch.query:lower()

    for _, row in pairs(layout.elements) do
        if row.name ~= "sectionHeader" then
            local visible = query == "" or SS_settingsSearch.rowMatches(row, query)
            row:setVisible(visible)
        end
    end

    layout:invalidateLayout()
end

function SS_settingsSearch.clearFilter(settingsFrame)
    local layout = SS_settingsSearch.getActiveLayout(settingsFrame)
    if layout == nil then
        return
    end

    for _, row in pairs(layout.elements) do
        row:setVisible(true)
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
