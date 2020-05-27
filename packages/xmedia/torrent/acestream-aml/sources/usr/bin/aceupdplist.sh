#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present Alex@ELEC (http://alexelec.in.ua)

. /storage/.cache/services/acerun.conf

[ "$ACETTV_UPD" == "1" ] && /usr/bin/ttvget-live nologo

exit 0
