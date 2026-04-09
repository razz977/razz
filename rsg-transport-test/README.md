# rsg-transport-test

Resource demo pentru test transport in stil RSG.

## Ce face

- NPC de start cu interactiune prin `ox_target`
- Start cursa -> destinatie random din config
- Spawn caruta la start cu model din config
- Spawn props in caruta (cutii etc.) din config
- Setare ruta GPS pe minimap catre destinatie
- La destinatie: payout bani + cleanup (despawn caruta + props + blip)

## Structura

- `fxmanifest.lua`
- `config.lua`
- `client/client.lua`
- `server/server.lua`
- `locales/ro.lua`

## Dependinte

- `rsg-core`
- `ox_target`
- `ox_lib`

## Instalare

1. Copiaza folderul `rsg-transport-test` in resources.
2. Adauga in `server.cfg`:

```cfg
ensure rsg-transport-test
```

3. Porneste/restart resource.

## Configurare rapida

- `Config.Npc` -> model/coords/target label
- `Config.Wagon` -> model caruta + spawn + props atasate
- `Config.TransportRun.Destinations` -> locatii random de livrare
- `Config.TransportRun.Reward` -> bani min/max + money type
- `Config.Blip` -> blip NPC + blip destinatie + ruta GPS

## Note

- Validarea finala este pe server (distanta fata de NPC, job permis, distanta fata de destinatie + cursa activa).
- Text locale in romana este fara diacritice, conform regulii.
