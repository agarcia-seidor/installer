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
