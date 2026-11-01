#!/system/bin/sh
# ReMi — remi-apply.sh
# Phone: Redmi Note 13 Pro 5G (garnet) · HyperOS OS2.0.4.0 · Android 15 · generated 2026-10-15 18:30
# Profile: xiaomi-hyperos v1.0.0
#
# Re-applies this ReMi session. Safe to run again after system updates:
# it skips apps that are not installed and settings that don't exist.
#
# Run from any computer (Windows, macOS, Linux) with the phone connected:
#   adb push remi-apply.sh /data/local/tmp/
#   adb shell sh /data/local/tmp/remi-apply.sh
# Undo everything with remi-restore.sh (same way).

LOG=/data/local/tmp/remi-apply.log
: > "$LOG"
INSTALLED="$(pm list packages)"
ok=0; skip=0; fail=0

log() { echo "$1" | tee -a "$LOG"; }

is_installed() { echo "$INSTALLED" | grep -qx "package:$1"; }

remove_pkg() {   # remove_pkg <package>   (reversible: cmd package install-existing <package>)
  if is_installed "$1"; then
    out="$(pm uninstall -k --user 0 "$1" 2>&1)"
    case "$out" in *Success*) log "OK    removed  $1"; ok=$((ok+1));;
                   *)         log "FAIL  removed  $1 -> $out"; fail=$((fail+1));; esac
  else
    log "SKIP  removed  $1 (not installed)"; skip=$((skip+1))
  fi
}

set_setting() {  # set_setting <system|secure|global> <key> <value>
  settings put "$1" "$2" "$3" 2>>"$LOG"
  now="$(settings get "$1" "$2" 2>/dev/null)"
  if [ "$now" = "$3" ]; then log "OK    setting  $1/$2=$3"; ok=$((ok+1))
  else log "FAIL  setting  $1/$2 wanted $3 got $now"; fail=$((fail+1)); fi
}

set_density() {  # set_density <dpi>
  wm density "$1" && log "OK    density  $1" && ok=$((ok+1))
}

set_home() {     # set_home <package>/<activity>
  pkg="${1%%/*}"
  if is_installed "$pkg"; then
    cmd package set-home-activity "$1" >>"$LOG" 2>&1 && log "OK    launcher $1" && ok=$((ok+1))
  else
    log "SKIP  launcher $pkg not installed — install it first"; skip=$((skip+1))
  fi
}

set_overlay() {  # set_overlay <overlay-package>   (AOSP navigation mode)
  cmd overlay enable-exclusive --category "$1" >>"$LOG" 2>&1 && log "OK    overlay  $1" && ok=$((ok+1))
}

# ---------------- packages ----------------
remove_pkg com.miui.msa.global
remove_pkg com.miui.analytics
remove_pkg com.miui.daemon
remove_pkg com.miui.hybrid
remove_pkg com.mi.globalminusscreen
remove_pkg com.miui.android.fashiongallery
remove_pkg com.xiaomi.mipicks
remove_pkg com.facebook.katana
remove_pkg com.facebook.appmanager
remove_pkg com.facebook.services
remove_pkg com.facebook.system
remove_pkg com.booking
remove_pkg com.block.juggle
remove_pkg com.mi.global.shop
remove_pkg com.miui.videoplayer
remove_pkg com.miui.cleanmaster

# ---------------- settings ----------------


# ---------------- personalization ----------------
set_setting global window_animation_scale 0.5
set_setting global transition_animation_scale 0.5
set_setting global animator_duration_scale 0.5
set_density 396

log "Done: $ok applied, $skip skipped, $fail failed. Log: $LOG"
