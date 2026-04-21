# Regulament complet pentru scripturi RedM (Rex style + CFX Developer Tools)

## 1) Scop

Acest regulament este standardul obligatoriu pentru fiecare script nou sau modificat.

Obiective:

- structura de proiect tip RexShackGaming;
- cod performant, sigur, modular si usor de mentinut;
- integrare prioritara cu `rsg-core` si suport optional `vorp_core`;
- localizare 100% in `locales/ro.json` (romana fara diacritice);
- proces de lucru complet, bazat pe bune practici din CFX-Developer-Tools;
- utilizare corecta a tuturor categoriilor de natives RedM relevante.

---

## 2) Surse obligatorii folosite pentru acest standard

Acest regulament combina informatii din:

- repository-uri RexShackGaming (structura si flow practic de resource RedM);
- CFX-Developer-Tools:
  - 9 skills;
  - 6 rules;
  - 24 snippets;
  - 11 templates;
  - baza de natives RDR3 (5875 natives, 84 categorii);
  - baza de events (101 evenimente);
  - standarde manifest, performanta, securitate, state bags, NUI, DB.

---

## 3) Structura obligatorie a scriptului (model Rex)

```text
my-script/
├── fxmanifest.lua
├── client/
│   ├── client.lua
│   ├── npcs.lua                 # optional
│   ├── prompts.lua              # optional
│   └── modules/*.lua            # optional
├── server/
│   ├── server.lua
│   └── modules/*.lua            # optional
├── shared/
│   ├── config.lua               # obligatoriu
│   └── cleanup.lua              # obligatoriu daca scriptul creeaza entities/props/blips
├── locales/
│   └── ro.json                  # obligatoriu
├── installation/                # optional
│   ├── shared_items.lua
│   ├── shared_jobs.lua
│   └── database.sql
└── README.md
```

Reguli:

- Nu hardcoda in cod: coords, iteme, joburi, preturi, durate, sanse.
- Tot ce este configurabil merge in `shared/config.lua`.
- Daca fisierul devine mare, separa in module pe responsabilitati.
- Daca scriptul creeaza resurse runtime, cleanup la stop este obligatoriu.

---

## 4) Manifest standard (Rex + CFX)

Template recomandat pentru script nou RedM:

```lua
fx_version 'cerulean'
games { 'rdr3' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name 'my-script'
author 'YourName/Team'
description 'Short script description'
version '1.0.0'
repository 'https://github.com/your/repo'

dependencies {
    'rsg-core',
    'ox_lib'
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

files {
    'locales/*.json'
}
```

Note:

- Pentru scripturi noi nu se foloseste `lua54 'yes'` (deprecated in standardele CFX moderne).
- Pentru scripturi Rex legacy, se poate pastra doar daca proiectul existent il foloseste deja.
- Daca exista NUI, adaugi `ui_page` + toate fisierele in `files`.
- Daca exista DB, adaugi `@oxmysql/lib/MySQL.lua` in `server_scripts`.

---

## 5) Localizare obligatorie (cerinta fixa)

La orice script nou se creeaza:

`locales/ro.json`

Conditii obligatorii:

- limba romana fara diacritice;
- toate notificarile, prompt-urile, meniurile, erorile, textele UI sunt in locale;
- in cod nu se lasa texte hardcodate, doar chei locale;
- orice text nou trebuie adaugat in `locales/ro.json`.

Exemplu:

```json
{
  "notify_success_action": "Actiune efectuata cu succes",
  "notify_error_no_item": "Nu ai itemul necesar",
  "prompt_press_e": "Apasa [E] pentru interactiune",
  "error_generic": "A aparut o eroare"
}
```

---

## 6) Arhitectura client-server obligatorie

Reguli:

- Prefix evenimente: `resourceName:eventName`.
- Serverul este autoritate finala (inventory, rewards, bani, validari).
- In server event:
  - prima linie: `local src = source`;
  - validezi toate argumentele (tip, range, whitelist);
  - verifici player-ul inainte de orice logica.
- Request/response se face prin callback pattern.
- Pentru stare persistenta se prefera State Bags, nu spam de net events.

Framework policy:

