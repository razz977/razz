## Prompturi utile pentru Cursor (RSG / RedM)

### 1) Scaffold complet

```
Genereaza un resource RedM numit "rsg-hunting" folosind rsg-core.
Structura obligatorie: fxmanifest.lua, config.lua, client/main.lua, server/main.lua.
Foloseste best practices de validare pe server si evenimente prefixate cu numele resursei.
```

### 2) Sistem job simplu

```
Creeaza un sistem simplu pentru job-ul hunter in RSG:
- comanda /start_hunt
- cooldown configurabil in config.lua
- reward dat doar de server dupa validare
- notificari client curate
```

### 3) Refactor pe securitate

```
Refactorizeaza acest script RSG ca sa fie server-authoritative:
- elimina logica sensibila de pe client
- valideaza source, iteme, sume si distante pe server
- pastreaza compatibilitatea cu rsg-core
```

### 4) Optimizare performanta

```
Optimizeaza scriptul RedM de mai jos:
- evita loop-uri cu Wait(0) cand nu sunt necesare
- foloseste cache pentru datele playerului unde are sens
- separa clar logica client/server
```

### 5) RSG + NUI complet

```
Genereaza un resource RedM numit "rsg-ui-jobs" cu rsg-core si NUI complet:
- fxmanifest.lua cu `games { 'rdr3' }` si fisierele ui/*
- html/ui/index.html, style.css, app.js
- client/main.lua pentru deschidere/inchidere NUI, SetNuiFocus, SendNUIMessage
- server/main.lua server-authoritative (validare source si date)
- callback NUI -> client -> server cu validare stricta
- config.lua pentru toggle debug, keybind si limite

Conditii:
- fara logică sensibila in NUI/client
- explica pe scurt ce ai validat pe server
```

### 6) Native lookup driven coding

```
Vreau sa folosesti native RDR3 relevante pentru un sistem de interactiune:
1) listeaza nativele propuse (nume + rol)
2) apoi genereaza implementarea finala in resource RSG
3) include fallback-uri daca un native nu returneaza date valide
4) optimizeaza tick-urile pentru performanta stabila
```

