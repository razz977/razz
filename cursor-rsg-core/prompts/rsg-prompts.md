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

