# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)

import os
import sys
import xbmcaddon

__settings__      = xbmcaddon.Addon(id = 'driver.dvb.hdhomerun')
__cwd__           = __settings__.getAddonInfo('path')
__resources_lib__ = xbmc.translatePath(os.path.join(__cwd__, 'resources', 'lib'))
__settings_xml__  = xbmc.translatePath(os.path.join(__cwd__, 'resources', 'settings.xml'))

if len(sys.argv) == 2 and sys.argv[1] == 'refresh_tuners':
  sys.path.append(__resources_lib__)
  from functions import refresh_hdhomerun_tuners
  refresh_hdhomerun_tuners(__settings_xml__)
  __settings__.openSettings()
