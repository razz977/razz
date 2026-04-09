local RSGCore = exports['rsg-core']:GetCoreObject()

local Lang = Locales[Config.Locale] or Locales['ro'] or {}
local DispatcherPed = nil
local DispatcherBlip = nil
local WagonEntity = nil
local DestinationBlip = nil
local CurrentRun = nil

local function _L(key)
    return Lang[key] or key
end

local function notify(message, ntype)
    lib.notify({
        title = _L('notify_title'),
        description = message,
        type = ntype or 'inform'
    })
end

RegisterNetEvent('RSGCore:Client:UpdateObject', function()
    RSGCore = exports['rsg-core']:GetCoreObject()
end)

local function loadModel(modelName)
    local modelHash = GetHashKey(modelName)
    if not IsModelValid(modelHash) then return nil end
    RequestModel(modelHash)

    local tries = 0
    while not HasModelLoaded(modelHash) and tries < 200 do
        Wait(50)
        tries = tries + 1
    end

    if not HasModelLoaded(modelHash) then
        return nil
    end
    return modelHash
end

local function removeDestinationBlip()
    if DestinationBlip and DoesBlipExist(DestinationBlip) then
        RemoveBlip(DestinationBlip)
    end
    DestinationBlip = nil
end

local function removeWagonProps()
    if not CurrentRun or not CurrentRun.props then return end
    for _, prop in ipairs(CurrentRun.props) do
        if prop and DoesEntityExist(prop) then
            DeleteEntity(prop)
        end
    end
    CurrentRun.props = {}
end

local function removeWagon()
    if WagonEntity and DoesEntityExist(WagonEntity) then
        DeleteEntity(WagonEntity)
    end
    WagonEntity = nil
end

local function stopRun()
    lib.hideTextUI()
    removeDestinationBlip()
    removeWagonProps()
    removeWagon()
    CurrentRun = nil
end

local function createDispatcherBlip()
    if not Config.Blip.Enabled then return end
    if DispatcherBlip and DoesBlipExist(DispatcherBlip) then return end

    DispatcherBlip = Citizen.InvokeNative(
        0x554D9D53F696D002,
        1664425300,
        Config.Npc.Coords.x,
        Config.Npc.Coords.y,
        Config.Npc.Coords.z
    )

    SetBlipSprite(DispatcherBlip, Config.Blip.NpcSprite, 1)
    SetBlipScale(DispatcherBlip, Config.Blip.NpcScale)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Config.Blip.NpcLabel)
    EndTextCommandSetBlipName(DispatcherBlip)
end

local function createDestinationBlip(destinationCoords)
    removeDestinationBlip()
    if not Config.Blip.Enabled then return end

    DestinationBlip = Citizen.InvokeNative(
        0x554D9D53F696D002,
        1664425300,
        destinationCoords.x,
        destinationCoords.y,
        destinationCoords.z
    )

    SetBlipSprite(DestinationBlip, Config.Blip.DestinationSprite, 1)
    SetBlipScale(DestinationBlip, Config.Blip.DestinationScale)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Config.Blip.DestinationLabel)
    EndTextCommandSetBlipName(DestinationBlip)
    SetBlipRoute(DestinationBlip, true)
end

