# Uninstall

```bash
bash ./uninstall-daiana.sh
bash ./uninstall-daiana.sh --purge
```

## Default behavior
- removes `.env`
- updates `.env.old` with the current config
- keeps `.env.old` for reinstall reuse
- keeps volumes/data
- stops/removes project containers and network

## Full purge
- removes `.env`
- removes `.env.old`
- removes data volumes
- removes project containers and network

## Reinstall
If `.env` is missing and `.env.old` exists, install restores from `.env.old` first.
If neither exists, it falls back to `.env.example`.
