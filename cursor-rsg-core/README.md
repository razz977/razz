## Cursor RSG Core (RedM) - Minimal Pack

Acest pachet este minimul util pentru a lucra bine cu scripturi RSG in Cursor, fara sa incarci tot repository-ul CFX-Developer-Tools.

### Ce contine

- `.cursorrules` - reguli dedicate RedM + rsg-core
- `templates/rsg/fxmanifest.lua` - manifest de baza pentru RSG
- `templates/rsg/client/main.lua` - schelet client
- `templates/rsg/server/main.lua` - schelet server
- `prompts/rsg-prompts.md` - prompt-uri gata de folosit in Cursor

### Ai nevoie de toate fisierele din repo-ul original?

Nu. Pentru a scrie scripturi bune pe **RSG**, ai nevoie in principal de:

1. un template corect de resource
2. reguli bune de generatie cod
3. prompt-uri clare pentru AI

Restul (MCP server complet, skill-uri pentru alte framework-uri, template-uri FiveM) sunt utile, dar optionale pentru fluxul strict RSG.

### Cum folosesti rapid

1. Deschide acest workspace in Cursor.
2. Cere in chat:
   - "Genereaza un resource RedM numit `rsg-hunting` folosind rsg-core, cu config/client/server."
3. Copiaza resursa rezultata in server-ul tau RedM si adauga `ensure rsg-hunting` in `server.cfg`.
