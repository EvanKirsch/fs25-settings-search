-- SS_settingsFilter
--
-- Owns applying and clearing settings search filter
--  Should be used through SS_filterDelegate
--

SS_settingsFilter = {}

function SS_settingsFilter.getAllLayouts(settingsFrame)
    return {
        settingsFrame.generalSettingsLayout,
        settingsFrame.gameSettingsLayout,
        settingsFrame.graphicSettingsLayout,
    }
end

function SS_settingsFilter.getActiveLayout(settingsFrame)
    for _, layout in ipairs(SS_settingsFilter.getAllLayouts(settingsFrame)) do
        if layout ~= nil and layout:getIsVisible() then
            return layout
        end
    end

    return nil
end

function SS_settingsFilter.applyFilter(settingsFrame, query)
    local layout = SS_settingsFilter.getActiveLayout(settingsFrame)
    if layout == nil then
        return
    end

    for _, row in pairs(layout.elements) do
        if row.name ~= "sectionHeader" then
            local matchesQuery = query == "" or SS_settingsFilter.rowMatches(row, query)
            local allowedForCurrentState = SS_rowVisibilityRules.isAllowedForCurrentState(settingsFrame, row)
            row:setVisible(matchesQuery and allowedForCurrentState)
        end
    end

    layout:invalidateLayout()
end

function SS_settingsFilter.clearFilterOnLayout(settingsFrame, layout)
    if layout == nil then
        return
    end

    for _, row in pairs(layout.elements) do
        if row.name ~= "sectionHeader" then
            row:setVisible(SS_rowVisibilityRules.isAllowedForCurrentState(settingsFrame, row))
        end
    end

    layout:invalidateLayout()
end

function SS_settingsFilter.clearActiveFilter(settingsFrame)
    SS_settingsFilter.clearFilterOnLayout(settingsFrame, SS_settingsFilter.getActiveLayout(settingsFrame))
end

function SS_settingsFilter.clearAllFilters(settingsFrame)
    for _, layout in ipairs(SS_settingsFilter.getAllLayouts(settingsFrame)) do
        SS_settingsFilter.clearFilterOnLayout(settingsFrame, layout)
    end
end

function SS_settingsFilter.rowMatches(row, query)
    local title = SS_settingsFilter.findRowTitle(row)
    if title == nil then
        return true
    end

    return title:lower():find(query:lower(), 1, true) ~= nil
end

function SS_settingsFilter.findRowTitle(element)
    if element.getText ~= nil then
        local ok, text = pcall(element.getText, element)
        if ok and text ~= nil and text ~= "" then
            return text
        end
    end

    if element.elements ~= nil then
        for _, child in pairs(element.elements) do
            local found = SS_settingsFilter.findRowTitle(child)
            if found ~= nil then
                return found
            end
        end
    end

    return nil
end
