-- SS_rowVisibilityRules
--
-- Owns conditional rules for settings visibility
--

SS_rowVisibilityRules = {}

SS_rowVisibilityRules.conditionalRowVisibility = {
    multiVoiceModeBox = function() return g_currentMission.missionDynamicInfo.isMultiplayer end,
    multiVolumeVoiceBox = function() return g_currentMission.missionDynamicInfo.isMultiplayer end,
    multiVolumeVoiceInputBox = function() return g_currentMission.missionDynamicInfo.isMultiplayer end,
    checkShowMultiplayerNamesBox = function() return g_currentMission.missionDynamicInfo.isMultiplayer end,
    multiVoiceInputSensitivityBox = function() return g_currentMission.missionDynamicInfo.isMultiplayer end,
    multiRealBeaconLightBrightnessBox = function() return g_beaconLightManager:getNumOfLights() > 0 end,
    checkCameraCheckCollisionBox = function() return g_modIsLoaded.FS25_disableVehicleCameraCollision or g_isDevelopmentVersion end,
}

function SS_rowVisibilityRules.isAllowedForCurrentState(settingsFrame, row)
    for fieldName, isVisible in pairs(SS_rowVisibilityRules.conditionalRowVisibility) do
        if settingsFrame[fieldName] == row then
            return isVisible()
        end
    end

    return true
end