local function attachWagonProps(wagonEntity)
    local props = {}

    for _, propCfg in ipairs(Config.Wagon.Props) do
        local propHash = loadModel(propCfg.Model)
        if propHash then
            local prop = CreateObject(propHash, 0.0, 0.0, 0.0, true, true, false)
            if DoesEntityExist(prop) then
                AttachEntityToEntity(
                    prop,
                    wagonEntity,
                    0,
                    propCfg.Offset.x,
                    propCfg.Offset.y,
                    propCfg.Offset.z,
                    propCfg.Rotation.x,
                    propCfg.Rotation.y,
                    propCfg.Rotation.z,
                    false,
                    false,
                    false,
                    false,
                    2,
                    true
                )
                props[#props + 1] = prop
            end
            SetModelAsNoLongerNeeded(propHash)
        end
    end

    return props
end

local function spawnRunWagon()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    local wagonHash = loadModel(Config.Wagon.Model)
    if not wagonHash then
        notify(_L('wagon_model_invalid'), 'error')
        return false
    end

    WagonEntity = CreateVehicle(
        wagonHash,
        coords.x,
        coords.y + Config.Wagon.SpawnForwardOffset,
        coords.z,
        heading,
        true,
        false
    )
    SetModelAsNoLongerNeeded(wagonHash)

    if WagonEntity == 0 or not DoesEntityExist(WagonEntity) then
        notify(_L('spawn_blocked'), 'error')
        return false
    end

    CurrentRun.props = attachWagonProps(WagonEntity)
    return true
end

local function createDispatcherNpc()
    if DispatcherPed and DoesEntityExist(DispatcherPed) then return end

    local npcHash = loadModel(Config.Npc.Model)
    if not npcHash then
        return
    end

    DispatcherPed = CreatePed(
        npcHash,
        Config.Npc.Coords.x,
        Config.Npc.Coords.y,
        Config.Npc.Coords.z - 1.0,
        Config.Npc.Coords.w,
        false,
        false,
        false,
        false
    )
    SetModelAsNoLongerNeeded(npcHash)

    if not DispatcherPed or not DoesEntityExist(DispatcherPed) then
        return
    end

    FreezeEntityPosition(DispatcherPed, true)
    SetEntityInvincible(DispatcherPed, true)
    SetBlockingOfNonTemporaryEvents(DispatcherPed, true)

    if Config.Npc.Scenario and Config.Npc.Scenario ~= '' then
        TaskStartScenarioInPlace(DispatcherPed, GetHashKey(Config.Npc.Scenario), -1, true, false, false, false)
    end

    createDispatcherBlip()

    if Config.UseOxTarget then
        exports.ox_target:addLocalEntity(DispatcherPed, {
            {
                name = Config.Npc.TargetName,
                icon = Config.Npc.TargetIcon,
                label = Config.Npc.TargetLabel,
                distance = Config.Npc.InteractionDistance,
                onSelect = function()
                    TriggerServerEvent('rsg-transport-test:server:requestRun')
                end
            }
        })
    end
end

local function deleteDispatcherNpc()
    if DispatcherPed and DoesEntityExist(DispatcherPed) then
        if Config.UseOxTarget then
            exports.ox_target:removeLocalEntity(DispatcherPed, { Config.Npc.TargetName })
        end
        DeleteEntity(DispatcherPed)
    end
    DispatcherPed = nil

    if DispatcherBlip and DoesBlipExist(DispatcherBlip) then
        RemoveBlip(DispatcherBlip)
    end
    DispatcherBlip = nil
end

local function isInRunWagon()
    if not WagonEntity or not DoesEntityExist(WagonEntity) then return false end
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    return vehicle ~= 0 and vehicle == WagonEntity
end

local function isAtDestination()
    if not CurrentRun or not CurrentRun.destination then return false end
    local coords = GetEntityCoords(PlayerPedId())
    local target = vector3(CurrentRun.destination.x, CurrentRun.destination.y, CurrentRun.destination.z)
    return #(coords - target) <= Config.TransportRun.CompleteDistance
end

RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', function()
    createDispatcherNpc()
end)

RegisterNetEvent('RSGCore:Client:OnPlayerUnload', function()
    stopRun()
    deleteDispatcherNpc()
end)

RegisterNetEvent('rsg-transport-test:client:notify', function(message, ntype)
    notify(message, ntype)
end)

RegisterNetEvent('rsg-transport-test:client:startRun', function(data)
    if CurrentRun then
        notify(_L('already_on_job'), 'error')
        return
    end

    CurrentRun = {
        id = data.runId,
        destination = data.destination.coords,
        destinationName = data.destination.name,
        reward = data.reward,
        props = {}
    }

    if not spawnRunWagon() then
        CurrentRun = nil
        return
    end

    createDestinationBlip(CurrentRun.destination)
    notify(_L('route_set'), 'inform')
    notify(_L('job_started'), 'success')
end)

RegisterNetEvent('rsg-transport-test:client:runPaid', function(amount)
    notify((_L('delivery_success')) .. (' $%s'):format(amount), 'success')
    stopRun()
end)

RegisterNetEvent('rsg-transport-test:client:runFailed', function(message)
    notify(message, 'error')
    stopRun()
end)

CreateThread(function()
    while true do
        if CurrentRun then
            local sleep = 500
            if isAtDestination() then
                sleep = 0
                if isInRunWagon() then
                    lib.showTextUI(_L('arrive_with_wagon'))
                    if IsControlJustPressed(0, RSGCore.Shared.Keybinds['E']) then
                        lib.hideTextUI()
                        TriggerServerEvent('rsg-transport-test:server:completeRun', CurrentRun.id)
                    end
                else
                    lib.showTextUI(_L('not_in_wagon'))
                end
            else
                lib.hideTextUI()
            end
            Wait(sleep)
        else
            Wait(1000)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    stopRun()
    deleteDispatcherNpc()
end)

