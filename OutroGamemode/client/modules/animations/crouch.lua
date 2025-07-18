local IsProne = false
local isCrouched = false
local isCrawling = false
local inAction = false
local proneType = "onfront"
local lastKeyPress = 0

local function CanPlayerCrouchCrawl(playerPed)
    if not IsPedOnFoot(playerPed) or IsPedJumping(playerPed) or IsPedFalling(playerPed) or IsPedInjured(playerPed) or IsPedInMeleeCombat(playerPed) or IsPedRagdoll(playerPed) then
        return false
    end

    return true
end

local function IsPlayerAiming(player)
    return (IsPlayerFreeAiming(player) or IsAimCamActive() or IsAimCamThirdPersonActive()) and tonumber(GetSelectedPedWeapon(player)) ~= tonumber(GetHashKey("WEAPON_UNARMED"))
end

local function PlayAnimOnce(playerPed, animDict, animName, blendInSpeed, blendOutSpeed, duration, startTime)
    Utils.Streaming.RequestAnimDict(animDict)
    TaskPlayAnim(playerPed, animDict, animName, blendInSpeed or 2.0, blendOutSpeed or 2.0, duration or -1, 0, startTime or 0.0, false, false, false)
    RemoveAnimDict(animDict)
end

local function ChangeHeadingSmooth(playerPed, amount, time)
    local times = math.abs(amount)
    local test = amount / times
    local wait = time / times

    for _i = 1, times do
        Citizen.Wait(wait)
        SetEntityHeading(playerPed, GetEntityHeading(playerPed) + test)
    end
end

-- Crouching --
local function ResetCrouch()
    local playerPed = PlayerPedId()

    ResetPedStrafeClipset(playerPed)
    ResetPedWeaponMovementClipset(playerPed)
    SetPedMaxMoveBlendRatio(playerPed, 1.0)
    SetPedCanPlayAmbientAnims(playerPed, true)

    -- Applies the previous walk style (or resets to default if non had been set)
    ClientModules.Misc.Animations:ResetClipset(false)
    RemoveAnimSet("move_ped_crouched")
end

local function CrouchThread()
    Citizen.CreateThread(function()
        local playerId = PlayerId()

        while isCrouched do
            local playerPed = PlayerPedId()

            -- Checks if the player is falling, in vehicle, dead etc.
            if not CanPlayerCrouchCrawl(playerPed) then
                isCrouched = false
                break
            end

            -- Limit the speed that the player can walk when aiming
            if IsPlayerAiming(playerId) then
                SetPedMaxMoveBlendRatio(playerPed, 0.15)
            end

            -- This blocks the ped from standing up and playing idle anims (this needs to be looped)
            SetPedCanPlayAmbientAnims(playerPed, false)

            -- Disables "INPUT_DUCK" and blocks action mode
            DisableControlAction(0, 36, true)
            if IsPedUsingActionMode(playerPed) == 1 then
                SetPedUsingActionMode(playerPed, false, -1, "DEFAULT_ACTION")
            end

            -- Disable first person
            DisableFirstPersonCamThisFrame()
            Citizen.Wait(0)
        end

        -- Reset walk style and ped variables
        ResetCrouch()
    end)
end

local function StartCrouch()
    isCrouched = true
    Utils.Streaming.RequestAnimSet("move_ped_crouched")
    local playerPed = PlayerPedId()

    -- Force leave stealth mode
    if GetPedStealthMovement(playerPed) == true then
        SetPedStealthMovement(playerPed, false, "DEFAULT_ACTION")
        Citizen.Wait(100)
    end

    -- Force leave first person view
    if GetFollowPedCamViewMode() == 4 then
        SetFollowPedCamViewMode(0) -- THIRD_PERSON_NEAR
    end

    SetPedMovementClipset(playerPed, "move_ped_crouched", 0.6)
    SetPedStrafeClipset(playerPed, "move_ped_crouched_strafing")

    CrouchThread()
end

local function AttemptCrouch(playerPed)
    if CanPlayerCrouchCrawl(playerPed) and IsPedHuman(playerPed) then
        StartCrouch()
        return true
    else
        return false
    end
