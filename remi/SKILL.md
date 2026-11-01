---
name: remi
description: ReMi ("rehaz tu móvil" / remake your phone) cleans and customizes an Android phone over official Google adb only, no root and no third-party tools. It detects the phone (brand, model, Android and skin such as HyperOS, One UI, ColorOS), backs up the package list and current settings, loads that brand's profile, proposes removing only ads and bloatware that the profile lists AND that really exist on the phone, turns off ad/recommendation settings, then customizes launcher, density, font size, animations, status bar icons and navigation. Every change is reversible and saved as re-runnable apply/restore scripts. Use this skill whenever the user wants to debloat, de-ad, clean up, "quitar publicidad", "quitar bloatware", "limpiar el móvil", speed up, or personalize an Android/Xiaomi/Redmi/POCO/Samsung/Pixel phone with adb, re-apply a cleanup after a system update, undo a previous ReMi change, or add a new brand profile to ReMi, even if they don't say "ReMi" or "adb".
---

# ReMi — rehaz tu móvil

ReMi turns a stock Android phone into a clean, ad-free, personalized one using only the
official `adb` from Google's Android SDK Platform-Tools. It is designed for non-technical
people: you do the technical work automatically and only ask the user about **taste**
(how they want the phone to look) and about **confirming blocks of commands**.

Talk to the user in their language (most users write in Spanish). Keep messages short and
plain; explain jargon in a few words the first time.

## Ground rules (why they exist)

1. **Only official adb.** Use `adb` from Platform-Tools and the tools already on the phone
   (`pm`, `cmd`, `settings`, `wm`, `getprop`, `dumpsys`). No third-party debloaters,
   APK tools, scripts downloaded from the internet, or root. People trust ReMi because
   everything it does can be read and checked.
2. **The profile decides, not you.** Only propose removing a package if it is listed in the
   loaded brand profile **and** it is installed on this phone. Never improvise a package
   from memory, even if you "know" it is bloat: an unlisted package might be what keeps the
   phone booting. When the user explicitly names an app that is not in the profile (and
   not `do-not-touch`), that is their decision: put it in a separate block **"Pedidas por
   ti"**, warn in one line that ReMi hasn't reviewed it, and remove it (reversibly) when
   they confirm that block. Log it as `user-requested`.
3. **`do-not-touch` is absolute.** Packages and prefixes in a profile's `do-not-touch`
   section are never removed or disabled, even if the user asks — explain that they can
   brick or bootloop the phone and stop there.
4. **Everything is reversible.** Remove apps only with `pm uninstall -k --user 0 <pkg>`
   (restorable with `cmd package install-existing <pkg>`). Before changing any setting, read
   and save its current value. Never use plain `pm uninstall` without `--user 0`, never
   `pm clear` on system apps, never touch `/system`, never factory reset.
5. **Show, then confirm, by block.** Before running anything that changes the phone, show the
   block's exact commands and wait for one "yes" for that block. Read-only commands
   (`getprop`, `pm list`, `settings get/list`, `wm density` without value, `dumpsys`) run
   without asking — they are needed for automation and change nothing.
6. **Trust levels.** Each profile entry carries a status: `tested` (verified on a real
   phone), `community` (reported by contributors, not verified by maintainers) or `untested`.
   Before applying any `community` or `untested` entry, say so clearly in the block
   preview (e.g. "⚠ 3 de estos cambios no están probados en un móvil real") so the user
   confirms knowing it.
7. **Check before you set.** Before proposing any setting, verify it exists on this phone
   (`settings get` returns a value, or the key appears in `settings list`, or the command
   prints help without error). If it does not exist on this Android/skin version, skip it
   silently in the plan and list it under "no disponible en tu versión" in the summary.

## Workflow

Track progress with a short checklist and keep going automatically between phases; only
stop for the confirmations and design questions described below.

### Phase 0 — Connect

1. Run `adb version`. If adb is missing, read `references/adb-setup.md` and walk the user
   through installing Platform-Tools and enabling USB debugging (include the brand's extra
   switches from the profile's `setup` section, e.g. Xiaomi's "USB debugging (Security
   settings)"). This is the only phase with real user hand-holding.
