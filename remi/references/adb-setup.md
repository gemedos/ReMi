# adb setup and connection troubleshooting

Only use Google's official **SDK Platform-Tools**:
https://developer.android.com/tools/releases/platform-tools
(Do not suggest "minimal adb", "15 seconds installer" or other repackaged installers.)

## Install

**Windows** — preferred: `winget install --id Google.PlatformTools -e` (official package from
Google's zip). If winget isn't available: download "SDK Platform-Tools for Windows" from the
link above, unzip to `C:\platform-tools`, and either run adb as `C:\platform-tools\adb.exe`
or add that folder to PATH (`setx PATH "%PATH%;C:\platform-tools"`, then open a new terminal).
Many phones need the OEM USB driver on Windows; for Xiaomi it usually works with the generic
Windows driver. If the phone isn't listed, try another cable/port and set USB mode to
"File transfer".

**macOS** — `brew install --cask android-platform-tools`, or download the zip and use
`./adb` from the unzipped folder.

**Linux** — download the zip (distro packages are often outdated). Add a udev rule if the
device shows as `no permissions`.

Check: `adb version` prints "Android Debug Bridge version 1.0.41" or newer.

## Enable developer options and USB debugging

1. Settings → About phone → tap the build/OS version 7 times (Xiaomi: "OS version";
   Samsung: Software information → "Build number"; Pixel: "Build number").
2. Developer options (Xiaomi: Settings → Additional settings → Developer options) →
   enable **USB debugging**.
3. Brand extras: see the profile's `setup` section.
4. Connect the cable, unlock the phone, accept "Allow USB debugging?" and tick "Always allow
   from this computer".

## `adb devices` states

| Output | Meaning | Fix |
|---|---|---|
| empty list | Not seen | Other cable (data, not charge-only), other port, USB mode "File transfer", driver on Windows. |
| `unauthorized` | Prompt not accepted | Unlock phone, accept prompt. If no prompt: Developer options → Revoke USB debugging authorizations, reconnect. |
| `offline` | Stale connection | `adb kill-server && adb start-server`, reconnect. |
| `no permissions` (Linux) | udev | Add udev rule or run `adb` once with sudo to test. |
| two or more serials | Several devices | Ask which; use `adb -s <serial>` on every command. |

Wireless debugging (Android 11+) also works: Developer options → Wireless debugging →
Pair with code, then `adb pair <ip>:<port>` and `adb connect <ip>:<port>`. Useful if the
cable is unreliable.

## Common command failures

| Error | Cause | What ReMi does |
|---|---|---|
| `SecurityException ... WRITE_SECURE_SETTINGS` | Xiaomi "USB debugging (Security settings)" off | Explain the switch; skip the setting if the user prefers. |
| `INSTALL_FAILED_USER_RESTRICTED` | Xiaomi "Install via USB" off or prompt denied | Explain the switch / accept the on-phone prompt within 10 s. |
| `Failure [not installed for 0]` | Package already removed for this user | Treat as done. |
| `DELETE_FAILED_INTERNAL_ERROR` | Protected package | Don't retry; report. |
| `Package ... is not installed` on install-existing | The APK isn't on the system image anymore (removed by an update) | Tell the user to reinstall from Play Store if they want it. |
