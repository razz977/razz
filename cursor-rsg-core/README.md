## Cursor RSG Core (RedM) - Full Native Pack

Acest pachet este varianta completa pentru Cursor daca vrei sa generezi scripturi RSG optimizate, inclusiv NUI si cautare in baza de natives.

### Ce contine

- `.cursorrules` - reguli dedicate RedM + rsg-core
- `templates/rsg/fxmanifest.lua` - manifest de baza pentru RSG
- `templates/rsg/client/main.lua` - schelet client
- `templates/rsg/server/main.lua` - schelet server
- `prompts/rsg-prompts.md` - prompt-uri gata de folosit in Cursor
- `.cursor/mcp.json` - configurare MCP pentru Cursor
- `mcp-server/` - server MCP local cu tools pentru scaffolding, manifest, events, docs, framework detect
- `mcp-server/data/natives_rdr3.json` - baza de native-uri RDR3 (plus alte date utile)
- `skills/` - skill-uri utile pentru native lookup, NUI, client-server, performanta, framework detect, fxmanifest
- `rules/` - reguli de securitate, performanta, manifest si conventii Lua

### Ce iti ofera concret pentru RSG

1. Lookup rapid de native-uri RDR3 direct din AI
2. Structura corecta pentru resource-uri RSG
3. Best practices de securitate server-side
4. Guidance pentru NUI + comunicare client/server
5. Reguli de performanta pentru scripturi mai stabile

### Setup rapid in Cursor

1. Deschide folderul `cursor-rsg-core` in Cursor.
2. Instaleaza dependentele MCP:
   - `cd mcp-server`
   - `pip install -r requirements.txt`
3. Reincarca Cursor. MCP server-ul va porni automat cand tool-urile sunt invocate.

### Prompt recomandat pentru inceput

```text
Genereaza un resource RedM numit "rsg-hunting" pentru rsg-core, cu NUI complet.
Include:
- fxmanifest.lua corect pentru rdr3
- config.lua
- client/main.lua
- server/main.lua
- html/ui + js + css pentru NUI
- validari server-side pentru toate reward-urile
- optimizari de performanta (fara loop-uri inutile)
- evenimente prefixate cu numele resursei
```
