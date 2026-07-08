# Daiana docs

## Lifecycle
- [Daiana lifecycle index](daiana-lifecycle.md)
- [Install](install.md)
- [Apply certificates](certs.md)
- [Update](update.md)
- [Uninstall](uninstall.md)

## Notes
- Use `install-daiana.sh` for bootstrap and `apply-certs.sh` for TLS plus post-cert env/stack refresh.
- Use `update-daiana.sh` for in-place stack updates; it can prompt for target image versions, saves rollback snapshots, and supports `--rollback`.
- Use `uninstall-daiana.sh` for cleanup, and `--purge` for a full wipe.
- The top-level `Makefile` mirrors these lifecycle commands with `make install`, `make certs`, `make update`, `make rollback`, `make rollback-list`, `make uninstall`, and `make purge`.
