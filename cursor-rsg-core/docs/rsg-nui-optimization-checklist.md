# RSG + NUI optimization checklist

Use this as a pre-release checklist before deploying a RedM resource.

## Server authority and security

- All rewards, inventory changes, money changes, and progression logic run on server side
- Every net event validates `source` and expected payload shape
- No trusted client values for item count, currency, or permission level
- Rate limiting or cooldowns are enforced server side for spam-prone events

## RSG compatibility

- `dependency 'rsg-core'` present in `fxmanifest.lua`
- Core object loaded with `exports['rsg-core']:GetCoreObject()`
- Event names are resource-prefixed (`resource:server:action`, `resource:client:action`)
- Script paths follow stable layout (`config.lua`, `client/*.lua`, `server/*.lua`)

## NUI integration

- `ui_page` and `files` are correctly declared in `fxmanifest.lua`
- `SetNuiFocus` is set only when needed and always released on close
- NUI callbacks validate input before invoking server events
- Any sensitive action from NUI is revalidated server side
- NUI messages are minimal and avoid high-frequency spam

## Performance

- No unnecessary `Wait(0)` loops
- Long-running loops use adaptive waits or event-driven logic
- Expensive native calls are cached where safe
- Client ticks are split by responsibility (UI, markers, interactions)
- Frequent database operations are batched or throttled

## Reliability

- Resource handles cleanup in `onResourceStop` (NUI focus, entities, blips)
- Nil guards added around player/core objects
- Server logs include enough context for troubleshooting
- Configurable values are in `config.lua` (not hardcoded in logic)