end

---Disables a control until it's key has been released
---@param padIndex integer
---@param control integer
local function DisableControlUntilReleased(padIndex, control)
    Citizen.CreateThread(function()
        while IsDisabledControlPressed(padIndex, control) do
            DisableControlAction(padIndex, control, true)
            Citizen.Wait(0)
        end
    end)
end

-- Called when the crouch key is pressed
local function CrouchKeyPressed()
    -- If we already are doing something, then don't continue
    if inAction then
        return
    end

    -- If crouched then stop crouching
    if isCrouched then
        isCrouched = false
        local crouchKey = GetControlInstructionalButton(0, `+crouch` | 0x80000000, false)
        local lookBehindKey = GetControlInstructionalButton(0, 26, false)

        -- Disable look behind if the crouch and look behind keys are the same
        if crouchKey == lookBehindKey then
            DisableControlUntilReleased(0, 26) -- INPUT_LOOK_BEHIND
        end

        return
    end

    -- Get the player ped
    local playerPed = PlayerPedId()

    -- Check if we can actually crouch and check if we are an animal
    if not CanPlayerCrouchCrawl(playerPed) or not IsPedHuman(playerPed) then
        return
    end

    -- Get +crouch, INPUT_DUCK and INPUT_LOOK_BEHIND keys
    local crouchKey = GetControlInstructionalButton(0, `+crouch` | 0x80000000, false)
    local duckKey = GetControlInstructionalButton(0, 36, false)
    local lookBehindKey = GetControlInstructionalButton(0, 26, false)

    -- Disable look behind if the crouch and look behind keys are the same
    if crouchKey == lookBehindKey then
        DisableControlUntilReleased(0, 26) -- INPUT_LOOK_BEHIND
    end

    -- If they are the same and we aren't prone, then check if we are in stealth mode and how long ago the last button press was.
    if crouchKey == duckKey and not IsProne then
        local timer = GetGameTimer()

        -- If we are in stealth mode and we have already pressed the button in the last second
        if GetPedStealthMovement(playerPed) == true and timer - lastKeyPress < 1000 then
            DisableControlAction(0, 36, true) -- Disable INPUT_DUCK this frame
            lastKeyPress = 0
        else
            lastKeyPress = timer
            return
        end
    end

    -- Start to crouch
    StartCrouch()

    -- If we are prone play an animation from prone to crouch
    if IsProne then
        inAction = true
        IsProne = false
        PlayAnimOnce(playerPed, "get_up@directional@transition@prone_to_knees@crawl", "front", nil, nil, 780)
        Citizen.Wait(780)
        inAction = false
    end
end


-- Crawling --
local function ShouldPlayerDiveToCrawl(playerPed)
    if IsPedRunning(playerPed) or IsPedSprinting(playerPed) then
        return true
    end

    return false
end

local function PlayIdleCrawlAnim(playerPed, heading, blendInSpeed)
    local playerCoords = GetEntityCoords(playerPed, true)
    TaskPlayAnimAdvanced(playerPed, "move_crawl", proneType.."_fwd", playerCoords.x, playerCoords.y, playerCoords.z, 0.0, 0.0, heading or GetEntityHeading(playerPed), blendInSpeed or 2.0, 2.0, -1, 2, 1.0, false, false)
end

local function PlayExitCrawlAnims(forceEnd)
    if not forceEnd then
        inAction = true
        local playerPed = PlayerPedId()

        if proneType == "onfront" then
            PlayAnimOnce(playerPed, "get_up@directional@transition@prone_to_knees@crawl", "front", nil, nil, 780)

            -- Only stand fully up if we are not crouching
            if not isCrouched then
                Citizen.Wait(780)
                PlayAnimOnce(playerPed, "get_up@directional@movement@from_knees@standard", "getup_l_0", nil, nil, 1300)
            end
        else
            PlayAnimOnce(playerPed, "get_up@directional@transition@prone_to_seated@crawl", "back", 16.0, nil, 950)

            -- Only stand fully up if we are not crouching
            if not isCrouched then
                Citizen.Wait(950)
                PlayAnimOnce(playerPed, "get_up@directional@movement@from_seated@standard", "get_up_l_0", nil, nil, 1300)
            end
        end
    end
