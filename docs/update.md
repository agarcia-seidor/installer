# Update

Use the update command to refresh the existing Portainer stacks in place.

## Quick path

```bash
bash update-daiana.sh
```

During an interactive update, the installer:

1. shows the current Daiana image targets;
2. asks for the target version for the main Daiana app images;
3. optionally asks whether to update independently versioned images;
4. renders a temporary compose override for Portainer without modifying the source compose files.

## Main Daiana app version

The main Daiana app version applies to these images together:

| Service | Image |
|---|---|
| `daiananext` | `cloudseidoranalytics/daiana` |
| `daianapython` | `cloudseidoranalytics/daianapython` |
| `daianavanna` | `cloudseidoranalytics/daianavanna` |
| `daianamsteams` | `cloudseidoranalytics/daianamsteams` |
| `daianawhatsapp` | `cloudseidoranalytics/daianawhatsapp` |

The prompt accepts versions with or without the leading `v`:

```text
Target Daiana app version [v2.1.9]: 2.1.10
```

The installer deploys that as `v2.1.10`.

## Independently versioned images

These images keep their own versions by default:

| Service | Image | Default behavior |
|---|---|---|
| `daianawebui` | `cloudseidoranalytics/daianawebui` | Keeps current compose version unless changed |
| `daianastudio` | `cloudseidoranalytics/daianastudio` | Keeps current compose version unless changed |
| `daianaqdrant` | `qdrant/qdrant` | Keeps current compose version unless changed |

When prompted, answer `y` to update them one by one. Press Enter to keep the shown default.

## Non-interactive update

Set environment variables before running the update:

```bash
DAIANA_TARGET_VERSION=2.1.10 \
DAIANA_WEBUI_TARGET_VERSION=0.10.3 \
DAIANA_STUDIO_TARGET_VERSION=3.1.3 \
QDRANT_TARGET_VERSION=v1.19.0 \
bash update-daiana.sh
```

Rules:

- `DAIANA_TARGET_VERSION`, `DAIANA_WEBUI_TARGET_VERSION`, and `DAIANA_STUDIO_TARGET_VERSION` accept values with or without `v`.
- `QDRANT_TARGET_VERSION` is used exactly as provided.
- Source compose files are not rewritten during `update`; the selected versions are applied through a temporary compose override sent to Portainer.

## Docker Hub registry

Private Daiana images use the Portainer registry named `dockerhub-prod-sdr` by default, with URL `docker.io`.

For automation, provide Docker Hub credentials as environment variables:

```bash
DAIANA_REGISTRY_USERNAME=<dockerhub-user> \
DAIANA_REGISTRY_PAT=<dockerhub-pat> \
bash update-daiana.sh
```

The installer still reuses older Portainer registries named `daiana-images` or using `registry-1.docker.io` when found, so existing installations keep updating without creating duplicates.
