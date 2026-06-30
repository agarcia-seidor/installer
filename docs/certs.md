# Apply certificates

```bash
bash apply-certs.sh
```

## Modes
1. Let’s Encrypt
2. self-signed / local certs
3. custom cert files

## What it does
- only applies certificates
- does not create proxy hosts
- updates existing NPM hosts for `port.$BASE_DOMAIN` and `nginx.$BASE_DOMAIN`
- auto-generates local/self-signed cert files when `TLS_MODE=local` and the files are missing
- supports `ONLY_PREFIX` to target a single proxy prefix (for example `port`, `nginx`, `supa`)

## Examples
- `ONLY_PREFIX=port bash apply-certs.sh`
- `ONLY_PREFIX=supa bash apply-certs.sh`
