# RSG DOCS REGULAMENT SUPLIMENTAR (din rsg-docs)

Sursa analizata: `https://github.com/Rexshack-RedM/rsg-docs`
Fisiere mdx analizate: **33**

Index complet cu extrageri: `RSG_DOCS_AUDIT_INDEX.json`

## 1) Reguli tehnice consolidate

1. Server-first pentru logic sensibila (money/item/permissions) - nu tranzactiona pe client.
2. Callback-uri pentru request-response; events pentru one-way communication.
3. Pentru money foloseste tipurile moderne (cash/valbank/rhobank/blkbank/armbank/bloodmoney), evita bank legacy.
4. Pentru inventory foloseste exports oficiale (`HasItem`, `CanAddItem`, `AddItem`, `RemoveItem`) cu validare prealabila.
5. Pentru status live foloseste StateBags (`LocalPlayer.state`, `Player(source).state`) + change handlers.
6. Pentru interactiuni lume foloseste prompturi native RSG sau ox_target, cu cleanup corect.
7. Respecta lifecycle events (`OnPlayerLoaded`, `OnPlayerUnload`) pentru init/cleanup.
8. Performance: local vars/functions, loop-uri controlate cu Wait dinamic, evita callback/event spam.
9. Input validation strict: tipuri, range, existenta entitati/player, permission checks.
10. Foloseste reasons explicite la tranzactii pentru audit/logging.

## 2) Mapa sectiuni -> fisiere relevante

### security
- `MiscGuides.mdx`
- `api-reference/endpoint/clienteventreference.mdx`
- `api-reference/endpoint/oxlibreference.mdx`
- `api-reference/endpoint/oxtargetreference.mdx`
- `api-reference/endpoint/playerinformationreference.mdx`
- `api-reference/endpoint/servereventreference.mdx`
- `development.mdx`
- `essentials/callbacks.mdx`
- `essentials/commands.mdx`
- `essentials/money-system.mdx`
- `essentials/playerdata.mdx`
- `inventory/functions.mdx`
- `inventory/metaitems.mdx`
- `inventory/overview.mdx`
- `lua-reference/events.mdx`
- `lua-reference/patterns.mdx`

### performance
- `api-reference/endpoint/clienteventreference.mdx`
- `api-reference/endpoint/clientfunctionreference.mdx`
- `api-reference/endpoint/oxlibreference.mdx`
- `api-reference/endpoint/oxtargetreference.mdx`
- `api-reference/endpoint/playerinformationreference.mdx`
- `api-reference/endpoint/servereventreference.mdx`
- `api-reference/endpoint/serverfunctionreference.mdx`
- `development.mdx`
- `essentials/callbacks.mdx`
- `essentials/configuration.mdx`
- `essentials/playerdata.mdx`
- `essentials/prompts.mdx`
- `essentials/reputation.mdx`
- `essentials/statebags.mdx`
- `inventory/item-decay.mdx`
- `inventory/metaitems.mdx`
- `inventory/overview.mdx`
- `inventory/weapons.mdx`
- `lua-reference/events.mdx`
- `lua-reference/luabegining.mdx`
- `lua-reference/patterns.mdx`
- `lua-reference/threads.mdx`

### callbacks
- `api-reference/endpoint/clientfunctionreference.mdx`
- `api-reference/endpoint/servereventreference.mdx`
- `api-reference/endpoint/serverfunctionreference.mdx`
- `essentials/callbacks.mdx`
- `essentials/prompts.mdx`
- `inventory/metaitems.mdx`
- `inventory/weapons.mdx`
- `lua-reference/events.mdx`

### events
- `api-reference/endpoint/clienteventreference.mdx`
- `api-reference/endpoint/clientfunctionreference.mdx`
- `api-reference/endpoint/oxlibreference.mdx`
- `api-reference/endpoint/oxtargetreference.mdx`
- `api-reference/endpoint/playerinformationreference.mdx`
- `api-reference/endpoint/servereventreference.mdx`
- `development.mdx`
- `essentials/callbacks.mdx`
- `essentials/commands.mdx`
- `essentials/money-system.mdx`
- `essentials/playerdata.mdx`
- `essentials/prompts.mdx`
- `essentials/reputation.mdx`
- `essentials/sharedexports.mdx`
- `essentials/statebags.mdx`
- `inventory/functions.mdx`
- `inventory/item-decay.mdx`
- `inventory/metaitems.mdx`
- `inventory/overview.mdx`
- `inventory/weapons.mdx`
- `lua-reference/events.mdx`
- `lua-reference/luabegining.mdx`
- `lua-reference/patterns.mdx`
- `lua-reference/threads.mdx`