- prioritar RSG: `exports['rsg-core']:GetCoreObject()`;
- optional VORP: `exports.vorp_core:GetCore()`;
- adaptoare separate pentru RSG/VORP (fara amestec haotic de API).

---

## 7) Standard complet CFX-Developer-Tools de aplicat

### 7.1 Skills care trebuie avute in vedere

1. Resource Scaffolding
2. Native Functions
3. fxmanifest
4. Client-Server Patterns
5. Framework Detection
6. Performance Optimization
7. NUI Development
8. Database Integration
9. State Bags

Regula: cand construiesti un script nou, tratezi aceste 9 puncte ca checklist obligatoriu.

### 7.2 Rules care trebuie respectate

1. CFX Lua conventions
2. CFX JavaScript conventions (daca exista JS)
3. CFX C# conventions (daca exista C#)
4. fxmanifest standards
5. Security best practices
6. Performance rules

### 7.3 Snippets standard de referinta

Lua snippets utile:

- client-event
- server-event
- thread-loop
- register-command
- nui-callback
- export-function
- config-template
- state-bag-entity
- state-bag-player
- state-bag-handler
- backtick-hash
- routing-bucket
- variable-attributes
- ace-permissions

Regula: pornesti de la pattern-uri validate, nu de la cod improvizat.

---

## 8) Natives RedM - proces complet ("tot, tot")

## 8.1 Surse obligatorii natives

- `mcp-server/data/natives_rdr3.json` (CFX-Developer-Tools): 5875 natives, 84 categorii;
- https://rdr3natives.com/;
- https://docs.fivem.net/natives/.

## 8.2 Reguli tehnice natives

- Nu amesteci side-uri (client/server/shared).
- Pentru string literal hashes in Lua folosesti backtick compile-time.
- `GetHashKey()` doar cand hash-ul este dinamic, apoi cache-uiesti rezultatul.
- Orice entity/prop creat prin native trebuie sters la `onResourceStop`.
- Pentru native neclar, validezi semnatura (params/return/side) inainte de implementare.

## 8.3 Native coverage checklist pe feature

La fiecare feature nou, documentezi intern minim:

- native name;
- hash;
- side (client/server/shared);
- scopul in feature;
- validari necesare;
- fallback (daca native-ul esueaza).

## 8.4 Categorii RDR3 native (84) care trebuie luate in calcul

- AICOVERPOINT
- AITRANSPORT
- ANIMSCENE
- ATTRIBUTE
- AUDIO
- BADSPORT
- BOUNTY
- BRAIN
- BUILTIN
- CAM
- CFX
- CLOCK
- COLLECTION
- COMPANION
- COMPENDIUM
- CREW
- DATABINDING
- DATAFILE
- DEBUG
- DECORATOR
- DLC
- ENTITY
- EVENT
- FIRE
- FLOCK
- GANG
- GOOGLE_ANALYTICS
- GRAPHICS
- HUD
- IK
- INTERACTION
- INTERIOR
- INVENTORY
- ITEMDATABASE
- ITEMSET
- LAW
- LOCALIZATION
- MAP
- MINIGAME
- MISC
- MISSIONDATA
- MONEY
- NETSHOPPING
- NETWORK
- OBJECT
- PAD
- PATHFIND
- PED
- PERSCHAR
- PERSISTENCE
- PHYSICS
- PLAYER
- POPULATION
- POSSE
- PROPSET
- QUEUE
- RECORDING
- REPLAY
- SAVE
- SCRIPTS
- SHAPETEST
- SOCIALCLUB
- SOCIALCLUBFEED
- SPACTIONPROXY
- STATS
- STREAMING
- TASK
- TELEMETRY
- TXD
- UIAPPS
- UIDEBUG
- UIEVENTS
- UIFEED
- UILOG
- UIPINNING
- UISTATEMACHINE
- UISTICKYFEED
- UITUTORIAL
- UNLOCK
- VEHICLE
- VOLUME
- WATER
- WEAPON
- ZONE

Regula: nu inseamna ca folosesti toate categoriile in orice script, dar verifici categoriile relevante pentru fiecare feature.

---

## 9) Performanta (obligatoriu)

Reguli ferme:

