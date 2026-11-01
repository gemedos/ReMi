# Personalization settings

For every setting: **check it exists → read and save the current value → show the user
the current value and the options → set after confirmation → read back → log**. Commands
below are run as `adb shell <command>`.

Ask design questions with choices, at most three at a time, each including "dejar como
está". Defaults to suggest are marked ★.

## 1. Launcher

Ask: keep the stock launcher or install another one. Options to offer (one line each):

| Launcher | Package | Why someone picks it |
|---|---|---|
| Keep stock ★ | — | Nothing to learn; best gesture support on Xiaomi. |
| Lawnchair | `app.lawnchair` (Play) / `app.lawnchair.play` | Free, open source, Pixel look, no ads. |
| Nova Launcher | `com.teslacoilsw.launcher` | Very customizable icons, grid, gestures. |
| Niagara Launcher | `bitpit.launcher` | Minimal, one-hand vertical list. |
| Smart Launcher 6 | `ginlemon.flowerfree` | Auto-sorted app categories. |
| Microsoft Launcher | `com.microsoft.launcher` | Good if the user lives in Microsoft 365. |

Package names can change; after install, always detect the real package (step 3).

Install (pick one):

- Play Store page (default): `am start -a android.intent.action.VIEW -d "market://details?id=<pkg>"`
  then ask the user to tap Install and say when it's done.
- APK the user downloaded from the developer's official site: `adb install <file.apk>`
  (on the host, not `adb shell`). Xiaomi needs "Install via USB".

Set as default and verify:

```
cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME <pkg>
# → prints <pkg>/<activity> on the last line
cmd package set-home-activity <pkg>/<activity>
cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME
# → should now print the new launcher
```

Before changing, save the current home activity (the last command without changes) for
restore: `cmd package set-home-activity <old>`. If `set-home-activity` fails (some skins
block it), open the system chooser instead: `am start -a android.settings.HOME_SETTINGS`
and ask the user to pick it.

Never uninstall the stock launcher (see profile do-not-touch).

## 2. Screen density (how much fits on screen)

```
wm density            # "Physical density: 446" (+ "Override density: X" if changed)
wm density <value>    # set
wm density reset      # back to physical
```

Offer in human terms relative to physical density P: "más grande" P×1.10, "estándar" P
(reset), "más contenido" P×0.90, "mucho más contenido" P×0.85. Round to an integer. Warn
about the profile's density limits. After setting, ask the user to look at the phone and
offer `wm density reset` right away if it looks wrong.

Restore: the previous override value, or `wm density reset` if there was none.

## 3. Font size

```
settings get system font_scale      # e.g. 1.0 (null = default 1.0)
settings put system font_scale <v>
```

Options: small 0.9 · default 1.0 ★ · large 1.1 · larger 1.2 · huge 1.3. Restore: old value or
`settings delete system font_scale`.

## 4. Animation speed

```
settings get global window_animation_scale
settings get global transition_animation_scale
settings get global animator_duration_scale
```

Options: off 0 · fast 0.5 ★ · normal 1.0. Set all three to the same value. Restore each to
its old value (null → `settings delete global <key>`).

## 5. Status bar icons

AOSP key (works on Pixel/AOSP, partially on skins):

```
settings get secure icon_blacklist
settings put secure icon_blacklist <comma,separated,slots>
```

Common slots: `rotate`, `headset`, `alarm_clock`, `nfc`, `volume`, `zen`, `bluetooth`,
`location`, `hotspot`, `vpn`, `cast`, `airplane`, `ime`, `data_saver`.

On HyperOS, many icons are controlled by the skin instead; test one slot, ask the user if
it disappeared, and if not, fall back to the manual path: Settings → Notifications & status
bar → Status bar. Status: `community` on HyperOS. Always merge with any existing value
rather than overwriting. Restore: old value or `settings delete secure icon_blacklist`.

## 6. Navigation type

Check which mechanism exists:

- **HyperOS/MIUI:** `settings get global force_fsg_nav_bar` → `1` gestures, `0` buttons.
  Also `settings get global hide_gesture_line` (`1` hides the bottom line). Status:
  `community`.
- **AOSP/Pixel/most others:** `cmd overlay list | grep navbar` and enable one:
  `cmd overlay enable-exclusive --category com.android.internal.systemui.navbar.gestural`
  (or `.threebutton`, `.twobutton`). Restore: re-enable the previously enabled overlay.

Options: gestures ★ · 3 buttons · (gestures) hide gesture line yes/no.

If the user picked a third-party launcher on Xiaomi, mention gestures may be limited and
offer buttons as an alternative.

## 7. Optional extras (offer only if the user asks for "más")

- Dark mode: `cmd uimode night yes|no|auto` (read with `cmd uimode night`).
- Screen timeout: `settings put system screen_off_timeout <ms>`.
- Show battery percentage: `settings put system status_bar_show_battery_percent 1` (verify it exists).
