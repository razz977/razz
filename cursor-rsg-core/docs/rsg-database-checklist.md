# RSG database checklist (oxmysql)

Use this before deploying scripts that persist data.

## Prerequisites

- `oxmysql` installed and ensured before your resource
- `mysql_connection_string` set in `server.cfg`
- `@oxmysql/lib/MySQL.lua` included in `server_scripts`

## Query safety

- All queries use placeholders (`?`) and parameter arrays
- No SQL string concatenation with player-provided values
- Input is validated server side before DB writes

## Schema quality

- Primary keys and unique keys defined where needed
- Indexed fields for frequent lookups (identifier, owner, job)
- JSON columns used only for flexible metadata, not core indexed fields

## Performance

- Avoid repeated identical queries in tight loops
- Use `single`/`scalar` when only one row/value is needed
- Add `LIMIT 1` for single-record lookups
- Batch or throttle spam-prone writes (logs, telemetry, UI spam)

## Consistency and reliability

- Multi-step critical operations use transactions
- Errors from queries are logged with useful context
- Default values exist for non-null columns
- Migration files are versioned and replay-safe
