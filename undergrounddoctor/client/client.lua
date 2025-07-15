local npc = nil
local shown = false

-- Sjekk spillerens avstand til NPC
local function IsPlayerNearNpc()
    local playerPed = cache.ped
    local playerCoords = GetEntityCoords(playerPed)
    local dist = #(playerCoords - vector3(Config.NpcCoords.x, Config.NpcCoords.y, Config.NpcCoords.z))
    return dist < Config.NpcSpawnRadius, dist
end

-- Spawner NPC
local function SpawnDoctor()
    if npc and DoesEntityExist(npc) then return end
    lib.requestModel(Config.NpcModel)
    npc = CreatePed(0, Config.NpcModel, Config.NpcCoords.x, Config.NpcCoords.y, Config.NpcCoords.z - 1, Config.NpcCoords.w, false, false)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)

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
    shown = true
end

-- Despawner NPC
local function DespawnDoctor()
    if npc and DoesEntityExist(npc) then
        DeleteEntity(npc)
        npc = nil
        shown = false
    end
end

-- Kontinuerlig avstandssjekk
CreateThread(function()
    while true do
        local isNear, dist = IsPlayerNearNpc()
        if isNear and not shown then
            SpawnDoctor()
        elseif not isNear and shown then
            if dist > Config.NpcDespawnRadius then
                DespawnDoctor()
            end
        end
        Wait(1000)
    end
end)

-- Start behandling: CPR-animasjon på NPC + progressbar
RegisterNetEvent('frp_undergrounddoctor:startRevive', function(time)
    -- Start CPR animasjon på NPC
    if npc and DoesEntityExist(npc) then
        RequestAnimDict('mini@cpr@char_a@cpr_str')
        while not HasAnimDictLoaded('mini@cpr@char_a@cpr_str') do
            Wait(10)
        end
        TaskPlayAnim(npc, 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest', 8.0, -8.0, -1, 1, 0, false, false, false)
    end

    -- Start progressbar
    exports['progressbar']:Progress({
        name = 'underground_doctor',
        duration = time * 1000,
        label = 'Behandler deg, vennligst vent...',
        useWhileDead = true,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }
    }, function(cancelled)
        -- Stopper CPR animasjon på NPC etterpå
        if npc and DoesEntityExist(npc) then
            ClearPedTasks(npc)
        end
    end)
end)

-- Notify
RegisterNetEvent('frp_undergrounddoctor:notify', function(msg, type)
    lib.notify({
        title = 'Underground Doctor',
        description = msg,
        type = type or 'info'
    })
end)
