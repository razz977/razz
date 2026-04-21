# Regulament pentru creare/modificare scripturi RedM (standard Rex + CFX)

## 1) Scop

Acest regulament defineste standardul obligatoriu pentru scripturile RedM:

- structura de proiect tip RexShackGaming;
- cod optimizat, curat, sigur si usor de mentinut;
- compatibilitate prioritara cu `rsg-core`, cu posibilitate de adaptare pentru `vorp_core`;
- localizare centralizata in `locales/ro.json` (romana fara diacritice);
- modificari strict la cerinta, fara schimbari colaterale.

---

## 2) Structura obligatorie a scriptului (model Rex)

Orice script nou trebuie sa respecte structura:

```text
my-script/
├── fxmanifest.lua
├── client/
│   ├── client.lua
│   ├── npcs.lua                 # optional, daca exista NPC logic
│   └── modules/*.lua            # optional, pe feature-uri
├── server/
│   ├── server.lua
│   ├── versionchecker.lua       # recomandat, dupa model Rex
│   └── modules/*.lua            # optional, pe feature-uri
├── shared/
│   ├── config.lua
│   └── cleanup.lua              # obligatoriu daca scriptul creeaza entitati/props persistente
├── locales/
│   └── ro.json                  # obligatoriu
├── installation/                # optional (items/jobs/sql)
│   ├── shared_items.lua
│   ├── shared_jobs.lua
│   └── database.sql
└── README.md                    # recomandat
```

Reguli:

- Nu hardcoda valori importante in client/server (coords, iteme, joburi, timpi, preturi) -> merg in `shared/config.lua`.
- Split pe module daca fisierul depaseste complexitatea acceptata (single-responsibility).
- Daca exista props/blips/entities create runtime, trebuie mecanism de cleanup.

---

## 3) Manifest standard (Rex style + CFX best practices)

Template de baza pentru RedM + RSG:

```lua
fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name 'my-script'
author 'YourName/Team'
description 'Short script description'
version '1.0.0'
url 'https://discord.gg/yourdiscord'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    -- 'shared/cleanup.lua', -- daca este folosit
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

dependencies {
    'rsg-core',
    'ox_lib'
}

files {
    'locales/*.json'
}
```

Note:

- Pentru consistenta cu multe scripturi Rex existente se poate pastra `lua54 'yes'` in proiectele legacy.
- Pentru scripturi noi, preferinta CFX actuala este sa nu depinzi de flaguri legacy inutile.
- Daca scriptul foloseste inventory/target/mysql, se declara explicit in `dependencies`.

---

## 4) Localizare obligatorie (cerinta fixa)

### Regula critica

La orice script nou se creeaza obligatoriu:

`locales/ro.json`

Conditii:

- limba romana fara diacritice;
- toate textele de notificari, meniuri, prompt-uri, erori, succes, warning trebuie sa fie in `locales/ro.json`;
- in cod nu se lasa texte hardcodate (exceptie: fallback tehnic minimal temporar);
- chei consistente, ex:
  - `notify_success_mined`
  - `notify_error_no_item`
  - `menu_open_storage`
  - `prompt_press_e`

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

## 5) Arhitectura client/server

### Obligatii

- Prefix evenimente: `resourceName:eventName` (ex: `rex-mining:server:MineReward`).
- Serverul este autoritatea finala pentru validari/reward/inventory.
- In handler server:
  - prima linie: `local src = source` (sau `local source = source`);
  - validezi parametrii (tip/range/whitelist);
  - verifici player-ul si drepturile inainte de orice actiune.
- Pentru request-response folosesti callback pattern clar.
- Pentru stare persistenta/sincronizata (nu one-shot), preferi State Bags.

### Framework policy

- Prioritar: `rsg-core` (`exports['rsg-core']:GetCoreObject()`).
- Optional suport VORP:
  - `local VORPcore = exports.vorp_core:GetCore()`
  - adaptoare separate, fara a amesteca haotic API-urile.

---

## 6) Regulament natives (RedM/CFX)

### Cerinta "toate nativele"

Setul complet de referinta obligatoriu pentru dezvoltare este:

- https://rdr3natives.com/
- https://docs.fivem.net/natives/

Regula: orice implementare trebuie sa aleaga native-ul corect ca side (client/server) si categorie.

### Reguli tehnice native

- Nu folosi native server-only pe client si invers.
- Pentru string literal hashes, preferi backtick compile-time in Lua (ex: `` `p_pickaxe01x` ``), nu `GetHashKey()` repetitiv.
- Caching pentru rezultate frecvente (ped, coords, entity handles) in loop-uri.
- Orice entity creat prin native trebuie sters pe `onResourceStop`.

### Categorii native care trebuie verificate in orice script RedM complex

- Player/Ped
- Entity/Object
- Tasks/Animation/Scenario
- Network/Event transport
- UI/Prompt/Blip/Notification
- Camera/Audio (daca feature-ul cere)
- Time/Weather (daca feature-ul cere)

---

## 7) Performanta (obligatoriu)

Reguli minime:

- Fiecare `while true` are `Wait(...)`.
- `Wait(0)` doar pentru draw/per-frame input strict necesar.
- Distante: `#(a - b)` cu vectori, nu `GetDistanceBetweenCoords`.
- Evita spam de net events (>1/s/player) fara motiv.
- Rate limiting pe server pentru actiuni exploatabile.
- Fara thread-uri inutile; thread separat doar unde aduce claritate/perf.
- Tinta idle resmon: sub `0.2ms` pentru script bine optimizat.

---

## 8) Securitate (obligatoriu)

- Never trust client.
- Verifici `source`, iteme, cantitati, stari, cooldown-uri pe server.
- Comenzile admin cu permisiuni (`restricted`/ACE).
- Nu expui logica server-only pe client.
- Fara token/parole in fisiere resource; se folosesc convars/env.
- Sanitizare la orice input care ajunge in comenzi/query-uri.

---

## 9) Regulament de modificare script existent (cerinta fixa)

La modificare:

1. Se analizeaza exact cerinta.
2. Se modifica/adauga strict ce a fost cerut.
3. Nu se introduc schimbari colaterale fara aprobare.
4. Se elimina functiile vechi/nefolositoare (dead code), dar doar dupa verificare referinte.
5. Se pastreaza compatibilitatea cu flow-ul existent.
6. Se valideaza impactul pe client/server si pe config/locale.

Checklist rapid inainte de final:

- [ ] Cerinta implementata 1:1
- [ ] Nu exista schimbari necerute
- [ ] Functiile legacy inutile eliminate
- [ ] Nicio notificare hardcodata in cod
- [ ] Toate textele sunt in `locales/ro.json`
- [ ] Cleanup complet pe stop resource

---

## 10) Standard de calitate finala

Un script este considerat gata doar daca este:

- bine structurat (Rex style);
- functional end-to-end;
- optimizat (loop-uri, natives, events, memorie);
- sigur (server authority + validari);
- localizat corect (`locales/ro.json`, romana fara diacritice);
- curat (fara cod mort, fara duplicari inutile).

---

## 11) Template minim recomandat pentru pornire rapida

1. Creezi structura de foldere din sectiunea 2.
2. Completezi `fxmanifest.lua` pe modelul de mai sus.
3. Definesti toate setarile in `shared/config.lua`.
4. Adaugi din prima `locales/ro.json` si pui acolo toate textele.
5. Construiesti logica server-first (validare + actiuni), apoi client UX.
6. Adaugi cleanup handlers si testezi resource restart.

Acesta este standardul oficial recomandat pentru scripturi RedM bine structurate si optimizate.
