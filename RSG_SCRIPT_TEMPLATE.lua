-- RSG SCRIPT TEMPLATE (official-style)
-- Copy the sections below into your resource files:
--   fxmanifest.lua, config.lua, client/main.lua, server/main.lua
-- This template follows CURSOR_RSG_RULESET.md + RSG_NATIVE_CATALOG.md

-----------------------------------------------------------------------
-- FILE: fxmanifest.lua
-----------------------------------------------------------------------
--[[
fx_version 'cerulean'
game 'rdr3'
lua54 'yes'

name 'rsg-template-resource'
author 'your-name'
description 'RSG template resource'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    'rsg-core',
    'rsg-inventory',
    'ox_lib'
}
]]

-----------------------------------------------------------------------
-- FILE: config.lua
-----------------------------------------------------------------------
--[[
Config = {}

Config.Debug = false
Config.ActionDistance = 2.0
Config.CooldownSeconds = 10
Config.RequiredJob = 'unemployed' -- set to your job
Config.RequiredItem = 'bread'
Config.RequiredItemAmount = 1

-- Money type must be one of:
-- cash, valbank, rhobank, blkbank, armbank, bloodmoney
Config.RewardMoneyType = 'cash'
Config.RewardMoneyAmount = 5

Config.Prompt = {
    id = 'template_action_prompt',
    coords = vector3(-322.5, 773.2, 116.2),
    label = 'Run Template Action',
    key = 'E'
}
]]

-----------------------------------------------------------------------
-- FILE: client/main.lua
-----------------------------------------------------------------------
--[[
local RSGCore = exports['rsg-core']:GetCoreObject()
local promptHandle

RegisterNetEvent('RSGCore:Client:UpdateObject', function()
    RSGCore = exports['rsg-core']:GetCoreObject()
end)

local function notify(msg, ntype)
    lib.notify({
        title = 'Template',
        description = msg,
        type = ntype or 'inform'
    })
end

local function createActionPrompt()
    if promptHandle then return end
    local keyHash = RSGCore.Shared.Keybinds[Config.Prompt.key]
    if not keyHash then
        notify('Invalid keybind in config', 'error')
        return
    end

    promptHandle = exports['rsg-core']:createPrompt(
        Config.Prompt.id,
        Config.Prompt.coords,
        keyHash,
        Config.Prompt.label,
        {
            type = 'server',
            event = 'rsg-template:server:attemptAction',
            args = {}
        }
    )
end

local function deleteActionPrompt()
    if not promptHandle then return end
    exports['rsg-core']:deletePrompt(promptHandle)
    promptHandle = nil
end

RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', function()
    createActionPrompt()
end)

RegisterNetEvent('RSGCore:Client:OnPlayerUnload', function()
    deleteActionPrompt()
end)

RegisterNetEvent('rsg-template:client:result', function(success, message)
    notify(message, success and 'success' or 'error')
end)

-- Example StateBag watcher (optional)
AddStateBagChangeHandler('hunger', nil, function(bagName, key, value)
    local myBag = ('player:%s'):format(GetPlayerServerId(PlayerId()))
    if bagName ~= myBag then return end
    if Config.Debug then
        print(('[template] hunger updated: %s'):format(value))
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    deleteActionPrompt()
end)
]]

-----------------------------------------------------------------------
-- FILE: server/main.lua
-----------------------------------------------------------------------
--[[
local RSGCore = exports['rsg-core']:GetCoreObject()
local playerCooldowns = {}

RegisterNetEvent('RSGCore:Server:UpdateObject', function()
    if source ~= '' then return false end
    RSGCore = exports['rsg-core']:GetCoreObject()
end)

local function now()
    return os.time()
end

local function isOnCooldown(src)
    local last = playerCooldowns[src] or 0
    return (now() - last) < Config.CooldownSeconds
end

local function setCooldown(src)
    playerCooldowns[src] = now()
end

local function isNearActionPoint(src)
    local ped = GetPlayerPed(src)
    if ped == 0 then return false end
    local coords = GetEntityCoords(ped)
    return #(coords - Config.Prompt.coords) <= Config.ActionDistance
end

local function fail(src, msg)
    TriggerClientEvent('rsg-template:client:result', src, false, msg)
end

local function succeed(src, msg)
    TriggerClientEvent('rsg-template:client:result', src, true, msg)
end

RegisterNetEvent('rsg-template:server:attemptAction', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end

    if isOnCooldown(src) then
        fail(src, 'You are on cooldown')
        return
    end

    if not isNearActionPoint(src) then
        fail(src, 'You are too far away')
        return
    end

    if Config.RequiredJob ~= 'unemployed' and Player.PlayerData.job.name ~= Config.RequiredJob then
        fail(src, 'You do not have the required job')
        return
    end

    if not exports['rsg-inventory']:HasItem(src, Config.RequiredItem, Config.RequiredItemAmount) then
        fail(src, ('Missing required item: %s x%s'):format(Config.RequiredItem, Config.RequiredItemAmount))
        return
    end

    if not exports['rsg-inventory']:CanAddItem(src, 'water', 1) then
        fail(src, 'Inventory full')
        return
    end

    setCooldown(src)

    -- Safe transaction order:
    -- 1) remove cost, 2) add reward item, 3) add money
    local removed = exports['rsg-inventory']:RemoveItem(src, Config.RequiredItem, Config.RequiredItemAmount, nil, 'template-cost')
    if not removed then
        fail(src, 'Failed to consume required item')
        return
    end

    local addedItem = exports['rsg-inventory']:AddItem(src, 'water', 1, nil, nil, 'template-reward')
    if not addedItem then
        -- rollback
        exports['rsg-inventory']:AddItem(src, Config.RequiredItem, Config.RequiredItemAmount, nil, nil, 'template-rollback')
        fail(src, 'Failed to grant reward item')
        return
    end

    local addedMoney = Player.Functions.AddMoney(Config.RewardMoneyType, Config.RewardMoneyAmount, 'template-reward')
    if not addedMoney then
        -- rollback item + cost
        exports['rsg-inventory']:RemoveItem(src, 'water', 1, nil, 'template-rollback')
        exports['rsg-inventory']:AddItem(src, Config.RequiredItem, Config.RequiredItemAmount, nil, nil, 'template-rollback')
        fail(src, 'Failed to grant reward money')
        return
    end

    succeed(src, ('Action complete! +1 water +$%s %s'):format(Config.RewardMoneyAmount, Config.RewardMoneyType))
end)

-- Example callback pattern
RSGCore.Functions.CreateCallback('rsg-template:server:canDoAction', function(source, cb)
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then
        cb(false, 'Invalid player')
        return
    end

    if isOnCooldown(source) then
        cb(false, 'On cooldown')
        return
    end

    cb(true, 'ok')
end)

AddEventHandler('playerDropped', function()
    local src = source
    playerCooldowns[src] = nil
end)
]]
