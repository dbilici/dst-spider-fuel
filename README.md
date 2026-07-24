# Spider Fuel

Public Don't Starve Together mod that lets Silk and Spider Glands be used as burnable fuel.

## Status

- Steam Workshop visibility: Public
- Workshop ID: `3761256366`
- Workshop URL: https://steamcommunity.com/sharedfiles/filedetails/?id=3761256366
- Steam title: `Spider Fuel`
- Local source package: `Fuel_DST`
- Mod name: `Spider Fuel`
- Author: `k0za1ak`
- Source repository: https://github.com/dbilici/dst-spider-fuel
- Repository folder: `dst-spider-fuel`
- Version: `1.1.2`

## Features

- Adds burnable fuel support to Silk.
- Adds burnable fuel support to Spider Glands.
- Keeps fuel values configurable per item.
- Defaults Spider Glands to tiny fuel value.
- Defaults Silk to small fuel value.
- Does not require every client to install the mod.

## Configuration

| Option | Values | Default |
| --- | --- | --- |
| Spider Gland Fuel Value | Tiny, Small, Medium | Tiny |
| Silk Fuel Value | Tiny, Small, Medium | Small |
| Debug Logging | Disabled, Enabled | Disabled |

## Diagnostics

Enable **Debug Logging**, restart the world, and inspect the shard's
`server_log.txt` for `[Spider Fuel 1.1.2]` lines. The host/server console command
below always prints the configured fuel values and live prefab patch counts:

```text
SPIDER_FUEL_DEBUG()
```

## Install Locally

Copy this folder into the Don't Starve Together mods folder, then enable it from the in-game mod screen.

Common macOS location:

```text
~/Library/Application Support/Steam/steamapps/common/Don't Starve Together/dontstarve_steam.app/Contents/mods/
```

## Repository Notes

- Keep generated or OS-local files out of Git (`.DS_Store`, logs, temporary zips).
- Keep Workshop metadata in this README.
- Keep the Steam Workshop page text in `STEAM_WORKSHOP.md`.
- Tag GitHub releases when publishing Workshop updates.
