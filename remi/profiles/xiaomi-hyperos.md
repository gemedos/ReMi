---
profile: xiaomi-hyperos
version: 1.0.0
status: community
maintainers: [ReMi]
last-reviewed: 2026-11-01
---

# Xiaomi / Redmi / POCO — HyperOS

Status legend: `tested` = verified on a real phone by a maintainer · `community` = reported
by several sources/contributors, not yet verified by a maintainer · `untested` = plausible,
nobody has confirmed it. ReMi warns before applying anything that isn't `tested`.

> v1.0.0 note: this profile was compiled from public HyperOS debloat knowledge and has not
> yet been run end-to-end on a real phone. Once a maintainer runs it on a Redmi Note 13
> Pro, promote the confirmed entries to `tested` and bump the version.

## match

- `ro.product.manufacturer` in: Xiaomi, Redmi, POCO (case-insensitive)
- `ro.mi.os.version.name` starts with `OS` (HyperOS 1.x, 2.x, 3.x)
- Fallback: `ro.miui.ui.version.name` set and no `ro.mi.os.version.name` → MIUI; use this
  profile but warn that it targets HyperOS.

## devices

| ro.product.device | Model | SoC | Status | Notes |
|---|---|---|---|---|
| `garnet` | Redmi Note 13 Pro 5G / POCO X6 5G | Snapdragon 7s Gen 2 | community | Vendor prefixes `com.qualcomm.`, `com.qti.`, `vendor.qti.` are do-not-touch. |
| `emerald` | Redmi Note 13 Pro 4G / POCO M6 Pro 4G | MediaTek Helio G99-Ultra | community | Vendor prefix `com.mediatek.` is do-not-touch. FM Radio (`com.miui.fm`) may be the only radio app — keep unless asked. |

Region comes from `ro.product.mod_device` (e.g. `garnet_eea_global`, `garnet_global`,
`emerald_in_global`). The preinstalled third-party apps differ a lot by region; ReMi only
proposes what is actually installed, so region doesn't change the logic.

## setup

Extra switches Xiaomi needs besides normal USB debugging (Settings → About phone → tap
"OS version" 7 times → Additional settings → Developer options):

1. **USB debugging** — required.
2. **Install via USB** — required only to `adb install` a launcher APK. Needs a Xiaomi
   account signed in, and sometimes a SIM inserted.
3. **USB debugging (Security settings)** — required for `settings put secure …` and some
   `settings put global …` writes; without it they fail with `SecurityException`. Same
   account/SIM requirement. ReMi can be used without it, but those settings get skipped.

## do-not-touch

Never remove or disable these. Most cause bootloops, broken settings, or loss of the
anti-theft lock.

Prefixes (anything starting with these is blocked **unless** that exact package is listed
in the `packages` section below — e.g. `com.android.thememanager` is allowed as `advanced`):
`com.android.`, `android`, `com.google.android.gms`, `com.google.android.gsf`,
`com.qualcomm.`, `com.qti.`, `vendor.qti.`, `com.mediatek.`, `org.codeaurora.`,
`com.xiaomi.mi_connect_service`

Packages:

| Package | Why |
|---|---|
| `com.miui.securitycenter` | Security/permissions hub; removing it bootloops HyperOS. |
| `com.miui.securitycore` | Second space / app lock core; system dependency. |
| `com.miui.securityadd` | Security center add-on; settings crash without it. |
| `com.miui.guardprovider` | Install-time scanner tied to the security center. |
| `com.lbe.security.miui` | Runtime permissions manager. |
| `com.miui.home` | Stock launcher; HyperOS Recents and gestures depend on it even with another launcher. |
| `com.android.systemui` / `com.miui.systemui.plugin` | Status bar, notifications, Control Center. |
| `com.miui.powerkeeper` | Battery/thermal management; removal causes drain and crashes. |
| `com.miui.miwallpaper` | Wallpaper service; removal can black-screen or bootloop. |
| `com.miui.rom`, `com.miui.core`, `com.miui.system` | Framework pieces. |
| `com.xiaomi.misettings` | Parts of Settings (display, battery). |
| `com.xiaomi.finddevice` | Find device / anti-theft lock; risk of being locked out. |
| `com.xiaomi.account` | Xiaomi account; needed for the debugging switches above. |
| `com.xiaomi.xmsf` | Xiaomi services framework / push; account sync breaks. |
| `com.miui.face` | Face unlock. |
| `com.miui.global.packageinstaller` | Package installer; removing blocks installing apps. |
| `com.google.android.packageinstaller` | Same. |
| `com.android.vending` | Play Store; needed to install a launcher and for updates. |
| `com.miui.notification` | Notification settings. |
| `com.miui.securityinputmethod` | Secure keyboard for passwords. |

