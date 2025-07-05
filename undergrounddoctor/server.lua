local cooldowns = {}

local function getIdentifier(src)
    local ids = GetPlayerIdentifiers(src)
    for _, id in ipairs(ids) do
        if string.find(id, "license:") then
            return id
        end
    end
    return ids[1]
end

RegisterNetEvent('frp_undergrounddoctor:tryRevive', function()
    local src = source
    local xPlayer = exports['qb-core']:GetPlayer(src)

    local id = getIdentifier(src)
    local now = os.time()

    -- Sjekk cooldown
    if cooldowns[id] and now < cooldowns[id] then
        local min = math.ceil((cooldowns[id] - now) / 60)
        TriggerClientEvent('frp_undergrounddoctor:notify', src, 'Du må vente ' .. min .. ' minutter før du kan bruke dette igjen.', 'error')
        return
    end

    -- Sjekk om spiller er død
    if not xPlayer or (not xPlayer.PlayerData.metadata["inlaststand"] and not xPlayer.PlayerData.metadata["isdead"]) then
        TriggerClientEvent('frp_undergrounddoctor:notify', src, 'Du er ikke død!', 'error')
        return
    end

    -- Sjekk penger (cash)
    if xPlayer.PlayerData.money['cash'] < Config.RevivePrice then
        TriggerClientEvent('frp_undergrounddoctor:notify', src, 'Du har ikke nok penger!', 'error')
        return
    end

    -- Start prosess på client (for progressbar)
    TriggerClientEvent('frp_undergrounddoctor:startRevive', src, Config.ReviveTime)

    -- Vente (revive tid)
    Wait(Config.ReviveTime * 1000)

    -- Sjekk om fortsatt død
    if xPlayer.PlayerData.metadata["inlaststand"] or xPlayer.PlayerData.metadata["isdead"] then
        -- Trekk penger og revive
        xPlayer.Functions.RemoveMoney('cash', Config.RevivePrice, "underground-doctor-revive")
        TriggerClientEvent('hospital:client:Revive', src)
        TriggerClientEvent('frp_undergrounddoctor:notify', src, 'Du har blitt behandlet!', 'success')
        -- Sett cooldown
        cooldowns[id] = os.time() + Config.Cooldown
    else
        TriggerClientEvent('frp_undergrounddoctor:notify', src, 'Du er allerede i live!', 'error')
    end
end)
