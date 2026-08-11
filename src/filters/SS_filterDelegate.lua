-- SS_filterDelegate
--
-- Owns delgating to proper filter class given the current settings frame
--

SS_filterDelegate = {}

function SS_filterDelegate.isControlsActive(settingsFrame)
    return settingsFrame.controlsList ~= nil and settingsFrame.controlsList:getIsVisible()
end

function SS_filterDelegate.applyFilter(settingsFrame, query)
    if SS_filterDelegate.isControlsActive(settingsFrame) then
        SS_controlsFilter.applyFilter(settingsFrame, query)
    else
        SS_settingsFilter.applyFilter(settingsFrame, query)
    end
end

function SS_filterDelegate.clearActiveFilter(settingsFrame)
    if SS_filterDelegate.isControlsActive(settingsFrame) then
        SS_controlsFilter.clearFilter(settingsFrame)
    else
        SS_settingsFilter.clearActiveFilter(settingsFrame)
    end
end

function SS_filterDelegate.clearAllFilters(settingsFrame)
    SS_settingsFilter.clearAllFilters(settingsFrame)
    SS_controlsFilter.clearFilter(settingsFrame)
end