## packages

Columns: package · what it is · level (`safe` / `recommended` / `advanced`) · status · notes.
Restore for every row: `cmd package install-existing <package>`.

### Ads and tracking

| Package | What it is | Level | Status | Notes |
|---|---|---|---|---|
| `com.miui.msa.global` | MSA — Xiaomi system ad service | safe | community | Main source of ads in system apps. |
| `com.miui.analytics` | Xiaomi analytics | safe | community | |
| `com.miui.analytics.go` | Xiaomi analytics (lite) | safe | untested | Present on some builds. |
| `com.miui.daemon` | Usage data collection daemon | recommended | community | |
| `com.xiaomi.joyose` | Telemetry + game/thermal profiles | recommended | community | Some users report slightly different gaming performance. |
| `com.miui.bugreport` | Bug report/feedback uploader | safe | community | |
| `com.miui.miservice` | Services & feedback | safe | community | |
| `com.miui.hybrid` | Quick apps (ad-driven mini apps) | safe | community | |
| `com.miui.hybrid.accessory` | Quick apps add-on | safe | community | |
| `com.mi.globalminusscreen` | App Vault (left-swipe feed with ads) | recommended | community | Removes the left screen on stock launcher. |
| `com.miui.android.fashiongallery` | Lock screen wallpaper carousel ("Glance") | recommended | community | Removes lock screen ad stories. |
| `com.xiaomi.mipicks` | GetApps — Xiaomi app store | recommended | community | Pushes app suggestions; some Xiaomi apps stop auto-updating (use Play Store). |
| `com.xiaomi.glgm` | Xiaomi games center | safe | community | |

### Third-party preinstalled apps

Only proposed if installed. All `safe`, status `community` unless noted. Users can always
reinstall them from the Play Store.

| Package | What it is |
|---|---|
| `com.facebook.katana` | Facebook |
| `com.facebook.appmanager` | Facebook app manager |
| `com.facebook.services` | Facebook services |
| `com.facebook.system` | Facebook installer |
| `com.netflix.mediaclient` | Netflix (preinstalled stub) |
| `com.netflix.partner.activation` | Netflix activation |
| `com.amazon.mShop.android.shopping` | Amazon Shopping |
| `com.amazon.appmanager` | Amazon app manager |
| `com.booking` | Booking.com |
| `com.agoda.mobile.consumer` | Agoda |
| `com.linkedin.android` | LinkedIn |
| `com.zhiliaoapp.musically` | TikTok |
| `com.einnovation.temu` | Temu |
| `com.alibaba.aliexpresshd` | AliExpress |
| `com.ebay.mobile` | eBay |
| `com.spotify.music` | Spotify (preinstalled) |
| `com.king.candycrushsaga` | Candy Crush Saga |
| `com.block.juggle` | Block puzzle game |
| `in.playsimple.wordtrip` | Word Trip game |
| `com.mobile.legends` | Mobile Legends |
| `com.dts.freefireth` | Free Fire |
| `com.opera.browser` | Opera browser (preinstalled) |
| `com.opera.preinstall` | Opera preinstall helper |
| `com.ss.android.ugc.trill` | TikTok (other regions) |

### Xiaomi apps with ads or duplicates

