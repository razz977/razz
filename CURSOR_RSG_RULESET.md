# CURSOR RSG RULESET (Natives + Logic)

Acest document este standardul pentru generarea scripturilor RSG in Cursor.
Obiectiv: scripturile sa foloseasca doar logica, evenimentele, exporturile si stilul prezentat in documentatia oficiala RSG.

## 1) Regula de baza

- Daca o functionalitate exista deja in RSG docs, foloseste exact acel pattern.
- Nu inventa alte flow-uri daca exista deja un flow RSG documentat.
- Nu muta bani/iteme pe client.
- Validarile critice sunt obligatoriu pe server.

## 2) Allowlist de integrare (RSG-first)

### Core object

```lua
local RSGCore = exports['rsg-core']:GetCoreObject()
```

Hot-reload object update:

```lua
RegisterNetEvent('RSGCore:Client:UpdateObject', function()
    RSGCore = exports['rsg-core']:GetCoreObject()
end)
```

```lua
RegisterNetEvent('RSGCore:Server:UpdateObject', function()
    if source ~= '' then return false end
    RSGCore = exports['rsg-core']:GetCoreObject()
end)
```

### Evenimente de baza permise

- `RSGCore:Client:OnPlayerLoaded`
- `RSGCore:Client:OnPlayerUnload`
- `RSGCore:Player:SetPlayerData`
- `RSGCore:Client:OnJobUpdate`
- `RSGCore:Client:SetDuty`
- `RSGCore:Client:OnMoneyChange`
- `RSGCore:Server:OnMoneyChange`

### Callback patterns permise

- Server callback:
  - `RSGCore.Functions.CreateCallback(...)`
  - `RSGCore.Functions.TriggerCallback(...)`
- Client callback:
  - `RSGCore.Functions.CreateClientCallback(...)`
  - `RSGCore.Functions.TriggerClientCallback(...)`

### Prompt system permis

- `exports['rsg-core']:createPrompt(location, coords, key, label, options)`
- `exports['rsg-core']:deletePrompt(handle)`
- Keybinduri doar din `RSGCore.Shared.Keybinds`

### Inventory APIs permise

- `exports['rsg-inventory']:HasItem(...)`
- `exports['rsg-inventory']:CanAddItem(...)`
- `exports['rsg-inventory']:AddItem(...)`
- `exports['rsg-inventory']:RemoveItem(...)`
- `exports['rsg-inventory']:GetItemByName(...)`
- `exports['rsg-inventory']:GetItemCount(...)`
- `exports['rsg-inventory']:OpenInventory(...)`
- `exports['rsg-inventory']:CreateInventory(...)`
- `exports['rsg-inventory']:ClearStash(...)`

### Money APIs permise

Prin `Player.Functions`:

- `AddMoney(moneytype, amount, reason)`
- `RemoveMoney(moneytype, amount, reason)`
- `SetMoney(moneytype, amount, reason)`
- `GetMoney(moneytype)`

Money types permise:

- `cash`
- `valbank`
- `rhobank`
- `blkbank`
- `armbank`
- `bloodmoney`

Nu folosi `bank` (deprecated in docs).

### Player APIs permise

- `SetJob`, `SetGang`, `SetJobDuty`
- `SetPlayerData`, `UpdatePlayerData`
- `SetMetaData`, `GetMetaData`
- `AddRep`, `RemoveRep`, `GetRep`
- `HasItem`, `Save`, `Logout`

### StateBags pattern permis

- Citire client: `LocalPlayer.state.<key>`
- Scriere server: `Player(source).state.<key> = value`
- Watchers: `AddStateBagChangeHandler(...)`

Chei recomandate (din docs): `hunger`, `thirst`, `cleanliness`, `stress`, `health`, `isLoggedIn`.

## 3) Natives/patterns recomandate explicit de docs

### Prefera aceste patterns

- `PlayerPedId()` in loc de `GetPlayerPed(-1)`
- Distanta: `#(coordsA - coordsB)` in loc de `GetDistanceBetweenCoords(...)`
- `GetEntityCoords(...)` + `GetEntityHeading(...)`
- `CreateThread(...)` cu `Wait(...)` controlat (fara loop agresiv)
- `GetGamePool(...)` pentru pools
- `GetActivePlayers()` / `RSGCore.Functions.GetPlayers()` conform contextului

## 4) Logic flow obligatoriu pentru orice actiune sensibila

1. Valideaza `source` si obiectul Player pe server.
2. Valideaza input (tipuri, range, nil checks).
3. Valideaza acces (job/gang/permission/duty).
4. Valideaza distanta fata de punctul actiunii.
5. Valideaza iteme/bani (`HasItem`, `GetMoney`, `CanAddItem`).
6. Executa tranzactia in ordine sigura:
   - Remove -> Add (si rollback daca al doilea pas esueaza).
7. Logheaza cu `reason` clar.
8. Notifica player-ul (`ox_lib`).
9. Aplica cooldown/anti-spam.

## 5) Interdictii (NU)

- NU da reward-uri (bani/iteme) direct din client.
- NU folosi callback/event fara validare server-side.
- NU folosi loop-uri `while true do` cu `Wait(0)` fara sleep dinamic.
- NU folosi money type `bank`.
- NU folosi native alternative daca exista pattern explicit in docs RSG pentru acel caz.

## 6) Prompt master pentru Cursor (copy/paste)

```txt
Genereaza cod STRICT in stil RSG docs, fara flow-uri custom care deviaza de la documentatie.

Respecta regulile din fisierul CURSOR_RSG_RULESET.md.

Conditii obligatorii:
- RSGCore object: exports['rsg-core']:GetCoreObject()
- Prompturi: exports['rsg-core']:createPrompt / deletePrompt
- Inventory: doar prin exports['rsg-inventory']
- Money: doar prin Player.Functions.(AddMoney/RemoveMoney/SetMoney/GetMoney)
- Money types: cash, valbank, rhobank, blkbank, armbank, bloodmoney
- State sync: StateBags pentru status live
- Validari si tranzactii doar pe server
- Input validation + permission checks + distance checks + cooldown + logs
- Nu folosi bank (deprecated), nu folosi GetPlayerPed(-1), nu folosi GetDistanceBetweenCoords

Returneaza fisiere complete: fxmanifest.lua, config.lua, client/main.lua, server/main.lua, README.md.
```

## 7) Optiune regulament server

In orice prompt nou, adauga blocul:

```txt
Regulament server:
[LIPESTE_AICI_REGULAMENTUL_TAU]

Transforma regulamentul in validari tehnice server-side, logs si restrictii de gameplay.
```
