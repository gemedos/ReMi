---
profile: <brand-skin>            # kebab-case, e.g. samsung-oneui
version: 0.1.0
status: untested                 # untested | community | tested (whole-profile summary)
maintainers: [<github-user>]
last-reviewed: <YYYY-MM-DD>
---

# <Brand(s)> — <Skin>

Status legend: `tested` = verified on a real phone by a maintainer · `community` = reported
by contributors, not verified by a maintainer · `untested` = plausible, nobody confirmed.
New entries always start as `untested`.

## match

- `ro.product.manufacturer` in: <list>
- <skin property> = <value pattern>

## devices

| ro.product.device | Model | SoC | Status | Notes |
|---|---|---|---|---|
| `<codename>` | <commercial name> | <SoC> | untested | <variant-specific notes> |

## setup

Extra switches this brand needs besides USB debugging (exact menu path).

1. <switch> — <why ReMi needs it>

## do-not-touch

Prefixes (blocked unless the exact package is listed under `packages`):
`<prefix.>`, …

| Package | Why |
|---|---|
| `<package>` | <what breaks: bootloop, settings crash, lockout…> |

## packages

Columns: package · what it is · level (`safe` / `recommended` / `advanced`) · status · notes.
Restore for every row: `cmd package install-existing <package>`.

- `safe`: ads, analytics, third-party preinstalls. Removing changes nothing the user relies on.
- `recommended`: manufacturer apps with ads or duplicates of better apps.
- `advanced`: useful apps some people use; only removed on request.

### Ads and tracking

| Package | What it is | Level | Status | Notes |
|---|---|---|---|---|

### Third-party preinstalled apps

| Package | What it is |
|---|---|

### Manufacturer apps with ads or duplicates

| Package | What it is | Level | Status | Notes |
|---|---|---|---|---|

## settings

| Namespace | Key | Set to | What it does | Status | Restore |
|---|---|---|---|---|---|

## manual-steps

1. <Menu path> → <switch to turn off>

## warnings

- <brand-specific gotchas: launcher limits, density limits, updates restoring apps…>

## sources

- <links used to compile this profile, and test reports: device, skin version, date, result>