| Package | What it is | Level | Status | Notes |
|---|---|---|---|---|
| `com.mi.global.shop` | Xiaomi Store | safe | community | |
| `com.mi.global.bbs` | Xiaomi Community | safe | community | |
| `com.miui.videoplayer` | Mi Video (ads, duplicate of gallery player) | recommended | community | Gallery still plays videos. |
| `com.miui.player` | Mi Music (ads) | recommended | community | Keep if the user uses it for local music. |
| `com.miui.cleanmaster` | Cleaner (ads) | recommended | community | Not the security center. |
| `com.xiaomi.discover` | System apps updater | recommended | community | Xiaomi app updates then come only with system updates or Play Store. |
| `com.miui.yellowpage` | Yellow pages / caller ID | advanced | community | |
| `com.miui.weather2` | Weather | advanced | community | Weather widget stops working. |
| `com.miui.compass` | Compass | advanced | community | |
| `com.miui.notes` | Notes | advanced | community | User data lives inside; check first. |
| `com.miui.gallery` | Gallery | advanced | community | Photo editor and screenshot editor go too; only with another gallery installed. |
| `com.android.thememanager` | Themes | advanced | untested | Some builds lose wallpaper changing. |
| `com.xiaomi.scanner` | Scanner | advanced | community | |
| `com.miui.touchassistant` | Quick ball | advanced | community | |
| `com.xiaomi.barrage` | Floating notification overlay | advanced | untested | |
| `com.xiaomi.aiasst.vision` | AI subtitles | advanced | untested | |
| `com.miui.fm` | FM Radio | advanced | community | See emerald note. |
| `com.miui.backup` | Local backup | advanced | community | Keep if the user backs up to PC/SD. |
| `com.miui.cloudbackup` | Xiaomi Cloud backup | advanced | community | |

## settings

Ad, recommendation and privacy switches reachable from adb. Always read the current value
first; skip if the key doesn't exist on this build.

| Namespace | Key | Set to | What it does | Status | Restore |
|---|---|---|---|---|---|
| global | `private_dns_mode` | `hostname` | Use a Private DNS server (with the next row) to block ads in all apps | community | old value, or `settings delete` |
| global | `private_dns_specifier` | `dns.adguard-dns.com` | Ad-blocking DNS (AdGuard public DNS). Optional: ask the user, it's an external service | community | old value, or `settings delete` |
| secure | `limit_ad_tracking` | `1` | Legacy "limit ad tracking" flag (Google ID reset is manual) | untested | old value |
| global | `upload_apk_enable` | `0` | Stops Play Protect uploading unknown apps (only if user wants it) — optional, not default | untested | old value |

Private DNS is opt-in: present it in the ads block with a one-line explanation and default
to "no" unless the user says yes; some captive Wi-Fi portals (hotels, airports) fail with it.

## manual-steps

Things adb can't switch off reliably on HyperOS. Show these after the cleanup blocks; skip
any whose app was removed.

1. Settings → Passwords & security → Privacy → Ad services → turn off **Personalized ad recommendations**.
2. Settings → Google → Ads → **Delete advertising ID**.
3. Long-press a home-screen folder → turn off **Recommended apps / Promote apps** (stock launcher only).
4. Security app → Settings (gear) → turn off **Receive recommendations**.
5. File Manager, Music, Downloads, Themes (if kept) → Settings → turn off **Receive recommendations**.
6. Settings → Additional settings → Privacy → turn off **User experience program** and **Send diagnostic data automatically**.

## warnings

- Never remove `com.miui.home` even after installing another launcher: HyperOS Recents and
  some gestures still depend on it.
- With a third-party launcher, full-screen gestures may be limited on older HyperOS 1.x
  builds; ReMi should mention this before switching launcher.
- HyperOS system updates can re-install removed packages. Use `remi-apply.sh` after each update.
- After a major update (OS1 → OS2 → OS3) re-read this profile; package names can change.
- Changing density beyond about ±20% from stock can break some HyperOS layouts (Control
  Center, Settings). Prefer small steps.
