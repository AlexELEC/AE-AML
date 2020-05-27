#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

SERVICE="tvheadend.service"
SERVICE_DIR="/storage/.cache/services"

case $1 in
  pre)
    if [ -f "$SERVICE_DIR/tvheadend.conf" ] ; then
      systemctl stop "$SERVICE"
    fi
    ;;
  post)
    if [ -f "$SERVICE_DIR/tvheadend.conf" ] ; then
      systemctl start "$SERVICE"
    fi
    ;;
esac
