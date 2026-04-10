# RSG UNIFIED REGULATION (SIMPLIFIED + REX STYLE)

Regulament unic pentru generare scripturi noi, cu reguli vechi pastrate si integrate.

## 1) Fisiere unice de referinta

1. `RSG_UNIFIED_REGULATION.md` (acest fisier)
2. `RSG_UNIFIED_NATIVE_FUNCTIONS.md` (native + functii unificate)
3. `RSG_UNIFIED_FUNCTION_NATIVE_INDEX.json` (index complet)

## 2) Structura obligatorie - stil Rex (pentru script nou)

- `fxmanifest.lua` (root)
- `config.lua` (root)
- `client/client.lua`
- `server/server.lua`
- `locales/ro.lua`

Structura config (clean, ordonata):
1. General
2. NPC/Locations
3. Jobs/Restrictions
4. Economy/Reward/Tax
5. Security/Cooldown/Validation
6. Blips/UI
7. Debug

Reguli config/locale:
- fiecare setare configurabila are comentariu inline pe acelasi rand
- toate textele user-facing in `locales/ro.lua` fara diacritice
- evita hardcode text in client/server daca exista cheia in locale

## 3) Reguli tehnice obligatorii

1. Server-first validation pentru bani/iteme/permissions/distance.
2. Nu procesa reward money/item pe client.
3. callbacks pentru request-response; events pentru one-way.
4. StateBags pentru status live; evita spam callbacks/events in loops.
5. Lifecycle: OnPlayerLoaded init, OnPlayerUnload cleanup, onResourceStop cleanup final.
6. Transaction flow: validate -> remove cost -> add reward -> rollback daca esueaza.
7. Money types: cash, valbank, rhobank, blkbank, armbank, bloodmoney (fara bank legacy).
8. Loop-uri cu Wait controlat; fara while true cu Wait(0) permanent.
9. Reason clar la tranzactii/logs pentru audit.

## 4) Scope strict (fara extra)

- Daca user cere doar NPC, modifica doar NPC (config/client/server strict necesar).
- Daca user cere doar blip/nume, modifica doar blip/nume.
- Nu adauga sisteme necerute (economy, inventory, commands, dependencies).

## 5) Cum alegi functii/native

- Cauta intai in `RSG_UNIFIED_NATIVE_FUNCTIONS.md`.
- Pentru lookup exact foloseste `RSG_UNIFIED_FUNCTION_NATIVE_INDEX.json`.
- Daca exista model in repo-uri scanate, adapteaza acel model; nu inventa flow nou.

## 6) Checklist final

- [ ] scope respectat exact
- [ ] server validation completa
- [ ] config curat + comentarii inline
- [ ] locale ro fara diacritice
- [ ] cleanup corect la unload/stop
- [ ] fara reward pe client
