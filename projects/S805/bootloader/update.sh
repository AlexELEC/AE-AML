#!/bin/sh

# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

[ -z "$SYSTEM_ROOT" ] && SYSTEM_ROOT=""
[ -z "$BOOT_ROOT" ] && BOOT_ROOT="/flash"

for arg in $(cat /proc/cmdline); do
  case $arg in
    boot=*)
      boot="${arg#*=}"
      case $boot in
        /dev/mmc*)
          LD_LIBRARY_PATH="$SYSTEM_ROOT/lib" $SYSTEM_ROOT/usr/sbin/fatlabel $boot "@BOOT_LABEL@"
          ;;
        LABEL=*)
          LD_LIBRARY_PATH="$SYSTEM_ROOT/lib" $SYSTEM_ROOT/usr/sbin/fatlabel $($SYSTEM_ROOT/usr/sbin/findfs $boot) "@BOOT_LABEL@"
          ;;
      esac
      ;;
    disk=*)
      disk="${arg#*=}"
      case $disk in
        /dev/mmc*)
          LD_LIBRARY_PATH="$SYSTEM_ROOT/lib" $SYSTEM_ROOT/usr/sbin/e2label $disk "@DISK_LABEL@"
          ;;
        LABEL=*)
          LD_LIBRARY_PATH="$SYSTEM_ROOT/lib" $SYSTEM_ROOT/usr/sbin/e2label $($SYSTEM_ROOT/usr/sbin/findfs $disk) "@DISK_LABEL@"
          ;;
      esac
      ;;
  esac
done
