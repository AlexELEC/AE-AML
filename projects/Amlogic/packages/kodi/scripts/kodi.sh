#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2008-2013 Team XBMC (http://xbmc.org)

. /etc/profile

trap cleanup TERM

KODI_ROOT=$HOME/.kodi

SAVED_ARGS="$@"

BOOT_STATUS=$HOME/.config/boot.status
NOSAFE_MODE=$HOME/.config/safemode.disable
CRASH_HIST=/run/libreelec/crashes.dat
KODI_MAX_RESTARTS=@KODI_MAX_RESTARTS@
KODI_MAX_SECONDS=@KODI_MAX_SECONDS@

cleanup() {
  # make systemd happy by not exiting immediately but
  # wait for kodi to exit
  while killall -0 kodi.bin &>/dev/null; do
    sleep 0.5
  done
}

detect_crash_loop()
{
  # use monotonic time (in case date/time changes after booting)
  NOW_TIME=$(awk '/^now/ {print int($3 / 1000000000)}' /proc/timer_list)
  echo "$NOW_TIME" >> $CRASH_HIST

  NUM_RESTARTS=$(wc -l $CRASH_HIST | cut -d' ' -f1)
  FIRST_RESTART_TIME=$(tail -n $KODI_MAX_RESTARTS $CRASH_HIST | head -n 1)

  # kodi restart loop detected? fail this kodi install
  if [ $NUM_RESTARTS -ge $KODI_MAX_RESTARTS -a $KODI_MAX_SECONDS -ge $((NOW_TIME - FIRST_RESTART_TIME)) ]; then
    return 0
  else
    return 1
  fi
}

activate_safe_mode()
{
  [ -f $NOSAFE_MODE ] && return 0

  BOOT_STATE="$(cat $BOOT_STATUS 2>/dev/null)"

  if [ "${BOOT_STATE:-OK}" = "OK" ]; then
    # generate logfiles zip for the failed kodi
    /usr/bin/createlog
    lastlog=$(ls -1 /storage/logfiles/*.zip | tail -n 1)
    mv $lastlog /storage/logfiles/log-$(date -u +%Y-%m-%d-%H.%M.%S)-FAILED.zip

    echo "SAFE" > $BOOT_STATUS
  fi

  return 0
}

# clean up any stale cores. just in case
find /storage/.cache/cores -type f -delete

# clean zero-byte database files that prevent migration/startup
for file in $KODI_ROOT/userdata/Database/*.db; do
  if [ -e "$file" ]; then
    [ -s $file ] || rm -f $file
  fi
done

/usr/lib/kodi/kodi.bin $SAVED_ARGS
RET=$?

if [ $(( ($RET >= 131 && $RET <= 136) || $RET == 139 )) = "1" ] ; then
  # Enable safe mode if a crash loop is detected
  detect_crash_loop && activate_safe_mode
fi

# Filter Kodi powerdown/restartapp/reboot codes to satisfy systemd
[ "$RET" -ge 64 -a "$RET" -le 66 ] && RET=0

exit $RET
