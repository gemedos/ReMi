#!/system/bin/sh
# ReMi — remi-restore.sh
# Phone: {{MODEL}} ({{DEVICE}}) · {{SKIN}} · Android {{ANDROID}} · generated {{DATE}}
#
# Undoes the ReMi session: reinstalls removed system apps for this user and puts every
# setting back to the value it had before ReMi changed it.
#   adb push remi-restore.sh /data/local/tmp/
#   adb shell sh /data/local/tmp/remi-restore.sh

LOG=/data/local/tmp/remi-restore.log
: > "$LOG"
log() { echo "$1" | tee -a "$LOG"; }

restore_pkg() {  # restore_pkg <package>
  out="$(cmd package install-existing "$1" 2>&1)"
  case "$out" in *installed*|*Success*) log "OK    restored $1";;
                 *) log "FAIL  restored $1 -> $out (reinstall from Play Store if needed)";; esac
}

restore_setting() {  # restore_setting <ns> <key> <old-value|__DELETE__>
  if [ "$3" = "__DELETE__" ]; then settings delete "$1" "$2" >/dev/null 2>&1; log "OK    deleted  $1/$2"
  else settings put "$1" "$2" "$3" && log "OK    setting  $1/$2=$3"; fi
}

# ---------------- personalization (reverse order) ----------------
{{RESTORE_PERSONALIZATION_LINES}}

# ---------------- settings ----------------
{{RESTORE_SETTING_LINES}}

# ---------------- packages ----------------
{{RESTORE_PKG_LINES}}

log "Restore finished. Reboot the phone to be sure everything reloads. Log: $LOG"
