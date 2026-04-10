# RSG UNIFIED REGULATION (SIMPLIFIED)

Acesta este regulamentul unic simplificat pentru generarea scripturilor noi RSG.

## 1) Fisiere unice de referinta

1. `RSG_UNIFIED_REGULATION.md` (acest fisier)
2. `RSG_UNIFIED_NATIVE_FUNCTIONS.md` (native + functii)
3. `RSG_UNIFIED_FUNCTION_NATIVE_INDEX.json` (index complet)

## 2) Structura obligatorie pentru script nou

- `fxmanifest.lua` (root)
- `config.lua` (root)
- `client/client.lua`
- `server/server.lua`
- `locales/ro.lua`

Reguli config/locale:
- fiecare setare configurabila are comentariu inline pe acelasi rand
- config ordonat pe sectiuni clare (General, NPC/Locations, Jobs, Economy, Security, UI/Blips, Debug)
- toate textele user-facing in `locales/ro.lua` fara diacritice

## 3) Reguli tehnice obligatorii

1. Server-first validation pentru bani/iteme/permissions/distance.
2. Nu procesa reward money/item pe client.
3. Pentru request-response foloseste callbacks; pentru one-way foloseste events.
4. Foloseste StateBags pentru status live (evita event spam).
5. Respecta lifecycle: OnPlayerLoaded init, OnPlayerUnload cleanup.
6. Transactions order: validate -> remove cost -> add reward -> rollback daca esueaza.
7. Money types: cash, valbank, rhobank, blkbank, armbank, bloodmoney (fara bank legacy).
8. Loop-uri cu Wait controlat; fara while true agresiv cu Wait(0) permanent.
9. Log reason clar la actiuni sensibile.

## 4) Regula de scope strict (cerinte punctuale)

- Daca user cere doar NPC, modifica doar ce tine de NPC.
- Daca user cere doar blip/nume, modifica doar blip/nume.
- Nu adauga sisteme necerute (economy, inventory, commands, dependencies).

## 5) Cum alegi functiile/nativele

- Cauta intai in `RSG_UNIFIED_NATIVE_FUNCTIONS.md`.
- Daca nu e clar, lookup exact in `RSG_UNIFIED_FUNCTION_NATIVE_INDEX.json`.
- Daca exista deja model in repo-uri scanate, adapteaza acel model; nu inventa flow nou.

## 6) Checklist inainte de final

- [ ] scope respectat exact
- [ ] server validation completa
- [ ] config curat + comentarii inline
- [ ] locale ro fara diacritice
- [ ] cleanup corect la onResourceStop / unload
- [ ] fara money/item reward pe client
