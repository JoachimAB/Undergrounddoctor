-- NPC Spawn
CreateThread(function()
    RequestModel(Config.NpcModel)
    while not HasModelLoaded(Config.NpcModel) do
        Wait(100)
    end

    local npc = CreatePed(0, Config.NpcModel, Config.NpcCoords.x, Config.NpcCoords.y, Config.NpcCoords.z - 1, Config.NpcCoords.w, false, false)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)

    -- ox_target oppsett
    exports.ox_target:addLocalEntity(npc, {
        {
            label = 'Bli behandlet (15.000 kr)',
            icon = 'fas fa-heart-pulse',
            canInteract = function(entity, distance, coords, name)
                return true
            end,
            onSelect = function()
                TriggerServerEvent('frp_undergrounddoctor:tryRevive')
            end
        }
    })
end)

-- Progressbar og animasjon når revive starter
RegisterNetEvent('frp_undergrounddoctor:startRevive', function(time)
    if lib and lib.progressCircle then
        lib.progressCircle({
            duration = time * 1000,
            label = 'Behandler deg, vennligst vent...',
            position = 'bottom',
            useWhileDead = true,
            canCancel = false,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim = {
                dict = 'mini@cpr@char_a@cpr_str',
                clip = 'cpr_pumpchest'
            }
        })
    else
        -- Fallback til native animasjon
        local playerPed = PlayerPedId()
        TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
        local endTime = GetGameTimer() + time * 1000
        while GetGameTimer() < endTime do
            Wait(100)
        end
        ClearPedTasks(playerPed)
    end
end)

RegisterNetEvent('frp_undergrounddoctor:notify', function(msg, type)
    if lib and lib.notify then
        lib.notify({
            title = 'Underground Doctor',
            description = msg,
            type = type or 'info'
        })
    else
        SetNotificationTextEntry("STRING")
        AddTextComponentString(msg)
        DrawNotification(false, false)
    end
end)