- orice `while true` are `Wait(...)`;
- `Wait(0)` doar pentru draw/per-frame input;
- folosesti `#(a - b)` pentru distante;
- eviti event spam;
- rate limiting pe server;
- fara thread-uri inutile;
- `CreateThread`/`Wait`, nu `Citizen.CreateThread`/`Citizen.Wait`;
- target `resmon`: sub 0.2ms idle;
- cleanup complet pe stop resource.

Pattern recomandat: dynamic sleep bazat pe distanta/relevanta.

---

## 10) Securitate (obligatoriu)

- never trust client;
- validare completa in server handlers;
- capturezi `source` imediat;
- verifici owner/permisiuni/job/item/cooldown;
- comenzi sensibile cu restricted/ACE;
- fara credientiale in resource files;
- query-uri SQL doar parametrizate;
- fara `ExecuteCommand` pe input user nesanitizat.

---

## 11) State Bags (obligatoriu pentru state persistent)

Folosesti:

- `Entity(...).state` pentru entitati;
- `Player(source).state` pentru player state;
- `GlobalState` pentru server-wide state.

Reguli:

- nume de chei namespaced (`myresource:key`);
- nu folosi state bags pentru update per-frame;
- nu te baza pe client-replicated state pentru logica critica;
- folosesti change handlers unde ai nevoie de reactii automate.

---

## 12) Database standard (cand scriptul cere persistenta)

Standard DB:

- `oxmysql` (nu mysql-async/ghmattimysql in script nou);
- query-uri parametrizate;
- folosesti `MySQL.query.await`, `MySQL.single.await`, `MySQL.scalar.await`, `MySQL.insert.await`, `MySQL.update.await`;
- index pe coloanele frecvent cautate;
- migration files versionate.

---

## 13) NUI standard (daca scriptul are UI)

Obligatoriu:

- `ui_page` declarat;
- toate asset-urile in `files`;
- `SendNUIMessage` pentru push de date;
- `RegisterNUICallback` pentru raspunsuri din UI;
- `SetNuiFocus(false, false)` la inchidere si `onResourceStop`.

---

## 14) Regulament strict pentru modificare script existent (cerinta fixa)

La modificare:

1. Analizezi exact ce s-a cerut.
2. Modifici strict ce s-a cerut.
3. Nu introduci schimbari colaterale.
4. Elimini functiile vechi/nefolositoare dupa verificare de referinte.
5. Pastrezi compatibilitatea flow-ului existent.
6. Actualizezi config/locale daca e necesar.
7. Verifici ca nu raman notificari hardcodate.

Checklist obligatoriu:

- [ ] Cerinta implementata 1:1
- [ ] Zero schimbari necerute
- [ ] Dead code eliminat
- [ ] Toate textele sunt in `locales/ro.json`
- [ ] Cleanup complet pe stop resource
- [ ] Event names prefixed corect
- [ ] Validari server complete

---

## 15) Workflow complet pentru script nou (de urmat mereu)

1. Definesti cerintele feature-ului.
2. Alegi framework-ul (`rsg-core` prioritar).
3. Scaffolding structura Rex.
4. Scrii `fxmanifest.lua` corect.
5. Definesti `shared/config.lua`.
6. Creezi `locales/ro.json` si pui toate textele.
7. Implementezi server logic (validari + autoritate).
8. Implementezi client logic (UX, prompt-uri, animatii).
9. Alegi natives corecte (side + categorie + cleanup).
10. Optimizezi loop-uri/events/memorie.
11. Testezi restart resource + edge cases.
12. Cureti codul mort.
13. Rulezi checklist-ul de calitate.

---

## 16) Definitia de "script gata de productie"

Scriptul este gata doar daca:

- respecta structura Rex;
- respecta regulile CFX de manifest, performanta si securitate;
- are locale `ro.json` complet (fara diacritice);
- este server-authoritative;
- foloseste corect natives pentru RedM;
- nu contine cod mort;
- nu are hardcoding inutil;
- este stabil la restart resource;
- este usor de extins si mentinut.

Acesta este standardul complet pentru a face scripturi RedM cat mai bune, bine structurate, functionale si optimizate.