end

local function Crawl(playerPed, type, direction)
    isCrawling = true

    TaskPlayAnim(playerPed, "move_crawl", type.."_"..direction, 8.0, -8.0, -1, 2, 0.0, false, false, false)

    local time = {
        ["onfront"] = {
            ["fwd"] = 820,
            ["bwd"] = 990
        },
        ["onback"] = {
            ["fwd"] = 1200,
            ["bwd"] = 1200
        }
    }

    SetTimeout(time[type][direction], function()
        isCrawling = false
    end)
end

local function CrawlFlip(playerPed)
    inAction = true
    local heading = GetEntityHeading(playerPed)

    if proneType == "onfront" then
        proneType = "onback"

        PlayAnimOnce(playerPed, "get_up@directional_sweep@combat@pistol@front", "front_to_prone", 2.0)
        ChangeHeadingSmooth(playerPed, -18.0, 3600)
    else
        proneType = "onfront"

        PlayAnimOnce(playerPed, "move_crawlprone2crawlfront", "back", 2.0, nil, -1)
        ChangeHeadingSmooth(playerPed, 12.0, 1700)
    end

    PlayIdleCrawlAnim(playerPed, heading + 180.0)
    Citizen.Wait(400)
    inAction = false
end

local function CrawlThread()
    Citizen.CreateThread(function()
        Citizen.Wait(400)

        local forceEnd = false

        while IsProne do
            local playerPed = PlayerPedId()

            -- Checks if the player is falling, in vehicle, dead etc.
            if not CanPlayerCrouchCrawl(playerPed) or IsEntityInWater(playerPed) then
                ClearPedTasks(playerPed)
                IsProne = false
                forceEnd = true
                break
            end

            -- Handles forwad/backward movement
            local forward, backwards = IsControlPressed(0, 32), IsControlPressed(0, 33) -- INPUT_MOVE_UP_ONLY, INPUT_MOVE_DOWN_ONLY
            if not isCrawling then
                if forward then -- Forward
                    Crawl(playerPed, proneType, "fwd")
                elseif backwards then -- Back
                    Crawl(playerPed, proneType, "bwd")
                end
            end

            -- Moving left/right
            if IsControlPressed(0, 34) then -- INPUT_MOVE_LEFT_ONLY
                if isCrawling then
                    local headingDiff = forward and 1.0 or -1.0
                    SetEntityHeading(playerPed, GetEntityHeading(playerPed) + headingDiff)
                else
                    inAction = true
                    if proneType == "onfront" then
                        local playerCoords = GetEntityCoords(playerPed, true)
                        TaskPlayAnimAdvanced(playerPed, "move_crawlprone2crawlfront", "left", playerCoords.x, playerCoords.y, playerCoords.z, 0.0, 0.0, GetEntityHeading(playerPed), 2.0, 2.0, -1, 2, 0.1, false, false)
                        ChangeHeadingSmooth(playerPed, -10.0, 300)
                        Citizen.Wait(700)
                    else
                        PlayAnimOnce(playerPed, "get_up@directional_sweep@combat@pistol@left", "left_to_prone")
                        ChangeHeadingSmooth(playerPed, 25.0, 400)
                        PlayIdleCrawlAnim(playerPed)
                        Citizen.Wait(600)
                    end
                    inAction = false
                end
            elseif IsControlPressed(0, 35) then -- INPUT_MOVE_RIGHT_ONLY
                if isCrawling then
                    local headingDiff = backwards and 1.0 or -1.0
                    SetEntityHeading(playerPed, GetEntityHeading(playerPed) + headingDiff)
                else
                    inAction = true
                    if proneType == "onfront" then
                        local playerCoords = GetEntityCoords(playerPed, true)
                        TaskPlayAnimAdvanced(playerPed, "move_crawlprone2crawlfront", "right", playerCoords.x, playerCoords.y, playerCoords.z, 0.0, 0.0, GetEntityHeading(playerPed), 2.0, 2.0, -1, 2, 0.1, false, false)
                        ChangeHeadingSmooth(playerPed, 10.0, 300)
                        Citizen.Wait(700)
                    else
                        PlayAnimOnce(playerPed, "get_up@directional_sweep@combat@pistol@right", "right_to_prone")
                        ChangeHeadingSmooth(playerPed, -25.0, 400)
                        PlayIdleCrawlAnim(playerPed)
                        Citizen.Wait(600)
                    end
                    inAction = false
                end
            end

            -- Flipping around
            if not isCrawling then
                if IsControlPressed(0, 22) then -- INPUT_JUMP
                    CrawlFlip(playerPed)
                end
            end

            Citizen.Wait(0)
        end

        -- If the crawling wasn't forcefully ended, then play the get up animations
        PlayExitCrawlAnims(forceEnd)

        -- Reset variabels
        isCrawling = false
        inAction = false
        proneType = "onfront"
        SetPedConfigFlag(PlayerPedId(), 48, false) -- CPED_CONFIG_FLAG_BlockWeaponSwitching

        -- Unload animation dictionaries
        RemoveAnimDict("move_crawl")
        RemoveAnimDict("move_crawlprone2crawlfront")
    end)
