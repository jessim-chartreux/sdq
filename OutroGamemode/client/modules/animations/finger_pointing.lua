local Pointing = false

local function IsPlayerAiming(player)
    return IsPlayerFreeAiming(player) or IsAimCamActive() or IsAimCamThirdPersonActive()
end

local function CanPlayerPoint(playerId, playerPed)
    if not DoesEntityExist(playerPed) or IsPedOnAnyBike(playerPed) or IsPlayerAiming(playerId) or IsPedFalling(playerPed) or IsPedInjured(playerPed) or IsPedInMeleeCombat(playerPed) or IsPedRagdoll(playerPed) or not IsPedHuman(playerPed) then
        return false
    end

    return true
end

local function PointingStopped()
    local playerPed = PlayerPedId()

    RequestTaskMoveNetworkStateTransition(playerPed, 'Stop')
    SetPedConfigFlag(playerPed, 36, false)
    if not IsPedInjured(playerPed) then
        ClearPedSecondaryTask(playerPed)
    end
    RemoveAnimDict("anim@mp_point")
end

local function PointingThread()
    Citizen.CreateThread(function()
        local playerId = PlayerId()
        local playerPed = PlayerPedId()

        while Pointing do
            Citizen.Wait(0)

            if not CanPlayerPoint(playerId, playerPed) then
                Pointing = false
                break
            end

            local camPitch = GetGameplayCamRelativePitch()
            if camPitch < -70.0 then
                camPitch = -70.0
            elseif camPitch > 42.0 then
                camPitch = 42.0
            end

            camPitch = (camPitch + 70.0) / 112.0

            local camHeading = GetGameplayCamRelativeHeading()
            local cosCamHeading = math.cos(camHeading)
            local sinCamHeading = math.sin(camHeading)

            if camHeading < -180.0 then
                camHeading = -180.0
            elseif camHeading > 180.0 then
                camHeading = 180.0
            end

            camHeading = (camHeading + 180.0) / 360.0
            local coords = GetOffsetFromEntityInWorldCoords(playerPed, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
            local _rayHandle, blocked = GetShapeTestResult(StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, playerPed, 7))

            SetTaskMoveNetworkSignalFloat(playerPed, 'Pitch', camPitch)
            SetTaskMoveNetworkSignalFloat(playerPed, 'Heading', (camHeading * -1.0) + 1.0)
            SetTaskMoveNetworkSignalBool(playerPed, 'isBlocked', blocked)
            SetTaskMoveNetworkSignalBool(playerPed, 'isFirstPerson', GetCamViewModeForContext(GetCamActiveViewModeContext()) == 4)
        end

        PointingStopped()
    end)
end

local function StartPointing()
    local playerPed = PlayerPedId()
    if not CanPlayerPoint(PlayerId(), playerPed) then
        return
    end

    Pointing = not Pointing

    -- If we should point and the animation was loaded, then start pointing
    if Pointing and Utils.Streaming.RequestAnimDict("anim@mp_point") then
        SetPedConfigFlag(playerPed, 36, true)
        TaskMoveNetworkByName(playerPed, 'task_mp_pointing', 0.5, false, 'anim@mp_point', 24)
        ClientModules.Misc.Animations:DeleteAttachedProps()
        -- Start thread
        PointingThread()
    end
end

Utils.KeyRegister('B', 'pointing', 'Pointer du doigt', function()
    StartPointing()
end)
