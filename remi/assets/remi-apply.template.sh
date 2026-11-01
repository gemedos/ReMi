#!/system/bin/sh
# ReMi — remi-apply.sh
# Phone: {{MODEL}} ({{DEVICE}}) · {{SKIN}} · Android {{ANDROID}} · generated {{DATE}}
# Profile: {{PROFILE}} v{{PROFILE_VERSION}}
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
{{REMOVE_PKG_LINES}}

# ---------------- settings ----------------
{{SETTING_LINES}}

# ---------------- personalization ----------------
{{PERSONALIZATION_LINES}}

log "Done: $ok applied, $skip skipped, $fail failed. Log: $LOG"
