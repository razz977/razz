local RSGCore = exports['rsg-core']:GetCoreObject()
local activeRuns = {}

local function _L(key)
    if not Locales or not Locales.ro then
        return key
    end
    return Locales.ro[key] or key
end

local function now()
    return os.time()
end

local function notify(src, key, ntype, ...)
    local msg = _L(key)
    if select('#', ...) > 0 then
        msg = msg:format(...)
    end
    TriggerClientEvent('rsg-transport-test:client:notify', src, msg, ntype or 'inform')
end

local function hasCooldown(src)
    local run = activeRuns[src]
    if not run then
        return false
    end
    return (now() - run.startedAt) < Config.TransportRun.CooldownSeconds
end

local function isNearPoint(src, point, maxDistance)
    local ped = GetPlayerPed(src)
    if ped == 0 then
        return false
    end
    local coords = GetEntityCoords(ped)
    return #(coords - point) <= maxDistance
end

local function pickRandomDestination()
    local list = Config.TransportRun.Destinations
    if not list or #list == 0 then
        return nil
    end
    return list[math.random(1, #list)]
end

local function getRandomReward()
    local min = Config.TransportRun.Reward.Min
    local max = Config.TransportRun.Reward.Max
    if min > max then
        min, max = max, min
    end
    return math.random(min, max)
end

RegisterNetEvent('RSGCore:Server:UpdateObject', function()
    if source ~= '' then
        return false
    end
    RSGCore = exports['rsg-core']:GetCoreObject()
end)

RegisterNetEvent('rsg-transport-test:server:requestRun', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then
        return
    end

    if hasCooldown(src) then
        notify(src, 'on_cooldown', 'error')
        return
    end

    local npcPoint = vector3(Config.Npc.Coords.x, Config.Npc.Coords.y, Config.Npc.Coords.z)
    if not isNearPoint(src, npcPoint, Config.Npc.InteractionDistance + 2.0) then
        notify(src, 'too_far_from_npc', 'error')
        return
    end

    if not Config.TransportRun.AllowedJobs[Player.PlayerData.job.name] then
        notify(src, 'missing_job_access', 'error')
        return
    end

    if activeRuns[src] and activeRuns[src].active then
        notify(src, 'already_on_job', 'error')
        return
    end

    local destination = pickRandomDestination()
    if not destination then
        notify(src, 'job_cancelled', 'error')
        return
    end

    local runId = ('run-%s-%s'):format(src, now())
    activeRuns[src] = {
        active = true,
        startedAt = now(),
        destination = destination,
        runId = runId
    }

    TriggerClientEvent('rsg-transport-test:client:startRun', src, {
        runId = runId,
        destination = destination.Coords,
        reward = {
            moneyType = Config.TransportRun.Reward.MoneyType
        }
    })
    notify(src, 'route_set', 'inform')
end)

RegisterNetEvent('rsg-transport-test:server:completeRun', function(runId)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then
        return
    end

    local run = activeRuns[src]
    if not run or not run.active then
        return
    end
    if run.runId ~= runId then
        notify(src, 'job_cancelled', 'error')
        return
    end

    local destPoint = vector3(run.destination.Coords.x, run.destination.Coords.y, run.destination.Coords.z)
    if not isNearPoint(src, destPoint, Config.TransportRun.CompleteDistance + 5.0) then
        notify(src, 'arrive_with_wagon', 'error')
        return
    end

    local reward = getRandomReward()
    local paid = Player.Functions.AddMoney(Config.TransportRun.Reward.MoneyType, reward, 'transport-run')
    if not paid then
        notify(src, 'job_cancelled', 'error')
        return
    end

    run.active = false
    run.lastReward = reward
    run.lastCompletedAt = now()

    TriggerClientEvent('rsg-transport-test:client:runPaid', src, reward)
end)

AddEventHandler('playerDropped', function()
    activeRuns[source] = nil
end)
