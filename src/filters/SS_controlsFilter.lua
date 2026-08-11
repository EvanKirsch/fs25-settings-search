-- SS_controlsFilter
--
-- Owns applying and clearing controls search filter
--  Should be used through SS_filterDelegate
--

SS_controlsFilter = {}
SS_controlsFilter.originalControlsData = nil

function SS_controlsFilter:loadMap()
    InGameMenuSettingsFrame.assignDeviceTableData = Utils.appendedFunction(InGameMenuSettingsFrame.assignDeviceTableData, SS_controlsFilter.onControlsDataAssigned)
end

function SS_controlsFilter.onControlsDataAssigned(settingsFrame)
    SS_controlsFilter.originalControlsData = settingsFrame.controlsData
    SS_controlsFilter.applyFilter(settingsFrame, SS_settingsSearch.query)
end

function SS_controlsFilter.applyFilter(settingsFrame, query)
    if SS_controlsFilter.originalControlsData == nil then
        return
    end

    query = (query or ""):lower()

    if query == "" then
        settingsFrame.controlsData = SS_controlsFilter.originalControlsData
        settingsFrame.controlsList:reloadData()
        return
    end

    local filtered = {}

    for _, section in ipairs(SS_controlsFilter.originalControlsData) do
        local filteredSection = { name = section.name }

        for _, actionBinding in ipairs(section) do
            if actionBinding.displayName ~= nil and actionBinding.displayName:lower():find(query, 1, true) ~= nil then
                table.insert(filteredSection, actionBinding)
            end
        end

        if #filteredSection > 0 then
            table.insert(filtered, filteredSection)
        end
    end

    settingsFrame.controlsData = filtered
    settingsFrame.controlsList:reloadData()
end

function SS_controlsFilter.clearFilter(settingsFrame)
    SS_controlsFilter.applyFilter(settingsFrame, "")
end

addModEventListener(SS_controlsFilter)
