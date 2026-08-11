-- SS_settingsSearch
--
-- Adds a live, type-to-filter search box to the in-game general settings menu
-- (InGameMenuSettingsFrame / g_inGameMenu.pageSettings). Rows whose title does
-- not match the current query are hidden until the query is cleared.
--
-- NOTE: This is a first scaffold and has not been verified against a running
-- game session yet. The row layout assumptions (gameSettingsLayout, row title
-- living at element.elements[2]) are based on how FS25_FieldLeasing extends
-- the same frame; they will need to be confirmed/adjusted in-game.

SS_settingsSearch = {}
SS_settingsSearch.dir = g_currentModDirectory
SS_settingsSearch.modName = g_currentModName

SS_settingsSearch.query = ""
SS_settingsSearch.searchLabel = nil
SS_settingsSearch.rowElements = {}

function SS_settingsSearch:loadMap()
    InGameMenuSettingsFrame.onFrameOpen = Utils.appendedFunction(InGameMenuSettingsFrame.onFrameOpen, SS_settingsSearch.onFrameOpen)
    InGameMenuSettingsFrame.onFrameClose = Utils.appendedFunction(InGameMenuSettingsFrame.onFrameClose, SS_settingsSearch.onFrameClose)
    InGameMenuSettingsFrame.keyEvent = Utils.appendedFunction(InGameMenuSettingsFrame.keyEvent, SS_settingsSearch.keyEvent)
end

function SS_settingsSearch.onFrameOpen(settingsFrame)
    print("onFrameOpen")

    if SS_settingsSearch.searchLabel == nil then
        SS_settingsSearch.createSearchLabel(settingsFrame)
    end

    SS_settingsSearch.query = ""
    SS_settingsSearch.collectRowElements(settingsFrame)
    SS_settingsSearch.applyFilter()
end

function SS_settingsSearch.onFrameClose(settingsFrame)
    print("onFrameClose")
    SS_settingsSearch.query = ""
end

-- Builds the "Search: <query>" label shown above the settings list by
-- cloning the existing section header style so it matches the vanilla UI.
function SS_settingsSearch.createSearchLabel(settingsFrame)
    local scrollPanel = settingsFrame.gameSettingsLayout
    if scrollPanel == nil then
        print("SS_settingsSearch: could not find gameSettingsLayout on InGameMenuSettingsFrame")
        return
    end

    local template = nil
    for _, element in pairs(scrollPanel.elements) do
        if element.name == "sectionHeader" then
            template = element
            break
        end
    end

    if template == nil then
        print("SS_settingsSearch: could not find sectionHeader template to clone")
        return
    end

    local searchLabel = template:clone(scrollPanel)
    searchLabel.id = nil
    searchLabel:setText(SS_settingsSearch.formatSearchText())

    -- Move the clone to the top of the layout so it always appears first.
    for i, child in ipairs(scrollPanel.elements) do
        if child == searchLabel then
            table.remove(scrollPanel.elements, i)
            table.insert(scrollPanel.elements, 1, searchLabel)
            break
        end
    end
    print("Created Search Label")

    searchLabel:setVisible(true)
    scrollPanel:invalidateLayout()

    SS_settingsSearch.searchLabel = searchLabel
end

function SS_settingsSearch.formatSearchText()
    if SS_settingsSearch.query == "" then
        return g_i18n:getText("ui_search_placeholder")
    end

    return string.format(g_i18n:getText("ui_search_label"), SS_settingsSearch.query)
end

-- Walks the settings scroll panel and records every row so we can
-- show/hide them again on future filter passes without re-scanning.
function SS_settingsSearch.collectRowElements(settingsFrame)
    local scrollPanel = settingsFrame.gameSettingsLayout
    if scrollPanel == nil then
        return
    end

    SS_settingsSearch.rowElements = {}

    for _, element in pairs(scrollPanel.elements) do
        if element ~= SS_settingsSearch.searchLabel and element.name ~= "sectionHeader" then
            table.insert(SS_settingsSearch.rowElements, element)
        end
    end
end

-- Captures typed characters while the settings frame is open and re-applies
-- the filter. Backspace trims the query, Escape/Return are left to the
-- vanilla frame handling.
function SS_settingsSearch.keyEvent(settingsFrame, unicode, sym, modifier, isDown)
    if not isDown or not settingsFrame.isOpen then
        return
    end

    local changed = false

    if sym == Input.KEY_backspace then
        if #SS_settingsSearch.query > 0 then
            SS_settingsSearch.query = SS_settingsSearch.query:sub(1, -2)
            changed = true
        end
    elseif unicode ~= nil and unicode >= 32 and unicode ~= 127 then
        SS_settingsSearch.query = SS_settingsSearch.query .. string.char(unicode)
        changed = true
    end

    if changed then
        if SS_settingsSearch.searchLabel ~= nil then
            SS_settingsSearch.searchLabel:setText(SS_settingsSearch.formatSearchText())
        end
        SS_settingsSearch.applyFilter()
    end
end

-- Hides every row whose title text does not contain the current query
-- (case-insensitive). An empty query shows everything again.
function SS_settingsSearch.applyFilter()
    local query = SS_settingsSearch.query:lower()

    for _, row in ipairs(SS_settingsSearch.rowElements) do
        local visible = query == "" or SS_settingsSearch.rowMatches(row, query)
        row:setVisible(visible)
    end

    local scrollPanel = SS_settingsSearch.searchLabel ~= nil and SS_settingsSearch.searchLabel.parent or nil
    if scrollPanel ~= nil then
        scrollPanel:invalidateLayout()
    end
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
-- first TextElement/GuiText with non-empty text.
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