### money
- `api-reference/endpoint/clientfunctionreference.mdx`
- `api-reference/endpoint/playerinformationreference.mdx`
- `api-reference/endpoint/servereventreference.mdx`
- `essentials/callbacks.mdx`
- `essentials/commands.mdx`
- `essentials/configuration.mdx`
- `essentials/money-system.mdx`
- `essentials/playerdata.mdx`
- `essentials/reputation.mdx`
- `essentials/shared.mdx`
- `inventory/functions.mdx`
- `inventory/item-decay.mdx`
- `inventory/metaitems.mdx`
- `inventory/weapons.mdx`
- `lua-reference/events.mdx`
- `lua-reference/patterns.mdx`

### inventory
- `api-reference/endpoint/clientfunctionreference.mdx`
- `api-reference/endpoint/oxtargetreference.mdx`
- `api-reference/endpoint/playerinformationreference.mdx`
- `api-reference/endpoint/servereventreference.mdx`
- `api-reference/endpoint/serverfunctionreference.mdx`
- `essentials/callbacks.mdx`
- `essentials/commands.mdx`
- `essentials/configuration.mdx`
- `essentials/money-system.mdx`
- `essentials/playerdata.mdx`
- `essentials/reputation.mdx`
- `essentials/shared.mdx`
- `essentials/sharedexports.mdx`
- `essentials/statebags.mdx`
- `inventory/functions.mdx`
- `inventory/item-decay.mdx`
- `inventory/metaitems.mdx`
- `inventory/overview.mdx`
- `inventory/weapons.mdx`
- `lua-reference/events.mdx`
- `lua-reference/patterns.mdx`
- `lua-reference/threads.mdx`

### statebags
- `api-reference/endpoint/serverfunctionreference.mdx`
- `development.mdx`
- `essentials/playerdata.mdx`
- `essentials/reputation.mdx`
- `essentials/statebags.mdx`

### prompts
- `api-reference/endpoint/clienteventreference.mdx`
- `essentials/prompts.mdx`
- `lua-reference/patterns.mdx`

### commands
- `MiscGuides.mdx`
- `api-reference/endpoint/clienteventreference.mdx`
- `api-reference/endpoint/clientfunctionreference.mdx`
- `api-reference/endpoint/oxlibreference.mdx`
- `api-reference/endpoint/oxtargetreference.mdx`
- `api-reference/endpoint/playerinformationreference.mdx`
- `api-reference/endpoint/servereventreference.mdx`
- `api-reference/endpoint/serverfunctionreference.mdx`
- `essentials/callbacks.mdx`
- `essentials/commands.mdx`
- `essentials/configuration.mdx`
- `essentials/installation.mdx`
- `essentials/linuxinstall.mdx`
- `essentials/money-system.mdx`
- `essentials/playerdata.mdx`
- `essentials/reputation.mdx`
- `essentials/shared.mdx`
- `essentials/statebags.mdx`
- `inventory/functions.mdx`
- `inventory/item-decay.mdx`
- `inventory/metaitems.mdx`
- `inventory/overview.mdx`
- `inventory/weapons.mdx`
- `lua-reference/events.mdx`
- `lua-reference/luabegining.mdx`
- `lua-reference/patterns.mdx`
- `lua-reference/threads.mdx`
- `quickstart.mdx`

### structure
- `essentials/commands.mdx`
- `essentials/configuration.mdx`
- `essentials/money-system.mdx`
- `essentials/prompts.mdx`
- `essentials/shared.mdx`
- `inventory/item-decay.mdx`
- `inventory/metaitems.mdx`
- `inventory/overview.mdx`
- `inventory/weapons.mdx`
- `lua-reference/luabegining.mdx`
- `lua-reference/threads.mdx`
- `quickstart.mdx`

## 3) Practica obligatorie la generare scripturi noi

- Inainte de implementare, identifica modelul cel mai apropiat in indexurile RSG existente.
- Daca userul cere schimbare punctuala (ex: NPC/blip), aplica scope strict fara functionalitati extra.
- In `config.lua`, fiecare setare are comentariu inline si ordonare pe sectiuni.
- Toate textele player-facing in `locales/ro.lua` fara diacritice.

