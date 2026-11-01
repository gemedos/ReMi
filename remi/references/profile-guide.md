# Writing and reviewing a ReMi profile

A profile is the only thing that tells ReMi what is safe to remove on a brand. A wrong
line can bootloop someone's phone, so profiles follow a fixed template and a review step.

## Write

1. Copy `profiles/_TEMPLATE.md` to `profiles/<brand-skin>.md` (kebab-case, e.g.
   `samsung-oneui.md`, `oppo-realme-oneplus.md`, `pixel-aosp.md`, `android-tv.md`).
   Keep every section, even if empty, and keep the column order.
2. Fill `match` with the `getprop` values ReMi uses to detect the skin, and `devices` with
   the codenames (`ro.product.device`) you know.
3. Fill `do-not-touch` first. When in doubt, a package goes here, not in `packages`.
4. Add packages with a one-line plain-language description, a level and a status. Never
   add a package you haven't seen on a real `pm list packages` output of that brand.
5. Add `settings` only with keys you've seen in `settings list` on that skin.
6. Put every source and test report in `sources`.
7. New entries are `untested`. Set the profile `status` to the lowest status that covers
   most entries.

## Test on a real phone (to reach `community` / `tested`)

1. Run ReMi with the profile on the phone and keep the session folder.
2. Reboot twice, then check: calls, SMS, mobile data, Wi-Fi, camera, notifications,
   fingerprint/face unlock, Play Store installs, settings pages open without crashing.
3. Run `remi-restore.sh` and confirm the restored apps open.
4. Add a line to `sources`: device codename, skin + Android version, date, result.

`community`: at least one contributor test report or two independent public sources.
`tested`: a maintainer ran steps 1-3 on that device and skin major version.

## Review checklist (maintainer, before merging)

- [ ] Template followed; all sections present; package names are exact (no wildcards in `packages`).
- [ ] Nothing in `packages` matches an exact `do-not-touch` entry.
- [ ] Every `advanced` entry explains what the user loses.
- [ ] No system-critical package (launcher, systemui, settings, security, permissions,
      providers, Play services, package installer, vendor/SoC packages) is removable.
- [ ] Settings keys include how to restore them.
- [ ] Statuses are honest; nothing is `tested` without a test report in `sources`.
- [ ] No third-party tools, downloads or root steps are introduced.
- [ ] Add the profile to the detection table in `SKILL.md`.