2. Run `adb devices`. Handle: no device → cable/USB mode/drivers; `unauthorized` → accept
   the prompt on the phone; more than one device → ask which serial and use `-s <serial>`
   on every command afterwards.

### Phase 1 — Detect and back up (automatic)

Read these properties in one call (missing ones print empty — that's fine):

```
adb shell 'for p in ro.product.manufacturer ro.product.brand ro.product.model ro.product.device ro.product.mod_device ro.build.version.release ro.build.version.sdk ro.build.version.incremental ro.build.display.id ro.mi.os.version.name ro.mi.os.version.incremental ro.miui.ui.version.name ro.miui.region ro.build.version.oneui ro.build.version.oplusrom ro.vivo.os.version ro.product.locale; do echo "$p=$(getprop $p)"; done'
```

Identify the skin with this table, then pick the profile:

| Signal | Skin | Profile |
|---|---|---|
| manufacturer Xiaomi/Redmi/POCO, `ro.mi.os.version.name` set (OS1.x, OS2.x, OS3.x…) | HyperOS | `profiles/xiaomi-hyperos.md` |
| manufacturer Xiaomi/Redmi/POCO, only `ro.miui.ui.version.name` | MIUI (legacy) | `profiles/xiaomi-hyperos.md` (warn: profile targets HyperOS) |
| `ro.build.version.oneui` set | One UI | `profiles/samsung-oneui.md` |
| `ro.build.version.oplusrom` set / OPPO, realme, OnePlus | ColorOS / realme UI / OxygenOS | `profiles/oppo-realme-oneplus.md` |
| `ro.vivo.os.version` set | Funtouch / OriginOS | `profiles/vivo.md` |
| manufacturer motorola | My UX | `profiles/motorola.md` |
| Google / anything else | Pixel / AOSP | `profiles/pixel-aosp.md` |
| `android.software.leanback` feature (check `pm list features`) | Android TV | `profiles/android-tv.md` |

If the profile file does not exist yet, say ReMi doesn't support that brand yet, offer
the customization phase only (it uses standard Android settings) and point to
`references/profile-guide.md` for contributing a profile. Do not clean anything.

Create a session folder in the current directory:
`remi/<device>-<YYYYMMDD-HHMM>/` and save (automatically, no confirmation needed):

- `device.txt` — the getprop output above.
- `packages-before.txt` — `adb shell pm list packages -s` (system) and `-3` (user), plus
  `pm list packages -u` (includes already-removed-for-user packages, useful after updates).
- `settings-before/` — `settings list system`, `settings list secure`,
  `settings list global`, and `wm density`, `wm size` outputs.

Tell the user in one or two lines what phone you found, e.g. "Redmi Note 13 Pro 5G
(garnet), HyperOS 2.0, Android 15, región EEA. Copia de seguridad guardada."

### Phase 2 — Build the cleanup plan (automatic)

Read the chosen profile. It has sections: `match`, `devices`, `setup`, `do-not-touch`,
`packages` (with `level` safe / recommended / advanced and `status`), `settings`
(ad/recommendation switches), `manual-steps` and `warnings`.

1. Check the model: if `ro.product.device` is listed in the profile's `devices` table, use
   its notes (variant-specific packages). If it isn't, warn that the profile hasn't been
   checked on this model and treat everything as at most `community`.
2. Intersect profile packages with `packages-before.txt`. Drop anything not installed.
   Drop any that is an exact `do-not-touch` package (defensive double check — exact
   entries always win). `do-not-touch` prefixes block every package not explicitly listed
   in the profile's `packages` section; an exact listing there is the profile author's
   deliberate exception.
3. Default selection: levels `safe` + `recommended`. `advanced` entries are listed in one
   line at the end ("también podría quitar: Galería Mi, Tema, …") and only included if the
   user asks.
4. For each profile `settings` entry, read its current value (or check the key exists).
   Keep only those that exist; save the old value for restore.

### Phase 3 — Clean (one confirmation per block)

Group into these blocks, skip empty ones, and present each as: title, one-line purpose,
a compact table (package/setting · what it is · status), the exact commands in a code
block, and the warnings for `community`/`untested` entries. Then wait for "sí/yes".

1. **Publicidad y rastreo** (ads, analytics, ad-related settings)
2. **Apps preinstaladas de terceros** (Facebook, juegos, tiendas, etc.)
3. **Apps del fabricante con publicidad o duplicadas**
4. **Pedidas por ti** (only apps the user named that aren't in the profile — see rule 2)

Accept partial answers ("sí, pero deja Mi Video") by removing those items and re-showing
nothing — just proceed. Run the commands one by one, check each output (`Success`, or the
setting reads back the new value), and record every change in `changes.log`
(`timestamp | type | target | old value | new value | result`). If a command fails, don't
retry blindly: note it, continue with the rest, and report it at the end.

After the cleanup blocks, list the profile's `manual-steps` (things adb cannot switch off,
e.g. per-app "recommendations" toggles) as a short numbered checklist for the user.

### Phase 4 — Personalize (design questions, then one confirmation per block)

Read `references/customization.md`. This is where the user's taste matters, so ask —
with a multiple-choice question when your interface supports it — at most three
questions at a time, always showing the current value and offering "dejar como está":

- Launcher: keep stock, or install one (the reference lists options with one-line
  descriptions). Install through the Play Store page opened over adb, or `adb install`
  of an APK the user already downloaded from the developer's official site. Then set it as
  default and verify.
- Screen density (more/less content on screen) and font size.
- Animation speed (off / fast / normal).
- Status bar icons to hide.
- Navigation type (gestures / buttons) and gesture line visibility.

Verify each setting exists on this phone before offering it (rule 7). Apply each block
after confirmation, read the value back, and log it. After changing density, tell the user
to check the screen and offer an immediate one-command undo if it looks wrong.

### Phase 5 — Save scripts and finish (automatic)

From `changes.log` generate, in the session folder, using the templates in `assets/`:

- `remi-apply.sh` — re-applies every successful change. Runs **on the phone** so it works
  from Windows, macOS or Linux alike:
  `adb push remi-apply.sh /data/local/tmp/ && adb shell sh /data/local/tmp/remi-apply.sh`
- `remi-restore.sh` — undoes everything (install-existing for packages, old values for
  settings, `settings delete` when there was no previous value, `wm density reset` or the
  old density). Same way to run.
- `RESUMEN.md` — phone, date, what was removed/changed, what was skipped and why, manual
  steps pending, and how to run both scripts.

Fill every `{{…}}` placeholder (no placeholder may remain) with one helper call per line:
`remove_pkg <pkg>`, `set_setting <ns> <key> <value>`, `set_density <dpi>`,
`set_home <pkg>/<activity>`, `set_overlay <overlay>`; and in restore, in reverse order:
`restore_pkg <pkg>`, `restore_setting <ns> <key> <old|__DELETE__>`, `wm density reset` or
`wm density <old>`, `cmd package set-home-activity <old-component>`. Only include changes
that succeeded.

Run `sh -n` on both scripts via `adb shell sh -n /data/local/tmp/<script>` after pushing to
catch syntax errors (this does not execute them). Then end with a short summary: number of
apps removed, settings changed, where the files are, and one line on how to undo.

## Other entry points

- **"He actualizado el móvil" / re-apply after an update:** find the latest session folder
  for this device, run Phase 1 again into a new folder, diff packages, show which removed
  apps came back, then offer `remi-apply.sh` as a single block (it skips missing packages).
  If the skin version changed (e.g. OS2 → OS3), re-check the profile for new
  `do-not-touch` or warnings before running.
- **Undo:** offer full restore (`remi-restore.sh`) or a single item (show its restore
  command from `changes.log`).
- **Add a brand:** follow `references/profile-guide.md` and copy `profiles/_TEMPLATE.md`.
  New profiles always start as `untested`.

## Files

- `profiles/<brand>.md` — one per brand/skin; read only the one you need.
- `profiles/_TEMPLATE.md` — fixed format for new profiles.
- `references/adb-setup.md` — installing Platform-Tools, enabling debugging, connection troubleshooting.
- `references/customization.md` — every personalization setting, how to verify, set, read back, restore.
- `references/profile-guide.md` — how to write and review a profile.
- `assets/remi-apply.template.sh`, `assets/remi-restore.template.sh` — script skeletons.
