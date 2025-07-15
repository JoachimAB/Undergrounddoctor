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
    local xPlayer = exports['qbx_core']:GetPlayer(src)
    local id = getIdentifier(src)
    local now = os.time()

    if cooldowns[id] and now < cooldowns[id] then
        local min = math.ceil((cooldowns[id] - now) / 60)
        TriggerClientEvent('frp_undergrounddoctor:notify', src, 'Du må vente ' .. min .. ' minutter før du kan bruke dette igjen.', 'error')
        return
    end

    if not xPlayer then
        TriggerClientEvent('frp_undergrounddoctor:notify', src, 'Kunne ikke finne spilleren.', 'error')
        return
    end

    local md = xPlayer.PlayerData.metadata or {}
    local isDead = md["inlaststand"] or md["isdead"] or md["isDead"] or md["dead"]
    if type(isDead) == "number" then isDead = isDead > 0 end
    if not isDead then
        TriggerClientEvent('frp_undergrounddoctor:notify', src, 'Du er ikke død!', 'error')
        return
    end

    if xPlayer.PlayerData.money['cash'] < Config.RevivePrice then
        TriggerClientEvent('frp_undergrounddoctor:notify', src, 'Du har ikke nok penger!', 'error')
        return
    end

    TriggerClientEvent('frp_undergrounddoctor:startRevive', src, Config.ReviveTime)
    Wait(Config.ReviveTime * 1000)

    md = xPlayer.PlayerData.metadata or {}
    local stillDead = md["inlaststand"] or md["isdead"] or md["isDead"] or md["dead"]
    if type(stillDead) == "number" then stillDead = stillDead > 0 end
    if stillDead then
        xPlayer.Functions.RemoveMoney('cash', Config.RevivePrice, "underground-doctor-revive")
        TriggerClientEvent('hospital:client:Revive', src)
        TriggerClientEvent('frp_undergrounddoctor:notify', src, 'Du har blitt behandlet!', 'success')
        cooldowns[id] = os.time() + Config.Cooldown
    else
        TriggerClientEvent('frp_undergrounddoctor:notify', src, 'Du er allerede i live!', 'error')
    end
end)
