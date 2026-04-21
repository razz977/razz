# Memory operativ - Scripturi RedM premium (Rex style)

Acest fisier este referinta rapida pentru orice dezvoltare sau modificare de script.
Scopul este consistenta intre scripturi, eliminarea codului vechi si implementare curata.

---

## 1) Principii fixe

- Server-authoritative: orice logica critica se valideaza pe server.
- Config-first: in `shared/config.lua` exista doar configurari si toate valorile variabile se seteaza de acolo.
- Locale-first: toate textele stau in `locales/ro.json` (romana fara diacritice).
- Refactor continuu: la fiecare modificare se elimina codul vechi/nefolositor dupa verificare referinte.
- Zero modificari colaterale: schimbi strict ce s-a cerut.

---

## 2) Structura de baza

```text
resource-name/
├── fxmanifest.lua
├── client/
│   ├── client.lua
│   └── modules/*.lua
├── server/
│   ├── server.lua
│   └── modules/*.lua
├── shared/
│   ├── config.lua
│   └── cleanup.lua
├── locales/
│   └── ro.json
└── installation/
```

---

## 3) Config only policy

In `shared/config.lua` sunt permise doar:

- flags (`true/false`);
- nume item/job/grade;
- coordonate;
- timers/cooldown/durations;
- distante/radius;
- sanse/procente;
- preturi/reward ranges;
- modele/animatii/scenario;
- blip/ui settings;
- mapari de keybind-uri;
- toggles framework integration.

Nu pui in config:

- logica operationala;
- functii de business;
- event handlers;
- query-uri SQL hardcoded in afara contextului de setari.

---

## 4) Checklist la fiecare modificare (obligatoriu)

1. Confirm cerinta exacta.
2. Caut functiile legate de flow-ul modificat.
3. Elimin codul vechi/nefolositor (dead code) care ramane dupa schimbare.
4. Verific sa nu existe notificari hardcodate ramase.
5. Mut in config orice valoare noua configurabila.
6. Verific cleanup pentru entities/blips/prompts/NUI focus.
7. Rulez validare finala pe side-effects.

---

## 5) Pattern de curatare cod vechi

- Daca o functie nu mai este apelata, o stergi.
- Daca un event nu mai este folosit, il stergi.
- Daca un config key nu mai este citit in cod, il stergi.
- Daca exista duplicate de logica, pastrezi o singura varianta clara.
- Daca ramas fallback inutil dupa refactor, il elimini.

Nota:
Stergerea se face doar dupa verificare de referinte ca sa nu rupi flow-ul activ.

---

## 6) Pachet minim pentru script premium

- structura modulata client/server/shared;
- config complet, fara hardcoding;
- locale complet in ro fara diacritice;
- validari server complete;
- performanta optimizata (`Wait`, dynamic sleep, fara spam events);
- cleanup corect la resource stop;
- cod curat, fara legacy nefolositor.

