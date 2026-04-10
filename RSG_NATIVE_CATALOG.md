# RSG Native Catalog (official-style allowlist)

Sursa: https://rsg.mintlify.app (llms.txt + paginile de referinta RSG).

Acest catalog este folosit ca allowlist implicit cand se genereaza scripturi noi pentru server.
Daca un script are nevoie de alt apel, se adauga doar dupa verificare in documentatia oficiala RSG.

## 1) Player / Entity natives

- `PlayerPedId()`
- `GetPlayerPed(sourceOrPlayerId)`
- `GetEntityCoords(entity, alive)`
- `GetEntityHeading(entity)`
- `GetActivePlayers()`
- `GetGamePool(poolName)`
- `GetClosestVehicle(x, y, z, radius, modelHash, flags)`
- `GetVehiclePedIsIn(ped, lastVehicle)`
- `GetEntityModel(entity)`
- `DeleteEntity(entity)`
- `DoesEntityExist(entity)`

## 2) Vehicle / Model natives

- `GetHashKey(modelName)`
- `RequestModel(modelHash)`
- `HasModelLoaded(modelHash)`
- `IsModelValid(modelHash)`
- `CreateVehicle(modelHash, x, y, z, heading, isNetwork, netMissionEntity)`
- `CreatePed(modelHash, x, y, z, heading, isNetwork, bScriptHostPed, p7, p8)`
- `CreateObject(modelHash, x, y, z, isNetwork, netMissionEntity, dynamic)`
- `SetPedIntoVehicle(ped, vehicle, seatIndex)`
- `SetModelAsNoLongerNeeded(modelHash)`

## 3) Blips / UI / Visual

- `DoesBlipExist(blip)`
- `RemoveBlip(blip)`
- `SetBlipSprite(blip, spriteHash, p2)`
- `SetBlipScale(blip, scale)`
- `SetBlipRoute(blip, enabled)`
- `BeginTextCommandSetBlipName(type)`
- `AddTextComponentString(text)`
- `EndTextCommandSetBlipName(blip)`
- `AttachEntityToEntity(entity1, entity2, boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, p9, useSoftPinning, collision, isPed, vertexIndex, fixedRot)`
- `FreezeEntityPosition(entity, toggle)`
- `SetEntityInvincible(entity, toggle)`
- `SetBlockingOfNonTemporaryEvents(entity, toggle)`
- `Citizen.InvokeNative(hash, ...)` (doar in pattern-ul documentat RSG, ex. blip creation)
- `SendNUIMessage(data)`

## 4) Events / Networking

- `RegisterNetEvent(eventName, handler)`
- `AddEventHandler(eventName, handler)`
- `TriggerEvent(eventName, ...)`
- `TriggerServerEvent(eventName, ...)`
- `TriggerClientEvent(eventName, target, ...)`
- `RegisterCommand(name, handler, restricted)`
- `DropPlayer(source, reason)`
- `GetPlayerName(source)`
- `GetCurrentResourceName()`
- `IsControlJustPressed(inputGroup, control)`

## 5) Threads / Timing

- `CreateThread(function() ... end)`
- `Wait(ms)`
- `SetTimeout(ms, callback)`

## 6) StateBags natives/pattern

- `Player(source).state.<key>`
- `LocalPlayer.state.<key>`
- `AddStateBagChangeHandler(keyFilter, bagFilter, handler)`
- `GetPlayerServerId(PlayerId())`
- `GetPlayerFromServerId(serverId)`

## 7) Combat / Status (folosite in exemplele docs)

- `SetCanAttackFriendly(ped, toggle, p2)`
- `NetworkSetFriendlyFireOption(toggle)`
- `SetPlayerHealthRechargeMultiplier(playerId, multiplier)`
- `SetPedSuffersCriticalHits(ped, toggle)`
- `RestorePlayerStamina(playerId, amount)`
- `SetTimecycleModifier(modifierName)`
- `ClearTimecycleModifier()`

## 8) Animation natives

- `TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, lockX, lockY, lockZ)`
- `TaskStartScenarioInPlace(ped, scenarioHash, duration, playEnterAnim, p4, p5, p6)`
- `ClearPedTasks(ped)`
- `RemoveAnimDict(dict)`

## 9) Pattern-uri obligatorii (din RSG development guide)

- Foloseste `PlayerPedId()` in loc de `GetPlayerPed(-1)`.
- Foloseste distanta vectoriala `#(coordsA - coordsB)` in loc de `GetDistanceBetweenCoords(...)`.
- Evita loops agresive; foloseste sleep dinamic cu `Wait(...)`.
- Pentru interactiuni, prefera `exports['rsg-core']:createPrompt(...)`.
- Pentru status live, prefera StateBags in loc de event spam.

## 10) Interzis by default

- `GetPlayerPed(-1)` (deprecated pattern in docs)
- `GetDistanceBetweenCoords(...)` (inlocuit de vector math)
- Orice flow de bani/iteme pe client

## Nota de utilizare

- Acest catalog merge impreuna cu `CURSOR_RSG_RULESET.md`.
- La generarea scripturilor, se folosesc intai API-urile RSG (core/inventory/money/callbacks/prompts/statebags), apoi doar nativele din acest fisier.
