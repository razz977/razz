# RSG ZERO-TO-SCRIPT PLAYBOOK (functie cu functie)

Acest fisier este facut pentru workflow-ul tau: creezi scripturi de la zero, pe etape, functie cu functie.

Se foloseste impreuna cu:
- `RSG_NATIVE_CATALOG.md` (native allowlist)
- `CURSOR_RSG_RULESET.md` (reguli de logica si securitate)

---

## 0) Structura obligatorie de resource

Cand creezi script nou de la zero, structura este fixa:

- `fxmanifest.lua` (root)
- `config.lua` (root)
- `client/client.lua`
- `server/server.lua`
- `locales/ro.lua`

Reguli locale:

- Toate textele pentru player se tin in `locales/ro.lua`.
- Textele din `locales/ro.lua` trebuie scrise in romana fara diacritice.
- In `client/client.lua` si `server/server.lua` nu se hardcodeaza texte user-facing daca exista deja cheia in locale.

---

## 1) Regula principala (cand generezi cod)

Ordinea obligatorie:
1. foloseste functii/API din RSG
2. foloseste native doar din `RSG_NATIVE_CATALOG.md`
3. adauga minim necesar doar daca nu exista deja model RSG

Nu se accepta:
- bani/iteme procesate pe client
- validari sensibile pe client
- money type `bank` (deprecated)

---

## 2) Catalog scurt de functii RSG (pe care sa te bazezi)

## Core object

```lua
local RSGCore = exports['rsg-core']:GetCoreObject()
```

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

## Client-side utile

- `RSGCore.Functions.GetPlayerData()`
- `RSGCore.Functions.GetCoords(entity)`
- `RSGCore.Functions.HasItem(item, amount)`
- `RSGCore.Functions.TriggerCallback(name, cb, ...)`
- `RSGCore.Functions.CreateClientCallback(name, cb)`

## Server-side utile

- `RSGCore.Functions.GetPlayer(source)`
- `RSGCore.Functions.CreateCallback(name, cb)`
- `RSGCore.Functions.TriggerClientCallback(name, source, cb)`
- `RSGCore.Functions.HasPermission(source, permission)`
- `RSGCore.Commands.Add(name, help, arguments, argsrequired, callback, permission)`

## Player.Functions (server)

- `SetJob(job, grade)`
- `SetGang(gang, grade)`
- `SetJobDuty(onDuty)`
- `SetPlayerData(key, val)`
- `SetMetaData(meta, val)`
- `GetMetaData(meta)`
- `AddRep(rep, amount)`
- `RemoveRep(rep, amount)`
- `GetRep(rep)`
- `AddMoney(type, amount, reason)`
- `RemoveMoney(type, amount, reason)`
- `SetMoney(type, amount, reason)`
- `GetMoney(type)`
- `HasItem(items, amount)`
- `Save()`

## Inventory exports (server)

- `exports['rsg-inventory']:HasItem(source, item, amount)`
- `exports['rsg-inventory']:CanAddItem(source, item, amount)`
- `exports['rsg-inventory']:AddItem(source, item, amount, slot, info, reason)`
- `exports['rsg-inventory']:RemoveItem(source, item, amount, slot, reason)`
- `exports['rsg-inventory']:GetItemByName(source, item)`
- `exports['rsg-inventory']:GetItemCount(source, item)`
- `exports['rsg-inventory']:OpenInventory(source, identifier, data)`
- `exports['rsg-inventory']:CreateInventory(identifier, data)`
- `exports['rsg-inventory']:ClearStash(identifier)`

## Prompt system

- `exports['rsg-core']:createPrompt(location, coords, key, label, options)`
- `exports['rsg-core']:deletePrompt(handle)`

## StateBags

- `Player(source).state.<key> = value` (server write)
- `LocalPlayer.state.<key>` (client read)
- `AddStateBagChangeHandler(key, bag, cb)`

---

## 3) Workflow de construit scriptul pe etape

## Etapa 0 - Setup fisier + config

Fa intai:
- `fxmanifest.lua` (root)
- `config.lua` (root)
- `client/client.lua`
- `server/server.lua`
- `locales/ro.lua` (toate textele user-facing, fara diacritice romanesti)
- init `RSGCore` in client + server

Nu implementa gameplay in etapa asta.

## Etapa 1 - O singura functie de validare server

Prima functie recomandata:

```lua
local function ValidateAction(src)
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return false, 'invalid-player' end
    return true, Player
end
```

## Etapa 2 - Distanta + cooldown + permission/job check

Adaugi pe rand functii mici:
- `IsNearPoint(src, coords, distance)`
- `IsOnCooldown(src)`
- `HasAccess(Player, config)`

## Etapa 3 - Tranzactie iteme/bani cu rollback

Ordine obligatorie:
1) Remove cost
2) Add reward item
3) Add money
4) rollback daca pasul urmator esueaza

## Etapa 4 - Prompt + event wire

- prompt in client
- event server pentru actiune
- notify rezultat in client

## Etapa 5 - Callback pentru verificare UI/pre-open

Adaugi callback simplu:
- poate face actiunea?
- ce motiv de blocare are?

## Etapa 6 - logs + cleanup

- reason clar la AddMoney/RemoveMoney/AddItem/RemoveItem
- cleanup la `playerDropped`
- cleanup prompt la `onResourceStop`

---

## 4) Regulament injectabil (template)

Copiaza asta in fiecare prompt nou:

```txt
REGULAMENT SERVER:
[LIPESTE_AICI_REGULAMENTUL_TAU]

Transforma regulamentul in validari tehnice server-side:
- verificari acces (job/gang/permission)
- verificari distanta
- verificari iteme/bani
- cooldown anti-spam
- logs pentru actiuni sensibile
```

---

## 5) Prompturi scurte pentru lucru functie-cu-functie

## Prompt A (doar o functie)

```txt
Implementeaza DOAR functia [NUME_FUNCTIE] in [fisier], fara alte modificari.
Respecta:
- RSG_NATIVE_CATALOG.md
- CURSOR_RSG_RULESET.md
- RSG_ZERO_TO_SCRIPT_PLAYBOOK.md

Regulament:
[LIPESTE_AICI_REGULAMENTUL_TAU]
```

## Prompt B (functie + test local simplu)

```txt
Implementeaza functia [NUME_FUNCTIE] + un test minimal de rulare in cod (fara a schimba arhitectura).
Foloseste strict pattern RSG.
Nu adauga alte feature-uri.

Regulament:
[LIPESTE_AICI_REGULAMENTUL_TAU]
```

## Prompt C (next stage only)

```txt
Continua doar cu Etapa [N] din RSG_ZERO_TO_SCRIPT_PLAYBOOK.md.
Nu atinge alte etape.
Pastreaza codul existent.

Regulament:
[LIPESTE_AICI_REGULAMENTUL_TAU]
```

---

## 6) Checklist rapid inainte de fiecare commit

- [ ] validari sensibile pe server
- [ ] fara native in afara allowlist
- [ ] fara `GetPlayerPed(-1)` / `GetDistanceBetweenCoords`
- [ ] fara money type `bank`
- [ ] prompt create/delete corect
- [ ] cooldown + distance checks
- [ ] rollback pe tranzactii in lant
- [ ] reason-uri la logs/tranzactii