end

local function CrawlKeyPressed()
    -- If we already are doing something, then don't continue
    if inAction then
        return
    end

    -- Don't start/stop to crawl if we are in the pause menu
    if IsPauseMenuActive() then
        return
    end

    -- If already prone, then stop
    if IsProne then
        IsProne = false
        return
    end

    -- If we are crouching we should stop that first
    local wasCrouched = false
    if isCrouched then
        isCrouched = false
        wasCrouched = true
    end

    local playerPed = PlayerPedId()
    if not CanPlayerCrouchCrawl(playerPed) or IsEntityInWater(playerPed) or not IsPedHuman(playerPed) then
        return
    end

    inAction = true

    IsProne = true
    SetPedConfigFlag(playerPed, 48, true) -- CPED_CONFIG_FLAG_BlockWeaponSwitching

    -- Force leave stealth mode
    if GetPedStealthMovement(playerPed) == true then
        SetPedStealthMovement(playerPed, false, "DEFAULT_ACTION")
        Citizen.Wait(100)
    end

    -- Load animations that the crawling is going to use
    Utils.Streaming.RequestAnimDict("move_crawl")
    Utils.Streaming.RequestAnimDict("move_crawlprone2crawlfront")

    if ShouldPlayerDiveToCrawl(playerPed) then
        PlayAnimOnce(playerPed, "explosions", "react_blown_forwards", nil, 3.0)
        Citizen.Wait(1100)
    elseif wasCrouched then
        PlayAnimOnce(playerPed, "amb@world_human_sunbathe@male@front@enter", "enter", nil, nil, -1, 0.3)
        Citizen.Wait(1500)
    else
        PlayAnimOnce(playerPed, "amb@world_human_sunbathe@male@front@enter", "enter")
        Citizen.Wait(3000)
    end

    -- Set the player into the idle position (but only if we can still crawl)
    if CanPlayerCrouchCrawl(playerPed) and not IsEntityInWater(playerPed) then
        PlayIdleCrawlAnim(playerPed, nil, 3.0)
    end
    inAction = false

    CrawlThread()
end

RegisterKeyMapping('+crouch', "S'accroupir", "keyboard", 'lcontrol')
RegisterCommand('+crouch', function() CrouchKeyPressed() end, false)
RegisterCommand('-crouch', function() end, false)

RegisterCommand('crouch', function()
    if isCrouched then
        isCrouched = false
        return
    end

    AttemptCrouch(PlayerPedId())
end, false)
TriggerEvent('chat:addSuggestion', '/crouch', "S'accroupir")

Utils.KeyRegister('rcontrol', 'crawl', 'Ramper', CrawlKeyPressed)
